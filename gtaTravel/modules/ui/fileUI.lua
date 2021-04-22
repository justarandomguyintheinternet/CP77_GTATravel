fileUI = {
    tooltips = require("modules/ui/tooltips"),
    colors = {frame = {0, 50, 255}},
	boxSize = {x = 480},
    statusText = ""
}

function fileUI.draw(gtaTravel)
    fileUI.drawSlot(gtaTravel, 1)
    fileUI.drawSlot(gtaTravel, 2)
    fileUI.drawSlot(gtaTravel, 3)
    gtaTravel.autoSave, pressed = ImGui.Checkbox("Autosave to load with start slot", gtaTravel.autoSave)
    if pressed then gtaTravel.config.saveFile("config/startup.json", {slot = gtaTravel.loadUpSlot, autoSave = gtaTravel.autoSave}) end

    speedUI.tooltips.drawBtn(gtaTravel, "?", "autoSave")
    ImGui.Text(fileUI.statusText)
end

function fileUI.drawSlot(gtaTravel, slot)
    gtaTravel.CPS.colorBegin("Text", fileUI.colors.frame)
    gtaTravel.CPS.colorBegin("Border", fileUI.colors.frame)
    gtaTravel.CPS.colorBegin("Separator", fileUI.colors.frame)
    ImGui.BeginChild("slot"..slot, fileUI.boxSize.x, 75, true)
	
	title = "Slot ".. slot
    ImGui.Text(title)
	ImGui.Separator()

	l = gtaTravel.CPS.CPButton("Load", 60, 30)
	ImGui.SameLine()
	save = gtaTravel.CPS.CPButton("Save", 60, 30)
	ImGui.SameLine()
	reset = gtaTravel.CPS.CPButton("Reset", 60, 30)
	ImGui.SameLine()

    if l then
        gtaTravel.settings = gtaTravel.config.loadFile("config/slot" .. slot .. ".json")
        fileUI.statusText = "Loaded slot ".. slot
    end
    if save then
        gtaTravel.config.saveFile("config/slot" .. slot .. ".json", gtaTravel.settings)
        fileUI.statusText = "Saved current settings to slot ".. slot
    end
    if reset then
        gtaTravel.config.saveFile("config/slot" .. slot .. ".json", gtaTravel.defaultSettings)
        fileUI.statusText = "Reset slot ".. slot
    end

    state = false
    if gtaTravel.loadUpSlot == slot then
        state = true
    end

    state, changed = ImGui.Checkbox("Load with start", state)
    if state == true and changed then
		gtaTravel.loadUpSlot = slot
		gtaTravel.config.saveFile("config/startup.json", {slot = slot, autoSave = gtaTravel.autoSave})
	elseif state == false and changed then
		gtaTravel.loadUpSlot = 0
		gtaTravel.config.saveFile("config/startup.json", {slot = 0, autoSave = gtaTravel.autoSave})
	end

    ImGui.EndChild()
    gtaTravel.CPS.colorEnd(3)
end

return fileUI