function B1.hasItem(itemName, amount)
    local hasItem = B1.callback.await('B1:hasItem', false, itemName, amount)
    return hasItem
end

function B1.getItemLabel(itemName)
    local itemLabel
    if B1.core == 'qb-core' then
        itemLabel = CoreObject.Shared.Items[itemName].label
    elseif B1.core == 'esx' then
        itemLabel = B1.callback.await('B1:getItemLabel', false, itemName)
    end
    return itemLabel
end

function B1.getItemCount(itemName)
    local itemCount = B1.callback.await('B1:getItemCount', false, itemName)
    return itemCount
end

function B1.toggleItem(toggle, name, amount, metadata)
    TriggerServerEvent('B1-lib:toggleItem', toggle, name, amount, metadata)
end