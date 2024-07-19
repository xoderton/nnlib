-- This file is part of nnlib which is released under MIT License.
-- See file LICENSE or go to https://github.com/xoderton/nnlib/blob/main/LICENSE for full license details.

local PLAYER = FindMetaTable("Player")

function player.FindInBox(mins, maxs)
  local result = {}

  for k, v in ipairs(ents.FindInBox(mins, maxs)) do
    if not v:IsPlayer() then continue end
    result[#result + 1] = v
  end

  return result, #result
end

function player.FindInSphere(origin, radius)
  local result = {}

  for k, v in ipairs(ents.FindInSphere(origin, radius)) do
    if not v:IsPlayer() then continue end
    result[#result + 1] = v
  end

  return result, #result
end

function player.FindByUserGroup(usergroup)
  local result = {}

  for k, v in player.Iterator() do
    if v:GetUserGroup() ~= usergroup then continue end
    result[#result + 1] = v
  end

  return result, #result
end