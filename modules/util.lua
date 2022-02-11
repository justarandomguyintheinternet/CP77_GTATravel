local GameSettings = require("modules/GameSettings")

util = {
    blur = ""
}

function util.applyRestrictions()
    Game.ApplyEffectOnPlayer("GameplayRestriction.NoZooming")
	Game.ApplyEffectOnPlayer("GameplayRestriction.NoScanning")
	Game.ApplyEffectOnPlayer("GameplayRestriction.NoCombat")
    Game.ApplyEffectOnPlayer("GameplayRestriction.NoMovement")
    StatusEffectHelper.RemoveStatusEffectsWithTag(GetPlayer(), "Breathing")
end

function util.removeRestrictions()
    Game.RemoveEffectPlayer("GameplayRestriction.NoMovement")
	Game.RemoveEffectPlayer("GameplayRestriction.NoZooming")
	Game.RemoveEffectPlayer("GameplayRestriction.NoScanning")
	Game.RemoveEffectPlayer("GameplayRestriction.NoCombat")
    GetPlayer():ReevaluateAllBreathingEffects()
end

function util.toggleHUD(state)
    if not Game.GetPlayer() then return end

    if state then
        local blackboardDefs = Game.GetAllBlackboardDefs()
        local blackboardPSM = Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), blackboardDefs.PlayerStateMachine)
        blackboardPSM:SetInt(blackboardDefs.PlayerStateMachine.SceneTier, 1, true)
    else
        local blackboardDefs = Game.GetAllBlackboardDefs()
        local blackboardPSM = Game.GetBlackboardSystem():GetLocalInstanced(Game.GetPlayer():GetEntityID(), blackboardDefs.PlayerStateMachine)
        blackboardPSM:SetInt(blackboardDefs.PlayerStateMachine.SceneTier, 3, true)
    end
end

function util.toggleBlur(state)
    print(GameSettings.Get("/graphics/basic/MotionBlur"))

    if state then
        util.blur = GameSettings.Get("/graphics/basic/MotionBlur")
        GameSettings.Set('/graphics/basic/MotionBlur', "High")
        GameSettings.Save()
    else
        if util.blur ~= "" then
            GameSettings.Set('/graphics/basic/MotionBlur', util.blur)
            GameSettings.Save()
        end
    end
end

return util