ESX = exports["es_extended"]:getSharedObject()

function B1.GetPlayerData()
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

function B1.IsPlayerLoaded()
    return ESX.IsPlayerLoaded()
end

function B1.GetPlayerIdentifier()
    return ESX.GetPlayerData().identifier
end

function B1.GetPlayerJob()
    return ESX.GetPlayerData().job
end

function B1.GetPlayerFunds()
    return ESX.PlayerData.accounts
end

function B1.GetPlayerMetadata()
    return ESX.PlayerData.metadata
end

function B1.Notify(text, textype, time)
    ESX.ShowNotification(text, textype, time)
end

RegisterNetEvent('B1:Client:Notify', function(text, textype, time)
    B1.Notify(text, textype, time)
end)

function B1.Progressbar(message, length, options)
    local esxOptions = {
    FreezePlayer = options.FreezePlayer or false,
    animation = options.animation,
    onFinish = options.onFinish,
    onCancel = options.onCancel
    }
    ESX.Progressbar(message, length, esxOptions)
end

function B1.TriggerServerCallback(name, cb, ...)
    ESX.TriggerServerCallback(name, cb, ...)
end

function B1.IsPlayerDead()
    return ESX.IsPlayerDead()
end