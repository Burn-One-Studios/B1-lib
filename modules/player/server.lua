function B1.getPlayer(source)
    if B1.core == 'qb-core' then
        return CoreObject.Functions.GetPlayer(source)
    elseif B1.core == 'esx' then
        return CoreObject.GetPlayerFromId(source)
    end
end

function B1.getPlayers()
    if B1.core == 'qb-core' then
        return CoreObject.Functions.GetQBPlayers()
    elseif B1.core == 'esx' then
        return CoreObject.GetPlayers()
    end
end

-- Money
function B1.addMoney(source, moneyType, amount, reason)
    if not reason then reason = 'unknown' end
    local Player = B1.getPlayer(source)
    local addedMoney = false
    local types = {
        ['cash'] = {
            ['qb-core'] = 'cash',
            ['esx'] = 'money'
        },
        ['bank'] = {
            ['qb-core'] = 'bank',
            ['esx'] = 'bank'
        }
    }

    if B1.core == 'qb-core' then
        moneyType = types[moneyType]['qb-core']
        addedMoney = Player.Functions.AddMoney(moneyType, amount, reason)
    elseif B1.core == 'esx' then
        moneyType = types[moneyType]['esx']
        local currentMoney = Player.getAccount(moneyType)
        Player.addAccountMoney(moneyType, amount, reason)
        if currentMoney + amount == Player.getAccount(moneyType) then
            addedMoney = true
        else
            addedMoney = false
        end
    end
    return addedMoney
end

function B1.removeMoney(source, moneyType, amount, reason)
    if not reason then reason = 'unknown' end
    local Player = B1.getPlayer(source)
    local removedMoney = false
    local types = {
        ['cash'] = {
            ['qb-core'] = 'cash',
            ['esx'] = 'money'
        },
        ['bank'] = {
            ['qb-core'] = 'bank',
            ['esx'] = 'bank'
        }
    }

    if B1.core == 'qb-core' then
        moneyType = types[moneyType]['qb-core']
        removedMoney = Player.Functions.RemoveMoney(moneyType, amount, reason)
    elseif B1.core == 'esx' then
        moneyType = types[moneyType]['esx']
        local currentMoney = Player.getAccount(moneyType)
        Player.removeAccountMoney(moneyType, amount, reason)
        if currentMoney - amount == currentMoney then
            removedMoney = false
        else
            removedMoney = true
        end
    end
    return removedMoney
end

function B1.getMoney(source, moneyType)
    local Player = B1.getPlayer(source)
    local types = {
        ['cash'] = {
            ['qb-core'] = 'cash',
            ['esx'] = 'money'
        },
        ['bank'] = {
            ['qb-core'] = 'bank',
            ['esx'] = 'bank'
        }
    }

    if B1.core == 'qb-core' then
        moneyType = types[moneyType]['qb-core']
        return Player.Functions.GetMoney(moneyType)
    elseif B1.core == 'esx' then
        moneyType = types[moneyType]['esx']
        return Player.getAccount(moneyType)
    end
    return false
end

function B1.setMoney(source, moneyType, amount)
    if not reason then reason = 'unknown' end
    local Player = B1.getPlayer(source)
    local types = {
        ['cash'] = {
            ['qb-core'] = 'cash',
            ['esx'] = 'money'
        },
        ['bank'] = {
            ['qb-core'] = 'bank',
            ['esx'] = 'bank'
        }
    }

    if B1.core == 'qb-core' then
        moneyType = types[moneyType]['qb-core']
        Player.Functions.SetMoney(moneyType, amount, reason)
    elseif B1.core == 'esx' then
        moneyType = types[moneyType]['esx']
        Player.setAccountMoney(moneyType, amount, reason)
    end
end

function B1.getLicences(source)
    local Player = B1.getPlayer(source)
    if B1.core == 'qb-core' then
        local licences = Player.PlayerData.metadata['licences']
        return licences or false
    elseif B1.core == 'esx' then
        TriggerEvent('esx_license:getLicenses', source, function(licenses)
            return licences or false
        end)
    end
end

function B1.getLicence(source, licenseType)
    local Player = B1.getPlayer(source)
    if B1.core == 'qb-core' then
        local licences = Player.PlayerData.metadata['licences']
        return licences[licenseType] or false
    elseif B1.core == 'esx' then
        TriggerEvent('esx_license:getLicenses', source, function(licenses)
            return licences[licenseType] or false
        end)
    end
end

function B1.addLicence(source, licenseType)
    local Player = B1.getPlayer(source)
    if B1.core == 'qb-core' then
        local licences = Player.PlayerData.metadata['licences']
        licences[licenseType] = true
        Player.Functions.SetMetaData('licences', licences)
        return true
    elseif B1.core == 'esx' then
        TriggerEvent('esx_license:addLicense', source, licenseType, function()
            return true
        end)
    end
    return false
end

function B1.removeLicence(source, licenseType)
    local Player = B1.getPlayer(source)
    if B1.core == 'qb-core' then
        local licences = Player.PlayerData.metadata['licences']
        licences[licenseType] = false
        Player.Functions.SetMetaData('licences', licences)
        return true
    elseif B1.core == 'esx' then
        TriggerEvent('esx_license:removeLicense', source, licenseType, function()
            return true
        end)
    end
    return false
end

function B1.getCitizenId(source)
    local Player = B1.getPlayer(source)
    if B1.core == 'qb-core' then
        local citizenid = Player.PlayerData.citizenid
        return citizenid
    elseif B1.core == 'esx' then
        local citizenid = Player.license
        return citizenid
    end
    return false
end

function B1.getPlayerName(source)
    local Player = B1.getPlayer(source)
    if B1.core == 'qb-core' then
        local player_name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        return player_name
    elseif B1.core == 'esx' then
        local player_name = Player.name
        return player_name
    end
    return false
end


B1.callback.register('B1-lib:getPlayerName', function(source)
    return B1.getPlayerName(source)
end)

B1.callback.register('B1-lib:getlicences', function(source)
    return B1.getLicences(source)
end)

B1.callback.register('B1-lib:getlicence', function(source, licenseType)
    return B1.getLicence(source, licenseType)
end)

B1.callback.register('B1-lib:getCitizenid', function(source)
    return B1.getCitizenId(source)
end)
