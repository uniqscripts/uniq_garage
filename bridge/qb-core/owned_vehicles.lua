if not lib then return end

local db = {}

function db.GetVehicleOwner(plate)
    local cb = MySQL.query.await('SELECT `citizenid` FROM `player_vehicles` WHERE `plate` = ?', { plate })

    if not cb[1] then return false end

    return cb[1].citizenid or false
end


function db.StoreVehicle(plate, garage, properties)
    local cb = MySQL.update.await('UPDATE `player_vehicles` SET `state` = ?, `garage` = ?, `mods` = ? WHERE `plate` = ?', { 1, garage, json.encode(properties), plate })

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


return db