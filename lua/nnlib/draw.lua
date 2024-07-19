-- This file is part of nnlib which is released under MIT License.
-- See file LICENSE or go to https://github.com/xoderton/nnlib/blob/main/LICENSE for full license details.

-- just a shortcut to make it simpler
function draw.DrawTexturedRect(material, x, y, width, height, color)
  surface.SetMaterial(material)
  surface.SetDrawColor(color:Unpack() or color_white:Unpack())
  surface.DrawTexturedRect(x, y, width, height)
end