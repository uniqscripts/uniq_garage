if not lib then return end

local Framework = {
    Export = exports[Shared.framework]:GetCoreObject()
}

function Framework.GetIdentifier(playerId)
    return Framework.Export.Functions.GetPlayer(playerId)?.PlayerData.citizenid
end


function Framework.SetMetadata(playerId, name, floor)
    local xPlayer = Framework.Export.Functions.GetPlayer(playerId)

    if xPlayer and xPlayer.PlayerData then
        xPlayer.Functions.SetMetaData('garage', { garage = name, floor = floor })
    end
end

function Framework.ClearMeta(playerId)
    local xPlayer = Framework.Export.Functions.GetPlayer(playerId)

    if xPlayer and xPlayer.PlayerData then
        xPlayer.Functions.SetMetaData('garage', nil)
    end
end


return Framework