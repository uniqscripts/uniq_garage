local QBCore = exports[Shared.framework]:GetCoreObject()
local PlayerData = {}
local CheckIfInGarage = require 'client.garage'.CheckIfInGarage




AddEventHandler('onResourceStart', function(resource)
    if cache.resource == resource then
        Wait(1000)
        -- PlayerData = ESX.GetPlayerData()
        PlayerLoaded = true
        CreateGarages()
        CheckIfInGarage()
    end
end)