function openCorpseInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "corpse"
        }
    )
    SetNuiFocus(true, true)
end

function loadCorpseInventory(blackMoney, inventory)
		items = {}
		print("loadCorpseInventory		"..json.encode(inventory))
		if tonumber(blackMoney) > 0 then
			accountData = {
				label = "dirty money",
				count = tonumber(blackMoney),
				type = "item_account",
				name = "black_money",
				usable = false,
				rare = false,
				limit = -1,
				canRemove = false
			}
			table.insert(items, accountData)
		end
		if (inventory[1]) then
			for key, value in pairs(inventory) do
				if inventory[key].count <= 0 then
					inventory[key] = nil
				else
					inventory[key].type = "item_standard"
					inventory[key].usable = false
					inventory[key].rare = false
					inventory[key].limit = -1
					inventory[key].canRemove = false
					table.insert(items, inventory[key])
				end
			end
		else
			if inventory.count <= 0 then
				inventory = nil
			else
				inventory.type = "item_standard"
				inventory.usable = false
				inventory.rare = false
				inventory.limit = -1
				inventory.canRemove = false
				table.insert(items, inventory)
			end
		end
		SendNUIMessage(
			{
				action = "setSecondInventoryItems",
				itemList = items
			}
		)
end

RegisterNetEvent('omgugly:setCorpseInventory')
AddEventHandler('omgugly:setCorpseInventory', function(blackMoney, inventory)
	loadCorpseInventory(blackMoney, inventory)
	openCorpseInventory()
end)

RegisterNetEvent('omgugly:refreshCorpseInventory')
AddEventHandler('omgugly:refreshCorpseInventory', function(blackMoney, inventory)
	loadCorpseInventory(blackMoney, inventory)
end)
