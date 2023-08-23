--[[ FX Information ]]--
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

--[[ Resource ]]--
name = 'byte_licenses'
author 'ByteScripts | https://bytescripts.tebex.io/ | discord.gg/6XwewsSk9W'
version 'Alpha'
description 'License script for the server'

--[[ Manifest ]]--
escrow_ignore {
    '**/*.*'
}
dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql'
}

shared_scripts {
    '@es_extended/imports.lua',
    '@oxmysql/lib/MySQL.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}



