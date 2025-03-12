if not lib then return end

local Framework = {
    Export = exports[Shared.framework]:getSharedObject()
}

function Framework.GetIdentifier(playerId)
    return Framework.Export.GetPlayerFromId(playerId)?.identifier
end

function Framework.SetMetadata(playerId, key, val)
    local xPlayer = Framework.Export.GetPlayerFromId(playerId)

    if xPlayer then
        xPlayer.setMeta(key, val)
    end
end

function Framework.ClearMeta(playerId, key, val)
    local xPlayer = Framework.Export.GetPlayerFromId(playerId)

    if xPlayer then
        xPlayer.clearMeta(key)
    end
end

function Framework.GetName(playerId)
    local xPlayer = Framework.Export.GetPlayerFromId(playerId)

    if xPlayer then
        return xPlayer.getName()
    end

    return 'Unknown'
end

return Framework