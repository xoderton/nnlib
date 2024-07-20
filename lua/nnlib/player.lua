-- This file is part of nnlib which is released under MIT License.
-- See file LICENSE or go to https://github.com/xoderton/nnlib/blob/main/LICENSE for full license details.

---Finds [n] players inside box from [a] to [b]
---@param mins Vector
---@param maxs Vector
---@return table
---@return integer
function player.FindInBox(mins, maxs)
  local result = {}

  for k, v in ipairs(ents.FindInBox(mins, maxs)) do
    if not v:IsPlayer() then continue end
    result[#result + 1] = v
  end

  return result, #result
end

---Finds [n] players inside sphere in [a] within [b] radius
---@param origin Vector
---@param radius number
---@return table
---@return integer
function player.FindInSphere(origin, radius)
  local result = {}

  for k, v in ipairs(ents.FindInSphere(origin, radius)) do
    if not v:IsPlayer() then continue end
    result[#result + 1] = v
  end

  return result, #result
end

---Finds [n] players by their [x] usergroup
---@param usergroup string
---@return table
---@return integer
function player.FindByUserGroup(usergroup)
  local result = {}

  for k, v in player.Iterator() do
    if v:GetUserGroup() ~= usergroup then continue end
    result[#result + 1] = v
  end

  return result, #result
end

---Finds [x] player using provided `[steamid/steamid64/entindex/name/ip]`
---@param info number|string
---@return Player|Entity
function player.Find(info)
  if info == nil then return NULL end

  local str = tostring(info)
  local num = tostring(info)

  -- SteamID
  if string.find(str, "STEAM") then
    for _, v in player.Iterator() do
      if v:SteamID() ~= str then continue end
      return v
    end
  end

  -- EntIndex
  if num ~= nil then
    ---@diagnostic disable-next-line: param-type-mismatch
    local ply = Entity(num)
    if ply:IsValid() then return ply end
  end

  -- SteamID64
  if utf8.len(str) == 17 and str[1] == "7" then
    local ply = player.GetBySteamID64(str)
    if ply ~= nil and ply:IsValid() then return ply end
  end

  -- IP Address
  if SERVER and string.find(str, "%d+%.%d+%.%d+%.%d+") then
    for _, v in player.Iterator() do
      if string.find(v:IPAddress(), str) == nil then continue end
      return v
    end
  end

  -- Exact Search by Name
  for _, v in player.Iterator() do
    if v:Name() ~= str then continue end
    return v
  end

  return NULL
end