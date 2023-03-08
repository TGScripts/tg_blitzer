fx_version 'cerulean'
games { 'gta5' }

author 'Tiger (Lets_Tiger#4159)'
description 'Blitzer Script'
version '1.0'

server_script "server.lua"

client_scripts {
	'client.lua',
	'config.lua'
}

dependencies {
	'es_extended',
	'esx_billing'
}
