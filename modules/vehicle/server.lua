function B1.spawnVehicle(source, model, coords, warp)
    local ped = GetPlayerPed(source)
    model = type(model) == 'string' and joaat(model) or model
    if not coords then coords = GetEntityCoords(ped) end
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then
        while GetVehiclePedIsIn(ped) ~= veh do
            Wait(0)
            TaskWarpPedIntoVehicle(ped, veh, -1)
        end
    end
    while NetworkGetEntityOwner(veh) ~= source do Wait(0) end
    return veh
end

function B1.getPlate(netId)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if vehicle == 0 then return end
    return B1.trim(GetVehicleNumberPlateText(vehicle))
end

if B1.core == 'esx' then
    local ESXVehicles = {}
    CreateThread(function()
        local vehicles = MySQL.query.await('SELECT * FROM vehicles')
        for _, vehicle in pairs(vehicles) do
            ESXVehicles[vehicle.model] = {
                label = vehicle.name,
                category = vehicle.category
            }
        end
    end)
end

function B1.getVehicleLabel(model)
    if B1.core == 'esx' then
        return ESXVehicles[model].label
    else
        return CoreObject.Shared.Vehicles[model].brand .. ' ' .. CoreObject.Shared.Vehicles[model].name
    end
end

B1.callback.register('B1-lib:getVehicleLabel', function(source, model)
    return B1.getVehicleLabel(model)
end)