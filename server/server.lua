if not lib then return end

local db = require(('bridge.%s.owned_vehicles'):format(Shared.framework))
local Framework = require(('bridge.%s.server'):format(Shared.framework))
local GaragesData = lib.load 'config.garages'
local utils = require 'server.functions'
local Interior = lib.load 'config.interior'
local Garages = {}
local PlayerVehicles = {}
local ClassList = lib.load 'config.impound'.ImpoundPrices
lib.locale()


MySQL.ready(function()
    local success, result = pcall(MySQL.scalar.await, 'SELECT 1 FROM `uniq_garage`')

    if not success then
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS `uniq_garage` (
            `owner` varchar(60) DEFAULT NULL,
            `name` varchar(100) NOT NULL,
            `data` longtext DEFAULT NULL,
            UNIQUE KEY `owner` (`owner`,`name`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
        ]])

        print('^2[success]^7 database was created successfully!')
    end

    Wait(0)

    result = MySQL.query.await('SELECT * FROM `uniq_garage`')

    if result[1] then
        for k,v in pairs(result) do
            local data = json.decode(v.data)

            if not Garages[v.owner] then
                Garages[v.owner] = {}
            end

            Garages[v.owner][v.name] = data
        end
    end
end)


lib.callback.register('uniq_garage:cb:DoesOwn', function(source, garage)
    local identifier = Framework.GetIdentifier(source)

    if not Garages[identifier] then
        return false
    end

    return Garages[identifier][garage]
end)


RegisterNetEvent('uniq_garage:server:BuyGarage', function(garage, interior)
    local src = source
    local price = GaragesData[garage].price
    local identifier = Framework.GetIdentifier(src)

    if utils.PayPrice(src, price) then
        if not Garages[identifier] then
            Garages[identifier] = {}
        end

        if not Garages[identifier][garage] then
            Garages[identifier][garage] = {}
        end

        Garages[identifier][garage].name = garage
        Garages[identifier][garage].style = Interior[interior].Customization and Interior[interior].Customization.Default or {}
        Garages[identifier][garage].slot = {}

        MySQL.insert('INSERT INTO `uniq_garage` (owner, name, data) VALUES (?, ?, ?)', { identifier, garage, json.encode(Garages[identifier][garage]) })

        TriggerClientEvent('uniq_garage:Notify', src, locale('bought_garage', garage), 'success')
    else
        TriggerClientEvent('uniq_garage:Notify', src, locale('no_money'), 'error')
    end
end)

lib.callback.register('uniq_garage:cb:BuyCustomization', function(source, data)
    local identifier = Framework.GetIdentifier(source)
    local playerGarage = Garages[identifier] and Garages[identifier][data.garage]

    if not playerGarage then return false end

    local floorStyles = playerGarage.style[data.floor]

    for _, style in ipairs(floorStyles) do
        if data.interior.color then
            if style.name == data.interior.name and tonumber(style.color) == tonumber(data.color) then
                TriggerClientEvent('uniq_garage:Notify', source, locale('have_customization'), 'error')
                return false
            end
        elseif style.name == data.interior.name then
            TriggerClientEvent('uniq_garage:Notify', source, locale('have_customization'), 'error')
            return false
        end
    end

    local price
    for _, category in pairs(Interior[data.int].Customization.Purchasable) do
        for _, item in pairs(category) do
            if item.label == data.interior.label then
                price = item.price
                break
            end
        end
        if price then break end
    end

    if not price or type(price) ~= "number" then return false end

    if utils.PayPrice(source, price) then
        local found = false

        for _, style in ipairs(floorStyles) do
            if style.type == data.interior.type then
                style.name = data.interior.name
                if data.interior.color then style.color = data.color end
                found = true
                break
            end
        end

        if not found then
            floorStyles[#floorStyles + 1] = {
                name = data.interior.name,
                color = data.interior.color and data.color or nil,
                type = data.interior.type
            }
        end

        return true
    else
        TriggerClientEvent('uniq_garage:Notify', source, locale('no_money'), 'error')
    end

    return false
end)


local function isSlotFree(name, identifier)
    if not GaragesData[name] or not Garages[identifier][name].slot then
        return false, false
    end

    local maxFloors = #Interior[GaragesData[name].interior].Vehicles or 1

    for floor = 1, maxFloors do
        if not Garages[identifier][name].slot[floor] then
            Garages[identifier][name].slot[floor] = {}
        end

        for slot = 1, #Interior[GaragesData[name].interior].Vehicles[floor] do
            if not Garages[identifier][name].slot[floor][slot] then
                return floor, slot
            end
        end
    end

    return false, false
end

local function FindSlotByPlate(name, identifier, plate)
    if not GaragesData[name] or not Garages[identifier][name].slot then
        return false, false
    end

    local maxFloors = #Interior[GaragesData[name].interior].Vehicles or 1

    for floor = 1, maxFloors do
        if Garages[identifier][name].slot[floor] then
            for slot = 1, #Interior[GaragesData[name].interior].Vehicles[floor] do
                if Garages[identifier][name].slot[floor][slot] and Garages[identifier][name].slot[floor][slot] == plate then
                    return floor, slot
                end
            end
        end
    end

    return false, false
end


lib.callback.register('uniq_garage:cb:TakeVehicleOut', function(source, name, plate)
    plate = string.strtrim(plate)
    local src = source
    local identifier = Framework.GetIdentifier(src)

    if #lib.getNearbyVehicles(GaragesData[name].vehicleSpawnPoint.xyz, 3.0, false) == 0 then
        local floor, slot = FindSlotByPlate(name, identifier, plate)

        if not floor or not slot then return false, 'something_wrong' end

        if Garages[identifier][name].slot[floor] and Garages[identifier][name].slot[floor][slot] then
            SetPlayerRoutingBucket(src, 0)
            Framework.ClearMeta(src, 'garage', nil)

            TriggerClientEvent('uniq_garage:client:TakeVehicleOut', src, name, PlayerVehicles[identifier][name][plate])

            Garages[identifier][name].slot[floor][slot] = nil
            PlayerVehicles[identifier][name][plate] = nil
            db.UpdateStored(plate, identifier, 0)

            return true
        end
    end

    return false, 'no_free_spawnpoint'
end)

lib.callback.register('uniq_garage:cb:HasMoney', function(source, class)
    local price = ClassList[class] or 100

    return utils.PayPrice(source, price)
end)


RegisterNetEvent('uniq_garage:server:UpdateBucket', function()
    local src = source
    SetPlayerRoutingBucket(src, src)
end)


lib.callback.register('uniq_garage:cb:CanStore', function(source, garage, plate, class, properties)
    if GaragesData[garage] then
        local identifier = Framework.GetIdentifier(source)
        plate = string.strtrim(plate)

        if lib.table.contains(GaragesData[garage].blackListClass, class) then
            return false, 'cant_store_here'
        end

        if not Garages[identifier] or not Garages[identifier][garage] then
            return false, 'doesnt_own'
        end

        local owner = db.GetVehicleOwner(plate)

        if not owner then
            return false, 'doesnt_own2'
        end

        if owner == identifier then
            local floor, slot = isSlotFree(garage, identifier)

            if type(slot) == "number" then
                Garages[identifier][garage].slot[floor][slot] = plate

                local cb = db.StoreVehicle(plate, garage, properties, GaragesData[garage].type)

                return cb > 0
            else
                return false, 'garage_full'
            end
        end
    else
        return false, 'something_wrong'
    end
end)


lib.callback.register('uniq_garage:cb:GetImpoundList', function(source, index)
    local identifier = Framework.GetIdentifier(source)
    local vehicles = db.GetImpoundList(index, identifier)

    return vehicles
end)


lib.callback.register('uniq_garage:cb:GetStyle', function(source, garage, floor)
    local identifier = Framework.GetIdentifier(source)

    return Garages[identifier][garage].style?[floor] or {}
end)


lib.callback.register('uniq_garage:cb:GetGarageVehicles', function(source, garage, floor)
    local identifier = Framework.GetIdentifier(source)

    if Garages[identifier][garage] then
        if not PlayerVehicles[identifier] then
            PlayerVehicles[identifier] = {}
        end

        if not PlayerVehicles[identifier][garage] then
            PlayerVehicles[identifier][garage] = {}
        end

        local vehicles = db.GetPlayerVehicles(identifier, garage)

        for plate, mods in pairs(vehicles) do
            PlayerVehicles[identifier][garage][plate] = mods
        end

        return PlayerVehicles[identifier][garage], Garages[identifier][garage].slot[floor]
    end
end)


RegisterNetEvent('uniq_garage:server:EnterGarage', function(garage, floor, inPreview)
    local playerId = source

    SetPlayerRoutingBucket(playerId, playerId)
    Framework.SetMetadata(playerId, 'garage', { garage = garage, floor = floor, inPreview = inPreview == true or nil })
end)


RegisterNetEvent('uniq_garage:server:ExitGarage', function(garage)
    local playerId = source

    SetPlayerRoutingBucket(playerId, 0)
    Framework.ClearMeta(playerId, 'garage', nil)
end)

RegisterNetEvent('uniq_garage:server:Orphan', function(id)
    local ent = NetworkGetEntityFromNetworkId(id)

    SetEntityOrphanMode(ent, 2)
end)


local function saveToDB()
    local insertTable = {}
    local query = 'UPDATE `uniq_garage` SET `data` = ? WHERE `owner` = ? AND `name` = ?'

    for owner, garages in pairs(Garages) do
        for name, garageData in pairs(garages) do
            insertTable[#insertTable + 1] = { query = query, values = { json.encode(garageData), owner, name } }
        end
    end

    if #insertTable > 0 then
        local success, response = pcall(MySQL.transaction, insertTable)

        if not success then print(response) end
    end
end


exports('DoesPlayerOwnGarage', function(identifier)
    return Garages[identifier]
end)


SetInterval(saveToDB, 600000)


local Commands = lib.load 'config.server'.Commands

if Commands.invite.enable then
    lib.addCommand(Commands.invite.name, {
        help = Commands.invite.help,
        restricted = false
    }, function(source, args, raw)
        local data = lib.callback.await('uniq_garage:cb:GetGarageClient', source)

        if not data.garage or not data.floor then
            TriggerClientEvent('uniq_garage:Notify', source, locale('only_in_garage'), 'error')
            return
        end

        if data.preview then
            TriggerClientEvent('uniq_garage:Notify', source, locale('not_in_preview'), 'error')
            return
        end

        local identifier = Framework.GetIdentifier(source)

        if not Garages[identifier][data.garage] then
            TriggerClientEvent('uniq_garage:Notify', source, locale('not_your_garage'), 'error')
            return
        end

        local players = lib.getNearbyPlayers(GaragesData[data.garage].enter, 10.0, false)

        if #players == 0 then
            TriggerClientEvent('uniq_garage:Notify', source, locale('no_player_nearby'), 'error')
            return
        end

        local options = {}

        for i = 1, #players do
            options[i] = { label = Framework.GetName(players[i].id), value = players[i].id }
        end

        TriggerClientEvent('uniq_garage:client:InvitePlayer', source, options, data)
    end)
end

RegisterNetEvent('uniq_garage:server:InvitePlayer', function(target, data)
    local src = source
    local inviter = Framework.GetName(src)
    local identifier = Framework.GetIdentifier(src)
    local cb = lib.callback.await('uniq_garage:cb:SendInvite', target, inviter)

    if cb == 'cancel' then
        TriggerClientEvent('uniq_garage:Notify', src, locale('declined_invite'), 'info')
        return
    end

    SetPlayerRoutingBucket(target, src)
    TriggerClientEvent('uniq_garage:client:TeleportPlayer', target, Garages[identifier][data.garage].style?[data.floor] or {}, data)
end)

RegisterNetEvent('uniq_garage:server:TeleportOut', function(name)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GaragesData[name].enter

    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
    SetPlayerRoutingBucket(src, 0)
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == cache.resource then saveToDB() end
end)


AddEventHandler('txAdmin:events:serverShuttingDown', function()
	saveToDB()
end)


AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining ~= 60 then return end

	saveToDB()
end)


AddEventHandler('playerDropped', function()
	if GetNumPlayerIndices() == 0 then
		saveToDB()
	end
end)

lib.versionCheck('uniqscripts/uniq_garage')