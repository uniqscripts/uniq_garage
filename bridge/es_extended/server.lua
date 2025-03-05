if not lib then return end

local Framework = {
    Export = exports[Shared.framework]:getSharedObject()
}

function Framework.GetIdentifier(playerId)
    return Framework.Export.GetPlayerFromId(playerId)?.identifier
end

function Framework.SetMetadata(playerId, name, floor)
    local xPlayer = Framework.Export.GetPlayerFromId(playerId)

    if xPlayer then
        xPlayer.setMeta('garage', { garage = name, floor = floor })
    end
end

function Framework.ClearMeta(playerId)
    local xPlayer = Framework.Export.GetPlayerFromId(playerId)

    if xPlayer then
        xPlayer.clearMeta('garage')
    end
end

return Framework