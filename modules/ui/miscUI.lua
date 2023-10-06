local util = require("modules/util")

miscUI = {
    tooltips = require("modules/ui/tooltips"),
    colors = {frame = {0, 50, 255}},
	boxSize = {x = 480}
}

function miscUI.draw(gtaTravel)
    gtaTravel.CPS.colorBegin("Border", miscUI.colors.frame)
    gtaTravel.CPS.colorBegin("Separator", miscUI.colors.frame)
    gtaTravel.CPS.colorBegin("Text", miscUI.colors.frame)

    ImGui.BeginChild("miscSettings", miscUI.boxSize.x, 130, true)
    ImGui.PushItemWidth(330)

    ImGui.Text("Enable GTA Travel from:")
    gtaTravel.CPS.colorEnd(1)
    ImGui.Separator()
    state, changed = ImGui.Checkbox("Fast Travel Points to Fast Travel Points",  gtaTravel.settings.miscSettings.ftp2ftp)
    if changed and state then
        miscUI.resetSettings(gtaTravel)
        gtaTravel.settings.miscSettings.ftp2ftp = state
    end
    ImGui.Separator()
    state, changed = ImGui.Checkbox("Anywhere to Fast Travel Points", gtaTravel.settings.miscSettings.anywhere2ftp)
    if changed and state then
        miscUI.resetSettings(gtaTravel)
        gtaTravel.settings.miscSettings.anywhere2ftp = state
    end
    ImGui.Separator()
    state, changed = ImGui.Checkbox("Anywhere to Anywhere", gtaTravel.settings.miscSettings.anywhere2anywhere)
    if changed and state then
        miscUI.resetSettings(gtaTravel)
        gtaTravel.settings.miscSettings.anywhere2anywhere = state
    end

    ImGui.PopItemWidth()
    ImGui.EndChild()

    ImGui.BeginChild("resetStuff", miscUI.boxSize.x, 80, true)
    gtaTravel.CPS.colorBegin("Text", miscUI.colors.frame)
    ImGui.Text("Reset Stuff")
    gtaTravel.CPS.colorEnd(1)
    miscUI.tooltips.drawBtn(gtaTravel, "?", "resetStuff")
    ImGui.Separator()
    cam = gtaTravel.CPS.CPButton("Reset cam", 75, 30)

    ImGui.SameLine()
    settings = gtaTravel.CPS.CPButton("Remove Restrictions", 150, 30)
    if settings then
        util.removeRestrictions()
        SaveLocksManager.RequestSaveLockRemove("gtaTravel")
    end
    ImGui.EndChild()

    local y = 125
    if gtaTravel.settings.timeSettings.speedUp then y = 150 end

    ImGui.BeginChild("visuals", miscUI.boxSize.x, y, true)
    gtaTravel.CPS.colorBegin("Text", miscUI.colors.frame)
    ImGui.Text("Visual Settings")
    gtaTravel.CPS.colorEnd(1)
    ImGui.Separator()
    gtaTravel.settings.visualSettings.noHud, c = ImGui.Checkbox("Disable HUD", gtaTravel.settings.visualSettings.noHud)
    if c and gtaTravel.flyPath then
        gtaTravel.util.toggleHUD(not gtaTravel.settings.visualSettings.noHud)
    end
    miscUI.tooltips.drawBtn(gtaTravel, "?", "noHud")
    gtaTravel.settings.visualSettings.blur = ImGui.Checkbox("Enable Motion Blur", gtaTravel.settings.visualSettings.blur)
    if changed and gtaTravel.flyPath then
        gtaTravel.util.toggleBlur(gtaTravel.settings.visualSettings.blur)
    end
    miscUI.tooltips.drawBtn(gtaTravel, "?", "blur")

    gtaTravel.settings.timeSettings.speedUp = ImGui.Checkbox("Speed up time during transition", gtaTravel.settings.timeSettings.speedUp)
    if gtaTravel.settings.timeSettings.speedUp then
        gtaTravel.settings.timeSettings.amount = ImGui.SliderInt("Speed increase", gtaTravel.settings.timeSettings.amount, 1, 25)
    end

    ImGui.EndChild()

    gtaTravel.CPS.colorEnd(2)
end

function miscUI.resetCam()
    local player = Game.GetPlayer()
    player:GetFPPCameraComponent().headingLocked = false
    player:GetFPPCameraComponent().pitchMax = 79.99
    player:GetFPPCameraComponent():SetLocalPosition(Vector4.new(0, 0, 0, 0))
end

function miscUI.resetSettings(gtaTravel)
    gtaTravel.settings.miscSettings.anywhere2anywhere = false
    gtaTravel.settings.miscSettings.anywhere2ftp = false
    gtaTravel.settings.miscSettings.ftp2ftp = false
end

return miscUI