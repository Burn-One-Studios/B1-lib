ConsumableItems = {}
local ox_inventory = exports.ox_inventory

function B1.hasItem(source, item, amount)
    if B1.inventory == 'ox' then
        local itemData = ox_inventory:GetItem(source, item, nil, true)
        if itemData >= amount then return true end
	elseif B1.core == "qb-core" then
		local Player = CoreObject.Functions.GetPlayer(source)
		if not Player then return false end
        local itemData = Player.Functions.GetItemByName(item)
        if not itemData then return false end
		if itemData.amount >= amount then return true end
	elseif B1.core == "esx" then
		local Player = CoreObject.GetPlayerFromId(source)
		local itemName, itemCount = Player.hasItem(item)
		if itemCount >= amount then return true end
	end
    return false
end

function B1.giveItem(source, item, amount, metadata)
    if B1.inventory == 'ox' then
        local added, _ = ox_inventory:AddItem(source, item, amount, metadata)
        return added
	elseif B1.core == "qb-core" then
		local Player = CoreObject.Functions.GetPlayer(source)
		if not Player then return end
		if Player.Functions.AddItem(item, amount, false, metadata or {}) then
            TriggerClientEvent("inventory:client:ItemBox", source, CoreObject.Shared.Items[item], "add", amount)
            return true
        end
	elseif B1.core == "esx" then
		local Player = CoreObject.GetPlayerFromId(source)
        local original_amount = Player.getInventoryItem(item)?.count
		Player.addInventoryItem(item, amount, metadata or {})
        local new_amount = Player.getInventoryItem(item)?.count
        if new_amount >= original_amount + amount then
            return true
        end
	end
    return false
end

function B1.removeItem(source, item, amount, metadata)
    if B1.inventory == 'ox' then
        local removedItem = ox_inventory:GetItem(source, item, nil, true)
        if removedItem >= amount then
            ox_inventory:RemoveItem(source, item, amount, metadata or {})
            return true
        end
	elseif B1.core == "qb-core" then
        local Player = CoreObject.Functions.GetPlayer(source)
		if not Player then return end
		if Player.Functions.RemoveItem(item, amount) then
            TriggerClientEvent("inventory:client:ItemBox", source, CoreObject.Shared.Items[item], "remove", amount)
            return true
        end
	elseif B1.core == "esx" and B1.inventory == 'esx' then
        local Player = CoreObject.GetPlayerFromId(source)
        local removedItem = Player.getInventoryItem(item)
        if removedItem.count >= amount then
            Player.removeInventoryItem(item, amount)
            return true
        end
	end
    return false
end

function B1.createUsableItem(item, cb)
    if ConsumableItems[item] then print('[B1-lib] The item ' .. item .. ' is already registered as a consumable item. Skipping the registration of this item.') end
	if B1.core == "qb-core" then
		CoreObject.Functions.CreateUseableItem(item, cb)
        ConsumableItems[item] = cb
	elseif B1.core == "esx" and B1.inventory == 'esx' then
		CoreObject.RegisterUsableItem(item, cb)
        ConsumableItems[item] = cb
	end
end

function B1.toggleItem(source, toggle, name, amount, metadata)
    if toggle == 1 or toggle == true then
        B1.giveItem(source, name, amount, metadata or nil)
    elseif toggle == 0 or toggle == false then
        B1.removeItem(source, name, amount, metadata or nil)
    end
end

function B1.getItemCount(source, item)
    if B1.inventory == 'ox' then
        local itemData = ox_inventory:GetItem(source, item, nil, true)
        if itemData then return itemData else return 0 end
	elseif B1.core == "qb-core" then
		local Player = CoreObject.Functions.GetPlayer(source)
		if not Player then return 0 end
        local itemData = Player.Functions.GetItemByName(item)
        if itemData then return itemData.amount else return 0 end
	elseif B1.core == "esx" then
		local Player = CoreObject.GetPlayerFromId(source)
		local itemData = Player.getInventoryItem(item)
		if itemData then return itemData.count else return 0 end
	end
    return 0
end

B1.callback.register('B1:hasItem', function(source, item, amount)
    local hasItem = B1.hasItem(source, item, amount)
    return hasItem
end)

B1.callback.register('B1:getItemCount', function(source, item)
    local itemCount = B1.getItemCount(source, item)
    return itemCount
end)

B1.callback.register('B1:getItemLabel', function(source, itemName)
    local itemLabel = CoreObject.GetItemLabel(itemName)
    return itemLabel
end)

RegisterNetEvent('B1-lib:toggleItem', function(toggle, name, amount, metadata)
    local source = source
    B1.toggleItem(source, toggle, name, amount, metadata)
end)