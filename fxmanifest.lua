fx_version 'cerulean'
game 'gta5'

description 'QBCore Permakill System'
author '_nullvalue'
version '1.0.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
} 
client_script 'client.lua'

shared_script '@qb-core/shared/locale.lua'
dependency 'qb-core'
