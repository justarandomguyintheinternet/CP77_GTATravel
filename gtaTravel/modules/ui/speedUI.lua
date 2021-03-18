speedUI = {
    tooltips = require("modules/ui/tooltips"),
    colors = {frame = {0, 50, 255}},
	boxSize = {x = 480}
}

function speedUI.draw(gtaTravel)
    gtaTravel.CPS.colorBegin("Border", speedUI.colors.frame)
    gtaTravel.CPS.colorBegin("Separator", speedUI.colors.frame)
    ------------------------------------------------------------------------------
    gtaTravel.CPS.colorBegin("Text", speedUI.colors.frame)
    ImGui.BeginChild("upSettings", speedUI.boxSize.x, 125, true)
    ImGui.Text("Upward Path Settings")
    gtaTravel.CPS.colorEnd(1)
    ImGui.Separator()
    ImGui.PushItemWidth(330)
        
    gtaTravel.settings.upwardPath.topSpeed = ImGui.SliderFloat("Max Speed", gtaTravel.settings.upwardPath.topSpeed, 0.25, 15, "%.2f")
    speedUI.tooltips.drawBtn(gtaTravel, "?", "topSpeed")
    gtaTravel.settings.upwardPath.speedIncrement = ImGui.SliderFloat("Speed Increment", gtaTravel.settings.upwardPath.speedIncrement, 0.001, 0.5, "%.3f")
    speedUI.tooltips.drawBtn(gtaTravel, "?", "speedIncrement")
    gtaTravel.settings.upwardPath.camHeight = ImGui.SliderInt("Cam Height", gtaTravel.settings.upwardPath.camHeight, 300, 1500)
    speedUI.tooltips.drawBtn(gtaTravel, "?", "camHeight")
    gtaTravel.settings.upwardPath.playerTpDistance = ImGui.SliderInt("Player TP Dist.", gtaTravel.settings.upwardPath.playerTpDistance, 50, 175)
    speedUI.tooltips.drawBtn(gtaTravel, "?", "playerTpDistanceUp")
    
    ImGui.PopItemWidth()
    ImGui.EndChild()
    ------------------------------------------------------------------------------
    gtaTravel.CPS.colorBegin("Text", speedUI.colors.frame)
    ImGui.BeginChild("sideSettings", speedUI.boxSize.x, 80, true)
    ImGui.Text("Sideways Path Settings")
    ImGui.Separator()
    gtaTravel.CPS.colorEnd(1)
    ImGui.PushItemWidth(330)
        
    gtaTravel.settings.sidePath.topSpeed = ImGui.SliderFloat("Max Speed", gtaTravel.settings.sidePath.topSpeed, 0.5, 75, "%.2f")
    speedUI.tooltips.drawBtn(gtaTravel, "?", "topSpeed")
    gtaTravel.settings.sidePath.speedIncrement = ImGui.SliderFloat("Speed Increment", gtaTravel.settings.sidePath.speedIncrement, 0.0001, 1, "%.3f")
    speedUI.tooltips.drawBtn(gtaTravel, "?", "speedIncrement")

    ImGui.PopItemWidth()
    ImGui.EndChild()
    ------------------------------------------------------------------------------
    gtaTravel.CPS.colorBegin("Text", speedUI.colors.frame)
    ImGui.BeginChild("downSettings", speedUI.boxSize.x, 102, true)
    ImGui.Text("Downward Path Settings")
    gtaTravel.CPS.colorEnd(1)
    ImGui.Separator()
    ImGui.PushItemWidth(330)
        
    gtaTravel.settings.downPath.topSpeed = ImGui.SliderFloat("Max Speed", gtaTravel.settings.downPath.topSpeed, 0.25, 15, "%.2f")
    speedUI.tooltips.drawBtn(gtaTravel, "?", "topSpeed")
    gtaTravel.settings.downPath.speedIncrement = ImGui.SliderFloat("Speed Increment", gtaTravel.settings.downPath.speedIncrement, 0.001, 0.5, "%.3f")
    speedUI.tooltips.drawBtn(gtaTravel, "?", "speedIncrement")
    gtaTravel.settings.downPath.playerTpDistance = ImGui.SliderInt("Player TP Dist.", gtaTravel.settings.downPath.playerTpDistance, 1, 200)
    speedUI.tooltips.drawBtn(gtaTravel, "?", "playerTpDistanceDown")
    
    ImGui.PopItemWidth()
    ImGui.EndChild()
    ------------------------------------------------------------------------------
    gtaTravel.CPS.colorEnd(2)
    ImGui.Text("Tip: Click on a settings box, and then use up and down arrows + enter \nto enter numeric values")
    pressed = gtaTravel.CPS.CPButton("Reset Settings", 110, 30)
    if pressed then
        gtaTravel.settings = gtaTravel.config.deepcopy(gtaTravel.defaultSettings)
    end
end

return speedUI