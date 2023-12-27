local StringCharset = {}
local NumberCharset = {}

for i = 48, 57 do NumberCharset[#NumberCharset + 1] = string.char(i) end
for i = 65, 90 do StringCharset[#StringCharset + 1] = string.char(i) end
for i = 97, 122 do StringCharset[#StringCharset + 1] = string.char(i) end

---@param type string success | warning | error | inform
---@param message string The message to log
function B1.log(type, message)
    local callingResource = GetInvokingResource()
    local printTypes = {
        ['success'] = {
            color = '^2',
            label = ('%s:SUCCESS'):format(callingResource),
            printer = function(content) print(content) end,
        },
        ['warning'] = {
            color = '^3',
            label = ('%s:WARN'):format(callingResource),
            printer = function(content) print(content) end,
        },
        ['error'] = {
            color = '^1',
            label = ('%s:ERROR'):format(callingResource),
            printer = function(content) error(content) end,
        },
        ['inform'] = {
            color = '^5',
            label = ('%s:INFORM'):format(callingResource),
            printer = function(content) print(content) end,
        },
    }
    local finalMessage = '[' .. printTypes[type].label .. ']' .. printTypes[type].color .. message .. ' ^0'
    printTypes[type].printer(finalMessage)
end

---@param length number The length of the string to generate
function B1.randomStr(length)
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    if length <= 0 then return '' end
    local str = ""
    for i = 1, length do
        local rand = math.random(#charset)
        str = str .. string.sub(charset, rand, rand)
    end
    return str
end

---@param length number The length of the number to generate
function B1.randomInt(length)
    if length <= 0 then return '' end
    local min = 10^(length-1)
    local max = 10^length - 1
    return math.random(min, max)
end

---@param str string The string to split
---@param delimiter string The delimiter to split the string by
function B1.splitStr(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        result[#result + 1] = string.sub(str, from, delim_from - 1)
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    result[#result + 1] = string.sub(str, from)
    return result
end

---@param value string The string to trim
function B1.trim(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

---@param value string The string to capitalize
function B1.firstToUpper(value)
    if not value then return nil end
    return (value:gsub("^%l", string.upper))
end

---@param value number The number to round
---@param numDecimalPlaces number The number of decimal places to round to
function B1.round(value, numDecimalPlaces)
    if not numDecimalPlaces then return math.floor(value + 0.5) end
    local power = 10 ^ numDecimalPlaces
    return math.floor((value * power) + 0.5) / (power)
end

---@return string 'esx' | 'qbcore'
function B1.getCoreName()
    return B1.core
end

---@return string 'qb' | 'ox' | 'esx'
function B1.getInventoryName()
    return B1.inventory
end

---@return table -- The CoreObject
function B1.getCoreObject()
    return CoreObject
end