--[[ ===================================================== ]] --
--[[            MH Money Wash Script by MaDHouSe           ]] --
--[[ ===================================================== ]] --
local QBCore = exports['qb-core']:GetCoreObject()

local tax = 30
local minToWash = 10000

QBCore.Functions.CreateCallback("mh-blackmoneywash:server:hasBlackmoney", function(source, cb)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if player and player.PlayerData and player.PlayerData.money then
        if player.PlayerData.money.blackmoney < minToWash then
            TriggerClientEvent('QBCore:Notify', src, Lang:t('notify.not_enough_blackmoney', {need = minToWash}), "error")
            cb(false)
        elseif player.PlayerData.money.blackmoney >= minToWash then
            cb(true)
        end
    end
    cb(false)
end)

RegisterServerEvent('mh-blackmoneywash:server:washmoney', function(machine)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local newAmount = Player.PlayerData.money.blackmoney - (minToWash * tax) / 100
        Player.Functions.RemoveMoney('blackmoney', minToWash)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['blackmoney'], "remove", minToWash)
        Wait(machine.washTime)
        Player.Functions.AddMoney('cash', newAmount, nil)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['cash'], "add", newAmount)
    else
        TriggerClientEvent("QBCore:Notify", src, "Player Not found")
    end
end)
