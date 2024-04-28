fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'rex-trapper'
version '1.0.5'

shared_scripts {
    '@ox_lib/init.lua',
    '@rsg-core/shared/locale.lua',
    'locales/en.lua', -- preferred language
    'config.lua',
}

client_scripts {
    'client/client.lua',
    'client/npcs.lua',
    'client/main.js'
}

server_scripts {
    'server/server.lua'
}

dependencies {
    'rsg-core',
    'rsg-target',
    'ox_lib',
}

exports {
    'DataViewNativeGetEventData'
}

lua54 'yes'
