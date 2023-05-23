local ShopItems = {}
local ShopJobs = {}
--------------------------------------------------------------------------------------------------------------------------------------------
data = {}
local Framework = "redemrp-reboot"
local QBRItems
local QRCore
local qc
local RSGCore
--------------------------------------------------------------------------------------------------------------------------------------------
if Framework == "redemrp" then
    TriggerEvent("redemrp_inventory:getData",function(call)
        data = call
    end)
elseif Framework == "redemrp-reboot" then
    TriggerEvent("redemrp_inventory:getData",function(call)
        data = call
    end)
    RedEM = exports["redem_roleplay"]:RedEM()
elseif Framework == "qbr" then 
    qc = "qbr-core"
    QBRItems = exports[qc]:GetItems()
elseif Framework == "qbr2" then 
    qc = "qr-core"
    QRCore = exports[qc]:GetCoreObject()
    QBRItems = QRCore.Shared.Items
elseif Framework == "rsg" then 
    qc = "rsg-core"
    RSGCore = exports[qc]:GetCoreObject()
    QBRItems = RSGCore.Shared.Items
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function GetPlayerData(src)
    local a = nil 
    if Framework == "redemrp" then
        TriggerEvent('redemrp:getPlayerFromId', src, function(user)
            if user then 
                local money = user.getMoney()
                local job = user.getJob()
                a = {money = money, job = job}
            else
                a = false 
            end
        end)
        Wait(200)
    elseif Framework == "redemrp-reboot" then
        local Player = RedEM.GetPlayer(src)
        if Player then 
            local money = Player.money
            local job = Player.job   
            a = {money = money, job = job}
        else
            a = false 
        end
    elseif Framework == "qbr" or Framework == "qbr2" or Framework == "rsg" then 
        local User 
        if  Framework == "qbr" then
            User = exports[qc]:GetPlayer(src)
        elseif Framework == "qbr2" then 
            User = QRCore.Functions.GetPlayer(src)
        elseif Framework == "rsg" then 
            User = RSGCore.Functions.GetPlayer(src)
        end
        local job =  User.PlayerData.job.name
        local money = User.PlayerData.money.cash
        a = {money = money, job = job}
    end
    return a
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function GetItemLabel(item)
    local label = false 
    if Framework == "redemrp" then
        if data.getItemData(item).label then 
            label = data.getItemData(item).label
        end
    elseif Framework == "redemrp-reboot" then
        if data.getItemData(item).label then 
            label = data.getItemData(item).label
        end
    elseif Framework == "qbr" then 
        if QBRItems[item].label then 
            label = QBRItems[item].label
        end
    elseif Framework == "qbr2" then 
        if QBRItems[item].label then 
            label = QBRItems[item].label
        end
    elseif Framework == "rsg" then 
        if QBRItems[item].label then 
            label = QBRItems[item].label
        end
    end
    return label 
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function GetItem(src, item)
    local itemD = nil 
    if Framework == "redemrp" then
        itemD = data.getItem(src, item)
    elseif Framework == "redemrp-reboot" then
        itemD = data.getItem(src, item)
    elseif Framework == "qbr" or Framework == "qbr2" or Framework == "rsg" then 
        itemD = {src, item}
    end
    return itemD
end

--------------------------------------------------------------------------------------------------------------------------------------------
local function AddRedMItem(value, itemD)
    local ret = nil
    if Framework == "redemrp" then
        if itemD.ItemAmount + value <= itemD.ItemInfo.limit then 
            itemD.AddItem(value)
            ret = true
        else
            ret = false
        end 
    elseif Framework == "redemrp-reboot" then
        if itemD.ItemInfo.type == "item_weapon" or itemD.ItemAmount + value <= itemD.ItemInfo.limit then 
            itemD.AddItem(value)
            ret = true
        else
            ret = false
        end 
    elseif Framework == "qbr" or Framework == "qbr2" or Framework == "rsg" then 
        local User 
        if  Framework == "qbr" then
            User = exports[qc]:GetPlayer(itemD[1])
        elseif Framework == "rsg" then 
            User = RSGCore.Functions.GetPlayer(itemD[1])
        else
            User = QRCore.Functions.GetPlayer(itemD[1])
        end
        User.Functions.AddItem(itemD[2], value)
        ret = true
    end
    return ret
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function RemoveRDMItem(value, itemD)
    if Framework == "redemrp" then
        itemD.RemoveItem(value)
    elseif Framework == "redemrp-reboot" then
        itemD.RemoveItem(value)
    elseif Framework == "qbr" or Framework == "qbr2" or Framework == "rsg" then 
        local User 
        if  Framework == "qbr" then
            User = exports[qc]:GetPlayer(itemD[1])
        elseif Framework == "rsg" then 
            User = RSGCore.Functions.GetPlayer(itemD[1])
        else
            User = QRCore.Functions.GetPlayer(itemD[1])
        end
        User.Functions.RemoveItem(itemD[2], value)
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------
 local function GetRDMItemCount(item)
    if Framework == "redemrp" then
        return item.ItemAmount
    elseif Framework == "redemrp-reboot" then
        return item.ItemAmount
    elseif Framework == "qbr" or Framework == "qbr2" or Framework == "rsg" then 
        local count
        local User 
        if  Framework == "qbr" then
            User = exports[qc]:GetPlayer(item[1])
        elseif Framework == "rsg" then 
            User = RSGCore.Functions.GetPlayer(item[1])
        else
            User = QRCore.Functions.GetPlayer(item[1])
        end
        local hasItem = User.Functions.GetItemByName(item[2])
        if hasItem and hasItem.amount > 0 then 
            count = hasItem.amount
        end
        return count
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function AddRDMMoney(src, value)
    if Framework == "redemrp" then 
        TriggerEvent('redemrp:getPlayerFromId', src, function(user)
            user.addMoney(value)
        end)
    elseif Framework == "redemrp-reboot" then
        local Player = RedEM.GetPlayer(src)
        Player.AddMoney(value)
        Character.addCurrency(0 , value)
    elseif Framework == "qbr" or Framework == "qbr2" or Framework == "rsg" then 
        local User 
        if  Framework == "qbr" then
            User = exports[qc]:GetPlayer(src)
        elseif Framework == "rsg" then 
            User = RSGCore.Functions.GetPlayer(src)
        else
            User = QRCore.Functions.GetPlayer(src)
        end
        User.Functions.AddMoney("cash", value, "Shop Add Money")
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function RemoveMoney(src, value)
    if Framework == "redemrp" then 
        TriggerEvent('redemrp:getPlayerFromId', src, function(user)
            user.removeMoney(value)
        end)
    elseif Framework == "redemrp-reboot" then
        local Player = RedEM.GetPlayer(src)
        Player.RemoveMoney(value)
    elseif Framework == "qbr" or Framework == "qbr2" or Framework == "rsg" then 
        local User 
        if  Framework == "qbr" then
            User = exports[qc]:GetPlayer(src)
        elseif Framework == "rsg" then 
            User = RSGCore.Functions.GetPlayer(src)
        else
            User = QRCore.Functions.GetPlayer(src)
        end
        User.Functions.RemoveMoney("cash", value, "Shop Remove Money")
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function LoadShop()
    ShopItems = {}
   for k,v in pairs(ShopItemsData) do
        if ShopItems[v.store] == nil then
            ShopItems[v.store] = {}
        end
        local name = v.item
        local label = GetItemLabel(name)
        if label then 
            name = label
        end
        table.insert(ShopItems[v.store], {
            label = name,
            item  = v.item,
            price = v.price,
            object = v.object,
            buy_price = v.buy_price,
        })
    end
    ShopJobs = {}
    for i,v in pairs(ShopJobsData) do 
        if not ShopJobs[v.store] then 
            ShopJobs[v.store] = v.jobs
        end
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function GetPrice(ItemName , Zone)
	for k,v in pairs(ShopItems[Zone]) do
        if v.item == ItemName then
           return v.price
        end
   end
   return 0
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function GetPrice2(ItemName , Zone)
	for k,v in pairs(ShopItems[Zone]) do
        if v.item == ItemName then
           return v.buy_price or 0
        end
   end
   return 0
end
--------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    LoadShop()
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('redemrp_shops:RequestItems', function()
    local _source = source
    TriggerClientEvent('redemrp_shops:GetItems', _source, ShopItems)
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('redemrp_shops:BuyItem', function(itemName, amount , zone)
    local _source = source
    local amount_ = math.floor(amount)
	if amount_ < 0 then return end
	local ItemPrice = GetPrice(itemName , zone)
	local TotalPrice = ItemPrice * amount_
    local player = GetPlayerData(_source)
    if player then 
        if ShopJobs[zone] then 
            local go = false 
            for i,v in pairs(ShopJobs[zone]) do 
                if v == player.job then 
                    go = true 
                    break 
                end
            end
            if not go then 
                TriggerClientEvent("redemrp_shops:notif", _source, 3)
                return 
            end
        end
        if player.money >= TotalPrice then
            local ItemData = GetItem(_source, itemName)
            if not AddRedMItem(amount_, ItemData) then
                TriggerClientEvent("redemrp_shops:notif", _source, 7)
            else
                RemoveMoney(_source, TotalPrice)
                local name = itemName
                local label = GetItemLabel(itemName)
                if label then
                    name = label
                end
                TriggerClientEvent("redemrp_shops:notif", _source, 6)
            end
        else
            TriggerClientEvent("redemrp_shops:notif", _source, 5)
        end
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('redemrp_shops:SellItem', function(itemName, amount , zone)
    local _source = source
    local amount_ = math.floor(amount)
	if amount_ < 0 then return end
	local ItemPrice = GetPrice2(itemName , zone)
    if not ItemPrice or ItemPrice == 0 then 
        TriggerClientEvent("redemrp_shops:notif", _source, 4)
        return 
    end
	local TotalPrice = ItemPrice * amount_
    local player = GetPlayerData(_source)
    if player then 
        if ShopJobs[zone] then 
            local go = false 
            for i,v in pairs(ShopJobs[zone]) do 
                if v == player.job then 
                    go = true 
                    break 
                end
            end
            if not go then 
                TriggerClientEvent("redemrp_shops:notif", _source, 3)
                return 
            end
        end
        local ItemData = GetItem(_source, itemName)
        local count = GetRDMItemCount(ItemData)
        if count and count >= amount then 
            RemoveRDMItem(amount_, ItemData)
            AddRDMMoney(_source, TotalPrice)
            local name = itemName
            local label = GetItemLabel(itemName)
            if label then
                name = label
            end
            TriggerClientEvent("redemrp_shops:notif", _source, 2, {text = name})
        else

            TriggerClientEvent("redemrp_shops:notif", _source, 1)
        end
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------