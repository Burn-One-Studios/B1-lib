fx_version 'cerulean'
game 'gta5'

author 'b1-lib'
description 'Small, easy-to-use FiveM library'
version '1.0.0'

-- Dependencies
dependencies {
    'oxmysql'
}

-- Optional dependencies
optional_dependencies {
    'ox_inventory',
    'ox_lib',
    'ZSX_UIV2'
}

-- Shared files
shared_scripts {
    'config.lua',
    'module/core/shared.lua',
    'module/log/shared.lua',
    'module/utils/shared.lua',
    'module/ui/shared.lua'
}

-- Server files
server_scripts {
    'module/db/server.lua',
    'module/player/server.lua',
    'module/vehicle/server.lua',
    'module/inventory/server.lua'
}

-- Client files
client_scripts {
    'module/player/client.lua',
    'module/vehicle/client.lua'
}

-- Exports
exports {
    -- Core
    'getB1Object',
    
    -- Logger
    'log',
    'set_log_level',
    'get_log_level',
    
    -- Utils
    'randomStr',
    'randomInt',
    'splitStr',
    'sanitizeString',
    'removeChars',
    'trim',
    'firstToUpper',
    'round',
    'getCoreName',
    'getInventoryName',
    'getCoreObject',
    'getNotificationSystem',
    'getProgressBarSystem',
    'getSkillCheckSystem',
    
    -- UI (client only)
    'notify',
    'progressBar',
    'skillCheck',
    'removeNotification',
    
    -- UI (server to client)
    'notifyServer',
    
    -- DB (server only)
    'db_query',
    'db_single',
    'db_scalar',
    'db_insert',
    'db_update',
    'orm_define',
    
    -- Player (server)
    'getCorePlayer',
    'getPlayerByIdentifier',
    'getOfflinePlayerByIdentifier',
    'getPlayers',
    'addMoney',
    'removeMoney',
    'getMoney',
    'setMoney',
    'getLicences',
    'getLicence',
    'addLicence',
    'removeLicence',
    'getCitizenId',
    'getPlayerName',
    
    -- Player (client)
    'getCorePlayerData',
    'getPlayerData',
    'getPlayerJob',
    'getPlayerGang',
    'getPlayerMoney',
    'getPlayerName',
    'getCitizenId',
    
    -- Vehicle (server)
    'spawnVehicle',
    'getPlate',
    'getVehicleLabel',
    
    -- Vehicle (client)
    'spawnVehicle',
    'getPlate',
    'getVehicleLabel',
    
    -- Inventory (server)
    'inv_add',
    'inv_remove',
    'inv_can_carry',
    'inv_get',
    'inv_search'
}
