if not lib then return end

local PlayerData = {}
local ESX = exports[Shared.framework]:getSharedObject()

local SetPlayerInGarage = require 'client.garage'.SetPlayerInGarage
local DeleteVehicles = require 'client.garage'.DeleteVehicles


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	PlayerLoaded = true
	while not PlayerLoaded do Wait(250) end
	CreateGarages()
    if PlayerData.metadata.garage then
        SetPlayerInGarage(PlayerData.metadata.garage.garage, PlayerData.metadata.garage.floor)
    end
end)


RegisterNetEvent('esx:onPlayerLogout', function()
    PlayerLoaded = false
    ClearAll()
    DeleteVehicles()
end)


AddEventHandler('onResourceStart', function(resource)
    if cache.resource == resource then
        Wait(1000)
        PlayerData = ESX.GetPlayerData()
        PlayerLoaded = true
        CreateGarages()

        if PlayerData.metadata.garage then
            SetPlayerInGarage(PlayerData.metadata.garage.garage, PlayerData.metadata.garage.floor)
        end
    end
end)