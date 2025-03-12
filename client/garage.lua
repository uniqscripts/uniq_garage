if not lib then return end

local Edit = require 'edit_me'
local GaragesData = lib.load 'config.garages'
local General = lib.load 'config.general'
local Interior = lib.load 'config.interior'
local ScaleForm = require 'client.carscaleform'
local TempVehicle = {}
local Garage = {}
local hasTextUI, CurrentGarageName, inPreview, InvitedPlayer
local CurrentFloor = 'exit'

lib.locale()

local function format_number(n)
    local formatted = tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return formatted:gsub("^,", "")
end


local function AwaitFadeIn()
    while IsScreenFadingIn() do
        Wait(200)
    end
end


local function AwaitFadeOut()
    while IsScreenFadingOut() do
        Wait(200)
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

function Garage.CreateOwnedVehicles(name, interior)
    local vehicles, slots = lib.callback.await('uniq_garage:cb:GetGarageVehicles', 1000, name, CurrentFloor)

    if not vehicles or not slots then return end

    Garage.DeleteVehicles()

    for id, plate in pairs(slots) do
        if plate and vehicles[plate] then
            if IsModelInCdimage(vehicles[plate].model) then
                local coords = Interior[interior].Vehicles[CurrentFloor][id]
                local model = lib.requestModel(vehicles[plate].model)
                local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, false)

                for _ = 1, 10 do
                    SetVehicleOnGroundProperly(vehicle)
                    Wait(0)
                end

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


function Garage.EnterGarage(name, interior)
    if not GaragesData[name] then return end
    if not Interior[interior] then return end

    if not IsIplActive(Interior[interior].ipl) then
        RequestIpl(Interior[interior].ipl)
    end

    if #Interior[interior].Vehicles > 1 then
        local options = {}

        for i = 1, #Interior[interior].Vehicles do
            options[i] = { label = locale("floor_label", i), value = i }
        end

        local floor = lib.inputDialog(locale("choose_floor"), {{ type = 'select', label = locale("choose_floor"), options = options, required = true }})
        if not floor then return end

        CurrentFloor = floor[1]
    else
        CurrentFloor = 1
    end

    CurrentGarageName = name
    Garage.CreateFloor(name, interior)
end


function Garage.OpenGarageMenu(name, interior)
    if not GaragesData[name] then return end
    if not Interior[interior] then return end

    local doesOwn = lib.callback.await('uniq_garage:cb:DoesOwn', false, name)
    local menu = {
        id = 'uniq_garage:main',
        title = name,
        options = doesOwn and {
            { title = locale("enter_garage_menu"), arrow = true, onSelect = function() Garage.EnterGarage(name, interior) end },
            { title = locale("sell_garage"), arrow = true }
        } or {
            { title = locale("preview_garage"), arrow = true, onSelect = function() Garage.PreviewGarage(name, interior) end },
            {
                title = locale("buy_garage"),
                description = locale("buy_garage_description", format_number(GaragesData[name].price)),
                arrow = true,
                metadata = { GaragesData[name].GarageInfo },
                onSelect = function()
                    TriggerServerEvent('uniq_garage:server:BuyGarage', name, interior)
                end
            }
        }
    }

    lib.registerContext(menu)
    lib.showContext(menu.id)
end

function Garage.GeneratePreviewCar(name, interior)
    if not GaragesData[name] then return end
    if not Interior[interior] then return end

    for i = 1, #Interior[interior].Vehicles[1] do
        local model = joaat(General.PreviewModels[GaragesData[name].type][math.random(#General.PreviewModels[GaragesData[name].type])])

        if IsModelInCdimage(model) then
            lib.requestModel(model)
            local coords = Interior[interior].Vehicles[1][i]
            local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, false, false)

            for _ = 1, 10 do
                SetVehicleOnGroundProperly(vehicle)
                Wait(0)
            end

            SetEntityInvincible(vehicle, true)
            SetVehicleDoorsLocked(vehicle, 2)

            TempVehicle[#TempVehicle + 1] = vehicle
        end
    end
end


function Garage.CreateCustmozations(name, interior)
    local GarageStyle = lib.callback.await('uniq_garage:cb:GetStyle', 100, name, CurrentFloor)

    if table.type(GarageStyle) == 'empty' then return end

    if Interior[interior].Customization.DeactivateInterior then
        Interior[interior].Customization.DeactivateInterior()
    end

    for _, customization in pairs(GarageStyle) do
        if not IsInteriorEntitySetActive(Interior[interior].interiorId, customization.name) then
            ActivateInteriorEntitySet(Interior[interior].interiorId, customization.name)
        end

        if customization.color then
            SetInteriorEntitySetColor(Interior[interior].interiorId, customization.name, customization.color)
        end
    end

    RefreshInterior(Interior[interior].interiorId)
end

function Garage.CreateFloor(name, interior)
    if not GaragesData[name] then return end
    if not Interior[interior] then return end

    TriggerServerEvent('uniq_garage:server:EnterGarage', name, CurrentFloor, false)

    DoScreenFadeOut(750)
    AwaitFadeOut()

    Garage.DeleteVehicles()
    Garage.CreateCustmozations(name, interior)

    local coords = Interior[interior].insideSpawn
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)
    SetEntityHeading(cache.ped, coords.w)

    lib.waitFor(function()
        if HasCollisionLoadedAroundEntity(cache.ped) == true then
            return true
        end
    end)

    DoScreenFadeIn(500)
    AwaitFadeIn()

    Garage.CreateOwnedVehicles(name, interior)
end


function Garage.ExitGarage()
    if not GaragesData[CurrentGarageName] then return end
    if not Interior[GaragesData[CurrentGarageName].interior] then return end

    local options = {}

    if #Interior[GaragesData[CurrentGarageName].interior].Vehicles > 1 and not inPreview and not InvitedPlayer then
        for i = 1, #Interior[GaragesData[CurrentGarageName].interior].Vehicles do
            options[i] = { label = locale("floor_label", i), value = i }
        end

        options[#options + 1] = { label = locale("exit"), value = "exit" }

        local floor = lib.inputDialog('', { { type = 'select', label = locale("choose"), options = options, required = true } })
        if not floor then return end

        CurrentFloor = floor[1]
    else
        CurrentFloor = 'exit'
    end

    if CurrentFloor == 'exit' then
        local coords = GaragesData[CurrentGarageName].enter

        DoScreenFadeOut(750)
        AwaitFadeOut()

        SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)

        lib.waitFor(function()
            if HasCollisionLoadedAroundEntity(cache.ped) == true then
                return true
            end
        end)

        DoScreenFadeIn(500)

        AwaitFadeIn()
        Garage.DeleteVehicles()
        TriggerServerEvent('uniq_garage:server:ExitGarage')

        if inPreview then
            inPreview = nil
            if Interior[GaragesData[CurrentGarageName].interior].Customization and Interior[GaragesData[CurrentGarageName].interior].Customization.DeactivateInterior then
                Interior[GaragesData[CurrentGarageName].interior].Customization.DeactivateInterior()
            end
        end

        if InvitedPlayer then
            InvitedPlayer = nil
        end

        CurrentGarageName = nil
    else
        Garage.CreateFloor(CurrentGarageName, GaragesData[CurrentGarageName].interior)
    end
end


function Garage.NearbyExit(point)
    ---@diagnostic disable-next-line: param-type-mismatch
    DrawMarker(General.Markers.Exit.id, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, General.Markers.Exit.scaleX, General.Markers.Exit.scaleY, General.Markers.Exit.scaleZ, General.Markers.Exit.red, General.Markers.Exit.green, General.Markers.Exit.blue, 222, false, false, 0, true, false, false, false)

    if point.isClosest and point.currentDistance < 1.2 then
        if not hasTextUI then
            hasTextUI = point
            lib.showTextUI(locale('exit_garage'))
        end

        if IsControlJustReleased(0, 38) then
            Garage.ExitGarage()
            hasTextUI = nil
            lib.hideTextUI()
        end
    elseif hasTextUI == point then
        hasTextUI = nil
        lib.hideTextUI()
    end
end


local PreviousSelected = nil
function Garage.CreateCutomizationMenu(garage, interior)
    if not GaragesData[garage] then return end
    if not Interior[interior] then return end

    if InvitedPlayer then
        Edit.Notify(locale('not_your_garage'), 'error')
        return
    end

    local options = {}

    for name, style in pairs(Interior[interior].Customization.Purchasable) do
        options[#options + 1] = { label = name, args = { style = name }, description = locale('total_options', #style) }
    end

    lib.registerMenu({
        id = 'uniq_garage:customization',
        title = locale('customization'),
        position = 'top-right',
        options = options,
    }, function (selected, scrollIndex, args, checked)
        if Interior[interior].Customization.Purchasable[args.style] then
            options = {}

            for numb, data in pairs(Interior[interior].Customization.Purchasable[args.style]) do
                options[#options + 1] = {
                    label = data.label,
                    description = locale('price', data.price),
                    args = {
                        label = data.label,
                        name = data.name,
                        color = data.color or nil,
                        type = data.type
                    }
                }
            end

            PreviousSelected = options[1].args.style

            lib.registerMenu({
                id = 'uniq_garage:customization:sub',
                title = args.style,
                position = 'top-right',
                options = options,
                onSelected = function(selected2, secondary2, args2)
                    if PreviousSelected then
                        if IsInteriorEntitySetActive(Interior[interior].interiorId, PreviousSelected) then
                            DeactivateInteriorEntitySet(Interior[interior].interiorId, PreviousSelected)
                        end
                    end

                    if args2.color then
                        if not IsInteriorEntitySetActive(Interior[interior].interiorId, args2.name) then
                            ActivateInteriorEntitySet(Interior[interior].interiorId, args2.name)
                        end

                        SetInteriorEntitySetColor(Interior[interior].interiorId, args2.name, args2.color)
                    else
                        if not IsInteriorEntitySetActive(Interior[interior].interiorId, args2.name) then
                            ActivateInteriorEntitySet(Interior[interior].interiorId, args2.name)
                        end
                    end

                    PreviousSelected = args2.name
                    RefreshInterior(Interior[interior].interiorId)
                end,
                onClose = function(keyPressed2)
                    if inPreview then return end
                    Garage.CreateCustmozations(garage, interior)
                end,
            }, function (selected2, scrollIndex2, args2, checked2)
                if inPreview then return end

                local cb = lib.callback.await('uniq_garage:cb:BuyCustomization', 100, {
                    garage = garage,
                    floor = CurrentFloor,
                    interior = args2,
                    int = interior,
                    color = args2.color or nil
                })

                if not cb then
                    Garage.CreateCustmozations(garage, interior)
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
            lib.showTextUI(locale('open_customization'))
        end

        if IsControlJustReleased(0, 38) then
            Garage.CreateCutomizationMenu(point.garage, point.interior)
            hasTextUI = nil
            lib.hideTextUI()
        end
    elseif hasTextUI == point then
        hasTextUI = nil
        lib.hideTextUI()
    end
end


function Garage.PreviewGarage(name, interior)
    if not GaragesData[name] then return end
    if not Interior[interior] then return end

    if not IsIplActive(Interior[interior].ipl) then
        RequestIpl(Interior[interior].ipl)
    end

    if Interior[interior].Customization and Interior[interior].Customization.DeactivateInterior then
        Interior[interior].Customization.DeactivateInterior()
    end

    if Interior[interior].Customization and Interior[interior].Customization.LoadDefault then
        Interior[interior].Customization.LoadDefault()
    end

    DoScreenFadeOut(750)
    AwaitFadeOut()

    SetEntityCoords(cache.ped, Interior[interior].insideSpawn.x, Interior[interior].insideSpawn.y, Interior[interior].insideSpawn.z, false, false, false, false)

    lib.waitFor(function()
        if HasCollisionLoadedAroundEntity(cache.ped) == true then
            return true
        end
    end)

    Garage.GeneratePreviewCar(name, interior)

    DoScreenFadeIn(500)
    AwaitFadeIn()
    inPreview = true
    CurrentFloor = 1
    CurrentGarageName = name
    TriggerServerEvent('uniq_garage:server:EnterGarage', name, CurrentFloor, true)
end

function Garage.SetPlayerInGarage(name, floor, inpreview)
    if not GaragesData[name] then return end
    if not Interior[GaragesData[name].interior] then return end

    CurrentGarageName = name
    CurrentFloor = floor

    if inpreview then
        inPreview = true
        CurrentFloor = 'exit'

        if Interior[GaragesData[name].interior].Customization and Interior[GaragesData[name].interior].Customization.LoadDefault then
            Interior[GaragesData[name].interior].Customization.LoadDefault()
        end
    else
        Garage.CreateFloor(name, GaragesData[name].interior)
    end

    TriggerServerEvent('uniq_garage:server:UpdateBucket')
end

function Garage.SpawnVehicle(mods, coords)
    if not mods then return end

    local hash = lib.requestModel(mods.model)

    local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, coords.w, true, true)
	local netid = NetworkGetNetworkIdFromEntity(vehicle)
	SetVehicleHasBeenOwnedByPlayer(vehicle, true)
	SetNetworkIdCanMigrate(netid, true)
	SetVehicleNeedsToBeHotwired(vehicle, false)
	SetVehRadioStation(vehicle, 'OFF')
	SetPedIntoVehicle(cache.ped, vehicle, -1)

	lib.setVehicleProperties(vehicle, mods)
    Edit.SetFuel(vehicle, mods.fuelLevel or 100.0)
    Edit.GiveCarKey(vehicle, mods.plate)
    TriggerServerEvent('uniq_garage:server:Orphan', VehToNet(vehicle))
end

RegisterNetEvent('uniq_garage:client:TakeVehicleOut', function(name, mods)
    if source == '' then return end

    lib.requestModel(mods.model)
    local coords = GaragesData[name].vehicleSpawnPoint

    DoScreenFadeOut(750)
    AwaitFadeOut()
    Garage.DeleteVehicles()

    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)

    lib.waitFor(function()
        if HasCollisionLoadedAroundEntity(cache.ped) == true then
            return true
        end
    end)

    Garage.SpawnVehicle(mods, coords)

    DoScreenFadeIn(500)
    AwaitFadeIn()
end)

local keybind = lib.addKeybind({
    name = 'take_vehicle_out',
    description = locale('keybind_description'),
    defaultKey = 'E',
    onReleased = function(self)
        local plate = GetVehicleNumberPlateText(cache.vehicle)
        local cb, msg = lib.callback.await('uniq_garage:cb:TakeVehicleOut', 100, CurrentGarageName, plate)

        if not cb then
            return Edit.Notify(locale(msg), 'error')
        end

        CurrentFloor = 'exit'
        lib.hideTextUI()
        TriggerServerEvent('uniq_garage:server:TakeVehicleOut', CurrentGarageName, plate)
        self:disable(true)
    end
})

keybind:disable(true)

lib.onCache('vehicle', function(value)
    if CurrentFloor == 'exit' or inPreview or InvitedPlayer then return end

    if type(value) == "number" then
        keybind:disable(false)
        lib.showTextUI(locale('take_out'))
    end
end)


lib.callback.register('uniq_garage:cb:GetGarageClient', function()
    return { garage = CurrentGarageName, floor = CurrentFloor, preview = inPreview }
end)

RegisterNetEvent('uniq_garage:client:InvitePlayer', function(players, data)
    if source == '' then return end

    local input = lib.inputDialog('', {{ type = 'select', label = locale('select_player'), options = players, required = true }})
    if not input then return end

    TriggerServerEvent('uniq_garage:server:InvitePlayer', input[1], data)
end)

lib.callback.register('uniq_garage:cb:SendInvite', function(name)
    return lib.alertDialog({
        header = locale('invite_title'),
        content = locale('invite_msg', name),
        centered = true,
        cancel = true,
        labels = {
            cancel = locale('decline'),
            confirm = locale('accept')
        }
    })
end)

RegisterNetEvent('uniq_garage:client:TeleportPlayer', function(GarageStyle, data)
    if source == '' then return end

    DoScreenFadeOut(750)
    AwaitFadeOut()

    local interior = GaragesData[data.garage].interior
    local coords = Interior[interior].insideSpawn

    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)

    if Interior[interior].Customization and Interior[interior].Customization.DeactivateInterior then
        Interior[interior].Customization.DeactivateInterior()
    end

    for _, customization in pairs(GarageStyle) do
        if not IsInteriorEntitySetActive(Interior[interior].interiorId, customization.name) then
            ActivateInteriorEntitySet(Interior[interior].interiorId, customization.name)
        end

        if customization.color then
            SetInteriorEntitySetColor(Interior[interior].interiorId, customization.name, customization.color)
        end
    end

    RefreshInterior(Interior[interior].interiorId)

    CurrentGarageName = data.garage
    CurrentFloor = data.floor
    InvitedPlayer = true

    DoScreenFadeIn(500)
    AwaitFadeIn()
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

AddEventHandler('onResourceStop', function(resource)
    if resource == cache.resource then
        if CurrentGarageName and InvitedPlayer then
            TriggerServerEvent('uniq_garage:server:TeleportOut', CurrentGarageName)
        end

        if inPreview and CurrentGarageName then
            if Interior[GaragesData[CurrentGarageName].interior].Customization and Interior[GaragesData[CurrentGarageName].interior].Customization.DeactivateInterior then
                Interior[GaragesData[CurrentGarageName].interior].Customization.DeactivateInterior()
            end
        end

        Garage.DeleteVehicles()
        lib.hideTextUI()
    end
end)

return Garage