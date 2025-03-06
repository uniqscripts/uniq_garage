if not lib then return end

local Framework = {
    Export = exports[Shared.framework]:GetCoreObject()
}

function Framework.GetIdentifier(playerId)
    return Framework.Export.Functions.GetPlayer(playerId)?.PlayerData.citizenid
end


function Framework.SetMetadata(playerId, key, val)
    local xPlayer = Framework.Export.Functions.GetPlayer(playerId)

    if xPlayer and xPlayer.PlayerData then
        xPlayer.Functions.SetMetaData(key, val)
    end
end

function Framework.ClearMeta(playerId, key, val)
    local xPlayer = Framework.Export.Functions.GetPlayer(playerId)

    if xPlayer and xPlayer.PlayerData then
        xPlayer.Functions.SetMetaData(key, val)
    end
end


return Framework