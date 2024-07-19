-- This file is part of nnlib which is released under MIT License.
-- See file LICENSE or go to https://github.com/xoderton/nnlib/blob/main/LICENSE for full license details.

function sql.CreateTable(table_name, data)
  local query = [[CREATE TABLE IF NOT EXISTS %s (
    %s
  );]]

  sql.Query(string.format(query, string.lower(table_name), table.concat(data, ",\n")))
end

function sql.UpdateKey(table_name, data)
  local query = [[UPDATE %s SET %s = %s]]

  if data.filter then
    query = query .. " WHERE (" .. table.concat(data.filter, " AND ") .. ")"
  end

  sql.Query(string.format(query, table_name, data.key, data.value))
end

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

function sql.DeleteKey(table_name, filter)
  local query = "DELETE FROM %s WHERE (%s);"
  sql.Query(string.format(query, table_name, table.concat(filter, " AND ")))
end

function sql.GetValue(table_name, key, filter)
  local query = "SELECT %s FROM %s"

  if filter then
    query = query .. " WHERE (" .. table.concat(filter, " AND ") .. ")"
  end

  return sql.QueryValue(string.format(query, key, table_name))
end

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

setmetatable(sql, {
  __newindex = function(table, k, v)
    if k == "m_strError" and v then
      error(v)
    end
  end
})