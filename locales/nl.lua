--[[ ===================================================== ]] --
--[[            MH Money Wash Script by MaDHouSe           ]] --
--[[ ===================================================== ]] --
local Translations = {
    notify = {
        ['not_enough_blackmoney'] = "Niet genoeg zwart geld, je hebt minimaal %{need} zwart geld nodig",
        ['washing_done'] = "Het geld is gewassen",
        ['wait_wash_machine'] = "De machine is wassen",
        ['take_money_from_machine'] = "Bezig met geld pakken",
        ['wash_money'] = "[E] - Witwassen",
        ['take_money'] = "[E] - Pak geld",
    },
    target = {
        ['wash_money'] = "Witwassen",
        ['take_money'] = "Pak geld",
    }
}

Lang = Locale:new({
    phrases = Translations, 
    warnOnMissing = true
})
