-- B1-lib Inventory Server Module
-- ox_inventory wrapper functions

local hasOxInventory = GetResourceState('ox_inventory') == 'started'

if not hasOxInventory then
    B1.log('warning', 'ox_inventory not found - inventory functions will be disabled')
end

-- Inventory namespace
B1.inv = {}

-- Add item to inventory
function B1.inv.add(src, name, count, metadata, slot)
    if not hasOxInventory then
        B1.log('error', 'ox_inventory not available for add')
        return false
    end
    
    count = count or 1
    metadata = metadata or {}
    
    local success = exports.ox_inventory:AddItem(src, name, count, metadata, slot)
    return success and success > 0
end

-- Remove item from inventory
function B1.inv.remove(src, name, count, metadata, slot)
    if not hasOxInventory then
        B1.log('error', 'ox_inventory not available for remove')
        return false
    end
    
    count = count or 1
    metadata = metadata or {}
    
    local success = exports.ox_inventory:RemoveItem(src, name, count, metadata, slot)
    return success and success > 0
end

-- Check if player can carry item
function B1.inv.canCarry(src, name, count, metadata)
    if not hasOxInventory then
        B1.log('error', 'ox_inventory not available for canCarry')
        return false
    end
    
    count = count or 1
    metadata = metadata or {}
    
    return exports.ox_inventory:CanCarryItem(src, name, count, metadata)
end

-- Get item from inventory
function B1.inv.get(src, name, metadata)
    if not hasOxInventory then
        B1.log('error', 'ox_inventory not available for get')
        return nil
    end
    
    metadata = metadata or {}
    
    return exports.ox_inventory:GetItem(src, name, metadata)
end

-- Search inventory
function B1.inv.search(src, searchType, items, metadata)
    if not hasOxInventory then
        B1.log('error', 'ox_inventory not available for search')
        return {}
    end
    
    metadata = metadata or {}
    
    return exports.ox_inventory:Search(src, searchType, items, metadata)
end

-- Export functions
exports('inv_add', B1.inv.add)
exports('inv_remove', B1.inv.remove)
exports('inv_can_carry', B1.inv.canCarry)
exports('inv_get', B1.inv.get)
exports('inv_search', B1.inv.search)
