local QBCore = exports[Shared.framework]:GetCoreObject()
local PlayerData = {}

local SetPlayerInGarage = require 'client.garage'.SetPlayerInGarage
local DeleteVehicles = require 'client.garage'.DeleteVehicles

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerLoaded = true

    Wait(1000)
    CreateGarages()
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)


RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerLoaded = false
    ClearAll()
    DeleteVehicles()
end)


AddEventHandler('onResourceStart', function(resource)
    if cache.resource == resource then
        Wait(1000)
        PlayerData = QBCore.Functions.GetPlayerData()
        PlayerLoaded = true
        CreateGarages()

        if PlayerData.metadata.garage then
            SetPlayerInGarage(PlayerData.metadata.garage.garage, PlayerData.metadata.garage.floor)
        end
    end
end)