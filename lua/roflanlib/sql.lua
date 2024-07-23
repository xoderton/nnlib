-- This file is part of nnlib which is released under MIT License.
-- See file LICENSE or go to https://github.com/xoderton/nnlib/blob/main/LICENSE for full license details.

---Creates a new table if `table_name` is unique and previously was not created, otherwise it will silently fail.
---
---## Example
---```lua
----- sql.Query might be better for that job, but that makes code cleaner?
---sql.CreateTable("users", {
---  "sid TEXT NOT NULL PRIMARY KEY",
---  "name TEXT NOT NULL"
---})
---```
---@param table_name string
---@param data string[]
function sql.CreateTable(table_name, data)
  local query = [[CREATE TABLE IF NOT EXISTS %s (
    %s
  );]]

  sql.Query(string.format(query, string.lower(table_name), table.concat(data, ",\n")))
end

---Updates `key` with provided `value` in `table_name` with custom filter.
---@param table_name string
---@param data { key: string, value: string, filter: string[] }
function sql.UpdateKey(table_name, data)
  local query = [[UPDATE %s SET %s = %s]]

  if data.filter then
    query = query .. " WHERE (" .. table.concat(data.filter, " AND ") .. ")"
  end

  sql.Query(string.format(query, table_name, data.key, data.value))
end

---Inserts a new key into the table, with `{ [key]: string }` table structure as data.
---
---## Example
---```lua
----- It's much easier to do that, than filling it out in string.format function :D
---sql.InsertKey("users", { sid: SQLStr("76561199090831696"), name: SQLStr("shockpast") })
---```
---@param table_name string
---@param data { row: string }
function sql.InsertKey(table_name, data)
  local query = [[INSERT INTO %s (%s) VALUES (%s);]]

  local rows = ""
  local values = ""

  for k, v in pairs(data) do
    rows = (rows ~= "" and rows .. ", " or rows) .. k
    values = (values ~= "" and values .. ", " or values) .. v
  end

  sql.Query(string.format(query, table_name, rows, values))
end

---Sizzles specific single or multiple rows from provided table.
---@param table_name any
---@param filter any
function sql.DeleteKey(table_name, filter)
  local query = "DELETE FROM %s WHERE (%s);"
  sql.Query(string.format(query, table_name, table.concat(filter, " AND ")))
end

---Queries specific value in provided table with custom filter.
---@param table_name string
---@param key string
---@param filter string[]
---@return string
function sql.GetValue(table_name, key, filter)
  local query = "SELECT %s FROM %s"

  if filter then
    query = query .. " WHERE (" .. table.concat(filter, " AND ") .. ")"
  end

  return sql.QueryValue(string.format(query, key, table_name))
end

---Queries multiple values in provided table within order provided in `keys` table (with custom filter!)
---
---## Example
---```lua
----- It looks stupid, but it's just an example ;)
---local sid, name = sql.GetValues("users", { "sid", "name" }, { "sid = '76561199090831696'" })
---print(name, "'s SteamID64 is ", sid)
---```
---@param table_name string
---@param keys string[]
---@param filter string[]
---@return any ...
function sql.GetValues(table_name, keys, filter)
  local query = "SELECT %s FROM %s"

  if filter then
    query = query .. " WHERE (" .. table.concat(filter, " AND ") .. ")"
  end

  local result = sql.Query(string.format(query, table.concat(keys, ", "), table_name))
  if not result or result == "" then return end
  if result[1] == nil then return end

  local t = {}
  -- this is very bad, ugly, i can't imagine any words to describe this
  -- unpack + order_vars just makes simple to use this function i guess
  local function order_vars(table_to_order, index, required_order, output_table)
    for k, v in pairs(table_to_order) do
      if k ~= required_order[index] then continue end
      table.insert(output_table, v)
      index = index + 1
      order_vars(table_to_order, index, required_order, output_table)
    end
  end

  order_vars(result[1], 1, keys, t)
  return unpack(t)
end