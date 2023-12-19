
local logLevels = {
    ["ERROR"] = { value = 1, color = "\27[31m" },
    ["WARN"] = { value = 2, color = "\27[33m" },
    ["INFO"] = { value = 3, color = "\27[32m" },
    ["VERBOSE"] = { value = 4, color = "\27[34m" },
    ["DEBUG"] = { value = 5, color = "\27[35m" }
}

local currentLogLevel = Config.logLevel or 3

local reverseLogLevels = {}
for name, data in pairs(logLevels) do
    reverseLogLevels[data.value] = name
end

local function serializeTable(t)
    local function aux(tbl)
        local result = {}
        for k, v in pairs(tbl) do
            if type(v) == "table" then
                v = aux(v)
                table.insert(result, k .. " = {" .. v .. "}")
            else
                table.insert(result, k .. " = " .. tostring(v))
            end
        end
        return table.concat(result, ", ")
    end
    return "{" .. aux(t) .. "}"
end

function logprint(level, msg)
    if type(level) == "number" then
        level = reverseLogLevels[level]
        if not level then return end
    elseif type(level) == "string" and not logLevels[level:upper()] then
        msg = level
        level = "INFO"
    end

    if logLevels[level].value <= currentLogLevel then
        local color = logLevels[level].color
        if type(msg) == "table" then
            msg = serializeTable(msg)
        elseif type(msg) ~= "string" then
            msg = tostring(msg)
        end
        local output = color .. "[" .. level .. "] " .. msg
        
        print(output)
    end
end

RegisterNetEvent('logprint', function(level, msg)
    logprint(level, msg)
end)

--[[ Usage examples
B1.print(3, "This is an info message using an integer level.")
B1.print("DEBUG", {a=1, b="test", c={x=5, y=6}})
B1.print("This is a message without a level.")
]]