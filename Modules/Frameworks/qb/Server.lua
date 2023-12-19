QBCore = exports["qb-core"]:getCoreObject()

if GetResourceState('qb-core') == 'started' then
    LoadResourceFile(GetCurrentResourceName(), "Modules/Frameworks/qb/Client.lua")
end

function B1.RegisterServerCallback(name, cb)
    QBCore.Functions.CreateCallback(name, cb)
end

function B1.GetPlayerDataByIdentifier(playerId)
    local rawPlayerData = QBCore.Functions.GetPlayerData(playerId)

    return {
        identifier = rawPlayerData.citizenid,
        job = {
            name = rawPlayerData.job.name,
            grade = rawPlayerData.job.grade
        },
        money = rawPlayerData.money["cash"],
        bank = rawPlayerData.money["bank"],
        metadata = rawPlayerData.metadata
    }
end

function B1.GetPlayberByIdentifier(identifier)
    local player = QBCore.Functions.GetPlayerByCitizenId(identifier)
    if not player then
        player = QBCore.Functions.GetOfflinePlayerByCitizenId(identifier)
    return player
    end
end
