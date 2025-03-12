if not lib then return end

lib.locale()

require(('bridge.%s.client'):format(Shared.framework))
require 'client.impound'

local Edit = require 'edit_me'
local GaragesData = lib.load 'config.garages'
local General = lib.load 'config.general'
local Interior = lib.load 'config.interior'
local Garage = require 'client.garage'
local Points = { enter = {}, exit = {}, park = {}, blip = {}, edit = {} }
local hasTextUI

local function nearbyPark(point)
    if cache.seat == -1 then
        ---@diagnostic disable-next-line: param-type-mismatch
		DrawMarker(General.Markers.DeleteVehicle.id, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, General.Markers.DeleteVehicle.scaleX, General.Markers.DeleteVehicle.scaleY, General.Markers.DeleteVehicle.scaleZ, General.Markers.DeleteVehicle.red, General.Markers.DeleteVehicle.green, General.Markers.DeleteVehicle.blue, 222, false, false, 0, true, false, false, false)

        if point.isClosest and point.currentDistance < 1.2 then
            if not hasTextUI then
                hasTextUI = point
                lib.showTextUI(locale('park_vehicle'))
            end

            if IsControlJustReleased(0, 38) then
                local plate = GetVehicleNumberPlateText(cache.vehicle)
                local class = GetVehicleClass(cache.vehicle)
                local properties = lib.getVehicleProperties(cache.vehicle)
                local cb, msg = lib.callback.await('uniq_garage:cb:CanStore', 1000, point.garage, plate, class, properties)

                if not cb then
                    return Edit.Notify(locale(msg), 'warning')
                end

                DeleteEntity(cache.vehicle)
            end
        elseif hasTextUI == point then
            hasTextUI = nil
            lib.hideTextUI()
        end
    elseif hasTextUI == point then
        hasTextUI = nil
        lib.hideTextUI()
    end
end

local function nearbyEnter(point)
    ---@diagnostic disable-next-line: param-type-mismatch
	DrawMarker(General.Markers.Enter.id, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, General.Markers.Enter.scaleX, General.Markers.Enter.scaleY, General.Markers.Enter.scaleZ, General.Markers.Enter.red, General.Markers.Enter.green, General.Markers.Enter.blue, 222, false, false, 0, true, false, false, false)

    if point.isClosest and point.currentDistance < 1.2 then
        if not hasTextUI then
            hasTextUI = point
            lib.showTextUI(locale('enter_garage', point.garage))
        end

        if IsControlJustReleased(0, 38) then
            if cache.vehicle then
                return Edit.Notify(locale('leave_vehicle_first'))
            end

            Garage.OpenGarageMenu(point.garage, point.interior)
            hasTextUI = nil
            lib.hideTextUI()
        end
    elseif hasTextUI == point then
        hasTextUI = nil
        lib.hideTextUI()
    end
end

function CreateGarages()
    for k, v in pairs(GaragesData) do
        local enter = lib.points.new({
            coords = v.enter,
            distance = 30.0,
            nearby = nearbyEnter,
            garage = k,
            interior = v.interior
        })

        local park = lib.points.new({
            coords = v.parkVehicle,
            distance = 30.0,
            nearby = nearbyPark,
            garage = k
        })

        local exit = lib.points.new({
            coords = Interior[v.interior].insideSpawn,
            distance = 20.0,
            nearby = Garage.NearbyExit,
        })

        if Interior[v.interior].customizationMenu then
            local edit = lib.points.new({
                coords = Interior[v.interior].customizationMenu,
                distance = 20.0,
                nearby = Garage.NearbyCustomization,
                garage = k,
                interior = v.interior
            })

            Points.edit[#Points.edit + 1] = edit
        end

        local blip = AddBlipForCoord(v.enter.x, v.enter.y, v.enter.z)
        SetBlipSprite(blip, v.blip.id)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, v.blip.scale)
        SetBlipColour(blip, v.blip.colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(k)
        EndTextCommandSetBlipName(blip)
        SetBlipCategory(blip, 10)

        Points.enter[#Points.enter + 1] = enter
        Points.exit[#Points.exit + 1] = exit
        Points.park[#Points.park + 1] = park
        Points.blip[#Points.blip + 1] = blip
    end
end

function ClearAll()
    for i = 1, #Points.enter do Points.enter[i]:remove() end
    for i = 1, #Points.park do Points.park[i]:remove() end
    for i = 1, #Points.exit do Points.exit[i]:remove() end
    for i = 1, #Points.edit do Points.edit[i]:remove() end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == cache.resource then
        ClearAll()
    end
end)