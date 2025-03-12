if not lib then return end

local db = {}

MySQL.ready(function()
    local datatype = MySQL.query.await('SHOW COLUMNS FROM `player_vehicles`')
    local hasValue = false

    for i = 1, #datatype do
        if datatype[i].Field == 'type' then
            hasValue = true
            break
        end
    end

    if not hasValue then
        MySQL.query('ALTER TABLE `player_vehicles` ADD COLUMN type varchar(20) NOT NULL DEFAULT "car"')
    end
end)

function db.GetVehicleOwner(plate)
    local cb = MySQL.query.await('SELECT `citizenid` FROM `player_vehicles` WHERE `plate` = ?', { plate })

    if not cb[1] then return false end

    return cb[1].citizenid or false
end


function db.StoreVehicle(plate, garage, properties, class)
    local cb = MySQL.update.await('UPDATE `player_vehicles` SET `state` = ?, `garage` = ?, `mods` = ?, `type` = ? WHERE `plate` = ?', { 1, garage, json.encode(properties), class, plate })

    return cb
end


function db.GetPlayerVehicles(identifier, name)
    local vehicles = MySQL.query.await('SELECT `mods` FROM `player_vehicles` WHERE `citizenid` = ? AND `garage` = ?', { identifier, name })
    local data = {}

    if vehicles[1] then
        for i = 1, #vehicles do
            local mods = json.decode(vehicles[i].mods)
            mods.plate = string.strtrim(mods.plate)

            data[mods.plate] = mods
        end
    end

    return data
end


function db.UpdateStored(plate, identifier, stored)
    MySQL.update('UPDATE `player_vehicles` SET `state` = ? WHERE `plate` = ? AND `citizenid` = ?', { stored, plate, identifier })
end

local ImpoundList = lib.load('config.impound').Locations
local strtrim = string.strtrim

local GetVehicleNumberPlateText = GetVehicleNumberPlateText
local GetVehiclePetrolTankHealth = GetVehiclePetrolTankHealth
local GetVehicleBodyHealth = GetVehicleBodyHealth

-- credit to: https://github.com/LukeWasTakenn/luke_garages/blob/master/server/server.lua#L54
function db.GetImpoundList(numb, identifier)
    if ImpoundList[numb] then
        local class = ImpoundList[numb].type
        local list = {}

        local vehicles = MySQL.query.await('SELECT `mods` FROM `player_vehicles` WHERE `citizenid` = ? and type = ? AND `state` = 0', { identifier, class })

        if vehicles[1] then
            local worldVehicles = GetAllVehicles()

            for i = 1, #vehicles do
                local mods = json.decode(vehicles[i].mods)
                local modPlate = strtrim(mods.plate)

                if #worldVehicles ~= nil and #worldVehicles > 0 then
                    for index = 1, #worldVehicles do
                        local vehicle = worldVehicles[index]
                        local plate = strtrim(GetVehicleNumberPlateText(vehicle))

                        if plate == modPlate then
                            if GetVehiclePetrolTankHealth(vehicle) > 0 and GetVehicleBodyHealth(vehicle) > 0 then break end
                            if GetVehiclePetrolTankHealth(vehicle) <= 0 and GetVehicleBodyHealth(vehicle) <= 0 then
                                DeleteEntity(vehicle)
                                list[modPlate] = mods
                            end
                            break
                        elseif index == #worldVehicles then
                            list[modPlate] = mods
                        end
                    end
                else
                    list[modPlate] = mods
                end
            end

            return list
        end
    end

    return false
end


return db