-- B1-lib Configuration
-- Core framework detection
Config = {}
Config.Core = 'qb-core' -- 'auto'|'qb-core'|'esx'

-- Notification system
Config.Notification = 'zsx' --auto'|'ox'|'zsx'|'esx'|'qb'|'native'

-- Progress bar system
Config.ProgressBar = 'zsx' -- 'auto'|'ox'|'zsx'|'esx'|'qb'|'native'

-- Skill check system
Config.SkillCheck = 'ox' -- 'auto'|'ox' | 'esx'|'qb'|'native'

-- Logging
Config.LogTag = '^3[b1-lib]^7'
Config.LogLevel = 'info' -- 'debug'|'info'|'warning'|'error'

-- Vehicle defaults
Config.VehicleDefaultSpawn = vector4(-42.4, -1098.3, 26.4, 70.0)

-- Notification settings
Config.NotificationDuration = 5000 -- Default notification duration in ms
Config.NotificationPosition = 'top-right' -- 'top-left'|'top-right'|'bottom-left'|'bottom-right'|'center'

-- Progress bar settings
Config.ProgressBarDuration = 10000 -- Default progress bar duration in ms
Config.ProgressBarPosition = 'bottom' -- 'top'|'bottom'|'center'

-- Skill check settings
Config.SkillCheckDuration = 5000 -- Default skill check duration in ms
Config.SkillCheckDifficulty = 'easy' -- 'easy'|'medium'|'hard'
