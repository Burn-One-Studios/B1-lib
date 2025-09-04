-- B1-lib UI Module
-- Client-side UI functions for notifications, progress bars, and skill checks
-- Note: UI functions are client-side only as they require player interaction

-- Notification type mapping for different systems
local notifyTypeMap = {
    ["info"] = { esx = "info", qb = "primary", oxlib = "inform", zsx = "info" },
    ["success"] = { esx = "success", qb = "success", oxlib = "success", zsx = "success" },
    ["error"] = { esx = "error", qb = "error", oxlib = "error", zsx = "error" },
    ["warning"] = { esx = "info", qb = "primary", oxlib = "warning", zsx = "warning" },
    [1] = { esx = "info", qb = "primary", oxlib = "inform", zsx = "info" },
    [2] = { esx = "success", qb = "success", oxlib = "success", zsx = "success" },
    [3] = { esx = "error", qb = "error", oxlib = "error", zsx = "error" },
    [4] = { esx = "info", qb = "primary", oxlib = "warning", zsx = "warning" }
}

-- Notification function (Client-side only)
function B1.notify(message, type, duration, position)
    -- Check if we're on client-side
    if IsDuplicityVersion() then
        B1.log('warning', 'B1.notify is client-side only. Use B1.notifyServer() or TriggerClientEvent to send notifications to players.')
        return
    end
    
    type = type or 'info'
    duration = duration or Config.NotificationDuration
    
    local notifyType = notifyTypeMap[type]
    local notificationSystem = B1.getNotificationSystem()
    
    if notificationSystem == 'ox' and GetResourceState('ox_lib') == 'started' then
        if lib then
            lib.notify({
                description = message,
                type = notifyTypeMap.oxlib, -- Use original type, not mapped
                duration = duration,
                position = position or Config.NotificationPosition
            })
        else
            B1.log('warning', 'ox_lib is not running but ox_lib notifications are configured. Falling back to core detected notify.')
            if B1.getCoreName() == 'qb-core' then
                TriggerEvent('QBCore:Notify', message, notifyType.qb, duration)
            elseif B1.getCoreName() == 'esx' then
                TriggerEvent('esx:showNotification', message, notifyType.esx, duration)
            end
        end
    elseif notificationSystem == 'zsx' and GetResourceState('ZSX_UIV2') == 'started' then
        local success, result = pcall(function()
            return exports['ZSX_UIV2']:Notification('b1-lib', message, notifyType.zsx, duration)
        end)
        if not success then
            -- Try alternative export name
            local altSuccess, altResult = pcall(function()
                return exports['ZSX_UIV2']:notification('b1-lib', message, notifyType.zsx, duration)
            end)
            if not altSuccess then
                B1.log('warning', 'ZSX_UIV2 Notification exports failed, falling back to core notifications')
                if B1.getCoreName() == 'qb-core' then
                    TriggerEvent('QBCore:Notify', message, notifyType.qb, duration)
                elseif B1.getCoreName() == 'esx' then
                    TriggerEvent('esx:showNotification', message, notifyType.esx, duration)
                end
            end
        end
    elseif B1.getCoreName() == 'qb-core' then
        TriggerEvent('QBCore:Notify', message, notifyType.qb, duration)
    elseif B1.getCoreName() == 'esx' then
        TriggerEvent('esx:showNotification', message, notifyType.esx, duration)
    else
        -- Fallback to native notification
        SetNotificationTextEntry('STRING')
        AddTextComponentString(message)
        DrawNotification(false, false)
    end
end

-- Progress bar function (Client-side only)
function B1.progressBar(label, duration, options)
    -- Check if we're on client-side
    if IsDuplicityVersion() then
        B1.log('warning', 'B1.progressBar is client-side only. Use TriggerClientEvent to send progress bars to players.')
        return false
    end
    
    duration = duration or Config.ProgressBarDuration
    options = options or {}
    
    local progressBarSystem = B1.getProgressBarSystem()
    
    if progressBarSystem == 'ox' and GetResourceState('ox_lib') == 'started' then
        return exports.ox_lib:progressBar({
            label = label,
            duration = duration,
            position = options.position or Config.ProgressBarPosition,
            useWhileDead = options.useWhileDead or false,
            canCancel = options.canCancel or true,
            disable = options.disable or {
                car = options.disableCar or false,
                move = options.disableMove or false,
                combat = options.disableCombat or false,
                mouse = options.disableMouse or false
            },
            anim = options.anim or {
                dict = options.animDict,
                clip = options.animClip
            },
            prop = options.prop or {
                model = options.propModel,
                bone = options.propBone,
                pos = options.propPos,
                rot = options.propRot
            }
        })
    elseif progressBarSystem == 'zsx' then
        -- Client-side: use ZSX_UIV2
        if GetResourceState('ZSX_UIV2') == 'started' then
            local success, result = pcall(function()
                return exports['ZSX_UIV2']:ProgressBar(
                    options.icon or 'info', -- icon
                    label, -- text
                    duration, -- duration
                    options.onFinish, -- onComplete
                    options.onCancel, -- onCancel
                    options.canCancel or true, -- canCancel
                    {
                        disable_mouse = options.disableMouse or false,
                        disable_walk = options.disableMove or false,
                        disable_driving = options.disableCar or false,
                        disable_combat = options.disableCombat or false
                    }, -- disableControls
                    options.anim and {
                        dict = options.anim.dict or options.animDict,
                        clip = options.anim.clip or options.animClip,
                        blendIn = options.anim.blendIn or 8.0,
                        blendOut = options.anim.blendOut or 8.0,
                        duration = options.anim.duration or duration,
                        flag = options.anim.flag or 0,
                        playbackRate = options.anim.playbackRate or 1.0,
                        lockX = options.anim.lockX or false,
                        lockY = options.anim.lockY or false,
                        lockZ = options.anim.lockZ or false
                    } or nil, -- anim
                    options.prop and {
                        model = options.prop.model or options.propModel,
                        bone = options.prop.bone or options.propBone,
                        pos = options.prop.pos or options.propPos,
                        rot = options.prop.rot or options.propRot
                    } or nil, -- prop1
                    nil -- prop2
                )
            end)
            if success then
                return result
            else
                -- Try alternative export name
                local altSuccess, altResult = pcall(function()
                    return exports['ZSX_UIV2']:progressBar(
                        options.icon or 'info', label, duration, options.onFinish, options.onCancel, options.canCancel or true,
                        {disable_mouse = options.disableMouse or false, disable_walk = options.disableMove or false, disable_driving = options.disableCar or false, disable_combat = options.disableCombat or false},
                        options.anim, options.prop, nil
                    )
                end)
                if altSuccess then
                    return altResult
                else
                    -- Fallback to ox_lib
                    B1.log('warning', 'ZSX_UIV2 ProgressBar exports failed, falling back to ox_lib')
                    if GetResourceState('ox_lib') == 'started' then
                        return exports.ox_lib:progressBar({
                            label = label,
                            duration = duration,
                            position = options.position or Config.ProgressBarPosition,
                            useWhileDead = options.useWhileDead or false,
                            canCancel = options.canCancel or true,
                            disable = options.disable or {
                                car = options.disableCar or false,
                                move = options.disableMove or false,
                                combat = options.disableCombat or false,
                                mouse = options.disableMouse or false
                            },
                            anim = options.anim or {
                                dict = options.animDict,
                                clip = options.animClip
                            },
                            prop = options.prop or {
                                model = options.propModel,
                                bone = options.propBone,
                                pos = options.propPos,
                                rot = options.propRot
                            }
                        })
                    else
                        return false
                    end
                end
            end
        else
            -- ZSX_UIV2 not available, fallback to ox_lib
            if GetResourceState('ox_lib') == 'started' then
                return exports.ox_lib:progressBar({
                    label = label,
                    duration = duration,
                    position = options.position or Config.ProgressBarPosition,
                    useWhileDead = options.useWhileDead or false,
                    canCancel = options.canCancel or true,
                    disable = options.disable or {
                        car = options.disableCar or false,
                        move = options.disableMove or false,
                        combat = options.disableCombat or false,
                        mouse = options.disableMouse or false
                    },
                    anim = options.anim or {
                        dict = options.animDict,
                        clip = options.animClip
                    },
                    prop = options.prop or {
                        model = options.propModel,
                        bone = options.propBone,
                        pos = options.propPos,
                        rot = options.propRot
                    }
                })
            else
                return false
            end
        end
    elseif progressBarSystem == 'qb' and GetResourceState('qb-core') == 'started' then
        local coreObject = B1.getCoreObject()
        if coreObject then
            return coreObject.Functions.Progressbar(label, label, duration, false, true, {
                disableMovement = options.disableMove or false,
                disableCarMovement = options.disableCar or false,
                disableMouse = options.disableMouse or false,
                disableCombat = options.disableCombat or false,
            }, {}, {}, {}, function() -- Done
                if options.onFinish then
                    options.onFinish()
                end
            end, function() -- Cancel
                if options.onCancel then
                    options.onCancel()
                end
            end)
        end
    elseif progressBarSystem == 'esx' and GetResourceState('esx') == 'started' then
        local coreObject = B1.getCoreObject()
        if coreObject then
            return coreObject.Progressbar(label, duration, {
                FreezePlayer = true,
                animation = options.anim or {
                    dict = options.animDict,
                    name = options.animClip
                },
                onFinish = options.onFinish,
                onCancel = options.onCancel
            })
        end
    else
        -- Fallback to native progress bar
        B1.log('warning', 'No progress bar system available')
        return false
    end
end

-- Skill check function (Client-side only)
function B1.skillCheck(difficulty, options)
    -- Check if we're on client-side
    if IsDuplicityVersion() then
        B1.log('warning', 'B1.skillCheck is client-side only. Use TriggerClientEvent to send skill checks to players.')
        return false
    end
    
    difficulty = difficulty or Config.SkillCheckDifficulty
    options = options or {}
    
    local skillCheckSystem = B1.getSkillCheckSystem()
    
    if skillCheckSystem == 'ox' and GetResourceState('ox_lib') == 'started' then
        return exports.ox_lib:skillCheck({
            difficulty = difficulty,
            duration = options.duration or Config.SkillCheckDuration,
            position = options.position or 'center',
            disable = options.disable or {
                car = options.disableCar or false,
                move = options.disableMove or false,
                combat = options.disableCombat or false,
                mouse = options.disableMouse or false
            }
        })
    elseif skillCheckSystem == 'zsx' or skillCheckSystem == 'qb' or skillCheckSystem == 'esx' then
        -- These systems don't support skill checks, fall back to ox_lib or native
        B1.log('warning', ('%s does not support skill checks, falling back to ox_lib'):format(skillCheckSystem))
        if GetResourceState('ox_lib') == 'started' then
            return exports.ox_lib:skillCheck({
                difficulty = difficulty,
                duration = options.duration or Config.SkillCheckDuration,
                position = options.position or 'center',
                disable = options.disable or {
                    car = options.disableCar or false,
                    move = options.disableMove or false,
                    combat = options.disableCombat or false,
                    mouse = options.disableMouse or false
                }
            })
        else
            B1.log('warning', 'No skill check system available')
            return false
        end
    else
        -- Fallback to native skill check
        B1.log('warning', 'No skill check system available')
        return false
    end
end

-- Remove notification function (Client-side only, for ZSX_UI)
function B1.removeNotification(serial)
    -- Check if we're on client-side
    if IsDuplicityVersion() then
        B1.log('warning', 'B1.removeNotification is client-side only. Use TriggerClientEvent to remove notifications on players.')
        return
    end
    
    -- ZSX_UIV2 is client-side only
    if GetResourceState('ZSX_UIV2') == 'started' then
        local success, result = pcall(function()
            return exports['ZSX_UIV2']:Notification_Remove(serial)
        end)
        if not success then
            -- Try alternative export name
            local altSuccess, altResult = pcall(function()
                return exports['ZSX_UIV2']:notification_remove(serial)
            end)
            if not altSuccess then
                B1.log('warning', 'ZSX_UIV2 notification removal exports failed')
            end
        end
    else
        B1.log('warning', 'Notification removal only supported with ZSX_UI on client-side')
    end
end

-- Server-side notification function
function B1.notifyServer(source, message, type, duration)
    -- Check if we're on server-side
    if not IsDuplicityVersion() then
        B1.log('warning', 'B1.notifyServer is server-side only. Use B1.notify() for client-side notifications.')
        return
    end
    
    type = type or 'info'
    duration = duration or Config.NotificationDuration
    
    local notifyType = notifyTypeMap[type]
    local notificationSystem = B1.getNotificationSystem()
    
    if notificationSystem == 'ox' and GetResourceState('ox_lib') == 'started' then
        TriggerClientEvent('B1-lib:OxlibNotify', source, message, type, duration)
    elseif notificationSystem == 'zsx' and GetResourceState('ZSX_UIV2') == 'started' then
        TriggerClientEvent('B1-lib:ZSXNotify', source, message, notifyType.zsx, duration)
    elseif B1.getCoreName() == 'qb-core' then
        TriggerClientEvent('QBCore:Notify', source, message, notifyType.qb, duration)
    elseif B1.getCoreName() == 'esx' then
        TriggerClientEvent('esx:showNotification', source, message, notifyType.esx, duration)
    else
        -- Fallback to native notification
        TriggerClientEvent('B1-lib:NativeNotify', source, message)
    end
end

-- Client-side event handlers for server notifications
if not IsDuplicityVersion() then
    -- Handle ox_lib notifications from server
    RegisterNetEvent('B1-lib:OxlibNotify', function(message, type, duration)
        if lib then
            lib.notify({
                description = message,
                type = type, -- Server already sends correct type
                duration = duration
            })
        else
            B1.log('warning', 'ox_lib not available, falling back to core notifications')
            B1.notify(message, 'info', duration)
        end
    end)
    
    -- Handle ZSX_UIV2 notifications from server
    RegisterNetEvent('B1-lib:ZSXNotify', function(message, type, duration)
        if GetResourceState('ZSX_UIV2') == 'started' then
            local success, result = pcall(function()
                return exports['ZSX_UIV2']:Notification('b1-lib', message, type, duration)
            end)
            if not success then
                B1.log('warning', 'ZSX_UIV2 not available, falling back to core notifications')
                B1.notify(message, 'info', duration)
            end
        else
            B1.log('warning', 'ZSX_UIV2 not available, falling back to core notifications')
            B1.notify(message, 'info', duration)
        end
    end)
    
    -- Handle native notifications from server
    RegisterNetEvent('B1-lib:NativeNotify', function(message)
        SetNotificationTextEntry('STRING')
        AddTextComponentString(message)
        DrawNotification(false, false)
    end)
end

-- Export functions
exports('notify', B1.notify)
exports('notifyServer', B1.notifyServer)
exports('progressBar', B1.progressBar)
exports('skillCheck', B1.skillCheck)
exports('removeNotification', B1.removeNotification)
