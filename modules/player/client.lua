function B1.getCorePlayerData()
    if B1.core == 'qb-core' then
        return CoreObject.Functions.GetPlayerData()
    elseif B1.core == 'esx' then
        return CoreObject.GetPlayerData()
    end
end

function B1.getPlayerData()
    if B1.core == 'qb-core' then
    local rawPlayerData = CoreObject.Functions.GetPlayerData()

    return {
        identifier = rawPlayerData.citizenid,
        job = {
            name = rawPlayerData.job.name,
            grade = rawPlayerData.job.grade
        },
        money = rawPlayerData.money["cash"],
        bank = rawPlayerData.money["bank"],
        metadata = rawPlayerData.metadata,
        charinfo = rawPlayerData.charinfo
    }
    elseif B1.core == 'esx' then
    local rawPlayerData = CoreObject.GetPlayerData()

    return {
        identifier = rawPlayerData.identifier,
        job = {
            name = rawPlayerData.job.name,
            grade = rawPlayerData.job.grade
        },
        money = rawPlayerData.accounts,
        bank = rawPlayerData.bank,
        metadata = rawPlayerData.metadata,
        charinfo = {
            firstname = ESX.PlayerData.firstname,
            lastname = ESX.PlayerData.lastname,
        }
    }
    end
end

function B1.getCitizenId()
    local citizenid = B1.callback.await('B1-lib:getCitizenid', false)
    return citizenid
end

function B1.getPlayerJob()
    local job = {}
    local playerData = B1.getCorePlayerData()
    
    if B1.core == 'qb-core' then
        job = {
            name = playerData.job.name,
            label = playerData.job.label,
            grade_name = playerData.job.grade,
            grade_label = playerData.job.grade.name,
            grade_salary = playerData.job.payment,
            isboss = playerData.job.isboss,
            onduty = playerData.job.onduty
        }
    elseif B1.core == 'esx' then
        job = {
            name = playerData.job.name,
            label = playerData.job.label,
            grade_name = playerData.job.grade_name,
            grade_label = playerData.job.grade_label,
            grade_salary = playerData.job.grade_salary,
            isboss = playerData.job.grade_name == 'boss' or false,
            onduty = true
        }
    end
    return job
end

function B1.getPlayerGang()
    local gang = {}
    local playerData = B1.getCorePlayerData()
    
    if B1.core == 'qb-core' then
        gang = {
            name = playerData.gang.name,
            label = playerData.gang.label,
            grade_name = playerData.gang.grade.level,
            grade_label = playerData.gang.grade.name,
            isboss = playerData.gang.isboss,
        }
    elseif B1.core == 'esx' then
        gang = {
            name = playerData.job.name,
            label = playerData.job.label,
            grade_name = playerData.job.grade_name,
            grade_label = playerData.job.grade_label,
            isboss = playerData.job.grade_name == 'boss' or false,
        }
    end
    return gang
end

function B1.getPlayerMoney(type)
    local playerData = B1.getCorePlayerData()
    if B1.core == 'qb-core' then
        local types = { ['cash'] = 'cash', ['bank'] = 'bank', ['black'] = false }

        if types[type] then
            return playerData.money[types[type]]
        end
        return false
    elseif B1.core == 'esx' then
        local types = { ['cash'] = 'money', ['bank'] = 'bank', ['black'] = 'black_money' }

        if types[type] then
            return playerData.accounts[types[type]]
        end
        return false
    end
end

function B1.getPlayerName()
    local playerData = B1.getCorePlayerData()
    if B1.core == 'qb-core' then
        return playerData.charinfo.firstname .. ' ' .. playerData.charinfo.lastname
    elseif B1.core == 'esx' then
        return B1.callback.await('B1-lib:getPlayerName', false)
    end
end

function B1.getLicences()
    local licenses = B1.callback.await('B1-lib:getlicences', false)
    return licenses
end

function B1.getLicence(licenseType)
    local license = B1.callback.await('B1-lib:getlicence', false, licenseType)
    return license
end

local notifyTypeMap = {
    ["info"] = { esx = "info", qb = "primary", oxlib = "inform" },
    ["success"] = { esx = "success", qb = "success", oxlib = "success" },
    ["error"] = { esx = "error", qb = "error", oxlib = "error" },
    ["warning"] = { esx = "info", qb = "primary", oxlib = "warning" },
    [1] = { esx = "info", qb = "primary", oxlib = "inform" },
    [2] = { esx = "success", qb = "success", oxlib = "success" },
    [3] = { esx = "error", qb = "error", oxlib = "error" }
}

function B1.notify(message, type, length)
    if not type then type = 'info' end
    if not length then length = 5000 end
    local notifyType = notifyTypeMap[type]
    if Config.UseOxNotify then
        if lib then
            lib.notify({
                description = message,
                type = notifyType.oxlib
            })
        else
            print("Warning: Oxlib is not running but Oxlib notifications are configured. Falling back to core detected notify.")
            if B1.core == 'qb-core' then
                TriggerEvent('QBCore:Notify', message, notifyType.qb, length)
            elseif B1.core == 'esx' then
                TriggerEvent('esx:showNotification', message, notifyType.esx, length)
            end
        end
    elseif B1.core == 'qb-core' then
        TriggerEvent('QBCore:Notify', message, notifyType.qb, length)
    elseif B1.core == 'esx' then
        TriggerEvent('esx:showNotification', message, notifyType.esx, length)
    end
end

RegisterNetEvent('B1:OxlibNotify')
AddEventHandler('B1:OxlibNotify', function(message, ttype, length)
    if lib then
        lib.notify({
            description = message,
            type = ttype,
            duration = length
        })
    else
        B1.notify(message, ttype, length)
    end
end)