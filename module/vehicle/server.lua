-- B1-lib Vehicle Server Module
-- Server-side vehicle functions

local coreName = B1.getCoreName()
local coreObject = B1.getCoreObject()

-- Vehicle data cache
local vehicleData = {}

-- Initialize vehicle data on resource start
CreateThread(function()
    if coreName == 'esx' then
        -- Load ESX vehicle data
        local vehicles = B1.db.query('SELECT * FROM vehicles')
        for _, vehicle in ipairs(vehicles) do
            vehicleData[vehicle.model] = {
                name = vehicle.name,
                price = vehicle.price,
                category = vehicle.category
            }
        end
        B1.log('info', ('Loaded %d vehicles from database'):format(#vehicles))
    end
end)

-- Spawn vehicle for player
function B1.spawnVehicle(source, model, coords, warp)
    coords = coords or Config.VehicleDefaultSpawn
    warp = warp or true
    
    local player = B1.getCorePlayer(source)
    if not player then
        B1.log('warning', 'Player not found for spawnVehicle')
        return nil
    end
    
    local vehicle = CreateVehicle(GetHashKey(model), coords.x, coords.y, coords.z, coords.w, true, true)
    
    if not DoesEntityExist(vehicle) then
        B1.log('error', ('Failed to spawn vehicle: %s'):format(model))
        return nil
    end
    
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    
    if warp then
        local ped = GetPlayerPed(source)
        SetPedIntoVehicle(ped, vehicle, -1)
    end
    
    -- Set vehicle properties
    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleOnGroundProperly(vehicle)
    
    B1.log('info', ('Spawned vehicle %s for player %s'):format(model, source))
    return netId
end

-- Get vehicle plate
function B1.getPlate(netId)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(vehicle) then
        return nil
    end
    
    return GetVehicleNumberPlateText(vehicle)
end

-- Get vehicle label
function B1.getVehicleLabel(model)
    if coreName == 'qb-core' then
        -- Use QB shared vehicles
        local sharedVehicles = exports['qb-core']:GetVehicles()
        if sharedVehicles and sharedVehicles[model] then
            return sharedVehicles[model].name or model
        end
    elseif coreName == 'esx' then
        -- Use cached vehicle data
        if vehicleData[model] then
            return vehicleData[model].name or model
        end
    end
    
    -- Fallback to model name
    return model
end

-- Register callback for vehicle label
RegisterNetEvent('B1-lib:getVehicleLabel', function(model)
    local src = source
    local label = B1.getVehicleLabel(model)
    TriggerClientEvent('B1-lib:getVehicleLabel', src, label)
end)

-- Export functions
exports('spawnVehicle', B1.spawnVehicle)
exports('getPlate', B1.getPlate)
exports('getVehicleLabel', B1.getVehicleLabel)
