function B1.print(lvl, msg)
    TriggerEvent('logprint', lvl, msg)
end

function B1.RandomStr(Length)
    local str = ""
    for i = 1, Length do
        str = str .. string.char(math.random(97, 122))
    end
    return str
end

function B1.SplitStr(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    table.insert(result, string.sub(str, from))
    return result
end

function B1.Trim(value)
    if not value then return nil end
    return string.gsub(value, "^%s*(.-)%s*$", "%1")
end
