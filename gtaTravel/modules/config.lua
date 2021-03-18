config = {
    counter = 0,
    autoSaveDelay = 5
}

function config.tryAutoSave(gtaTravel, deltaTime)
    config.counter = config.counter + deltaTime
    if (config.counter > config.autoSaveDelay) then
		config.counter = config.counter - config.autoSaveDelay
        if gtaTravel.loadUpSlot ~= 0 and gtaTravel.autoSave then
            config.saveFile("config/slot" .. gtaTravel.loadUpSlot .. ".json", gtaTravel.settings)
        end
    end
end

function config.deepcopy(origin)
	local orig_type = type(origin)
    local copy
    if orig_type == 'table' then
        copy = {}
        for origin_key, origin_value in next, origin, nil do
            copy[config.deepcopy(origin_key)] = config.deepcopy(origin_value)
        end
        setmetatable(copy, config.deepcopy(getmetatable(origin)))
    else
        copy = origin
    end
    return copy
end

function config.startup(gtaTravel)
    config.tryCreateFile("config/startup.json", {slot = 1, autoSave = false})
    config.tryCreateFile("config/slot1.json", gtaTravel.defaultSettings)
    config.tryCreateFile("config/slot2.json", gtaTravel.defaultSettings)
    config.tryCreateFile("config/slot3.json", gtaTravel.defaultSettings)

    gtaTravel.loadUpSlot = config.loadFile("config/startup.json").slot
    gtaTravel.autoSave = config.loadFile("config/startup.json").autoSave
    if gtaTravel.loadUpSlot ~= 0 then
        gtaTravel.settings = config.loadFile("config/slot" .. gtaTravel.loadUpSlot .. ".json")
    else
        gtaTravel.settings = config.deepcopy(gtaTravel.defaultSettings)
    end

    Game.GetPlayer().anywhere2anywhere  = gtaTravel.settings.miscSettings.anywhere2anywhere
    Game.GetPlayer().anywhere2ftp = gtaTravel.settings.miscSettings.anywhere2ftp
    Game.GetPlayer().ftp2ftp = gtaTravel.settings.miscSettings.ftp2ftp
end

function config.fileExists(filename)
    local f=io.open(filename,"r")
    if (f~=nil) then io.close(f) return true else return false end
end

function config.tryCreateFile(path, data)
	if not config.fileExists(path) then
        local file = io.open(path, "w")
        local jconfig = json.encode(data)
        file:write(jconfig)
        file:close()
    end
end

function config.loadFile(path)    
    local file = io.open(path, "r")
    local config = json.decode(file:read("*a"))
    file:close()
    return config
end

function config.saveFile(path, data)
    local file = io.open(path, "w")
    local jconfig = json.encode(data)
    file:write(jconfig)
    file:close()
end

return config