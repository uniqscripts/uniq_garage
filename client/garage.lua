if not lib then return end

local Edit = require 'edit_me'
local GaragesData = lib.load('config.garages')
local General = lib.load('config.general')
local ScaleForm = require 'client.carscaleform'
local TempVehicle = {}
local Garage = {}
local hasTextUI, CurrentGarageName, inPreview
local CurrentFloor = 'exit'

local function format_number(n)
    local formatted = tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return formatted:gsub("^,", "")
end

function Garage.AwaitFadeIn()
    while IsScreenFadingIn() do
        Wait(200)
    end
end


function Garage.AwaitFadeOut()
    while IsScreenFadingOut() do
        Wait(200)
    end
end


function Garage.CreateOwnedVehicles(name)
    local vehicles, slots = lib.callback.await('uniq_garage:cb:GetGarageVehicles', 1000, name, CurrentFloor)

    if not vehicles or not slots then return end

    for id, plate in pairs(slots) do
        if plate and vehicles[plate] then
            if IsModelInCdimage(vehicles[plate].model) then
                local coords = GaragesData[name].Vehicles[CurrentFloor][id]
                local model = lib.requestModel(vehicles[plate].model)
                local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, false, false)

                for _ = 1, 10 do
                    SetVehicleOnGroundProperly(vehicle)
                    Wait(0)
                end

                -- FreezeEntityPosition(vehicle, true)
                lib.setVehicleProperties(vehicle, vehicles[plate])
                Edit.GiveCarKey(vehicle, plate)

                TempVehicle[#TempVehicle + 1] = vehicle
            end
        end
    end

    if #TempVehicle > 0 then
        if General.VehicleScaleFormInfo then
            ScaleForm.VehicleStatus(TempVehicle)
        end
    end
end


function Garage.EnterGarage(name)
    if not GaragesData[name] then return end

    if not IsIplActive(GaragesData[name].ipl) then
        RequestIpl(GaragesData[name].ipl)
    end

    if GaragesData[name].hasMultipleFloors then
        local options = {}

        for i = 1, #GaragesData[name].Vehicles do
            options[i] = { label = ('Floor %s'):format(i), value = i }
        end

        local floor = lib.inputDialog('Chose Floor', { { type = 'select', label = 'Chose Floor', options = options, required = true } })
        if not floor then return end

        CurrentFloor = floor[1]
    else
        CurrentFloor = 1
    end

    Garage.CreateFloor(name)
end


function Garage.OpenGarageMenu(name)
    if not GaragesData[name] then return end
    local doesOwn = lib.callback.await('uniq_garage:cb:DoesOwn', false, name)
    local menu = {
        id = 'uniq_garage:main',
        title = name,
        options = doesOwn and {
            { title = 'Enter Garage', arrow = true, onSelect = function() Garage.EnterGarage(name) end },
            { title = 'Sell Garage', arrow = true }
        } or {
            { title = 'Preview', arrow = true, onSelect = function() Garage.PreviewGarage(name) end },
            {
                title = 'Buy Garage',
                description = ('Buy for €%s'):format(format_number(GaragesData[name].price)),
                arrow = true,
                metadata = { GaragesData[name].GarageInfo },
                onSelect = function()
                    TriggerServerEvent('uniq_garage:server:BuyGarage', name)
                end
            }
        }
    }

    lib.registerContext(menu)
    lib.showContext(menu.id)
end

function Garage.GeneratePreviewCar(name)
    if not GaragesData[name] then return end

    for i = 1, #GaragesData[name].Vehicles[1] do
        local model = joaat(General.PreviewModels[math.random(#General.PreviewModels)])

        if IsModelInCdimage(model) then
            lib.requestModel(model)
            local coords = GaragesData[name].Vehicles[1][i]
            local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, false, false)

            for _ = 1, 10 do
                SetVehicleOnGroundProperly(vehicle)
                Wait(0)
            end

            SetVehicleDoorsLocked(vehicle, 2)

            TempVehicle[#TempVehicle + 1] = vehicle
        end
    end
end


function Garage.DeleteVehicles()
    for i = 1, #TempVehicle do
        if DoesEntityExist(TempVehicle[i]) then
            DeleteEntity(TempVehicle[i])
        end
    end

    TempVehicle = {}
    if General.VehicleScaleFormInfo then
        ScaleForm.HideVehicleStatus()
    end
end


function Garage.CreateCustmozations(name)
    local GarageStyle = lib.callback.await('uniq_garage:cb:GetStyle', 100, name, CurrentFloor)

    if table.type(GarageStyle) ~= 'empty' then
        if GaragesData[name].Customization.DeactivateInterior then GaragesData[name].Customization.DeactivateInterior() end

        for _, customization in pairs(GarageStyle) do
            if type(customization) == "table" then
                if customization.color then
                    if not IsInteriorEntitySetActive(GaragesData[name].interiorId, customization.entity) then
                        ActivateInteriorEntitySet(GaragesData[name].interiorId, customization.entity)
                    end

                    SetInteriorEntitySetColor(GaragesData[name].interiorId, customization.entity, customization.color)
                end
            else
                if not IsInteriorEntitySetActive(GaragesData[name].interiorId, customization) then
                    ActivateInteriorEntitySet(GaragesData[name].interiorId, customization)
                end
            end
        end

        RefreshInterior(GaragesData[name].interiorId)
    end
end

function Garage.CreateFloor(name)
    if not GaragesData[name] then return end

    TriggerServerEvent('uniq_garage:server:EnterGarage', name, CurrentFloor, false)
    DoScreenFadeOut(750)

    Garage.AwaitFadeOut()
    Garage.DeleteVehicles()

    Garage.CreateCustmozations(name)

    SetEntityCoords(cache.ped, GaragesData[name].insideSpawn.x, GaragesData[name].insideSpawn.y, GaragesData[name].insideSpawn.z, false, false, false, false)
    SetEntityHeading(cache.ped, GaragesData[name].insideSpawn.w)

    DoScreenFadeIn(500)
    Garage.AwaitFadeIn()

    Garage.CreateOwnedVehicles(name)
end

function Garage.ExitGarage(name)
    if not GaragesData[name] then return end
    local options = {}

    if GaragesData[name].hasMultipleFloors and not inPreview then
        for i = 1, #GaragesData[name].Vehicles do
            options[i] = { label = ('Floor %s'):format(i), value = i }
        end

        options[#options + 1] = { label = 'Exit', value = 'exit' }

        local floor = lib.inputDialog('', { { type = 'select', label = 'Chose', options = options, required = true } })
        if not floor then return end

        CurrentFloor = floor[1]
    else
        CurrentFloor = 'exit'
    end

    if CurrentFloor == 'exit' then
        local coords = GaragesData[name].enter

        DoScreenFadeOut(750)
        Garage.AwaitFadeOut()

        SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)
        DoScreenFadeIn(500)

        Garage.AwaitFadeIn()
        Garage.DeleteVehicles()
        TriggerServerEvent('uniq_garage:server:ExitGarage')
        
        if inPreview then
            inPreview = nil
            if GaragesData[name].Customization and GaragesData[name].Customization.DeactivateInterior then
                GaragesData[name].Customization.DeactivateInterior()
            end
        end
    else
        Garage.CreateFloor(name)
    end
end


function Garage.NearbyExit(point)
    ---@diagnostic disable-next-line: param-type-mismatch
    DrawMarker(General.Markers.Exit.id, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, General.Markers.Exit.scaleX, General.Markers.Exit.scaleY, General.Markers.Exit.scaleZ, General.Markers.Exit.red, General.Markers.Exit.green, General.Markers.Exit.blue, 222, false, false, 0, true, false, false, false)

    if point.isClosest and point.currentDistance < 1.2 then
        if not hasTextUI then
            hasTextUI = point
            lib.showTextUI('[E] - Exit')
        end

        if IsControlJustReleased(0, 38) then
            Garage.ExitGarage(point.garage)
            hasTextUI = nil
            lib.hideTextUI()
        end
    elseif hasTextUI == point then
        hasTextUI = nil
        lib.hideTextUI()
    end
end


local PreviousSelected = nil
function Garage.CreateCutomizationMenu(garage)
    if not GaragesData[garage] then return end

    local options = {}

    for name, style in pairs(GaragesData[garage].Customization.Purchasable) do
        options[#options + 1] = { label = name, args = { style = name }, description = ('Total %s options'):format(#style) }
    end

    lib.registerMenu({
        id = 'uniq_garage:customization',
        title = 'Customization Menu',
        position = 'top-right',
        options = options,
        onClose = function(keyPressed)
            if inPreview == true then return end

            -- load purchased
        end,
    }, function (selected, scrollIndex, args, checked)
        if GaragesData[garage].Customization.Purchasable[args.style] then
            options = {}

            for numb, data in pairs(GaragesData[garage].Customization.Purchasable[args.style]) do
                options[#options + 1] = { label = data.label, description = ('Price €%s'):format(data.price), args = { style = data.style, color = data.color or nil, type = data.type } }
            end

            PreviousSelected = options[1].args.style

            lib.registerMenu({
                id = 'uniq_garage:customization:sub',
                title = args.style,
                position = 'top-right',
                options = options,
                onSelected = function(selected2, secondary2, args2)
                    if PreviousSelected then
                        if IsInteriorEntitySetActive(GaragesData[garage].interiorId, PreviousSelected) then
                            DeactivateInteriorEntitySet(GaragesData[garage].interiorId, PreviousSelected)
                        end
                    end

                    if args2.color then
                        if not IsInteriorEntitySetActive(GaragesData[garage].interiorId, args2.style) then
                            ActivateInteriorEntitySet(GaragesData[garage].interiorId, args2.style)
                        end

                        SetInteriorEntitySetColor(GaragesData[garage].interiorId, args2.style, selected2)
                    else
                        if not IsInteriorEntitySetActive(GaragesData[garage].interiorId, args2.style) then
                            ActivateInteriorEntitySet(GaragesData[garage].interiorId, args2.style)
                        end
                    end

                    PreviousSelected = args2.style
                    RefreshInterior(GaragesData[garage].interiorId)
                end,
                onClose = function(keyPressed2)
                    if inPreview == true then return end
                    Garage.CreateCustmozations(garage)
                end,
            }, function (selected2, scrollIndex2, args2, checked2)
                if inPreview == true then return end

                local cb = lib.callback.await('uniq_garage:cb:BuyCustomization', false, garage, CurrentFloor, args2, args2.color and selected2 or nil)

                if not cb then
                    Garage.CreateCustmozations(garage)
                end
            end)

            lib.showMenu('uniq_garage:customization:sub')
        end
    end)

    lib.showMenu('uniq_garage:customization')
end


function Garage.NearbyCustomization(point)
    ---@diagnostic disable-next-line: param-type-mismatch
    DrawMarker(General.Markers.CustomizationMenu.id, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, General.Markers.CustomizationMenu.scaleX, General.Markers.CustomizationMenu.scaleY, General.Markers.CustomizationMenu.scaleZ, General.Markers.CustomizationMenu.red, General.Markers.CustomizationMenu.green, General.Markers.CustomizationMenu.blue, 222, false, false, 0, true, false, false, false)

    if point.isClosest and point.currentDistance < 1.2 then
        if not hasTextUI then
            hasTextUI = point
            lib.showTextUI('[E] - Open Customization Menu')
        end

        if IsControlJustReleased(0, 38) then
            Garage.CreateCutomizationMenu(point.garage)
            hasTextUI = nil
            lib.hideTextUI()
        end
    elseif hasTextUI == point then
        hasTextUI = nil
        lib.hideTextUI()
    end
end


function Garage.PreviewGarage(name)
    if not GaragesData[name] then return end

    if not IsIplActive(GaragesData[name].ipl) then
        RequestIpl(GaragesData[name].ipl)
    end

    if GaragesData[name].Customization and GaragesData[name].Customization.LoadDefault then
        GaragesData[name].Customization.LoadDefault()
    end

    DoScreenFadeOut(750)
    Garage.AwaitFadeOut()

    SetEntityCoords(cache.ped, GaragesData[name].insideSpawn.x, GaragesData[name].insideSpawn.y, GaragesData[name].insideSpawn.z, false, false, false, false)
    Garage.GeneratePreviewCar(name)

    DoScreenFadeIn(500)
    Garage.AwaitFadeIn()
    inPreview = true
    CurrentFloor = 1
    TriggerServerEvent('uniq_garage:server:EnterGarage', name, CurrentFloor, true)
end

function Garage.SetPlayerInGarage(name, floor, inpreview)
    if not GaragesData[name] then return end

    CurrentGarageName = name
    CurrentFloor = floor

    if inpreview == true then
        inPreview = true
        CurrentFloor = 'exit'

        if GaragesData[name].Customization and GaragesData[name].Customization.LoadDefault then
            GaragesData[name].Customization.LoadDefault()
        end
    else
        Garage.CreateFloor(name)
    end

    TriggerServerEvent('uniq_garage:server:UpdateBucket')
end

local keybind = lib.addKeybind({
    name = 'take_vehicle_out',
    description = 'Press E to take vehicle out',
    defaultKey = 'E',
    onReleased = function(self)
        if inPreview == true then return end
        local plate = GetVehicleNumberPlateText(cache.vehicle)

        CurrentFloor = 'exit'
        lib.hideTextUI()
        TriggerServerEvent('uniq_garage:server:TakeVehicleOut', CurrentGarageName, plate)
        self:disable(true)
    end
})

keybind:disable(true)

RegisterNetEvent('uniq_garage:client:TakeVehicleOut', function(name, mods)
    if source == '' then return end

    lib.requestModel(mods.model)
    local coords = GaragesData[name].vehicleSpawnPoint

    DoScreenFadeOut(750)
    Garage.AwaitFadeOut()
    Garage.DeleteVehicles()

    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)

    local vehicle = CreateVehicle(mods.model, coords.x, coords.y, coords.z, coords.w, true, false)
	local netid = NetworkGetNetworkIdFromEntity(vehicle)
	SetVehicleHasBeenOwnedByPlayer(vehicle, true)
	SetNetworkIdCanMigrate(netid, true)
	SetVehicleNeedsToBeHotwired(vehicle, false)
	SetVehRadioStation(vehicle, 'OFF')
	SetPedIntoVehicle(cache.ped, vehicle, -1)
	-- SetEntityHeading(veh, GetEntityHeading(cache.ped))

	lib.setVehicleProperties(vehicle, mods)
    Edit.SetFuel(vehicle, mods.fuelLevel or 100.0)
    Edit.GiveCarKey(vehicle, mods.plate)

    DoScreenFadeIn(500)
    Garage.AwaitFadeIn()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == cache.resource then
        if inPreview and CurrentGarageName then
            print(json.encode(CurrentGarageName, { indent = true }))
            if GaragesData[CurrentGarageName].Customization.DeactivateInterior then
                GaragesData[CurrentGarageName].Customization.DeactivateInterior()
            end
        end

        Garage.DeleteVehicles()
        lib.hideTextUI()
    end
end)

RegisterCommand('getint', function (source, args, raw)
   local coors = GetEntityCoords(cache.ped)
   local int = GetInteriorAtCoords(coors.x, coors.y, coors.z)

   print(json.encode(int, { indent = true }))
end)

lib.onCache('vehicle', function(value)
    if CurrentFloor == 'exit' then return end

    if type(value) == "number" then
        keybind:disable(false)
        lib.showTextUI('[E] - take out')
    end
end)


AddEventHandler('onResourceStart', function(resource)
    if cache.resource == resource then
        for i = 1, #General.PreviewModels do
            local model = joaat(General.PreviewModels[i])
            
            if not IsModelInCdimage(model) then
                warn(('%s is not valid model or not part of your game build'):format(General.PreviewModels[i]))
            end
        end
    end
end)

return Garage