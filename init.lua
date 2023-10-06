-- _                       __          ___                       
-- | |                      \ \        / / |                      
-- | | _____  __ _ _ __  _   \ \  /\  / /| |__   ___  ___ _______ 
-- | |/ / _ \/ _` | '_ \| | | \ \/  \/ / | '_ \ / _ \/ _ \_  / _ \
-- |   <  __/ (_| | | | | |_| |\  /\  /  | | | |  __/  __// /  __/
-- |_|\_\___|\__,_|_| |_|\__,_| \/  \/   |_| |_|\___|\___/___\___|
-------------------------------------------------------------------------------------------------------------------------------
-- This mod was created by keanuWheeze from CP2077 Modding Tools Discord. 
--
-- You are free to use this mod as long as you follow the following license guidelines:
--    * It may not be uploaded to any other site without my express permission.
--    * Using any code contained herein in another mod requires full credits / asking me.
--    * You may not fork this code and make your own competing version of this mod available for download without my permission.
--
-------------------------------------------------------------------------------------------------------------------------------

gtaTravel = {
    isUIVisible = false,
    pathing = require("modules/pathing"),
    CPS = require("CPStyling"),
	ui = require("modules/ui/ui"),
	config = require("modules/config"),
    api = require("modules/api"),
    mapObserver = require("modules/mapObserver"),
    util = require("modules/util")
}

function gtaTravel:new()
    registerForEvent("onInit", function()
        CName.add("gtaTravel")

        gtaTravel.settings = {}
        gtaTravel.defaultSettings = {
            upwardPath = {topSpeed = 4, speedIncrement = 0.025, camHeight = 700, playerTpDistance = 50},
            sidePath = {topSpeed = 10, speedIncrement = 0.05},
            downPath = {topSpeed = 4, speedIncrement = 0.025, playerTpDistance = 50},
            miscSettings = {anywhere2anywhere = false, anywhere2ftp = false, ftp2ftp = true},
            visualSettings = {noHud = true, blur = false},
            timeSettings = {speedUp = false, amount = 5}
        }

        gtaTravel.loadUpSlot = 1
        gtaTravel.autoSave = true

        gtaTravel.config.startup(gtaTravel)

        gtaTravel.flyPath = false
        gtaTravel.currentStep = 1
        gtaTravel.stepsTodo = 0
        gtaTravel.resetPitch = false
        gtaTravel.setDirForVector = false
        gtaTravel.readyForGeneratePath = false
        gtaTravel.positions = {}
        gtaTravel.path = {}
        gtaTravel.paused = false

        gtaTravel.mapObserver.addObservers(gtaTravel)

        Observe('RadialWheelController', 'OnIsInMenuChanged', function(_, isInMenu )
            gtaTravel.paused = isInMenu
        end)
    end)

    registerForEvent("onUpdate", function(deltaTime)
        gtaTravel.config.tryAutoSave(gtaTravel, deltaTime)
        gtaTravel.api.check(gtaTravel)

        if gtaTravel.resetPitch then
            gtaTravel.resetPitch = false
            GetPlayer():GetFPPCameraComponent():ResetPitch()
            GetPlayer():GetFPPCameraComponent().headingLocked = false
        end

        if gtaTravel.readyForGeneratePath then
            gtaTravel.readyForGeneratePath = false
            gtaTravel.pathing.generatePath(gtaTravel)
            gtaTravel.flyPath = true
            gtaTravel.positions = pathing.positions
            gtaTravel.path = pathing.path
            gtaTravel.stepsTodo = pathing.steps
        end

        if gtaTravel.setDirForVector then  -- Entry point to the whole animation
            if not gtaTravel.flyPath then
                gtaTravel.setDirForVector = false
                if not Game.GetWorkspotSystem():IsActorInWorkspot(GetPlayer()) then
                    GetPlayer():GetFPPCameraComponent().pitchMax = -80
                    gtaTravel.readyForGeneratePath = true
                    Game.GetStatPoolsSystem():RequestSettingStatPoolValue(GetPlayer():GetEntityID(), gamedataStatPoolType.Health, 100, nil)

                    if GetMod("ImmersiveFirstPerson") then
                        GetMod("ImmersiveFirstPerson").api.Disable()
                    end

                    if gtaTravel.settings.visualSettings.noHud then
                        gtaTravel.util.toggleHUD(false)
                    end
                    if gtaTravel.settings.visualSettings.blur then
                        gtaTravel.util.toggleBlur(true)
                    end

                    SaveLocksManager.RequestSaveLockAdd("gtaTravel")
                else
                    Game.GetTeleportationFacility():Teleport(GetPlayer(), gtaTravel.pathing.gtaTravelDestination , EulerAngles.new(0, 0, GetPlayer():GetWorldYaw()))
                    gtaTravel.api.done = true
                end
            end
        end

        if gtaTravel.flyPath and not gtaTravel.paused then
            gtaTravel.util.applyRestrictions()
            if gtaTravel.currentStep == gtaTravel.pathing.sideSteps then
                Game.GetTimeSystem():UnsetTimeDilation("gtaTravel")
            end
            if gtaTravel.currentStep < gtaTravel.pathing.sideSteps and gtaTravel.currentStep > gtaTravel.pathing.upSteps and gtaTravel.settings.timeSettings.speedUp then
                Game.GetTimeSystem():SetTimeDilation("gtaTravel", (gtaTravel.settings.timeSettings.amount / 2) * gtaTravel.pathing.distanceVector(gtaTravel.positions[gtaTravel.currentStep], gtaTravel.positions[gtaTravel.currentStep + 1]))
            end

            Game.GetStatPoolsSystem():RequestSettingStatPoolValue(GetPlayer():GetEntityID(), gamedataStatPoolType.Health, 100, nil)
            Game.GetTeleportationFacility():Teleport(GetPlayer(), gtaTravel.positions[gtaTravel.currentStep] , EulerAngles.new(0, 0, GetPlayer():GetWorldYaw()))
            GetPlayer():GetFPPCameraComponent():SetLocalPosition(gtaTravel.path[gtaTravel.currentStep])
            GetPlayer():GetFPPCameraComponent().pitchMax = -80
            GetPlayer():GetFPPCameraComponent().headingLocked = true

            gtaTravel.currentStep = gtaTravel.currentStep + 1
            if gtaTravel.currentStep >= gtaTravel.stepsTodo then
                util.removeRestrictions()

                if GetMod("ImmersiveFirstPerson") then
                    GetMod("ImmersiveFirstPerson").api.Enable()
                end

                if gtaTravel.settings.visualSettings.noHud then
                    gtaTravel.util.toggleHUD(true)
                end
                if gtaTravel.settings.visualSettings.blur then
                    gtaTravel.util.toggleBlur(false)
                end

                SaveLocksManager.RequestSaveLockRemove("gtaTravel")

                GetPlayer():GetFPPCameraComponent().pitchMax = 79.99
                gtaTravel.currentStep = 1
                gtaTravel.flyPath = false
                gtaTravel.resetPitch = true
                gtaTravel.api.done = true
            end
        end
    end)

    registerForEvent("onDraw", function()
        if gtaTravel.isUIVisible then
            gtaTravel.ui.draw(gtaTravel)
        end
    end)

    registerForEvent("onOverlayOpen", function()
        gtaTravel.isUIVisible = true
    end)

    registerForEvent("onOverlayClose", function()
        gtaTravel.isUIVisible = false
    end)

    return gtaTravel
end

return gtaTravel:new()



