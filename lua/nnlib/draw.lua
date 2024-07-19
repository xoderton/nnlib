-- This file is part of nnlib which is released under MIT License.
-- See file LICENSE or go to https://github.com/xoderton/nnlib/blob/main/LICENSE for full license details.

---surface.DrawTexturedRect but combined into one function to make life "easier"
---@param material IMaterial
---@param x number
---@param y number
---@param width number
---@param height number
---@param color Color|nil
function draw.DrawTexturedRect(material, x, y, width, height, color)
  surface.SetMaterial(material)
  ---@diagnostic disable-next-line: param-type-mismatch
  surface.SetDrawColor(color and color:Unpack() or color_white:Unpack())
  surface.DrawTexturedRect(x, y, width, height)
end