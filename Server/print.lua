local logLevels = {
    ["ERROR"] = { value = 1, color = "\27[31m" },
    ["WARN"] = { value = 2, color = "\27[33m" },
    ["INFO"] = { value = 3, color = "\27[32m" },
    ["VERBOSE"] = { value = 4, color = "\27[34m" },
    ["DEBUG"] = { value = 5, color = "\27[35m" }
}

local currentLogLevel = 3

local function serializeTable(t)
    local result = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            table.insert(result, k .. " = " .. serializeTable(v))
        else
            table.insert(result, k .. " = " .. tostring(v))
        end
    end
    return "{" .. table.concat(result, ", ") .. "}"
end

function logprint(level, msg)
    if type(level) == "string" then
        level = level:upper()
    else
        level = "INFO"
    end

    if logLevels[level] and logLevels[level].value <= currentLogLevel then
        if type(msg) == "table" then
            msg = serializeTable(msg)
        end
        print(logLevels[level].color .. "[" .. level .. "] " .. tostring(msg))
    end
end

--[[ Usage examples
B1.print(3, "This is an info message using an integer level.")
B1.print("DEBUG", {a=1, b="test", c={x=5, y=6}})
B1.print("This is a message without a level.")
]]