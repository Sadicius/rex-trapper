local RSGCore = exports['rsg-core']:GetCoreObject()
local SpawnedTrapperBilps = {}

-----------------------------------------------------------------
-- trapper prompts and blips
-----------------------------------------------------------------
Citizen.CreateThread(function()
    for _,v in pairs(Config.TrapperLocations) do
        if not Config.EnableTarget then
            exports['rsg-core']:createPrompt(v.prompt, v.coords, RSGCore.Shared.Keybinds[Config.KeyBind], Lang:t('client.lang_1')..v.name, {
                type = 'client',
                event = 'rex-trapper:client:opentrapper',
            })
        end
        if v.showblip == true then
            local TrapperBlip = BlipAddForCoords(1664425300, v.coords)
            SetBlipSprite(TrapperBlip, joaat(Config.Blip.blipSprite), true)
            SetBlipScale(TrapperBlip, Config.Blip.blipScale)
            SetBlipName(TrapperBlip, Config.Blip.blipName)
            table.insert(SpawnedTrapperBilps, TrapperBlip)
        end
    end
end)

--------------------------------------
-- trapper shop hours system
--------------------------------------
local OpenTrappers = function()
    if not Config.AlwaysOpen then
        local hour = GetClockHours()
        if (hour < Config.OpenTime) or (hour >= Config.CloseTime) and not Config.AlwaysOpen then
            lib.notify({
                title = Lang:t('client.lang_2'),
                description = Lang:t('client.lang_3')..Config.OpenTime..Lang:t('client.lang_4'),
                type = 'error',
                icon = 'fa-solid fa-shop',
                iconAnimation = 'shake',
                duration = 7000
            })
            return
        end
    end
    TriggerEvent('rex-trapper:client:mainmenu')
end

--------------------------------------
-- get trapper hours function
--------------------------------------
local GetTrapperHours = function()
    if not Config.AlwaysOpen then
        local hour = GetClockHours()
        if (hour < Config.OpenTime) or (hour >= Config.CloseTime) then
            for k, v in pairs(SpawnedTrapperBilps) do
                BlipAddModifier(v, joaat('BLIP_MODIFIER_MP_COLOR_2'))
            end
        else
            for k, v in pairs(SpawnedTrapperBilps) do
                BlipAddModifier(v, joaat('BLIP_MODIFIER_MP_COLOR_8'))
            end
        end
    else
        for k, v in pairs(SpawnedTrapperBilps) do
            BlipAddModifier(v, joaat('BLIP_MODIFIER_MP_COLOR_8'))
        end
    end
end

--------------------------------------
-- get trapper hours on player loading
--------------------------------------
RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
    GetTrapperHours()
end)

---------------------------------
-- update trapper hours every min
---------------------------------
CreateThread(function()
    while true do
        GetTrapperHours()
        Wait(60000) -- every min
    end
end)

AddEventHandler('rex-trapper:client:opentrapper', function()
    OpenTrappers()
end)

-----------------------------------------------------------------
-- main menu
-----------------------------------------------------------------
RegisterNetEvent('rex-trapper:client:mainmenu', function()
    lib.registerContext(
        {
            id = 'trapper_menu',
            title = Lang:t('client.lang_5'),
            position = 'top-right',
            options = {
                {
                    title = Lang:t('client.lang_6'),
                    description = Lang:t('client.lang_7'),
                    icon = 'fas fa-paw',
                    event = 'rex-trapper:client:selltotrapper',
                },
                {
                    title = Lang:t('client.lang_8'),
                    description = Lang:t('client.lang_9'),
                    icon = 'fas fa-shopping-basket',
                    event = 'rex-trapper:client:openshop',
                },
            }
        }
    )
    lib.showContext('trapper_menu')
end)

-----------------------------------------------------------------
-- delete holding
-----------------------------------------------------------------
local function DeleteThis(holding)
    NetworkRequestControlOfEntity(holding)
    SetEntityAsMissionEntity(holding, true, true)
    Wait(100)
    DeleteEntity(holding)
    Wait(500)
    local entitycheck = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
    local holdingcheck = GetPedType(entitycheck)
    if holdingcheck == 0 then
        return true
    else
        return false
    end
end

-----------------------------------------------------------------
-- process bar before selling
-----------------------------------------------------------------
RegisterNetEvent('rex-trapper:client:selltotrapper', function()
    LocalPlayer.state:set("inv_busy", true, true) -- lock inventory
    if lib.progressBar({
        duration = Config.SellTime,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disableControl = true,
        disable = {
            move = true,
            mouse = true,
        },
        label = Lang:t('client.lang_10'),
    }) then
        TriggerServerEvent('rex-trapper:server:sellitems')
    end
    LocalPlayer.state:set("inv_busy", false, true) -- unlock inventory
end)

-----------------------------------------------------------------
-- pelt workings
-----------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
        local pelthash = Citizen.InvokeNative(0x31FEF6A20F00B963, holding)
        if holding ~= false then
            for i = 1, #Config.Pelts do
                if pelthash == Config.Pelts[i].pelthash then
                    local name = Config.Pelts[i].name
                    -- rewards
                    local rewarditem1 = Config.Pelts[i].rewarditem1
                    local rewarditem2 = Config.Pelts[i].rewarditem2
                    local rewarditem3 = Config.Pelts[i].rewarditem3
                    local rewarditem4 = Config.Pelts[i].rewarditem4
                    local rewarditem5 = Config.Pelts[i].rewarditem5
                   
                    local deleted = DeleteThis(holding)
                    if deleted then
                        lib.notify({ title = Lang:t('client.lang_11'), description = Lang:t('client.lang_12'), type = 'inform', duration = 7000 })
                        TriggerServerEvent('rex-trapper:server:givereward', rewarditem1, rewarditem2, rewarditem3, rewarditem4, rewarditem5)
                    else
                        lib.notify({ title = Lang:t('client.lang_13'), type = 'error', duration = 7000 })
                    end
                end
            end
        end
    end
end)

-----------------------------------------------------------------
-- loot check
-----------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2)
        local size = GetNumberOfEvents(0)
        if size > 0 then
            for index = 0, size - 1 do
                local event = GetEventAtIndex(0, index)
                if event == 1376140891 then
                    local view = exports["rex-trapper"]:DataViewNativeGetEventData(0, index, 3)
                    local pedGathered = view['2']
                    local ped = view['0']
                    local model = GetEntityModel(pedGathered)
                    local model = model
                    local bool_unk = view['4']
                    local player = PlayerPedId()
                    local playergate = player == ped

                    if model and playergate == true and Config.Debug == true then
                        print(Lang:t('client.lang_14') .. model)
                    end

                    for i = 1, #Config.Animal do 
                        if model and Config.Animal[i].modelhash ~= nil and playergate and bool_unk == 1 then
                            local chosenmodel = Config.Animal[i].modelhash
                            if model == chosenmodel then
                                local rewarditem1 = Config.Animal[i].rewarditem1
                                local rewarditem2 = Config.Animal[i].rewarditem2
                                local rewarditem3 = Config.Animal[i].rewarditem3
                                local rewarditem4 = Config.Animal[i].rewarditem4
                                local rewarditem5 = Config.Animal[i].rewarditem5
                                TriggerServerEvent('rex-trapper:server:givereward', rewarditem1, rewarditem2, rewarditem3, rewarditem4, rewarditem5)
                                lib.notify({ title = Lang:t('client.lang_15'), type = 'inform', duration = 7000 })
                            end
                        end
                    end
                end
            end
        end
    end
end)


-----------------------------------------------------------------
-- trapper shop
-----------------------------------------------------------------
RegisterNetEvent('rex-trapper:client:openshop', function()
    local ShopItems = {}
    ShopItems.label = Lang:t('client.lang_16')
    ShopItems.items = Config.TrapperShop
    ShopItems.slots = #Config.TrapperShop
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "TrapperShop_"..math.random(1, 99), ShopItems)
end)

--[[
-----------------------------------------------------------------
-- spawn animal / dev enabled
-----------------------------------------------------------------
RegisterCommand('spawn_animal', function(source, args, rawCommand)
    local animal = args[1] -- example : mp_a_c_wolf_01
    local outfit = args[2] -- example : 0
    local wait = args[3] -- example : 1000
    local player = PlayerPedId()
    local playerCoords = GetEntityCoords(player)
    if animal == nil then
        animal = 'mp_a_c_wolf_01'
    end
    if outfit == nil then
        outfit = 0
    end
    if wait == nil then
        wait = '1000'
    end
    wait = tonumber(wait)
    if Config.Debug then
        RequestModel(animal)
        while not HasModelLoaded(animal) do
            Wait(10)
        end
        animal = CreatePed(animal, playerCoords.x, playerCoords.y +5, playerCoords.z, true, true, true)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, animal, outfit, false)
        Wait(wait)
        FreezeEntityPosition(animal, true)
    end
end, false)
--]]
