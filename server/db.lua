local db = {}

function db.GetVehicleOwner(plate)
    if Shared.esx then
        local cb = MySQL.query.await('SELECT `owner` FROM `owned_vehicles` WHERE `plate` = ?', { plate })

        if not cb[1] then return false end

        return cb[1].owner
    elseif Shared.qb then
        local cb = MySQL.query.await('SELECT `citizenid` FROM `player_vehicles` WHERE `plate` = ?', { plate })

        if not cb[1] then return false end

        return cb[1].citizenid
    end

    return false
end

function db.StoreVehicle(plate, garage, properties)
    if Shared.esx then
        local cb = MySQL.update.await('UPDATE `owned_vehicles` SET `stored` = ?, `parking` = ?, `vehicle` = ? WHERE `plate` = ?', { 1, garage, json.encode(properties), plate })

        return cb
    elseif Shared.qb then
        local cb = MySQL.update.await('UPDATE `player_vehicles` SET `stored` = ?, `garage` = ?, `mods` = ? WHERE `plate` = ?', { 1, garage, json.encode(properties), plate })

        return cb
    end
end

function db.GetPlayerVehicles(identifier, name)
    if Shared.esx then
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
    elseif Shared.qb then
        local vehicles = MySQL.update.await('SELECT `mods` FROM `player_vehicles` WHERE `citizenid` = ? AND `garage` = ?', { identifier, name })
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
end

function db.UpdateStored(plate, identifier, stored)
    if Shared.esx then
        if Shared.esx then
            MySQL.update('UPDATE `owned_vehicles` SET `stored` = ?, `parking` = ? WHERE `plate` = ? AND `owner` = ?', { stored, nil, plate, identifier })
        end
    end
end

return db