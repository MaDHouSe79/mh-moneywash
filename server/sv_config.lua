--[[ ===================================================== ]] --
--[[          MH Blackmoney Wash Script by MaDHouSe        ]] --
--[[ ===================================================== ]] --
SV_Config = {}
SV_Config.Tax = 30                                      -- 30% tax (black_money - 30%)
SV_Config.MinAmountToWash = 1                           -- you need a x amount min black_money before you can use it
SV_Config.BlackMoneyItem = "black_money"                -- black_money item
SV_Config.Locations = {                                 -- all locations
    { -- blockenpark (test)
        prop = "prop_washer_03",                        -- prop
        icon = 'fa fa-eur',                             -- target icon
        coords = vector3(158.0883, -1001.0672, 28.3551),-- location
        heading = 270.0,                                -- heading
        washTime = 60000                                -- wash timer
    }, {
        prop = "prop_washer_03",                        -- prop
        icon = 'fa fa-eur',                             -- target icon
        coords = vector3(19.2635, -1336.6592, 29.2502), -- location
        heading = 270.0,                                -- heading
        washTime = 60000,                               -- wash timer
    }, {
        prop = "prop_washer_03",
        icon = 'fa fa-eur',
        coords = vector3(114.7649, -1297.6033, 34.0099),
        heading = 210.0,
        washTime = 60000,
    }, {
        prop = "prop_washer_03",
        icon = 'fa fa-eur',
        coords = vector3(177.4815, 3076.9609, 42.0983),
        heading = 277.0,
        washTime = 60000,
    }, {
        prop = "prop_washer_03",
        icon = 'fa fa-eur',
        coords = vector3(394.0967, 3576.6179, 32.2923),
        heading = 80.0,
        washTime = 60000,
    }, {
        prop = "prop_washer_03",
        icon = 'fa fa-eur',
        coords = vector3(-1809.7546, -1223.8811, 12.0173),
        heading = 50.0,
        washTime = 60000,
    }, {
        prop = "prop_washer_03",
        icon = 'fa fa-eur',
        coords = vector3(648.9498, 100.2005, 79.7398),
        heading = 180.0,
        washTime = 60000,
    }, {
        prop = "prop_washer_03",
        icon = 'fa fa-eur',
        coords = vector3(-90.1299, 6401.2046, 30.6404),
        heading = 45.0,
        washTime = 60000,
    }
}