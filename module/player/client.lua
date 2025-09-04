-- B1-lib Player Client Module
-- Client-side player functions with normalized data

local coreName = B1.getCoreName()
local coreObject = B1.getCoreObject()

-- Get core player data
function B1.getCorePlayerData()
    if not coreObject then
        B1.log('warning', 'No core object available for getCorePlayerData')
        return nil
    end
    
    if coreName == 'qb-core' then
        return coreObject.Functions.GetPlayerData()
    elseif coreName == 'esx' then
        return coreObject.GetPlayerData()
    end
    
    return nil
end

-- Get normalized player data
function B1.getPlayerData()
    local playerData = B1.getCorePlayerData()
    if not playerData then return nil end
    
    if coreName == 'qb-core' then
        return {
            identifier = playerData.citizenid,
            job = playerData.job,
            money = playerData.money,
            bank = playerData.money.bank,
            metadata = playerData.metadata,
            charinfo = playerData.charinfo
        }
    elseif coreName == 'esx' then
        return {
            identifier = playerData.identifier,
            job = playerData.job,
            money = playerData.money,
            bank = playerData.accounts.bank.money,
            metadata = playerData.metadata or {},
            charinfo = {
                firstname = playerData.firstName,
                lastname = playerData.lastName
            }
        }
    end
    
    return nil
end

-- Get citizen ID via server callback
function B1.getCitizenId()
    local promise = promise.new()
    RegisterNetEvent('B1-lib:getCitizenid', function(citizenId)
        promise:resolve(citizenId)
    end)
    TriggerServerEvent('B1-lib:getCitizenid')
    return Citizen.Await(promise)
end

-- Get player job (normalized)
function B1.getPlayerJob()
    local playerData = B1.getCorePlayerData()
    if not playerData then return nil end
    
    if coreName == 'qb-core' then
        return {
            name = playerData.job.name,
            label = playerData.job.label,
            grade = playerData.job.grade,
            isboss = playerData.job.isboss,
            onduty = playerData.job.onduty
        }
    elseif coreName == 'esx' then
        return {
            name = playerData.job.name,
            label = playerData.job.label,
            grade = playerData.job.grade,
            isboss = playerData.job.grade_name == 'boss',
            onduty = true -- ESX doesn't have onduty concept
        }
    end
    
    return nil
end

-- Get player gang (QB only, ESX reuses job structure)
function B1.getPlayerGang()
    local playerData = B1.getCorePlayerData()
    if not playerData then return nil end
    
    if coreName == 'qb-core' then
        return playerData.gang
    elseif coreName == 'esx' then
        -- ESX doesn't have gangs, return job as gang
        return playerData.job
    end
    
    return nil
end

-- Get player money
function B1.getPlayerMoney(type)
    local playerData = B1.getCorePlayerData()
    if not playerData then return 0 end
    
    if coreName == 'qb-core' then
        return playerData.money[type] or 0
    elseif coreName == 'esx' then
        if type == 'cash' then
            return playerData.money
        elseif type == 'bank' then
            return playerData.accounts.bank.money
        elseif type == 'black' then
            return playerData.accounts.black_money.money
        end
    end
    
    return 0
end

-- Get player name
function B1.getPlayerName()
    if coreName == 'qb-core' then
        local playerData = B1.getCorePlayerData()
        if playerData and playerData.charinfo then
            return playerData.charinfo.firstname .. ' ' .. playerData.charinfo.lastname
        end
        return 'Unknown'
    elseif coreName == 'esx' then
        local promise = promise.new()
        RegisterNetEvent('B1-lib:getPlayerName', function(name)
            promise:resolve(name)
        end)
        TriggerServerEvent('B1-lib:getPlayerName')
        return Citizen.Await(promise)
    end
    
    return 'Unknown'
end

-- Notify function (deprecated - use B1.notify from UI module)
function B1.notify(message, type, length)
    B1.log('warning', 'B1.notify in player module is deprecated, use UI module instead')
    -- Redirect to UI module
    return exports['b1-lib']:notify(message, type, length)
end

-- Export functions
exports('getCorePlayerData', B1.getCorePlayerData)
exports('getPlayerData', B1.getPlayerData)
exports('getPlayerJob', B1.getPlayerJob)
exports('getPlayerGang', B1.getPlayerGang)
exports('getPlayerMoney', B1.getPlayerMoney)
exports('getPlayerName', B1.getPlayerName)
exports('getCitizenId', B1.getCitizenId)
exports('notify', B1.notify)
