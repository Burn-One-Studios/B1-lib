-- B1-lib Vehicle Client Module
-- Client-side vehicle functions

-- Spawn vehicle (client)
function B1.spawnVehicleClient(model, cb, coords, isnetworked, teleportInto)
    coords = coords or Config.VehicleDefaultSpawn
    isnetworked = isnetworked or true
    teleportInto = teleportInto or true
    
    local vehicle = CreateVehicle(GetHashKey(model), coords.x, coords.y, coords.z, coords.w, isnetworked, true)
    
    if not DoesEntityExist(vehicle) then
        B1.log('error', ('Failed to spawn vehicle: %s'):format(model))
        if cb then cb(nil) end
        return nil
    end
    
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    
    if teleportInto then
        local ped = PlayerPedId()
        SetPedIntoVehicle(ped, vehicle, -1)
    end
    
    -- Set vehicle properties
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleOnGroundProperly(vehicle)
    
    B1.log('info', ('Spawned vehicle: %s'):format(model))
    
    if cb then cb(netId) end
    return netId
end

-- Get vehicle plate (client)
function B1.getPlateClient(vehicle)
    if type(vehicle) == 'number' then
        -- Network ID provided
        vehicle = NetworkGetEntityFromNetworkId(vehicle)
    end
    
    if not DoesEntityExist(vehicle) then
        return nil
    end
    
    return GetVehicleNumberPlateText(vehicle)
end

-- Get vehicle label via server callback (client)
function B1.getVehicleLabelClient(model)
    local promise = promise.new()
    RegisterNetEvent('B1-lib:getVehicleLabel', function(label)
        promise:resolve(label)
    end)
    TriggerServerEvent('B1-lib:getVehicleLabel', model)
    return Citizen.Await(promise)
end

-- Export functions
exports('spawnVehicle', B1.spawnVehicleClient)
exports('getPlate', B1.getPlateClient)
exports('getVehicleLabel', B1.getVehicleLabelClient)
