fx_version   'cerulean'
lua54        'yes'
game 'gta5'
author 'Burn One Studios'

description 'A libary of functions for FiveM'

client_scripts {
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

shared_scripts {
    'shared/*.lua',
}

files {
    './Modules/Frameworks/*/Client.lua',
    './Modules/Frameworks/*/Server.lua',
}