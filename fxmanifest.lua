fx_version 'cerulean'
games { 'gta5' }

author 'Tiger (Lets_Tiger#4159)'
description 'Blitzer Script'
version '1.4'

lua54 'yes'

server_script "server/version_check.lua"

client_scripts {
	'client/main.lua',
	'config.lua'
}

dependencies {
	'es_extended',
	'esx_billing'
}
