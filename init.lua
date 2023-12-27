local B1lib = 'B1-lib'
local export = exports[B1lib]

if not GetResourceState(B1lib):find('start') then
	error('^1B1-lib should be started before this resource.^0', 2)
end



-----------------------------------------------
--------------- Module handling ---------------
-----------------------------------------------
local LoadResourceFile = LoadResourceFile
local context = IsDuplicityVersion() and 'server' or 'client'

function noop() end

local function loadModule(self, module)
	local dir = ('modules/%s'):format(module)
	local chunk = LoadResourceFile(B1lib, ('%s/%s.lua'):format(dir, context))
	local shared = LoadResourceFile(B1lib, ('%s/shared.lua'):format(dir))

	if shared then
		chunk = (chunk and ('%s\n%s'):format(shared, chunk)) or shared
	end

	if chunk then
		local fn, err = load(chunk, ('@@' .. B1lib .. '/%s/%s.lua'):format(module, context))

		if not fn or err then
			return error(('\n^1Error importing module (%s): %s^0'):format(dir, err), 3)
        end

        local result = fn()
        self[module] = result or noop
        return self[module]
	end
end

local function call(self, index, ...)
	local module = rawget(self, index)

	if not module then
        self[index] = noop
		module = loadModule(self, index)

		if not module then
			local function method(...)
				return export[index](nil, ...)
			end

			if not ... then
				self[index] = method
			end

			return method
		end
	end

	return module
end

B1 = setmetatable({
	name = B1lib,
	context = context
}, {
	__index = call,
	__call = call,
})

requireMod = B1.requireMod



-----------------------------------------------
------------- Locales from QBCore -------------
-----------------------------------------------
Locale = {}
Locale.__index = Locale

local function translateKey(phrase, subs)
    if type(phrase) ~= 'string' then
        error('TypeError: translateKey function expects arg #1 to be a string')
    end

    if not subs then
        return phrase
    end

    local result = phrase

    for k, v in pairs(subs) do
        local templateToFind = '%%{' .. k .. '}'
        result = result:gsub(templateToFind, tostring(v)) -- string to allow all types
    end

    return result
end

function Locale.new(_, opts)
    local self = setmetatable({}, Locale)

    self.fallback = opts.fallbackLang and Locale:new({
        warnOnMissing = false,
        phrases = opts.fallbackLang.phrases,
    }) or false

    self.warnOnMissing = type(opts.warnOnMissing) ~= 'boolean' and true or opts.warnOnMissing

    self.phrases = {}
    self:extend(opts.phrases or {})

    return self
end

function Locale:extend(phrases, prefix)
    for key, phrase in pairs(phrases) do
        local prefixKey = prefix and ('%s.%s'):format(prefix, key) or key
        -- If this is a nested table, we need to go reeeeeeeeeeeecursive
        if type(phrase) == 'table' then
            self:extend(phrase, prefixKey)
        else
            self.phrases[prefixKey] = phrase
        end
    end
end

function Locale:clear()
    self.phrases = {}
end

function Locale:replace(phrases)
    phrases = phrases or {}
    self:clear()
    self:extend(phrases)
end

function Locale:locale(newLocale)
    if (newLocale) then
        self.currentLocale = newLocale
    end
    return self.currentLocale
end

function Locale:t(key, subs)
    local phrase, result
    subs = subs or {}

    if type(self.phrases[key]) == 'string' then
        phrase = self.phrases[key]
    else
        if self.warnOnMissing then
            print(('^3Warning: Missing phrase for key: "%s"'):format(key))
        end
        if self.fallback then
            return self.fallback:t(key, subs)
        end
        result = key
    end

    if type(phrase) == 'string' then
        result = translateKey(phrase, subs)
    end

    return result
end

function Locale:has(key)
    return self.phrases[key] ~= nil
end

function Locale:delete(phraseTarget, prefix)
    if type(phraseTarget) == 'string' then
        self.phrases[phraseTarget] = nil
    else
        for key, phrase in pairs(phraseTarget) do
            local prefixKey = prefix and prefix .. '.' .. key or key

            if type(phrase) == 'table' then
                self:delete(phrase, prefixKey)
            else
                self.phrases[prefixKey] = nil
            end
        end
    end
end