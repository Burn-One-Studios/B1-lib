---@param need string
---@param type string
---@param amount number
function B1.updateNeed(need, type, amount)
    local source = source
    if B1.core == 'qb-core' then
        local Player = B1.getPlayer(source)
        local defaultValue = Player.Functions.GetMetaData(need)
        local newValue = amount
        if type == 'add' then newValue = defaultValue + amount
        elseif type == 'remove' then newValue = defaultValue - amount
        elseif type == 'set' then newValue = amount end

        Player.Functions.SetMetaData(need, newValue)
        TriggerClientEvent('hud:client:UpdateNeeds', source, Player.Functions.GetMetaData('hunger'), Player.Functions.GetMetaData('thirst'))
    elseif B1.core == 'esx' then
        if type == 'add' then TriggerClientEvent(source, 'esx_status:add', need, amount)
        elseif type == 'remove' then TriggerClientEvent(source, 'esx_status:remove', need, amount)
        elseif type == 'set' then TriggerClientEvent(source, 'esx_status:set', need, amount) end
    end
end

RegisterNetEvent('B1-lib:updateNeed', function(need, type, amount)
    local source = source
    B1.updateNeed(need, type, amount)
end)