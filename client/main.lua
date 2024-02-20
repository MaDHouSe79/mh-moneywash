--[[ ===================================================== ]] --
--[[          MH Blackmoney Wash Script by MaDHouSe        ]] --
--[[ ===================================================== ]] --
local QBCore = exports['qb-core']:GetCoreObject()
local isLoggedIn, isDone, isBisy, machines, blips = false, false, false, {}, {}

--- Play Animation
---@param dict string
---@param name string
---@param time number
local function PlayAnimation(machine, dict, name, text)
    LocalPlayer.state:set("inv_busy", true, true)
    QBCore.Functions.Progressbar('wash_money', text, machine.washTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true
    }, {
        animDict = dict,
        anim = name,
        flags = 49
    }, {}, {}, function()
        ClearPedTasks(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
        isBisy = false
        TriggerServerEvent('mh-blackmoneywash:server:payout', machine)
        LocalPlayer.state:set("inv_busy", false, true)
    end, function() -- cansel
        FreezeEntityPosition(PlayerPedId(), false)
        LocalPlayer.state:set("inv_busy", false, true)
        isBisy = false
    end)
end

--- Create Machine Blip
---@param coords table
local function CreateMachineBlip(coords)
    local blip = nil
    if Config.Blip.enable then
        blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, Config.Blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, Config.Blip.color)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Blip.label)
        EndTextCommandSetBlipName(blip)
        blips[#blips + 1] = blip
    end
    return blip
end

--- Delete Blips
local function DeleteBlips() 
    for k, blip in pairs(blips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
end

local function Wash(machine)
    QBCore.Functions.TriggerCallback("mh-blackmoneywash:server:hasBlackmoney", function(hasBlacmmoney)
        if hasBlacmmoney then
            TriggerServerEvent('mh-blackmoneywash:server:washmoney', machine)
        end
    end)
end

---Create Stash Object
---@param itemName string
---@return table
local function CreateMachine(machine)
    local model = GetHashKey(machine.prop)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end
    local prop = CreateObject(model, machine.coords.x, machine.coords.y, machine.coords.z, true, true, false)
    SetEntityHeading(prop, machine.heading)
    SetEntityAsMissionEntity(prop, true, true)
    PlaceObjectOnGroundProperly(prop)
    FreezeEntityPosition(prop, true)
    CreateMachineBlip(machine.coords)
    if Config.Target == "qb-target" then
        exports[Config.Target]:AddTargetEntity(prop, {
            options = {
                {
                    icon = machine.icon,
                    label = Lang:t('target.wash_money'),
                    action = function(entity)
                        isBisy = true
                        TaskTurnPedToFaceEntity(PlayerPedId(), entity, 5000)
                        Wait(1500)
                        Wash(machine)
                    end,
                    canInteract = function(entity, distance, data)
                        if isBisy then return false end
                        return true
                    end
                }
            },
            distance = 2.5
        })     
    elseif Config.Target == "ox_target" then
        exports.ox_target:removeModel(machine.prop, 'moneywash')
        exports.ox_target:addModel(machine.prop, {
            {
                name = 'moneywash',
                icon = machine.icon,
                label = Lang:t('target.wash_money'),
                onSelect = function(data)
                    isBisy = true
                    TaskTurnPedToFaceEntity(PlayerPedId(), data.entity, 5000)
                    Wait(1500)
                    Wash(machine)
                end,
                canInteract = function(entity, distance, data)
                    if isBisy then return false end
                    return true
                end,
                distance = 2.5
            },
        })
    end
    machines[#machines + 1] = prop
    return prop
end

--- Create Machines
local function CreateMachines()
    QBCore.Functions.TriggerCallback("mh-blackmoneywash:server:GetMachines", function(machineList)
        if type(machineList) == 'table' and #machineList > 0 then
            for k, machine in pairs(machineList) do
                CreateMachine(machine)
            end
        end
    end)
end

--- Delete Machines
local function DeleteMachines() 
    for k, machine in pairs(machines) do
        if DoesEntityExist(machine) then
            DeleteEntity(machine)
        end
    end
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    TriggerServerEvent('mh-blackmoneywash:server:onjoin')
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    DeleteMachines()
    DeleteBlips() 
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        isLoggedIn = true
        TriggerServerEvent('mh-blackmoneywash:server:onjoin')
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        isLoggedIn = false
        DeleteMachines()
        DeleteBlips() 
    end
end)

RegisterNetEvent('mh-blackmoneywash:client:onjoin', function()
    CreateMachines()
end)

RegisterNetEvent('mh-blackmoneywash:client:washmoney', function(machine)
    PlayAnimation(machine, "amb@world_human_gardener_plant@male@base", "base", Lang:t('notify.wait_wash_machine'))
end)
