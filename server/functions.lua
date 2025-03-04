if not lib then return end

local Framework = require(('bridge.%s.server'):format(Shared.framework))
local Function = {}

function Function.BuyGarage(playerId, price)
    if Shared.esx then
        local xPlayer = Framework.Export.GetPlayerFromId(playerId)

        if xPlayer then
            local money = xPlayer.getInventoryItem('money').count or 0

            if money >= price then
                xPlayer.removeInventoryItem('money', price)
                return true
            end

            money = xPlayer.getAccount('bank')?.money or 0

            if money >= price then
                xPlayer.removeAccountMoney('bank', price)
                return true
            end
        end
    else
        local xPlayer = Framework.Export.Functions.GetPlayer(playerId)

        if xPlayer then
            local money = xPlayer.Functions.GetMoney('cash') or 0

            if money >= price then
                xPlayer.Functions.RemoveMoney('cash', price)
                return true
            end

            money = xPlayer.Functions.GetMoney('bank') or 0

            if money >= price then
                xPlayer.Functions.RemoveMoney('bank', price)
                return true
            end
        end
    end

    return false
end

return Function