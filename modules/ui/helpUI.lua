helpUI = {
    tooltips = require("modules/ui/tooltips"),
    colors = {frame = {0, 50, 255}},
	boxSize = {x = 480}
}

function helpUI.draw(gtaTravel)
    gtaTravel.CPS.colorBegin("Border", speedUI.colors.frame)
    gtaTravel.CPS.colorBegin("Separator", speedUI.colors.frame)
    ------------------------------------------------------------------------------
    ImGui.BeginChild("help1", speedUI.boxSize.x, 125, true)
    gtaTravel.CPS.colorBegin("Text", speedUI.colors.frame)
    ImGui.Text("Mod wont work / nothing happens")
    gtaTravel.CPS.colorEnd(1)
    ImGui.Separator()

    ImGui.TextWrapped("- Make sure you dont have any other mods installed that affect fast traveling, like \"Fast travel from anywhere 2 anywhere\"")
    ImGui.TextWrapped("- Check your \"GTA Travel from:\" settings in the misc settings tab to enable fast travel from anywhere and more")
    ImGui.TextWrapped("- If used in a vehicle you will get teleported regularly, thats just how it works")
    ImGui.EndChild()

    gtaTravel.CPS.colorBegin("Text", speedUI.colors.frame)
    ImGui.BeginChild("help2", speedUI.boxSize.x, 150, true)
    ImGui.Text("Loading screen / stuck after / during transition")
    gtaTravel.CPS.colorEnd(1)
    ImGui.Separator()

    ImGui.TextWrapped("- First thing to try especially on slow pcs / with game on hdd, is to lower the max speeds on all paths")
    ImGui.TextWrapped("- If you travel up a bit and then get a loading screen, followed by being stuck at your original position lower your \"Player TP Dist.\" on the upward path settings")
    ImGui.TextWrapped("- If during the downward motion you get a loading screen / get stuck at the target destination lower your \"Player TP Dist.\" on the downward path settings")
    ImGui.EndChild()

    gtaTravel.CPS.colorBegin("Text", speedUI.colors.frame)
    ImGui.BeginChild("help3", speedUI.boxSize.x, 68, true)
    ImGui.Text("Other issues")
    gtaTravel.CPS.colorEnd(1)
    ImGui.Separator()

    ImGui.TextWrapped("- If you want a smoother motion that is less linear lower the speed increment / play aorund with that value")
    ImGui.EndChild()

    gtaTravel.CPS.colorEnd(2)
end

return helpUI