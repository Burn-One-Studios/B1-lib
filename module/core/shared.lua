-- B1-lib Core Bootstrap
-- Handles framework detection and global B1 table initialization

-- Initialize global B1 table
B1 = B1 or {}

-- Core detection
local function detectCore()
    if Config.Core == 'auto' then
        if GetResourceState('qb-core') == 'started' then
            return 'qb-core'
        elseif GetResourceState('esx') == 'started' then
            return 'esx'
        else
            return nil
        end
    else
        return Config.Core
    end
end

-- Notification system detection
local function detectNotification()
    if Config.Notification == 'auto' then
        if GetResourceState('ox_lib') == 'started' then
            return 'ox'
        elseif GetResourceState('ZSX_UIV2') == 'started' then
            return 'zsx'
        elseif GetResourceState('qb-core') == 'started' then
            return 'qb'
        elseif GetResourceState('esx') == 'started' then
            return 'esx'
        else
            return 'native'
        end
    else
        return Config.Notification
    end
end

-- Progress bar system detection
local function detectProgressBar()
    if Config.ProgressBar == 'auto' then
        if GetResourceState('ox_lib') == 'started' then
            return 'ox'
        elseif GetResourceState('ZSX_UIV2') == 'started' then
            return 'zsx'
        elseif GetResourceState('qb-core') == 'started' then
            return 'qb'
        elseif GetResourceState('esx') == 'started' then
            return 'esx'
        else
            return 'native'
        end
    else
        return Config.ProgressBar
    end
end

-- Skill check system detection
local function detectSkillCheck()
    if Config.SkillCheck == 'auto' then
        if GetResourceState('ox_lib') == 'started' then
            return 'ox'
        elseif GetResourceState('ZSX_UIV2') == 'started' then
            return 'zsx'
        elseif GetResourceState('qb-core') == 'started' then
            return 'qb'
        elseif GetResourceState('esx') == 'started' then
            return 'esx'
        else
            return 'native'
        end
    else
        return Config.SkillCheck
    end
end

-- Get core object
local function getCoreObject()
    local coreName = detectCore()
    if not coreName then
        return nil
    end
    
    if coreName == 'qb-core' then
        return exports['qb-core']:GetCoreObject()
    elseif coreName == 'esx' then
        return exports['esx']:getSharedObject()
    end
    
    return nil
end

-- Get inventory name
local function getInventoryName()
    if GetResourceState('ox_inventory') == 'started' then
        return 'ox'
    elseif GetResourceState('qb-inventory') == 'started' then
        return 'qb'
    elseif GetResourceState('esx') == 'started' then
        return 'esx'
    else
        return 'unknown'
    end
end

-- Initialize core data
local coreName = detectCore()
local coreObject = getCoreObject()
local inventoryName = getInventoryName()
local notificationSystem = detectNotification()
local progressBarSystem = detectProgressBar()
local skillCheckSystem = detectSkillCheck()

-- Expose core functions
B1.getCoreName = function()
    return coreName
end

B1.getCoreObject = function()
    return coreObject
end

B1.getInventoryName = function()
    return inventoryName
end

B1.getNotificationSystem = function()
    return notificationSystem
end

B1.getProgressBarSystem = function()
    return progressBarSystem
end

B1.getSkillCheckSystem = function()
    return skillCheckSystem
end

-- Store core data for other modules
B1._core = {
    name = coreName,
    object = coreObject,
    inventory = inventoryName,
    notification = notificationSystem,
    progressBar = progressBarSystem,
    skillCheck = skillCheckSystem
}

-- Export B1 object
function getB1Object()
    return B1
end

-- Export function
exports('getB1Object', getB1Object)

-- Log initialization
if coreName then
    print(('^2[b1-lib]^7 Initialized with %s framework'):format(coreName))
else
    print('^1[b1-lib]^7 Warning: No supported framework detected')
end
