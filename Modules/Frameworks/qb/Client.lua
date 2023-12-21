QBCore = exports['qb-core']:getCoreObject()

function B1.GetPlayerData()
    local rawPlayerData = QBCore.Functions.GetPlayerData()

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
end

function B1.IsPlayerLoaded()
    return QBCore.Functions.GetPlayerData() ~= nil
end

function B1.GetPlayerIdentifier()
    return B1.GetPlayerData().identifier
end

function B1.GetPlayerJob()
    return B1.GetPlayerData().job
end

function B1.GetPlayerFunds()
    return {
        cash = B1.GetPlayerData().money,
        bank = B1.GetPlayerData().bank
    }
end

function B1.GetPlayerMetadata()
    return B1.GetPlayerData().metadata
end

function B1.Notify(text, textype, time)
    QBCore.Functions.Notify(text, textype, time)
end

RegisterNetEvent('B1:Client:Notify', function(text, textype, time)
    B1.Notify(text, textype, time)
end)

function B1.Progressbar(message, length, options)
    local name = options.name or "default_name"
    local label = message
    local duration = length
    local useWhileDead = options.useWhileDead or false
    local canCancel = options.canCancel or true
    local disableControls = options.disableControls or {
        disableMovement = options.FreezePlayer or false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false
    }
    local animation = options.animation and {
        animDict = options.animation.dict,
        anim = options.animation.lib,
        flags = options.animation.flags or 0,
        task = options.animation.task
    } or nil
    local prop = options.prop or nil
    local propTwo = options.propTwo or nil
    local onFinish = options.onFinish
    local onCancel = options.onCancel

    QBCore.Functions.Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
end

function B1.TriggerServerCallback(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb, ...)
end

function B1.IsPlayerDead()
    return {
        isDead = QBCore.Functions.GetPlayerData().metadata["isdead"],
        islaststand = QBCore.Functions.GetPlayerData().metadata["islaststand"]
    }
end