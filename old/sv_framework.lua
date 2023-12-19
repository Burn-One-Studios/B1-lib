--[[ local supportedFrameworks = {
    esx = {
        check = 'es_extended',
        GetPlayerDataByID = function(framework, playerId)
            local player = framework.GetPlayerFromId(playerId)
            return player and player.getIdentifier()
        end,
        registerServerCallback = function(name, cb)
            ESX.RegisterServerCallback(name, cb)
        end
    },
    qb = {
        check = 'qb-core',
        GetPlayerDataByID = function(framework, playerId)
            local player = framework.Functions.GetPlayer(playerId)
            return player and player.PlayerData
        end,
        registerServerCallback = function(name, cb)
            QBCore.Functions.CreateCallback(name, cb)
        end
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

function B1.RegisterServerCallback(name, cb)
    if Framework and supportedFrameworks[Fw] and supportedFrameworks[Fw].registerServerCallback then
        supportedFrameworks[Fw].registerServerCallback(name, cb)
    end
end

function B1.GetPlayerDataByID(playerId)
    if Framework and supportedFrameworks[Fw] then
        local rawPlayerData = supportedFrameworks[Fw].getPlayerData(Framework, playerId)

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

function B1.NotifySource(source, text, textype, time)
    TriggerClientEvent('B1:Client:Notify', source, text, textype, time)
end ]]