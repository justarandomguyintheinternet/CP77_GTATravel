tooltips = {}

function tooltips.drawBtn(gtaTravel, label, key)
    ImGui.SameLine()
    ImGui.Button(label)
    active = ImGui.IsItemHovered()

    if active then
        if key == "topSpeed" then
            gtaTravel.CPS.CPToolTip1Begin(275, 45)
            ImGui.TextWrapped("This sets the top speed that you can reach during that phase")
            gtaTravel.CPS.CPToolTip1End()
        elseif key == "speedIncrement" then
            gtaTravel.CPS.CPToolTip1Begin(275, 45)
            ImGui.TextWrapped("This determines how fast you accelerate / decelerate")
            gtaTravel.CPS.CPToolTip1End()
        elseif key == "camHeight" then
            gtaTravel.CPS.CPToolTip1Begin(275, 45)
            ImGui.TextWrapped("This sets how much the cam travels upwards (Global z)")
            gtaTravel.CPS.CPToolTip1End()
        elseif key == "playerTpDistanceUp" then
            gtaTravel.CPS.CPToolTip1Begin(275, 82)
            ImGui.TextWrapped("This sets at which distance the player gets teleported away from the ground, if set too high you can get stuck in the ground forever (85 recommended)")
            gtaTravel.CPS.CPToolTip1End()
        elseif key == "playerTpDistanceDown" then
            gtaTravel.CPS.CPToolTip1Begin(275, 70)
            ImGui.TextWrapped("This sets at which distance the player gets teleported tothe ground, if set too high you there will be a loading screen (85 recommended)")
            gtaTravel.CPS.CPToolTip1End()
        elseif key == "autoSave" then
            gtaTravel.CPS.CPToolTip1Begin(275, 70)
            ImGui.TextWrapped("Enable this to autosave your current settings to the slot thats set to load with start (Runs every 5 seconds)")
            gtaTravel.CPS.CPToolTip1End()
        elseif key == "headSettings" then
            gtaTravel.CPS.CPToolTip1Begin(275, 70)
            ImGui.TextWrapped("If you encounter issues with the players head (You see him after the transition is done), disable this option")
            gtaTravel.CPS.CPToolTip1End()
        elseif key == "resetStuff" then
            gtaTravel.CPS.CPToolTip1Begin(260, 188)
            ImGui.TextWrapped("Reset Cam:\nThis resets your cam to its deault position and also removes any movement locks")
            ImGui.Separator()
            ImGui.TextWrapped("Toggle Head:\nUse this if you can see your head while in FPP view")
            ImGui.Separator()
            ImGui.TextWrapped("Restore Visual Settings:\nUse this if need to restore your previous HUD and Blur options manually if needed (After crash durring transition for example)")
            gtaTravel.CPS.CPToolTip1End()
        elseif key == "noHud" then
            gtaTravel.CPS.CPToolTip1Begin(275, 45)
            ImGui.TextWrapped("This option disables your HUD during the transition")
            gtaTravel.CPS.CPToolTip1End()
        elseif key == "blur" then
            gtaTravel.CPS.CPToolTip1Begin(275, 45)
            ImGui.TextWrapped("This option enables Motion Blur during the transition")
            gtaTravel.CPS.CPToolTip1End()
        end
    end
end

return tooltips