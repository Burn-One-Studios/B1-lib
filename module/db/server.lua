-- B1-lib Database Module
-- Lightweight ORM inspired by 4DaysORM with oxmysql adapter

-- Check for oxmysql
local hasOxmysql = GetResourceState('oxmysql') == 'started'

if not hasOxmysql then
    B1.log('warning', 'oxmysql not found - database functions will be disabled')
end

-- Database adapter
local db = {}

-- Execute query and return rows
function db.query(sql, params)
    if not hasOxmysql then
        B1.log('error', 'oxmysql not available for query: ' .. tostring(sql))
        return {}
    end
    
    local result = MySQL.query.await(sql, params or {})
    return result or {}
end

-- Get single row
function db.single(sql, params)
    if not hasOxmysql then
        B1.log('error', 'oxmysql not available for single: ' .. tostring(sql))
        return nil
    end
    
    local result = MySQL.single.await(sql, params or {})
    return result
end

-- Get scalar value
function db.scalar(sql, params)
    if not hasOxmysql then
        B1.log('error', 'oxmysql not available for scalar: ' .. tostring(sql))
        return nil
    end
    
    local result = MySQL.scalar.await(sql, params or {})
    return result
end

-- Insert and return insert ID
function db.insert(sql, params)
    if not hasOxmysql then
        B1.log('error', 'oxmysql not available for insert: ' .. tostring(sql))
        return 0
    end
    
    local result = MySQL.insert.await(sql, params or {})
    return result.insertId or 0
end

-- Update and return affected rows
function db.update(sql, params)
    if not hasOxmysql then
        B1.log('error', 'oxmysql not available for update: ' .. tostring(sql))
        return 0
    end
    
    local result = MySQL.update.await(sql, params or {})
    return result.affectedRows or 0
end

-- ORM Model factory
local function createModel(tableName, primaryKey)
    local Model = {}
    Model.__index = Model
    Model.tableName = tableName
    Model.primaryKey = primaryKey or 'id'
    
    -- Find single record
    function Model:find(id)
        local sql = ('SELECT * FROM %s WHERE %s = ?'):format(tableName, self.primaryKey)
        local row = db.single(sql, {id})
        if row then
            return setmetatable(row, {
                __index = function(t, k)
                    if k == 'save' then
                        return function()
                            local updateFields = {}
                            local updateValues = {}
                            for field, value in pairs(t) do
                                if field ~= self.primaryKey then
                                    table.insert(updateFields, field .. ' = ?')
                                    table.insert(updateValues, value)
                                end
                            end
                            table.insert(updateValues, t[self.primaryKey])
                            
                            local sql = ('UPDATE %s SET %s WHERE %s = ?'):format(
                                tableName, 
                                table.concat(updateFields, ', '), 
                                self.primaryKey
                            )
                            return db.update(sql, updateValues) > 0
                        end
                    elseif k == 'delete' then
                        return function()
                            local sql = ('DELETE FROM %s WHERE %s = ?'):format(tableName, self.primaryKey)
                            return db.update(sql, {t[self.primaryKey]}) > 0
                        end
                    else
                        return rawget(t, k)
                    end
                end
            })
        end
        return nil
    end
    
    -- Find all records with optional where clause
    function Model:findAll(where, params)
        local sql = 'SELECT * FROM ' .. tableName
        if where then
            sql = sql .. ' WHERE ' .. where
        end
        local rows = db.query(sql, params)
        local result = {}
        for _, row in ipairs(rows) do
            table.insert(result, setmetatable(row, {
                __index = function(t, k)
                    if k == 'save' then
                        return function()
                            local updateFields = {}
                            local updateValues = {}
                            for field, value in pairs(t) do
                                if field ~= self.primaryKey then
                                    table.insert(updateFields, field .. ' = ?')
                                    table.insert(updateValues, value)
                                end
                            end
                            table.insert(updateValues, t[self.primaryKey])
                            
                            local sql = ('UPDATE %s SET %s WHERE %s = ?'):format(
                                tableName, 
                                table.concat(updateFields, ', '), 
                                self.primaryKey
                            )
                            return db.update(sql, updateValues) > 0
                        end
                    elseif k == 'delete' then
                        return function()
                            local sql = ('DELETE FROM %s WHERE %s = ?'):format(tableName, self.primaryKey)
                            return db.update(sql, {t[self.primaryKey]}) > 0
                        end
                    else
                        return rawget(t, k)
                    end
                end
            }))
        end
        return result
    end
    
    -- Insert new record
    function Model:insert(data)
        local fields = {}
        local placeholders = {}
        local values = {}
        
        for field, value in pairs(data) do
            table.insert(fields, field)
            table.insert(placeholders, '?')
            table.insert(values, value)
        end
        
        local sql = ('INSERT INTO %s (%s) VALUES (%s)'):format(
            tableName,
            table.concat(fields, ', '),
            table.concat(placeholders, ', ')
        )
        
        return db.insert(sql, values)
    end
    
    -- Update record by ID
    function Model:update(id, data)
        local updateFields = {}
        local values = {}
        
        for field, value in pairs(data) do
            table.insert(updateFields, field .. ' = ?')
            table.insert(values, value)
        end
        table.insert(values, id)
        
        local sql = ('UPDATE %s SET %s WHERE %s = ?'):format(
            tableName,
            table.concat(updateFields, ', '),
            self.primaryKey
        )
        
        return db.update(sql, values) > 0
    end
    
    -- Delete record by ID
    function Model:delete(id)
        local sql = ('DELETE FROM %s WHERE %s = ?'):format(tableName, self.primaryKey)
        return db.update(sql, {id}) > 0
    end
    
    return Model
end

-- ORM namespace
B1.orm = {
    define = createModel
}

-- Attach to B1
B1.db = db

-- Export functions
exports('db_query', db.query)
exports('db_single', db.single)
exports('db_scalar', db.scalar)
exports('db_insert', db.insert)
exports('db_update', db.update)
exports('orm_define', createModel)
