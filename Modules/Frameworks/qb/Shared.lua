QBCore = exports["qb-core"]:getCoreObject()

if GetResourceState('qb-core') == 'started' then
    LoadResourceFile(GetCurrentResourceName(), "Modules/Frameworks/qb/Shared.lua")
end

function B1.ChangeVehicleExtra(vehicle, extra, enable)
    QBShared.ChangeVehicleExtra(vehicle, extra, enable)
end

function SetDefaultVehicleExtras(vehicle, config)
    QBShared.SetDefaultVehicleExtras(vehicle, config)
end