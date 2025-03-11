if not lib then return end

local PlayerData = {}
local ESX = exports[Shared.framework]:getSharedObject()

local SetPlayerInGarage = require 'client.garage'.SetPlayerInGarage
local DeleteVehicles = require 'client.garage'.DeleteVehicles
local CreateImpound = require 'client.impound'.CreatePoints
local DeleteImpound = require 'client.impound'.DeleteImpound


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	PlayerLoaded = true

	CreateGarages()
    CreateImpound()

    if PlayerData.metadata.garage then
        SetPlayerInGarage(PlayerData.metadata.garage.garage, PlayerData.metadata.garage.floor, PlayerData.metadata.garage.inPreview)
    end
end)


RegisterNetEvent('esx:onPlayerLogout', function()
    PlayerLoaded = false
    ClearAll()
    DeleteVehicles()
    DeleteImpound()
end)


AddEventHandler('onResourceStart', function(resource)
    if cache.resource == resource then
        Wait(1000)
        PlayerData = ESX.GetPlayerData()
        PlayerLoaded = true
        CreateGarages()
        CreateImpound()

        if PlayerData.metadata.garage then
            SetPlayerInGarage(PlayerData.metadata.garage.garage, PlayerData.metadata.garage.floor, PlayerData.metadata.garage.inPreview)
        end
    end
end)