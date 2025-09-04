-- B1-lib Player Server Module
-- QBCore/ESX normalized player functions

local coreName = B1.getCoreName()
local coreObject = B1.getCoreObject()

-- Get core player object
function B1.getCorePlayer(source)
    if not coreObject then
        B1.log('warning', 'No core object available for getCorePlayer')
        return nil
    end
    
    if coreName == 'qb-core' then
        return coreObject.Functions.GetPlayer(source)
    elseif coreName == 'esx' then
        return coreObject.GetPlayerFromId(source)
    end
    
    return nil
end

-- Get player by identifier
function B1.getPlayerByIdentifier(identifier)
    if not coreObject then
        B1.log('warning', 'No core object available for getPlayerByIdentifier')
        return nil
    end
    
    if coreName == 'qb-core' then
        return coreObject.Functions.GetPlayerByCitizenId(identifier)
    elseif coreName == 'esx' then
        return coreObject.GetPlayerFromIdentifier(identifier)
    end
    
    return nil
end

-- Get offline player by identifier
function B1.getOfflinePlayerByIdentifier(identifier)
    if not coreObject then
        B1.log('warning', 'No core object available for getOfflinePlayerByIdentifier')
        return nil
    end
    
    if coreName == 'qb-core' then
        return coreObject.Functions.GetOfflinePlayerByCitizenId(identifier)
    elseif coreName == 'esx' then
        local result = B1.db.single('SELECT * FROM users WHERE identifier = ?', {identifier})
        if result then
            result.accounts = json.decode(result.accounts or '{}')
            result.metadata = json.decode(result.metadata or '{}')
            return result
        end
    end
    
    return nil
end

-- Get all players
function B1.getPlayers()
    if not coreObject then
        B1.log('warning', 'No core object available for getPlayers')
        return {}
    end
    
    if coreName == 'qb-core' then
        return coreObject.Functions.GetPlayers()
    elseif coreName == 'esx' then
        return coreObject.GetPlayers()
    end
    
    return {}
end

-- Money functions
function B1.addMoney(source, moneyType, amount, reason)
    local player = B1.getCorePlayer(source)
    if not player then return false end
    
    if coreName == 'qb-core' then
        return player.Functions.AddMoney(moneyType, amount, reason or 'b1-lib')
    elseif coreName == 'esx' then
        if moneyType == 'cash' then
            player.addMoney(amount)
        elseif moneyType == 'bank' then
            player.addAccountMoney('bank', amount)
        end
        return true
    end
    
    return false
end

function B1.removeMoney(source, moneyType, amount, reason)
    local player = B1.getCorePlayer(source)
    if not player then return false end
    
    if coreName == 'qb-core' then
        return player.Functions.RemoveMoney(moneyType, amount, reason or 'b1-lib')
    elseif coreName == 'esx' then
        if moneyType == 'cash' then
            player.removeMoney(amount)
        elseif moneyType == 'bank' then
            player.removeAccountMoney('bank', amount)
        end
        return true
    end
    
    return false
end

function B1.getMoney(source, moneyType)
    local player = B1.getCorePlayer(source)
    if not player then return 0 end
    
    if coreName == 'qb-core' then
        return player.PlayerData.money[moneyType] or 0
    elseif coreName == 'esx' then
        if moneyType == 'cash' then
            return player.getMoney()
        elseif moneyType == 'bank' then
            return player.getAccount('bank').money
        end
    end
    
    return 0
end

function B1.setMoney(source, moneyType, amount)
    local player = B1.getCorePlayer(source)
    if not player then return false end
    
    if coreName == 'qb-core' then
        player.Functions.SetMoney(moneyType, amount)
        return true
    elseif coreName == 'esx' then
        if moneyType == 'cash' then
            player.setMoney(amount)
        elseif moneyType == 'bank' then
            player.setAccountMoney('bank', amount)
        end
        return true
    end
    
    return false
end

-- License functions
function B1.getLicences(source)
    local player = B1.getCorePlayer(source)
    if not player then return {} end
    
    if coreName == 'qb-core' then
        return player.PlayerData.metadata.licences or {}
    elseif coreName == 'esx' then
        return player.get('licenses') or {}
    end
    
    return {}
end

function B1.getLicence(source, licenseType)
    local licences = B1.getLicences(source)
    return licences[licenseType] or false
end

function B1.addLicence(source, licenseType)
    local player = B1.getCorePlayer(source)
    if not player then return false end
    
    if coreName == 'qb-core' then
        local licences = player.PlayerData.metadata.licences or {}
        licences[licenseType] = true
        player.Functions.SetMetaData('licences', licences)
        return true
    elseif coreName == 'esx' then
        local licenses = player.get('licenses') or {}
        licenses[licenseType] = true
        player.set('licenses', licenses)
        return true
    end
    
    return false
end

function B1.removeLicence(source, licenseType)
    local player = B1.getCorePlayer(source)
    if not player then return false end
    
    if coreName == 'qb-core' then
        local licences = player.PlayerData.metadata.licences or {}
        licences[licenseType] = false
        player.Functions.SetMetaData('licences', licences)
        return true
    elseif coreName == 'esx' then
        local licenses = player.get('licenses') or {}
        licenses[licenseType] = false
        player.set('licenses', licenses)
        return true
    end
    
    return false
end

-- Identity functions
function B1.getCitizenId(source)
    local player = B1.getCorePlayer(source)
    if not player then return nil end
    
    if coreName == 'qb-core' then
        return player.PlayerData.citizenid
    elseif coreName == 'esx' then
        return player.identifier
    end
    
    return nil
end

function B1.getPlayerName(source)
    local player = B1.getCorePlayer(source)
    if not player then return 'Unknown' end
    
    if coreName == 'qb-core' then
        return player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
    elseif coreName == 'esx' then
        return player.getName()
    end
    
    return 'Unknown'
end

-- Callbacks for client
RegisterNetEvent('B1-lib:getPlayerName', function()
    local src = source
    local name = B1.getPlayerName(src)
    TriggerClientEvent('B1-lib:getPlayerName', src, name)
end)

RegisterNetEvent('B1-lib:getlicences', function()
    local src = source
    local licences = B1.getLicences(src)
    TriggerClientEvent('B1-lib:getlicences', src, licences)
end)

RegisterNetEvent('B1-lib:getlicence', function(licenseType)
    local src = source
    local hasLicense = B1.getLicence(src, licenseType)
    TriggerClientEvent('B1-lib:getlicence', src, hasLicense)
end)

RegisterNetEvent('B1-lib:getCitizenid', function()
    local src = source
    local citizenId = B1.getCitizenId(src)
    TriggerClientEvent('B1-lib:getCitizenid', src, citizenId)
end)

-- Export functions
exports('getCorePlayer', B1.getCorePlayer)
exports('getPlayerByIdentifier', B1.getPlayerByIdentifier)
exports('getOfflinePlayerByIdentifier', B1.getOfflinePlayerByIdentifier)
exports('getPlayers', B1.getPlayers)
exports('addMoney', B1.addMoney)
exports('removeMoney', B1.removeMoney)
exports('getMoney', B1.getMoney)
exports('setMoney', B1.setMoney)
exports('getLicences', B1.getLicences)
exports('getLicence', B1.getLicence)
exports('addLicence', B1.addLicence)
exports('removeLicence', B1.removeLicence)
exports('getCitizenId', B1.getCitizenId)
exports('getPlayerName', B1.getPlayerName)
