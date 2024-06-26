local debug_getinfo = debug.getinfo

B1 = setmetatable({
    name = 'B1-lib',
    context = IsDuplicityVersion() and 'server' or 'client',
}, {
    __newindex = function(self, name, fn)
        rawset(self, name, fn)

        if debug_getinfo(2, 'S').short_src:find('@B1%-lib/modules') then
            exports(name, fn)
        end
    end
})

cache = {
    resource = B1.name,
    game = GetGameName(),
}

if GetResourceState('qb-core') == 'started' then
    B1.core = 'qb-core'
    CoreObject = exports['qb-core']:GetCoreObject()
    print('^2B1-lib: Using QBCore^7')
elseif GetResourceState('es_extended') == 'started' then
    B1.core = 'esx'
    CoreObject = exports['es_extended']:getSharedObject()
    print('^2B1-lib: Using ESX^7')
end

if GetResourceState('ox_inventory') == 'started' then
    B1.inventory = 'ox'
elseif GetResourceState('qb-inventory') == 'started' then
    B1.inventory = 'qb'
elseif GetResourceState('ox_inventory') ~= 'started' and GetResourceState('es_extended') == 'started' then
    B1.inventory = 'esx'
end

function B1.hasLoaded() return true end
