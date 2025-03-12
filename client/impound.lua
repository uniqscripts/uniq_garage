if not lib then return end

local cfg = lib.load 'config.impound'
local Impound = { Points = {} }
local Marker = lib.load 'config.general'.Markers.Impound
local hasTextUI
local Edit = require 'edit_functions'
local LastVehicle
local SpawnVehicle = require 'client.garage'.SpawnVehicle

local function FindFreeSpawn(index)
    if cfg.Locations[index] and cfg.Locations[index].spawns then
        for i = 1, #cfg.Locations[index].spawns do
            local coords = cfg.Locations[index].spawns[i]

            if #lib.getNearbyVehicles(coords.xyz, 2.0, false) == 0 then
                return coords
            end
        end
    end

    return false
end

local function DeletePreview()
    if LastVehicle then
        DeleteEntity(LastVehicle)
        LastVehicle = nil
    end
end


function Impound.CreateImpoundList(index)
    local vehicles = lib.callback.await('uniq_garage:cb:GetImpoundList', 100, index)

    if not vehicles then
        return Edit.Notify(locale('impound_empty'))
    end

    local menu = {
        id = 'uniq_garage:impound',
        title = locale('impound_title'),
        position = 'top-right',
        onSelected = function(selected, secondary, args)
            if vehicles[args.plate] then
                DeletePreview()

                if IsModelInCdimage(vehicles[args.plate].model) then
                    local hash = lib.requestModel(vehicles[args.plate].model)
                    local coords = cfg.Locations[index].coords
                    local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, GetEntityHeading(cache.ped), false, false)

                    FreezeEntityPosition(vehicle, true)
                    TaskWarpPedIntoVehicle(cache.ped, vehicle, -1)

                    LastVehicle = vehicle
                else
                    Edit.Notify(locale('invalid_model'))
                end
            end
        end,
        onClose = function(keyPressed)
            DeletePreview()
        end,
        options = {}
    }

    local options = {}

    for plate, mods in pairs(vehicles) do
        options[#options + 1] = { label = ('%s'):format(plate), args = { plate = plate } }
    end

    if #options == 0 then
        return Edit.Notify(locale('impound_empty'))
    end

    menu.options = options

    lib.registerMenu(menu, function(selected, scrollIndex, args, checked)
        if LastVehicle then
            DeleteEntity(LastVehicle)
            LastVehicle = nil

            local cb = lib.callback.await('uniq_garage:cb:HasMoney', 100, GetVehicleClass(vehicles[args.plate]))

            if not cb then
                Edit.Notify(locale('no_money'), 'error')
                return
            end

            local coords = FindFreeSpawn(index)
            
            if not coords then
                Edit.Notify(locale('no_free_spawnpoint'), 'error')
                return
            end

            SpawnVehicle(vehicles[args.plate], coords)
        else
            Edit.Notify(locale('invalid_model'))
        end
    end)


    lib.showMenu(menu.id)
end

local function NearbyImpound(point)
    ---@diagnostic disable-next-line: param-type-mismatch
    DrawMarker(Marker.id, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Marker.scaleX, Marker.scaleY, Marker.scaleZ, Marker.red, Marker.green, Marker.blue, 222, false, false, 0, true, false, false, false)

    if point.isClosest and point.currentDistance < 1.2 then
        if not hasTextUI then
            hasTextUI = point
            lib.showTextUI(locale('open_impound'))
        end

        if IsControlJustReleased(0, 38) then
            Impound.CreateImpoundList(point.index)
        end
    elseif hasTextUI == point then
        hasTextUI = nil
        lib.hideTextUI()
    end
end

function Impound.CreatePoints()
    for i = 1, #cfg.Locations do
        local coords = cfg.Locations[i].coords

        local point = lib.points.new({
            coords = coords,
            distance = 30.0,
            nearby = NearbyImpound,
            index = i
        })

        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, cfg.Locations[i].blip.id)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, cfg.Locations[i].blip.scale)
        SetBlipColour(blip, cfg.Locations[i].blip.colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(locale('impound'))
        EndTextCommandSetBlipName(blip)

        Impound.Points[#Impound.Points + 1] = point
    end
end

function Impound.DeleteImpound()
    for i = 1, #Impound.Points do
        Impound.Points[i]:remove()
    end
end


AddEventHandler('onResourceStop', function(resource)
    if cache.resource == resource then
        DeletePreview()
    end
end)


return Impound