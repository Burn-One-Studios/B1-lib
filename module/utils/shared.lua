-- B1-lib Utils Module
-- Common utility functions

-- Generate random string
function B1.randomStr(length)
    length = length or 10
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    local result = ''
    for i = 1, length do
        local rand = math.random(#chars)
        result = result .. chars:sub(rand, rand)
    end
    return result
end

-- Generate random integer
function B1.randomInt(length)
    length = length or 6
    local result = ''
    for i = 1, length do
        result = result .. tostring(math.random(0, 9))
    end
    return tonumber(result)
end

-- Split string by delimiter
function B1.splitStr(str, delimiter)
    delimiter = delimiter or ','
    local result = {}
    local pattern = ('([^%s]+)'):format(delimiter)
    for match in str:gmatch(pattern) do
        table.insert(result, match)
    end
    return result
end

-- Sanitize string (keep only specified characters)
function B1.sanitizeString(s, charset)
    charset = charset or 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 '
    local result = ''
    for i = 1, #s do
        local char = s:sub(i, i)
        if charset:find(char, 1, true) then
            result = result .. char
        end
    end
    return result
end

-- Remove characters from string
function B1.removeChars(s, charset)
    charset = charset or '!@#$%^&*()_+-=[]{}|;:,.<>?'
    local result = s
    for i = 1, #charset do
        local char = charset:sub(i, i)
        result = result:gsub(char, '')
    end
    return result
end

-- Trim whitespace
function B1.trim(s)
    return s:match('^%s*(.-)%s*$')
end

-- First letter uppercase
function B1.firstToUpper(s)
    return s:gsub('^%l', string.upper)
end

-- Round number to specified decimals
function B1.round(num, decimals)
    decimals = decimals or 0
    local mult = 10 ^ decimals
    return math.floor(num * mult + 0.5) / mult
end

-- Re-export core functions for convenience
B1.getCoreName = B1.getCoreName or function()
    return B1._core and B1._core.name
end

B1.getInventoryName = B1.getInventoryName or function()
    return B1._core and B1._core.inventory
end

B1.getCoreObject = B1.getCoreObject or function()
    return B1._core and B1._core.object
end

-- Export functions
exports('randomStr', B1.randomStr)
exports('randomInt', B1.randomInt)
exports('splitStr', B1.splitStr)
exports('sanitizeString', B1.sanitizeString)
exports('removeChars', B1.removeChars)
exports('trim', B1.trim)
exports('firstToUpper', B1.firstToUpper)
exports('round', B1.round)
exports('getCoreName', B1.getCoreName)
exports('getInventoryName', B1.getInventoryName)
exports('getCoreObject', B1.getCoreObject)
