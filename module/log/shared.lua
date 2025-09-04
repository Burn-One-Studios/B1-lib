-- B1-lib Logger Module
-- Provides colored, boxed logging with traceback support

local logLevels = {
    debug = 1,
    info = 2,
    warning = 3,
    error = 4
}

local logColors = {
    debug = '^5',
    info = '^2',
    warning = '^3',
    error = '^1'
}

local currentLevel = logLevels[Config.LogLevel] or 2

-- Get calling resource name
local function getCallingResource()
    local resource = GetInvokingResource()
    if resource and resource ~= GetCurrentResourceName() then
        return ('[%s]'):format(resource)
    end
    return '[b1-lib]'
end

-- Format message with context
local function formatMessage(level, message, opts)
    local callingResource = getCallingResource()
    local timestamp = GetGameTimer() -- Use GetGameTimer instead of os.date for client compatibility
    local color = logColors[level] or '^7'
    local levelUpper = level:upper()
    
    local formattedMessage = message
    if type(message) == 'table' then
        formattedMessage = json.encode(message, {indent = true})
    end
    
    local context = ''
    if opts and opts.ctx then
        context = (' | %s'):format(json.encode(opts.ctx))
    end
    
    return ('%s%s[%s] %s%s %s%s^7'):format(
        Config.LogTag,
        color,
        levelUpper,
        callingResource,
        color,
        formattedMessage,
        context
    )
end

-- Main log function
function B1.log(level, message, opts)
    -- Handle numeric levels
    if type(level) == 'number' then
        for name, num in pairs(logLevels) do
            if num == level then
                level = name
                break
            end
        end
    end
    
    -- Check log level
    local messageLevel = logLevels[level] or 2
    if messageLevel < currentLevel then
        return
    end
    
    -- Format and print message
    local formatted = formatMessage(level, message, opts)
    print(formatted)
    
    -- Add traceback for errors
    if level == 'error' then
        print(('^1%s^7'):format(debug.traceback()))
    end
end

-- Set log level
function B1.setLogLevel(level)
    if logLevels[level] then
        currentLevel = logLevels[level]
        B1.log('info', ('Log level set to %s'):format(level))
    else
        B1.log('warning', ('Invalid log level: %s'):format(tostring(level)))
    end
end

-- Get current log level
function B1.getLogLevel()
    for level, num in pairs(logLevels) do
        if num == currentLevel then
            return level
        end
    end
    return 'info'
end

-- Export functions
exports('log', B1.log)
exports('set_log_level', B1.setLogLevel)
exports('get_log_level', B1.getLogLevel)
