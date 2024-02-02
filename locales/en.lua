--[[ ===================================================== ]] --
--[[          MH Blackmoney Wash Script by MaDHouSe        ]] --
--[[ ===================================================== ]] --
local Translations = {
    notify = {
        ['not_enough_blackmoney'] = "Not enough blackmoney, you need at least %{need} black money",
        ['washing_done'] = "The money has been washed",
        ['wait_wash_machine'] = "The machine is washing",
        ['take_money_from_machine'] = "Busy taking money",
        ['wash_money'] = "[E] - Wash Money",
        ['take_money'] = "[E] - Take Money",
    },
    target = {
        ['wash_money'] = "Wash Money",
        ['take_money'] = "Take Money",
    }
}

Lang = Locale:new({
    phrases = Translations, 
    warnOnMissing = true
})
