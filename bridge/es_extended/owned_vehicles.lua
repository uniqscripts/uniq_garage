if not lib then return end

local db = {}

function db.GetVehicleOwner(plate)
    local cb = MySQL.query.await('SELECT `owner` FROM `owned_vehicles` WHERE `plate` = ?', { plate })

    if not cb[1] then return false end

    return cb[1].owner or false
end


function db.StoreVehicle(plate, garage, properties)
    local cb = MySQL.update.await('UPDATE `owned_vehicles` SET `stored` = ?, `parking` = ?, `vehicle` = ? WHERE `plate` = ?', { 1, garage, json.encode(properties), plate })

    return cb
end


function db.GetPlayerVehicles(identifier, name)
    local data = {}
    local vehicles = MySQL.query.await('SELECT `vehicle` FROM `owned_vehicles` WHERE `owner` = ? AND `parking` = ?', { identifier, name })

    if vehicles[1] then
        for i = 1, #vehicles do
            local mods = json.decode(vehicles[i].vehicle)
            mods.plate = string.strtrim(mods.plate)

            data[mods.plate] = mods
        end
    end

    return data
end


function db.UpdateStored(plate, identifier, stored)
    MySQL.update('UPDATE `owned_vehicles` SET `stored` = ? WHERE `plate` = ? AND `owner` = ?', { stored, plate, identifier })
end


local ImpoundList = lib.load 'config.impound'.Locations
local strtrim = string.strtrim

local GetVehicleNumberPlateText = GetVehicleNumberPlateText
local GetVehiclePetrolTankHealth = GetVehiclePetrolTankHealth
local GetVehicleBodyHealth = GetVehicleBodyHealth

-- credit to: https://github.com/LukeWasTakenn/luke_garages/blob/master/server/server.lua#L54
function db.GetImpoundList(numb, identifier)
    if ImpoundList[numb] then
        local class = ImpoundList[numb].type
        local list = {}

        local vehicles = MySQL.query.await('SELECT `vehicle` FROM `owned_vehicles` WHERE `owner` = ? and type = ? AND `stored` = 0', { identifier, class })

        if vehicles[1] then
            local worldVehicles = GetAllVehicles()

            for i = 1, #vehicles do
                local mods = json.decode(vehicles[i].vehicle)
                local modPlate = strtrim(mods.plate)

                if #worldVehicles ~= nil and #worldVehicles > 0 then
                    for index = 1, #worldVehicles do
                        local vehicle = worldVehicles[index]
                        local plate = strtrim(GetVehicleNumberPlateText(vehicle))

                        if plate == modPlate then
                            if GetEntityRoutingBucket(vehicle) > 0 then
                                SetEntityRoutingBucket(vehicle, 0)
                                DeleteEntity(vehicle)
                                list[modPlate] = mods
                                break
                            end

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