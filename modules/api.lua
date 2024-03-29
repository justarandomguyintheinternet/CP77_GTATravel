api = {
    toggled = false,
    target = nil,
    activeFromAPI = false,
    version = "1.7",
    modBlocked = false
}

function api.requestTravel(pos)
    api.done = false
    api.toggled = true
    api.target = pos
end

function api.check(gtaTravel)
    if api.toggled then
        api.activeFromAPI = true
        api.toggled = false
        gtaTravel.pathing.gtaTravelDestination = api.target
        gtaTravel.setDirForVector = true
    end
end

return api