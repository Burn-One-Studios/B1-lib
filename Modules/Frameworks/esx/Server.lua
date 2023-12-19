ESX = exports["es_extended"]:getSharedObject()

if GetResourceState('es_extended') == 'started' then
    LoadResourceFile(GetCurrentResourceName(), "Modules/Frameworks/esx/Server.lua")
end

function B1.RegisterServerCallback(name, cb)
    ESX.RegisterServerCallback(name, cb)
end

function B1.GetPlayerDataByIdentifier(playerId)
    local rawPlayerData = ESX.GetPlayerFromIdentifier(playerId)

    if rawPlayerData then
        -- Player is online, return their data
        return {
            identifier = rawPlayerData.identifier,
            job = {
                name = rawPlayerData.job.name,
                grade = rawPlayerData.job.grade
            },
            money = rawPlayerData.accounts,
            bank = rawPlayerData.bank,
            metadata = rawPlayerData.metadata
        }
    else
        -- Player is offline, fetch their data from the database
        local result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
            ['@identifier'] = playerId
        })

        if result and result[1] then
            -- Convert the result to the desired format
            return {
                identifier = result[1].identifier,
                job = {
                    name = result[1].job,
                    grade = result[1].job_grade
                },
                money = json.decode(result[1].accounts),
                bank = result[1].bank,
                metadata = json.decode(result[1].metadata)
            }
        else
            -- No data found for the given identifier
            return nil
        end
    end
end
