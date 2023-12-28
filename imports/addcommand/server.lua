local function table_clone(t)
    local t2 = {}
    for k,v in pairs(t) do
      t2[k] = v
    end
    return t2
  end

---@class CommandProperties
---@field public name string
---@field public help string
---@field public params table
---@field public restricted boolean

---@param commandName string | string[]
---@param properties CommandProperties | false
---@param cb fun(source: number, args: table, raw: string)
---@param ... any
function B1.addCommand(commandName, properties, cb, ...)
    local restricted, params

    if properties then
        restricted = properties.restricted
        params = properties.params
    end

    if params then
        for i = 1, #params do
            local param = params[i]

            if param.type then
                param.help = param.help and ('%s (type: %s)'):format(param.help, param.type) or ('(type: %s)'):format(param.type)
            end
        end
    end

    local commands = type(commandName) ~= 'table' and { commandName } or commandName
    local numCommands = #commands
    local totalCommands = #registeredCommands

    local function commandHandler(source, args, raw)
        args = parseArguments(source, args, raw, params)

        if not args then return end

        cb(source, args, raw)
    end

    for i = 1, numCommands do
        totalCommands += 1
        commandName = commands[i]

        RegisterCommand(commandName, commandHandler, restricted and true)

        if restricted then
            local ace = ('command.%s'):format(commandName)
            local restrictedType = type(restricted)

            if restrictedType == 'string' then
                ExecuteCommand(('add_ace group.%s %s allow'):format(restricted, ace))
            elseif restrictedType == 'table' then
                for j = 1, #restricted do
                    ExecuteCommand(('add_ace group.%s %s allow'):format(restricted[j], ace))
                end
            end
        end

        if properties then
            properties.name = ('/%s'):format(commandName)
            properties.restricted = nil
            registeredCommands[totalCommands] = properties

            if i ~= numCommands and numCommands ~= 1 then
                properties = table_clone(properties)
            end

            if shouldSendCommands then TriggerClientEvent('chat:addSuggestions', -1, properties) end
        end
    end
end
