local Edit = {}

function Edit.SetFuel(vehicle, fuel)
    SetVehicleFuelLevel(vehicle, fuel)
end


function Edit.GiveCarKey(vehicle, plate)
    if Shared.qb then
        TriggerEvent('vehiclekeys:client:SetOwner', plate)
    end
end


function Edit.Notify(description, type)
    lib.notify({
        description = description,
        duration = 4500,
        type = type,
        position = 'bottom'
    })
end


function Edit.RemoveKeys(vehicle, plate)
    
end


RegisterNetEvent('uniq_garage:Notify', Edit.Notify)


return Edit