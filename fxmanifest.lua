fx_version 'cerulean'
name 'bankrobbery'
author 'Scentral (860097417144041472)'
game 'gta5'

ui_page 'source/interface/index.html'

files {
    'source/interface/index.html',
    'source/interface/script.js',
    'source/interface/style.css',
    'source/interface/assets/*.png',
    'source/interface/assets/*.mp3'
}

client_script {
    'config.lua',
    'source/client.lua'
}

server_script {
    'config.lua',
    'source/server.lua'
}
