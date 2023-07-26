local MenuActive = false
local camera
local lastPreView
local spawnCoords
local canChange = true
local items_list = {}
local shopBlips = {}
--------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	Wait(3500)
    TriggerServerEvent("redemrp_shops:RequestItems")
    OpenShop()
end)
--------------------------------------------------------------------------------------------------------------------------------------------
MenuData = {}
TriggerEvent(Config.MenuBaseData..":getData",function(call)
    MenuData = call
end)
local PromptShop
local OpenShopGroup = GetRandomIntInRange(0, 0xffffff)
function OpenShop()
    Citizen.CreateThread(function()
        local str = Config.Texts.OpenShop
        PromptShop = PromptRegisterBegin()
        PromptSetControlAction(PromptShop, Config.ShopPrompt)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(PromptShop, str)
        PromptSetEnabled(PromptShop, true)
        PromptSetVisible(PromptShop, true)
        PromptSetHoldMode(PromptShop, true)
        PromptSetGroup(PromptShop, OpenShopGroup)
        PromptRegisterEnd(PromptShop)

    end)
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function PreView (model)
    if model == "empty" then return end
    if lastPreView ~= nil then
        DeleteEntity(lastPreView)
        while DoesEntityExist(lastPreView) do
            Wait(1)
        end
    end
    local _model = GetHashKey(model)
    while not HasModelLoaded(_model) do
        Wait(1)
        RequestModel(_model)
    end
    lastPreView = CreateObject(_model, spawnCoords.x , spawnCoords.y, spawnCoords.z , 0.0, false, false )
    while not DoesEntityExist(lastPreView) do
        Wait(1)
    end
    SetEntityAsMissionEntity(lastPreView, true, true)
    FreezeEntityPosition(lastPreView , true)
    PointCamAtEntity(camera, lastPreView)
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function StartCam(prev)
    DestroyAllCams(true)
    DoScreenFadeOut(800)
    Wait(800)
    local camera_pos = GetObjectOffsetFromCoords(spawnCoords.x , spawnCoords.y, spawnCoords.z ,0.0 ,1.0, 1.0, 1.0)
    camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camera_pos.x, camera_pos.y, camera_pos.z, 00.00, 00.00, 40.00, 30.00, true, 0)
    SetCamActive(camera,true)
    RenderScriptCams(true, true, 1000, true, true)
    if not prev then 
        if canChange == true then
            canChange = false
            PreView (items_list[1].obj)
            canChange = true
        end
    end
    DisplayRadar(false)
    DoScreenFadeIn(1500)
    Wait(1500)
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function EndCam()
	DoScreenFadeOut(800)
    Wait(800)
    RenderScriptCams(false, true, 1000, true, false)
    DestroyCam(camera, false)
    camera = nil
    DisplayRadar(true)
    DestroyAllCams(true)
    DoScreenFadeIn(1500)
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function OpenShopMenu(zone, pt)
    items_list = {}
    local _zone = zone
    if pt == "buy" then 
        for i=1, #Config.Zones[_zone].Items, 1 do
            local item = Config.Zones[_zone].Items[i]
            table.insert(items_list, {label = item.label, value = i , desc = Config.Texts.ItemPrice..": $"..item.price , obj =  item.object , name = item.item , zone = _zone, image = "items/"..item.item..".png" })
        end
    elseif pt == "sell" then 
        local found = false 
        for i=1, #Config.Zones[_zone].Items, 1 do
            local item = Config.Zones[_zone].Items[i]
            if item.buy_price then 
                if not found then 
                    found = true 
                end
                table.insert(items_list, {label = item.label, value = i , desc = Config.Texts.ItemPrice2..": $"..item.buy_price , obj =  item.object , name = item.item , zone = _zone, image = "items/"..item.item..".png" })
            end
        end
        if not found then 
            MenuActive = false
            MenuData.CloseAll()
            return
        end
    end
    StartCam()
    MenuData.Open(
        'default', GetCurrentResourceName(), 'shop_menu',
        {
            title    = Config.Zones[_zone].Name,
            subtext    = (Config.Zones[_zone].SubTitle or Config.Texts.Cheapest),
            align    = 'top-right',
            elements = items_list,
        },

        function(data, menu)
            if pt == "buy" then 
                TriggerServerEvent('redemrp_shops:BuyItem', data.current.name, 1 , data.current.zone)
            elseif pt == "sell" then 
                TriggerServerEvent('redemrp_shops:SellItem', data.current.name, 1 , data.current.zone)
            end
        end,

        function(data, menu)
            menu.close()
            EndCam()
            if lastPreView ~= nil then
                DeleteEntity(lastPreView)
                while DoesEntityExist(lastPreView) do
                    Wait(0)
                end
            end
            OpenShopMenu1(_zone)
        end,

        function(data, menu)
            if canChange == true then
                canChange = false
                PreView (data.current.obj)
                canChange = true
            end
        end
    )
end
--------------------------------------------------------------------------------------------------------------------------------------------
function OpenShopMenu1(zone)
    local _zone = zone
    if Config.Zones[_zone].OpeningTime then 
        local hour = GetClockHours()
        local go = false 
        if hour >= Config.Zones[_zone].OpeningTime.open and hour < Config.Zones[_zone].OpeningTime.close then 
            go = true 
        end
        if not go then 
            TriggerEvent("Notification:redemrp_shops", Config.Texts.Shop, Config.Texts.ClosedShop, Config.Textures.alert[1], Config.Textures.alert[2], 2000)
            MenuActive = false
            return 
        end
    end
    items_list = {}
    local elements = {
        {label = Config.Texts.BuyItems, value = "buy", desc = Config.Texts.BuyItemsD},
        {label = Config.Texts.SellItems, value = "sell", desc = Config.Texts.SellItemsD},
    }
    MenuData.Open(
        'default', GetCurrentResourceName(), 'shop_menu1',
        {
            title    = Config.Zones[_zone].Name,
            subtext    = (Config.Zones[_zone].SubTitle or Config.Texts.Cheapest),
            align    = 'top-right',
            elements = elements,
        },

        function(data, menu)
            menu.close()
            OpenShopMenu(zone, data.current.value)
        end,

        function(data, menu)
            menu.close()
            if lastPreView ~= nil then
                DeleteEntity(lastPreView)
                while DoesEntityExist(lastPreView) do
                    Wait(0)
                end
            end
            MenuActive = false
        end)
end
--------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Wait(4)
        local can_wait = true
        local coords   = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Config.Zones) do
            for i = 1, #v.Pos, 1 do
                local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
                if distance <= 15.0 then
                    can_wait = false
                end

                if distance < Config.EnableDistance and not MenuActive then
                    local ShopGroupName  = CreateVarString(10, 'LITERAL_STRING', v.Name)
                    PromptSetActiveGroupThisFrame(OpenShopGroup, ShopGroupName)
					 if PromptHasHoldModeCompleted(PromptShop) and not MenuActive then
                        MenuActive = true
                        spawnCoords = v.Spawn[i]
                        Wait(400)
                        OpenShopMenu1(k)
					end
                end

            end
        end
        if can_wait == true then
            Wait(1000)
        end

    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    for k,v in pairs(Config.Zones) do
        for i = 1, #v.Pos, 1 do
            if v.Legal then
                local blip = N_0x554d9d53f696d002(1664425300, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
                local sprite = v.Sprite or Config.BlipSprite
                SetBlipSprite(blip, sprite, 1)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, v.Name)
                shopBlips[#shopBlips+1] = blip
            end 
        end
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('redemrp_shops:GetItems')
AddEventHandler('redemrp_shops:GetItems', function(ShopItems)
    for k,v in pairs(ShopItems) do
        if (Config.Zones[k] ~= nil) then
            Config.Zones[k].Items = v
        end
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
    for i=1, #shopBlips do 
        if shopBlips[i] then 
            RemoveBlip(shopBlips[i])
        end
    end
    if MenuActive then 
        MenuData.CloseAll()
    end
    if camera then 
        RenderScriptCams(false, true, 1000, true, false)
        DestroyCam(camera, false)
        DisplayRadar(true)
    end
end)

----------------------------Basic Notification----------------------------

RegisterNetEvent('redemrp_shops:notif', function(id, data)
    if id == 1 then 
        TriggerEvent("Notification:redemrp_shops", Config.Texts.Shop, Config.Texts.NoItems, Config.Textures.alert[1], Config.Textures.alert[2], 2000)
    elseif id == 2 then 
        TriggerEvent("Notification:redemrp_shops", Config.Texts.Shop, Config.Texts.SoldItem.." "..data.text, Config.Textures.alert[1], Config.Textures.alert[2], 2000)
    elseif id == 3 then 
        TriggerEvent("Notification:redemrp_shops", Config.Texts.Shop, Config.Texts.NoJob, Config.Textures.alert[1], Config.Textures.alert[2], 2000)
    elseif id == 4 then 
        TriggerEvent("Notification:redemrp_shops", Config.Texts.Shop, Config.Texts.InvalidPrice, Config.Textures.alert[1], Config.Textures.alert[2], 2000)
    elseif id == 5 then 
        TriggerEvent("Notification:redemrp_shops", Config.Texts.Shop, Config.Texts.NoMoney, Config.Textures.alert[1], Config.Textures.alert[2], 2000)
    elseif id == 6 then 
        TriggerEvent("Notification:redemrp_shops", Config.Texts.Shop, Config.Texts.ItemPurchased, Config.Textures.alert[1], Config.Textures.alert[2], 2000)
    elseif id == 7 then 
        TriggerEvent("Notification:redemrp_shops", Config.Texts.Shop, Config.Texts.NoSpace, Config.Textures.alert[1], Config.Textures.alert[2], 2000)
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('Notification:redemrp_shops', function(t1, t2, dict, txtr, timer)
    local _dict = tostring(dict)
    if _dict and Citizen.InvokeNative(0x7332461FC59EB7EC, _dict) and not HasStreamedTextureDictLoaded(_dict) then
        RequestStreamedTextureDict(_dict, true) 
        while not HasStreamedTextureDictLoaded(_dict) do
            Citizen.Wait(5)
        end
    end
    exports.redemrp_shops.LeftNot(0, tostring(t1), tostring(t2), _dict, txtr, tonumber(timer))
    SetStreamedTextureDictAsNoLongerNeeded(_dict)
end)
--------------------------------------------------------------------------------------------------------------------------------------------
