fx_version   'cerulean'
lua54        'yes'
game 'gta5'
author 'Burn One Studios'

description 'A libary of functions for FiveM'

client_scripts {
    'client/*.lua',
    '/Modules/Frameworks/**/Client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
    '/Modules/Frameworks/**/Server.lua',
}

shared_scripts {
    'shared/*.lua',
    '/Modules/Frameworks/init.lua',
}

files {
    '/Modules/Frameworks/init.lua',
}