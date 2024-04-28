local RSGCore = exports['rsg-core']:GetCoreObject()
local haspelts = false

------------------------------------------
-- give reward
------------------------------------------
RegisterNetEvent('rex-trapper:server:givereward')
AddEventHandler('rex-trapper:server:givereward', function(rewarditem1, rewarditem2, rewarditem3, rewarditem4, rewarditem4)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    if rewarditem1 ~= nil then
        Player.Functions.AddItem(rewarditem1, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[rewarditem1], "add")
    end

    if rewarditem2 ~= nil then
        Player.Functions.AddItem(rewarditem2, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[rewarditem2], "add")
    end

    if rewarditem3 ~= nil then
        Player.Functions.AddItem(rewarditem3, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[rewarditem3], "add")
    end

    if rewarditem4 ~= nil then
        Player.Functions.AddItem(rewarditem4, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[rewarditem4], "add")
    end

    if rewarditem5 ~= nil then
        Player.Functions.AddItem(rewarditem4, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[rewarditem4], "add")
    end

end)

------------------------------------------
-- sell to trapper
------------------------------------------
RegisterServerEvent('rex-trapper:server:sellitems')
AddEventHandler('rex-trapper:server:sellitems', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local price = 0
    local haspelts = false
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then
                if Player.PlayerData.items[k].name == "poor_pelt" then 
                    price = price + (Config.PoorPeltPrice * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("poor_pelt", Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items["poor_pelt"], "remove")
                    haspelts = true
                elseif Player.PlayerData.items[k].name == "good_pelt" then 
                    price = price + (Config.GoodPeltPrice * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("good_pelt", Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items["good_pelt"], "remove")
                    haspelts = true
                elseif Player.PlayerData.items[k].name == "perfect_pelt" then 
                    price = price + (Config.PerfectPeltPrice * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("perfect_pelt", Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items["perfect_pelt"], "remove")
                    haspelts = true
                elseif Player.PlayerData.items[k].name == "legendary_pelt" then 
                    price = price + (Config.LegendaryPeltPrice * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("legendary_pelt", Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items["legendary_pelt"], "remove")
                    haspelts = true
                elseif Player.PlayerData.items[k].name == "small_pelt" then 
                    price = price + (Config.SmallPeltPrice * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("small_pelt", Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items["small_pelt"], "remove")
                    haspelts = true
                elseif Player.PlayerData.items[k].name == "reptile_skin" then 
                    price = price + (Config.ReptileSkinPrice * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("reptile_skin", Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items["reptile_skin"], "remove")
                    haspelts = true
                elseif Player.PlayerData.items[k].name == "feather" then 
                    price = price + (Config.FeatherPrice * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem("feather", Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items["feather"], "remove")
                    haspelts = true
                end
            end
        end
        if haspelts == true then
            Player.Functions.AddMoney(Config.PaymentType, price, "pelts-sold")
            TriggerEvent('rsg-log:server:CreateLog', Config.WebhookName, Config.WebhookTitle, Config.WebhookColour, GetPlayerName(src) .. Config.Lang1 .. price, false)
            haspelts = false
        else
            TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('server.lang_1'), type = 'error', duration = 7000 })
        end
    end
end)
