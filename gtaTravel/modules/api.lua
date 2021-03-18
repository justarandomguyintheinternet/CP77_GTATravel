api = {
    toggled = false,
    target = nil
}

function api.requestTravel(pos)
    api.done = false
    api.toggled = true
    api.target = pos
end

function api.check(gtaTravel)
    if api.toggled then
        api.toggled = false
        gtaTravel.pathing.gtaTravelDestination = api.target
        gtaTravel.setDirForVector = true
    end
end

return api