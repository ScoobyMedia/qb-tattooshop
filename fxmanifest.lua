fx_version 'cerulean'
games { 'gta5' }

client_scripts {
	'client/jaymenu.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

file 'AllTattoos.json'