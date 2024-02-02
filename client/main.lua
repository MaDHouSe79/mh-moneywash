--[[ ===================================================== ]] --
--[[          MH Blackmoney Wash Script by MaDHouSe        ]] --
--[[ ===================================================== ]] --
local QBCore = exports['qb-core']:GetCoreObject()
local isLoggedIn, isDone, isBisy, canUse, machines, blips = false, false, false, true, {}, {}

--- Play Animation
---@param dict string
---@param name string
---@param time number
local function PlayAnimation(dict, name, time, text)
    isBisy = true
    canUse = false
    LocalPlayer.state:set("inv_busy", true, true) -- lock
    QBCore.Functions.Progressbar('searching', text, time, false, true, {
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
        LocalPlayer.state:set("inv_busy", false, true) -- unlock
        FreezeEntityPosition(PlayerPedId(), false)
        isBisy = false
        canUse = true
    end, function() -- cansel
        LocalPlayer.state:set("inv_busy", false, true) -- unlock
        FreezeEntityPosition(PlayerPedId(), false)
        isBisy = false
        canUse = true
    end)
end

local function CreateMachineBlip(machine)
    local blip = nil
    if machine.blip.enable then
        blip = AddBlipForCoord(machine.coords.x, machine.coords.y, machine.coords.z)
        SetBlipSprite(blip, machine.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, machine.blip.color)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(machine.blip.name)
        EndTextCommandSetBlipName(blip)
        blips[#blips + 1] = blip
    end
    return blip
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
    CreateMachineBlip(machine)
    exports['qb-target']:AddTargetEntity(prop, {
        options = {
            {
                icon = machine.icon,
                label = Lang:t('target.wash_money'),
                action = function(entity)
                    QBCore.Functions.TriggerCallback("mh-blackmoneywash:server:hasBlackmoney", function(canWash)
                        if canWash then
                            PlayAnimation("amb@world_human_gardener_plant@male@base", "base", machine.washTime, Lang:t('notify.wait_wash_machine'))
                            TriggerServerEvent('mh-blackmoneywash:server:washmoney', machine)
                        end
                    end)
                end,
                canInteract = function(entity, distance, data)
                    if isBisy then return false end
                    if not canUse then return false end
                    return true
                end
            }
        },
        distance = 2.5
    })
    machines[#machines + 1] = prop
    return prop
end

--- Delete Machines
local function DeleteMachines() 
    for k, machine in pairs(machines) do
        if DoesEntityExist(machine) then
            DeleteEntity(machine)
        end
    end
end

--- Create Machines
local function CreateMachines()
    for k, v in pairs(Config.Locations) do
        CreateMachine(v)
    end
end

local function DeleteBlips() 
    for k, blip in pairs(blips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    CreateMachines()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    DeleteMachines()
    DeleteBlips() 
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        isLoggedIn = true
        CreateMachines()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        isLoggedIn = false
        DeleteMachines()
        DeleteBlips() 
    end
end)