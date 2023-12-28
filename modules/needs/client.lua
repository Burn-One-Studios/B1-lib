---@param need string
---@param type string
---@param amount number
function B1.updateNeed(need, type, amount)
    TriggerServerEvent('B1-lib:updateNeed', need, type, amount)
end