item = {}
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	ESX.RegisterServerCallback('omgugly:inventoryhudCorpse_getItem', function(source, cb, inventory)
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local wait = true
		local ret = {}
		MySQL.Async.fetchAll("SELECT * FROM items", {}, function(items)
			while (type(items) ~= 'table') do Citizen.Wait(0) end
			for i = 1, #items do
				item[items[i].name] = items[i]
				-- print(json.encode(items[i]))
			end
			wait = false
			while (wait) do Citizen.Wait(0) end
			if (inventory[1]) then
				for i = 1, #inventory do
					-- print("--->	"..inventory[i].name..", "..inventory[i].count)
					table.insert(ret, {
						name      = inventory[i].name,
						count     = inventory[i].count,
						label     = item[inventory[i].name].label,
						limit     = item[inventory[i].name].limit,
						usable    = ESX.UsableItemsCallbacks[inventory[i].name] ~= nil,
						rare      = item[inventory[i].name].rare,
						canRemove = item[inventory[i].name].can_remove
					})
				end
			else
				print("- ->	"..inventory.name..", "..inventory.count..", "..json.encode(item[inventory.name]))
				table.insert(ret, {
					name      = inventory.name,
					count     = inventory.count,
					label     = item[inventory.name].label,
					limit     = item[inventory.name].limit,
					usable    = ESX.UsableItemsCallbacks[inventory.name] ~= nil,
					rare      = item[inventory.name].rare,
					canRemove = item[inventory.name].can_remove
				})
			end
			if (ret ~= nil) then cb(ret)
			else cb(nil) end
		end)
	end)
end)	
