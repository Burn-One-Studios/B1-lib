if GetResourceState('qb-core') == 'started' then
    LoadResourceFile(GetCurrentResourceName(), "Modules/Frameworks/qb/Client.lua")
elseif GetResourceState('es_extended') == 'started' then
    LoadResourceFile(GetCurrentResourceName(), "Modules/Frameworks/esx/Client.lua")
end