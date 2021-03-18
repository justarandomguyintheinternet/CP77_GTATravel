ui = {
	speedUI = require("modules/ui/speedUI"),
    fileUI = require("modules/ui/fileUI"),
    miscUI = require("modules/ui/miscUI")
}

function ui.draw(gtaTravel)
    gtaTravel.CPS.setThemeBegin()

	if ImGui.Begin("GTA Travel 1.1", ImGuiWindowFlags.AlwaysAutoResize) then
    	ImGui.SetWindowSize(500, 550)
        
		if ImGui.BeginTabBar("Tabbar", ImGuiTabBarFlags.NoTooltip) then
            gtaTravel.CPS.styleBegin("TabRounding", 0)

            if ImGui.BeginTabItem("Speed Settings") then
                ui.speedUI.draw(gtaTravel)
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("Misc Settings") then
                miscUI.draw(gtaTravel)
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("File & Config") then
                ui.fileUI.draw(gtaTravel)
                ImGui.EndTabItem()
            end

        end
		
	end

	gtaTravel.CPS.setThemeEnd()
end

return ui