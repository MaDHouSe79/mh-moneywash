--[[ ===================================================== ]] --
--[[          MH Blackmoney Wash Script by MaDHouSe        ]] --
--[[ ===================================================== ]] --
local QBCore = exports['qb-core']:GetCoreObject()
local Players = {}

QBCore.Functions.CreateCallback("mh-blackmoneywash:server:GetMachines", function(source, cb)
    cb(SV_Config.Locations)
end)

QBCore.Functions.CreateCallback("mh-blackmoneywash:server:hasBlackmoney", function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and Player.PlayerData and Player.PlayerData.money then
        if Player.PlayerData.money[SV_Config.BlackMoneyItem] < SV_Config.MinAmountToWash then
            QBCore.Functions.Notify(src, {text = "Moneywash", caption = Lang:t('notify.not_enough_blackmoney', {need = SV_Config.MinAmountToWash })}, "error", 5000)
            cb(false)
        elseif Player.PlayerData.money[SV_Config.BlackMoneyItem] >= SV_Config.MinAmountToWash  then
            cb(true)
        end
    end
    cb(false)
end)

RegisterServerEvent('mh-blackmoneywash:server:onjoin', function()
    local src = source
    TriggerClientEvent('mh-blackmoneywash:client:onjoin', src)
end)

RegisterServerEvent('mh-blackmoneywash:server:washmoney', function(machine, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        table.insert(Players, src)
        TriggerClientEvent('mh-blackmoneywash:client:washmoney', src, machine, amount)
    else
        TriggerClientEvent("QBCore:Notify", src, Lang:t('notify.player_not_found'))
    end
end)

RegisterServerEvent('mh-blackmoneywash:server:payout', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        if Players[src] then
            local newAmount = Player.PlayerData.money[SV_Config.BlackMoneyItem] - (amount * SV_Config.Tax) / 100
            Player.Functions.RemoveMoney(SV_Config.BlackMoneyItem, amount)
            TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[SV_Config.BlackMoneyItem], "remove", amount)
            Player.Functions.AddMoney('cash', newAmount, nil)
            TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items['cash'], "add", newAmount)
            table.remove(Players, src)
        else
            TriggerClientEvent("QBCore:Notify", src, Lang:t('notify.machine_not_found'))
        end
    else
        TriggerClientEvent("QBCore:Notify", src, Lang:t('notify.player_not_found'))
    end
end)

local error = false
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if not QBCore.Config.Money.MoneyTypes[SV_Config.BlackMoneyItem] then
            error = true
        end
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if error then
            sleep = 10
            print(Lang:t('notify.error'))
        end
        Wait(sleep)
    end
end)
