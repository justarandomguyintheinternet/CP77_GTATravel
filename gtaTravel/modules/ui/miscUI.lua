miscUI = {
    tooltips = require("modules/ui/tooltips"),
    colors = {frame = {0, 50, 255}},
	boxSize = {x = 480}
}

function miscUI.draw(gtaTravel)
    gtaTravel.CPS.colorBegin("Border", miscUI.colors.frame)
    gtaTravel.CPS.colorBegin("Separator", miscUI.colors.frame)
    gtaTravel.CPS.colorBegin("Text", miscUI.colors.frame)

    ImGui.BeginChild("miscSettings", miscUI.boxSize.x, 110, true)
    ImGui.PushItemWidth(330)

    ImGui.Text("Enable GTA Travel from:")
    gtaTravel.CPS.colorEnd(1)
    ImGui.Separator()
    state, changed = ImGui.Checkbox("Fast Travel Points to Fast Travel Points",  gtaTravel.settings.miscSettings.ftp2ftp)
    if changed and state then
        miscUI.resetSettings(gtaTravel)
        gtaTravel.settings.miscSettings.ftp2ftp = state
        Game.GetPlayer().ftp2ftp = state
    end
    ImGui.Separator()
    state, changed = ImGui.Checkbox("Anywhere to Fast Travel Points", gtaTravel.settings.miscSettings.anywhere2ftp)
    if changed and state then
        miscUI.resetSettings(gtaTravel)
        gtaTravel.settings.miscSettings.anywhere2ftp = state
        Game.GetPlayer().anywhere2ftp = state
    end
    ImGui.Separator()
    state, changed = ImGui.Checkbox("Anywhere to Anywhere", gtaTravel.settings.miscSettings.anywhere2anywhere)
    if changed and state then
        miscUI.resetSettings(gtaTravel)
        gtaTravel.settings.miscSettings.anywhere2anywhere = state
        Game.GetPlayer().anywhere2anywhere = state
    end

    ImGui.PopItemWidth()
    ImGui.EndChild()

    ImGui.BeginChild("resetStuff", miscUI.boxSize.x, 75, true)
    gtaTravel.CPS.colorBegin("Text", miscUI.colors.frame)
    ImGui.Text("Reset Stuff")
    gtaTravel.CPS.colorEnd(1)
    miscUI.tooltips.drawBtn(gtaTravel, "?", "resetStuff")
    ImGui.Separator()
    cam = gtaTravel.CPS.CPButton("Reset cam", 75, 30)
    if cam then miscUI.resetCam() end
    ImGui.SameLine()
    head = gtaTravel.CPS.CPButton("Toggle Head", 90, 30)
    if head then gtaTravel.pathing.toggleHead() end
    ImGui.EndChild()

    ImGui.BeginChild("experimental", miscUI.boxSize.x, 62, true)
    gtaTravel.CPS.colorBegin("Text", miscUI.colors.frame)
    ImGui.Text("Head Settings")
    gtaTravel.CPS.colorEnd(1)
    miscUI.tooltips.drawBtn(gtaTravel, "?", "headSettings")
    ImGui.Separator()
    gtaTravel.settings.miscSettings.toggleHead = ImGui.Checkbox("Add player head during flight",  gtaTravel.settings.miscSettings.toggleHead)
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
    Game.GetPlayer().anywhere2anywhere  = false
    Game.GetPlayer().anywhere2ftp = false
    Game.GetPlayer().ftp2ftp = false
end

return miscUI