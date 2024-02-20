--[[ ===================================================== ]] --
--[[          MH Blackmoney Wash Script by MaDHouSe        ]] --
--[[ ===================================================== ]] --
fx_version 'cerulean'
game 'gta5'
description 'MH Blackmoney Wash'
version '1.0'
shared_scripts {'@qb-core/shared/locale.lua', 'locales/en.lua'}
client_scripts {'client/config.lua', 'client/main.lua'}
server_scripts {'@oxmysql/lib/MySQL.lua', 'server/sv_config.lua', 'server/main.lua', 'server/update.lua'}
dependencies {'qb-core'}
lua54 'yes'
