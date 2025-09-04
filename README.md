# 🚀 B1-lib

> **A small, easy-to-use FiveM library that provides normalized functions for QBCore and ESX frameworks.**

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/your-repo/b1-lib)
[![Framework](https://img.shields.io/badge/framework-QBCore%20%7C%20ESX-green.svg)](https://github.com/your-repo/b1-lib)


[![FiveM](https://img.shields.io/badge/FiveM-Resource-orange.svg)](https://fivem.net/)
[![Lua](https://img.shields.io/badge/Lua-5.4-blue.svg)](https://www.lua.org/)
[![oxmysql](https://img.shields.io/badge/oxmysql-Compatible-green.svg)](https://github.com/overextended/oxmysql)

[![Documentation](https://img.shields.io/badge/Documentation-blue.svg)](https://docs.burnonestudios.com/FiveM-Resources/B1-Lib/Documention/)
---

## ✨ Features

- 🔄 **Framework Agnostic** - Works seamlessly with both QBCore and ESX
- 🗄️ **Lightweight ORM** - 4DaysORM-inspired database management
- 📝 **Advanced Logging** - Colored output with traceback support
- 🎨 **Unified UI System** - Notifications, progress bars, and skill checks
- 🚗 **Vehicle Management** - Spawn, plate detection, and label retrieval
- 👤 **Player Functions** - Normalized player data and money management
- 🎒 **Inventory Integration** - ox_inventory wrapper functions
- ⚡ **Performance Optimized** - Await-style, non-blocking operations
- 🔧 **Easy Configuration** - Simple `Config.[value] =` format

---

## 📦 Installation

1. **Download** the `b1-lib` folder to `resources/[lib]/b1-lib/`
2. **Add** `ensure b1-lib` to your `server.cfg`
3. **Optional dependencies**: `oxmysql`, `ox_inventory`, `ox_lib`

```lua
-- server.cfg
ensure oxmysql
ensure ox_inventory
ensure ox_lib
ensure b1-lib
```

---

## ⚡ Quick Start

### Get the B1 Object (Recommended)

```lua
-- Get the complete B1 object
local B1 = exports['b1-lib']:getB1Object()

-- Use any B1 function
B1.log('info', 'Hello from b1-lib!')
B1.notify('Welcome to the server!', 'success')
B1.progressBar('Loading...', 5000)
```

### Basic Usage Examples

```lua
-- Get B1 object (recommended approach)
local B1 = exports['b1-lib']:getB1Object()

-- Logging + notifications
B1.log('info', 'Hello from b1-lib!')
B1.notify('Welcome to the server!', 'success')

-- UI functions
B1.progressBar('Loading...', 5000, {
    onFinish = function()
        B1.notify('Loading complete!', 'success')
    end
})

local success = B1.skillCheck('easy')
if success then
    B1.notify('Skill check passed!', 'success')
end

-- Spawn a vehicle
local netId = B1.spawnVehicle('adder', function(vehicle)
    print('Vehicle spawned:', vehicle)
end)

-- Simple database query (server-side only)
local players = B1.db.query('SELECT * FROM users WHERE job = ?', {'police'})

-- ORM model (server-side only)
local Users = B1.orm.define('users', 'id')
local user = Users:find(1)
user.name = 'New Name'
user:save()
```

---

## 🎯 Core Modules

### 📝 Logger _(Shared: client & server)_
Colored, boxed output with traceback support and calling resource detection.

```lua
-- String levels
B1.log('info', 'This is an info message')
B1.log('warning', 'This is a warning')
B1.log('error', 'This is an error')

-- Numeric levels (1=debug, 2=info, 3=warning, 4=error)
B1.log(2, 'This is also an info message')

-- Table logging (automatically formatted)
B1.log('info', { name = 'John', age = 30, job = 'police' })

-- With context
B1.log('info', 'Player joined', { ctx = { playerId = 123, name = 'John', source = 1 } })
```

### 🛠️ Utils _(Shared)_
Common utilities for strings, numbers, and system detection.

```lua
-- Random generation
local randomStr = B1.randomStr(10) -- "aB3xY9mK2p"
local randomInt = B1.randomInt(6)  -- 123456

-- String manipulation
local parts = B1.splitStr('apple,banana,cherry', ',') 
-- Returns: {"apple", "banana", "cherry"}

-- Framework detection
local coreName = B1.getCoreName() -- "qb-core" or "esx" or nil
local inventoryName = B1.getInventoryName() -- "ox", "qb", "esx", or "unknown"
```

### 🗄️ Database _(Server only)_
Lightweight ORM with oxmysql adapter. All functions are await-style and non-blocking.

```lua
-- Basic queries
local players = B1.db.query('SELECT * FROM users WHERE job = ?', {'police'})
local user = B1.db.single('SELECT * FROM users WHERE id = ?', {1})
local count = B1.db.scalar('SELECT COUNT(*) FROM users')

-- ORM models
local Users = B1.orm.define('users', 'id')
local user = Users:find(1)
user.name = 'New Name'
user:save()
```

### 🎨 UI Functions _(Client only)_
Client-side UI functions for notifications, progress bars, and skill checks.

```lua
-- Notifications
B1.notify('Hello world!', 'success')
B1.notify('Warning message', 'warning', 3000, 'bottom-left')

-- Progress bars
B1.progressBar('Loading...', 10000, {
    onFinish = function()
        B1.notify('Process completed!', 'success')
    end
})

-- Skill checks
local success = B1.skillCheck('easy')
if success then
    B1.notify('Skill check passed!', 'success')
end
```

### 👤 Player Functions
Normalized player management functions that work with both QBCore and ESX frameworks.

```lua
-- Server-side
local player = B1.getCorePlayer(source)
B1.addMoney(source, 'cash', 1000, 'Reward')
local cash = B1.getMoney(source, 'cash')

-- Client-side
local playerData = B1.getPlayerData()
local job = B1.getPlayerJob()
local cash = B1.getPlayerMoney('cash')
```

### 🚗 Vehicle Functions
Vehicle management functions for spawning, plate detection, and label retrieval.

```lua
-- Server-side
local netId = B1.spawnVehicle(source, 'adder', vector4(0, 0, 0, 0), true)
local plate = B1.getPlate(netId)
local label = B1.getVehicleLabel('adder')

-- Client-side
local netId = B1.spawnVehicle('adder', function(vehicle)
    print('Vehicle spawned:', vehicle)
end)
```

### 🎒 Inventory Functions _(Server only)_
Server-side inventory management with ox_inventory integration.

```lua
-- Add item
B1.inv.add(source, 'bread', 5, {quality = 100})

-- Remove item
B1.inv.remove(source, 'bread', 2)

-- Check if player can carry
local canCarry = B1.inv.canCarry(source, 'bread', 10)

-- Get item
local item = B1.inv.get(source, 'bread')
```

---

## 🔧 Configuration

Edit `config.lua` to customize behavior:

```lua
-- B1-lib Configuration
Config.Core = 'auto' -- 'auto'|'qb-core'|'esx'
Config.Notification = 'auto' -- 'auto'|'ox'|'zsx'|'esx'|'qb'|'native'
Config.ProgressBar = 'auto' -- 'auto'|'ox'|'zsx'|'esx'|'qb'|'native'
Config.SkillCheck = 'auto' -- 'auto'|'ox'|'zsx'|'esx'|'qb'|'native'
Config.LogLevel = 'info' -- 'debug'|'info'|'warning'|'error'
```

---

## 📚 Documentation

For complete documentation, visit: [https://docs.burnonestudios.com/FiveM-Resources/B1-Lib/Documention/](https://docs.burnonestudios.com/FiveM-Resources/B1-Lib/Documention/)

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [QBCore Framework](https://github.com/qbcore-framework/qb-core) - QBCore support
- [ESX Framework](https://github.com/esx-framework/esx-legacy) - ESX support
- [oxmysql](https://github.com/overextended/oxmysql) - Database functionality
- [ox_inventory](https://github.com/overextended/ox_inventory) - Inventory integration
- [ox_lib](https://github.com/overextended/ox_lib) - UI functionality

---

## 📞 Support

- **Discord**: [Join our Discord](https://discord.gg/your-discord)
- **Issues**: [GitHub Issues](https://github.com/your-repo/b1-lib/issues)
- **Documentation**: [Full Documentation](https://docs.burnonestudios.com/FiveM-Resources/B1-Lib/Documention/)

---

<div align="center">

**Made with ❤️ for the FiveM community**

[⬆ Back to top](#-b1-lib)

</div>
