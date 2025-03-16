--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'
version '1.0.3'

dependencies {
    'oxmysql',
    'ox_lib'
}

shared_script '@ox_lib/init.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'init.lua'
}

client_script 'init.lua'

files {
	'edit_functions.lua',
	'client/client.lua',
	'server/server.lua',
	'locales/*.json',
	'bridge/**/client.lua',
	'client/*.lua',
	'config/*.lua',
	'server/*.lua'
}