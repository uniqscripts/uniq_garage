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
    MySQL.update('UPDATE `owned_vehicles` SET `stored` = ?, `parking` = ? WHERE `plate` = ? AND `owner` = ?', { stored, nil, plate, identifier })
end

return db