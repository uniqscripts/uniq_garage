QBCore = exports[Shared.framework]:GetCoreObject()

function GetIdentifier(playerId)
    return QBCore.Functions.GetPlayer(playerId)?.PlayerData.citizenid
end