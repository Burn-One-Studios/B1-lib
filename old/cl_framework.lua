--[[ local supportedFrameworks = {
    esx = {
        check = 'es_extended',
        getPlayerData = function(fw) return fw.GetPlayerData() end,
        notify = function(fw, text, textype, time) fw.ShowNotification(text, textype, time) end,
        isPlayerDead = function(fw) return fw.GetPlayerData().dead end,
        isPlayerLoaded = function() return fw.IsPlayerLoaded() end,
        triggerServerCallback = function(name, cb, ...)
            Framework.TriggerServerCallback(name, cb, ...)
        end,
    },
    qb = {
        check = 'qb-core',
        getPlayerData = function(fw) return fw.Functions.GetPlayerData() end,
        notify = function(fw, text, textype, time) fw.Functions.Notify(text, textype, time) end,
        isPlayerDead = function(fw) 
            local playerData = fw.Functions.GetPlayerData()
            return playerData.metadata["isdead"] or playerData.metadata["islaststand"]
        end,
        isPlayerLoaded = function() return LocalPlayer.state.isLoggedIn end,
        triggerServerCallback = function(name, cb, ...)
            Framework.Functions.TriggerCallback(name, cb, ...)
        end,
    }
}



Framework = nil
Fw = nil

for name, framework in pairs(supportedFrameworks) do
    if GetResourceState(framework.check) == 'started' then
        -- if esx then run this
        if name == "esx" then
            Framework = exports['es_extended']:getSharedObject()
            Fw = name
        elseif name == "qb" then
            Framework = exports['qb-core']:getCoreObject()
            Fw = name
        end
    end
end

if not Framework then
    print('Supported framework not found!')
end

function B1.GetPlayerData()
    if Framework and supportedFrameworks[Fw] then
        local rawPlayerData = supportedFrameworks[Fw].getPlayerData(Framework)

        if Fw == "esx" then
            -- For ESX
            return {
                identifier = rawPlayerData.identifier,
                job = {
                    name = rawPlayerData.job.name,
                    grade = rawPlayerData.job.grade
                },
                money = rawPlayerData.money,
                bank = rawPlayerData.bank,
                metadata = rawPlayerData.metadata
            }
        elseif Fw == "qb" then
            return {
                identifier = rawPlayerData.cid,
                job = {
                    name = rawPlayerData.job.name,
                    grade = rawPlayerData.job.grade.level
                },
                money = rawPlayerData.money["cash"],
                bank = rawPlayerData.money["bank"],
                metadata = rawPlayerData.metadata
            }
        end
    end
    return nil
end

function B1.Notify(text, textype, time)
    if Framework and supportedFrameworks[Fw] then
        supportedFrameworks[Fw].notify(Framework, text, textype, time)
    end
end

RegisterNetEvent('B1:Client:Notify', function(text, textype, time)
    B1.Notify(text, textype, time)
end)

function B1.Progressbar(message, length, options)
    if not Framework then
        print("Supported framework not found!")
        return
    end

    if Fw == "esx" then
        local esxOptions = {
            FreezePlayer = options.FreezePlayer or false,
            animation = options.animation,
            onFinish = options.onFinish,
            onCancel = options.onCancel
        }
        Framework.Progressbar(message, length, esxOptions)
    elseif Fw == "qb" then
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

        Framework.Functions.Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    end
end

function B1.TriggerServerCallback(name, cb, ...)
    if Framework and supportedFrameworks[Fw] and supportedFrameworks[Fw].triggerServerCallback then
        supportedFrameworks[Fw].triggerServerCallback(name, cb, ...)
    end
end

function B1.IsPlayerDead()
    if Framework and supportedFrameworks[Fw] then
        return supportedFrameworks[Fw].isPlayerDead(Framework)
    end
    return false
end

function B1.IsPlayerLoaded()
    if Framework and supportedFrameworks[Fw] then
        return supportedFrameworks[Fw].isPlayerLoaded()
    end
    return false
end

RegisterNetEvent('B1:Client:OnPlayerLogout', function(cb)
    if Framework and supportedFrameworks == "esx" then
        AddEventHandler('esx:onPlayerLogout', function()
            cb()
        end)
    elseif Framework and supportedFrameworks == "qb" then
        AddEventHandler('qb-core:client:OnPlayerLogout', function()
            cb()
        end)
    end
end) ]]