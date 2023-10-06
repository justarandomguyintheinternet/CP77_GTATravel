local GameSettings = require("modules/GameSettings")

util = {
    blur = ""
}

function util.applyRestrictions()
    Game.GetStatusEffectSystem():ApplyStatusEffect(GetPlayer():GetEntityID(), "GameplayRestriction.NoZooming", GetPlayer():GetRecordID(), GetPlayer():GetEntityID())
    Game.GetStatusEffectSystem():ApplyStatusEffect(GetPlayer():GetEntityID(), "GameplayRestriction.NoScanning", GetPlayer():GetRecordID(), GetPlayer():GetEntityID())
    Game.GetStatusEffectSystem():ApplyStatusEffect(GetPlayer():GetEntityID(), "GameplayRestriction.NoCombat", GetPlayer():GetRecordID(), GetPlayer():GetEntityID())
    Game.GetStatusEffectSystem():ApplyStatusEffect(GetPlayer():GetEntityID(), "GameplayRestriction.NoMovement", GetPlayer():GetRecordID(), GetPlayer():GetEntityID())

    StatusEffectHelper.RemoveStatusEffectsWithTag(GetPlayer(), "Breathing")
end

function util.removeRestrictions()
    Game.GetStatusEffectSystem():RemoveStatusEffect(GetPlayer():GetEntityID(), "GameplayRestriction.NoMovement")
    Game.GetStatusEffectSystem():RemoveStatusEffect(GetPlayer():GetEntityID(), "GameplayRestriction.NoZooming")
    Game.GetStatusEffectSystem():RemoveStatusEffect(GetPlayer():GetEntityID(), "GameplayRestriction.NoScanning")
    Game.GetStatusEffectSystem():RemoveStatusEffect(GetPlayer():GetEntityID(), "GameplayRestriction.NoCombat")

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