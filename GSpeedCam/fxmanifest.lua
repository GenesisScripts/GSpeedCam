fx_version 'cerulean'
game 'gta5'

lua54 'yes'

description 'Genesis Speed cams'
version '1.0.0'

server_scripts {
  'server/main.lua',
  '@oxmysql/lib/MySQL.lua',
   '@es_extended/locale.lua',
}

client_scripts {
  'client/main.lua',
  '@es_extended/locale.lua',
}

shared_script { 
  '@ox_lib/init.lua',
  'config.lua'
}