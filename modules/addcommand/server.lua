function B1.addCommand(name, options, cb)
    local help = options.help or ''
    local params = options.params or {}
    local restricted = options.restricted or 'user'

    if B1.core == 'qb-core' then
        -- QBCore command registration
        local permission = restricted
        local argsrequired = #params > 0

        RegisterCommand(name, function(source, args, rawCommand)
            if argsrequired and #args < #params then
                return TriggerClientEvent('chat:addMessage', source, {
                    color = { 255, 0, 0 },
                    multiline = true,
                    args = { 'System', 'Missing arguments' }
                })
            end
            cb(source, args, rawCommand)
        end, restricted ~= 'user')

        QBCore.Commands.List[name:lower()] = {
            name = name:lower(),
            permission = permission,
            help = help,
            arguments = params,
            argsrequired = argsrequired,
            callback = cb
        }
    elseif B1.core == 'esx' then
        -- ESX command registration
        local group = restricted
        local suggestion = {
            help = help,
            arguments = params
        }
        ESX.RegisterCommand(name, group, cb, true, suggestion)
    end
end