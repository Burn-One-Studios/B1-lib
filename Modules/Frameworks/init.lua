if GetResourceState('qb-core') == 'started' then
    local file = IsDuplicityVersion() and "Modules/Frameworks/qb/Server.lua" or "Modules/Frameworks/qb/Client.lua"
    LoadResourceFile(GetCurrentResourceName(), file)
    print("B1 Framework: Loaded QB-Core Framework")
elseif GetResourceState('es_extended') == 'started' then
    local file = IsDuplicityVersion() and "Modules/Frameworks/esx/Server.lua" or "Modules/Frameworks/esx/Client.lua"
    LoadResourceFile(GetCurrentResourceName(), file)
    print("B1 Framework: Loaded ESX Framework")
end