if GetResourceState('qb-core') == 'started' then
    LoadResourceFile(GetCurrentResourceName(), "Modules/Frameworks/qb/Server.lua")
elseif GetResourceState('es_extended') == 'started' then
    LoadResourceFile(GetCurrentResourceName(), "Modules/Frameworks/esx/Server.lua")
end