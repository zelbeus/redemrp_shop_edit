Config = {}
Config.framework = "redemrp-reboot" --"redemrp" or "redemrp-reboot" or "qbr" or "qbr2" or "rsg"
Config.Textures = {
    cross = {"scoretimer_textures", "scoretimer_generic_cross"},
    locked = {"menu_textures","stamp_locked_rank"},
    tick = {"scoretimer_textures","scoretimer_generic_tick"},
    money = {"inventory_items", "money_moneystack"},
    alert = {"menu_textures", "menu_icon_alert"},
}
Config.Texts = {
	Cheapest = "Cheapest items",
	ItemPrice = "Item Price",
	ItemPrice2 = "Item Sell Price",
	Shop = "Shop",
	ClosedShop = "Shop is closed, come back later",
	BuyItems = "Buy Items",
	NoItems = "You don't have the items!",
	SoldItem = "Item sold!",
	NoJob = "You don't have the required job!",
	InvalidPrice = "Invalid Price!",
	NoMoney = "You don't have enough money!",
	ItemPurchased = "Item Purchased",
	SellItems = "Sell Items",
	BuyItemsD = "Browse items to purchase",
	SellItemsD = "Browse items to sell",
	OpenShop = "Open Shop",
	NoSpace = "You don't have enough space!",
	Bought = "Item purchased!",
	MissingMoney = "You don't have enough money",
}
Config.MenuBaseData = "redemrp_menu_base"
Config.ShopPrompt = 0xC7B5340A
Config.BlipSprite = 819673798 
Config.EnableDistance = 2.0 
Config.Zones = {
	Basic = {
		Name = "Valentine General Store",
		SubTitle = "Cheapest Items",
		Sprite = 819673798,
		Items = {},
		Legal = true,
		OpeningTime = {open = 6, close = 20},
		Pos = {
			{x = -324.28,   y = 801.51, z = 117.88},				
		},
		Spawn = {
			{x = -323.18,   y = 802.81, z = 117.94},				
		},
	},
	Basic_DENIS = {
		Name = "Saint Denis General Store",
		SubTitle = "Cheapest Items",
		Items = {},
		Legal = true,
		OpeningTime = {open = 6, close = 20},
		Pos = {
			{x = 2825.641, y = -1318.251, z = 46.756},				
		},
		Spawn = {
			{x = 2825.117, y = -1318.828, z = 46.805},				
		},
	},
	Basic_RHODES = {
		Name = "Rhodes General Store",
		SubTitle = "Cheapest Items",
		Items = {},
		Legal = true,
		OpeningTime = {open = 6, close = 20},
		Pos = {
			{x = 1328.856, y = -1292.145, z = 77.024},				
		},
		Spawn = {
			{x = 1329.850, y = -1292.398, z = 77.045},				
		},
	},
	Basic_BLACKWATER = {
		Name = "Blackwater General Store",
		SubTitle = "Cheapest Items",
		Items = {},
		Legal = true,
		OpeningTime = {open = 6, close = 20},
		Pos = {
			{x = -785.271, y = -1323.813, z = 43.024},				
		},
		Spawn = {
			{x = -786.130, y = -1323.111, z = 43.933},				
		},
	},
	Basic_ARMADILLO = {
		Name = "Armadillo General Store",
		SubTitle = "Cheapest Items",
		Items = {},
		Legal = true,
		OpeningTime = {open = 6, close = 20},
		Pos = {
			{x = -3685.548, y = -2623.073, z = -13.491},				
		},
		Spawn = {
			{x = -3686.28125, y = -2623.585, z = -13.382},				
		},
	},
	Basic_TUMBLEWEED = {
		Name = "Tumbleweed General Store",
		SubTitle = "Cheapest Items",
		Items = {},
		Legal = true,
		OpeningTime = {open = 6, close = 20},
		Pos = {
			{x = -5487.658, y = -2938.427, z = -0.448},				
		},
		Spawn = {
			{x = -5487.403, y = -2937.425, z = -0.362},				
		},
	},
	Doctor_STRAWBERRY = {
		Name = "Strawberry Doctor Store",
		SubTitle = "Best Medicines",
		Items = {},
		Legal = true,
		OpeningTime = {open = 6, close = 20},
		Pos = {
			{x = -1804.745, y = -430.353, z = 158.072},				
		},
		Spawn = {
			{x = -1805.369, y = -430.321, z = 158.874},				
		},
	},
	WEAPON_VALENTINE = {
		Name = "Valentine Weapon Store",
		SubTitle = "Cheapest Items",
		Items = {},
		Legal = true,
		OpeningTime = {open = 6, close = 20},
		Pos = {
			{x = -281.4,  y = 780.73, z = 119.53},				
		},
		Spawn = {
			{x = -282.91, y = 779.64, z = 119.52},				
		},
	},
	WEAPON_DENIS = {
		Name = "Saint Denis Weapon Store",
		SubTitle = "Cheapest Items",
		Items = {},
		Legal = true,
		OpeningTime = {open = 6, close = 20},
		Pos = {
			{x = 2716.091, y = -1285.576, z = 49.630},				
		},
		Spawn = {
			{x = 2716.683, y = -1286.547, z = 49.679},				
		},
	},
	WEAPON_RHODES = {
		Name = "Rhodes Weapon Store",
		SubTitle = "Cheapest Items",
		Items = {},
		Legal = true,
		OpeningTime = {open = 6, close = 20},
		Pos = {
			{x = 1323.287, y = -1321.686, z = 77.890},				
		},
		Spawn = {
			{x = 1323.166, y = -1322.216, z = 77.935},				
		},
	},
	WEAPON_TUMBLEWEED = {
		Name = "Tumbleweed Weapon Store",
		SubTitle = "Cheapest Items",
		Items = {},
		Legal = true,
		OpeningTime = {open = 6, close = 20},
		Pos = {
			{x = -5507.898, y = -2965.076, z = -0.689},				
		},
		Spawn = {
			{x = -5507.451, y = -2964.137, z = -0.590},				
		},
	},
}
