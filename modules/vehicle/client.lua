---@param model string  The model name or hash of the vehicle to spawn
---@param cb function   The callback function to execute after the vehicle has been spawned
---@param coords table  The Vector3 to spawn the vehicle at
---@param isnetworked boolean Whether or not the vehicle should be networked
---@param teleportInto boolean Whether or not the player should be teleported into the vehicle
function B1.spawnVehicle(model, cb, coords, isnetworked, teleportInto)
    local ped = PlayerPedId()
    model = type(model) == 'string' and GetHashKey(model) or model
    if not IsModelInCdimage(model) then return end
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    isnetworked = isnetworked == nil or isnetworked
    B1.requestModel(model)
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, isnetworked, false)
    local netid = NetworkGetNetworkIdFromEntity(veh)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetNetworkIdCanMigrate(netid, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehRadioStation(veh, 'OFF')
    SetVehicleFuelLevel(veh, 100.0)
    SetModelAsNoLongerNeeded(model)
    if teleportInto then TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1) end
    if cb then cb(veh) end
end

---@param vehicle string|number The vehicle to delete
function B1.getPlate(vehicle)
    if vehicle == 0 then return end
    return B1.trim(GetVehicleNumberPlateText(vehicle))
end

---@param model string|number The model name or hash of the vehicle to grab the label of
---@return string The label of the vehicle
function B1.getVehicleLabel(model)
    local label = B1.callback.await('B1-lib:getVehicleLabel', false, model)
    return label
end