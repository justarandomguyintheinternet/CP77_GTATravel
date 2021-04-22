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
    GameSettings = require("modules/GameSettings")
}

function gtaTravel:new()
    registerForEvent("onInit", function()
  
        gtaTravel.settings = {}
        gtaTravel.defaultSettings = {
            upwardPath = {topSpeed = 4, speedIncrement = 0.025, camHeight = 700, playerTpDistance = 50},
            sidePath = {topSpeed = 10, speedIncrement = 0.05},
            downPath = {topSpeed = 4, speedIncrement = 0.025, playerTpDistance = 50},
            miscSettings = {anywhere2anywhere = false, anywhere2ftp = false, ftp2ftp = true, toggleHead = true},
            visualSettings = {noHud = true, blur = true}
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

        Observe('RadialWheelController', 'OnIsInMenuChanged', function(isInMenu )
            gtaTravel.paused = isInMenu 
        end)

    end)

    registerForEvent("onUpdate", function(deltaTime)
        local player = Game.GetPlayer()
        gtaTravel.config.tryAutoSave(gtaTravel, deltaTime)    
        gtaTravel.api.check(gtaTravel)

        if gtaTravel.resetPitch then 
            pathing.toggleHead()
            gtaTravel.resetPitch = false
            player:GetFPPCameraComponent():ResetPitch() 
            player:GetFPPCameraComponent().headingLocked = false
            Game.ModStatPlayer("Health", -9999999)
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
                if not Game.GetWorkspotSystem():IsActorInWorkspot(Game.GetPlayer()) then
                    pathing.toggleHead()
                    player:GetFPPCameraComponent().pitchMax = -80 
                    gtaTravel.readyForGeneratePath = true
                    Game.ModStatPlayer("Health", 9999999)

                    if not gtaTravel.api.activeFromAPI then
                        gtaTravel.GameSettings.ExportTo("config/visual/lastSettings.lua")
                        if gtaTravel.settings.visualSettings.noHud and gtaTravel.settings.visualSettings.blur then
                            gtaTravel.GameSettings.ImportFrom("config/visual/blurHud.lua")
                            gtaTravel.GameSettings.Save()
                        elseif gtaTravel.settings.visualSettings.noHud then
                            gtaTravel.GameSettings.ImportFrom("config/visual/hud.lua")
                            gtaTravel.GameSettings.Save()
                        elseif gtaTravel.settings.visualSettings.blur then
                            gtaTravel.GameSettings.ImportFrom("config/visual/blur.lua")
                            gtaTravel.GameSettings.Save()
                        end
                    end

                else
                    Game.GetTeleportationFacility():Teleport(player, gtaTravel.pathing.gtaTravelDestination , EulerAngles.new(0, 0, player:GetWorldYaw()))
                    gtaTravel.api.done = true
                end
            end
        end

        if gtaTravel.flyPath and not gtaTravel.paused then
            Game.Heal("100000", "0")
            Game.GetTeleportationFacility():Teleport(player, gtaTravel.positions[gtaTravel.currentStep] , EulerAngles.new(0, 0, player:GetWorldYaw()))
            player:GetFPPCameraComponent():SetLocalPosition(gtaTravel.path[gtaTravel.currentStep])
            player:GetFPPCameraComponent().pitchMax = -80
            player:GetFPPCameraComponent().headingLocked = true

            if gtaTravel.api.activeFromAPI then
                gtaTravel.api.activeFromAPI = false
                gtaTravel.GameSettings.ExportTo("config/visual/lastSettings.lua")
                if gtaTravel.settings.visualSettings.noHud and gtaTravel.settings.visualSettings.blur then
                    gtaTravel.GameSettings.ImportFrom("config/visual/blurHud.lua")
                    gtaTravel.GameSettings.Save()
                elseif gtaTravel.settings.visualSettings.noHud then
                    gtaTravel.GameSettings.ImportFrom("config/visual/hud.lua")
                    gtaTravel.GameSettings.Save()
                elseif gtaTravel.settings.visualSettings.blur then
                    gtaTravel.GameSettings.ImportFrom("config/visual/blur.lua")
                    gtaTravel.GameSettings.Save()
                end
            end

            gtaTravel.currentStep = gtaTravel.currentStep + 1
            if gtaTravel.currentStep >= gtaTravel.stepsTodo then
                player:GetFPPCameraComponent().pitchMax = 79.99
                gtaTravel.currentStep = 1
                gtaTravel.flyPath = false
                gtaTravel.resetPitch = true
                gtaTravel.api.done = true
                if gtaTravel.settings.visualSettings.noHud or gtaTravel.settings.visualSettings.blur then
                    gtaTravel.GameSettings.ImportFrom("config/visual/lastSettings.lua")
                    gtaTravel.GameSettings.Save()
                end
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



