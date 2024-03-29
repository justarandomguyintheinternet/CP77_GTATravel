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

    gtaTravel.loadUpSlot = config.loadFile("config/startup.json", {slot = 1, autoSave = false}).slot
    gtaTravel.autoSave = config.loadFile("config/startup.json", {slot = 1, autoSave = false}).autoSave
    if gtaTravel.loadUpSlot ~= 0 then
        gtaTravel.settings = config.loadFile("config/slot" .. gtaTravel.loadUpSlot .. ".json", gtaTravel.defaultSettings)
    else
        gtaTravel.settings = config.deepcopy(gtaTravel.defaultSettings)
    end
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

function config.loadFile(path, fallback)
    local cf
    local file = io.open(path, "r")

    local success = pcall(function ()
        cf = json.decode(file:read("*a"))
    end)

    file:close()

    if not success then
        print("[GTATravel] Error while reading config file \"" .. path .. "\", resetting it now...")
        os.remove(path)
        config.tryCreateFile(path, fallback)

        local file = io.open(path, "r")
        cf = json.decode(file:read("*a"))
        file:close()
    end

    if cf.visualSettings == nil then
        cf.visualSettings = {noHud = true, blur = true}
    end
    if cf.timeSettings == nil then
        cf.timeSettings = {speedUp = true, amount = 5}
    end

    config.saveFile(path, cf)

    return cf
end

function config.saveFile(path, data)
    local file = io.open(path, "w")
    local jconfig = json.encode(data)
    file:write(jconfig)
    file:close()
end

return config