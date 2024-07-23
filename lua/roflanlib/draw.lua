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

---`draw.RoundedBox` but with rotation, made by Phoenixf *(i just copied it into library without any changes)*<br>
---
---[(View on Wiki)](https://wiki.facepunch.com/gmod/cam.PushModelMatrix#example)
---@param cornerRadius any
---@param x any
---@param y any
---@param w any
---@param h any
---@param color any
---@param angle any
function draw.RotatedBox(cornerRadius, x, y, w, h, color, angle)
  local m = Matrix()
  local center = Vector(x, y, 0)

  m:Translate(center)
  m:Rotate(Angle( 0, angle, 0))
  m:Translate(-center)

  render.PushFilterMag(TEXFILTER.ANISOTROPIC)
  render.PushFilterMin(TEXFILTER.ANISOTROPIC)

  cam.PushModelMatrix(m)
  draw.RoundedBox(cornerRadius, x, y, w, h, color)
  cam.PopModelMatrix()

  render.PopFilterMag()
  render.PopFilterMin()
end

local vector_one = Vector(1, 1, 1)

---`draw.DrawText` but with rotation<br>
---
---[(View on Wiki)](https://wiki.facepunch.com/gmod/cam.PushModelMatrix#example)
---@param text any
---@param font string
---@param x number
---@param y number
---@param color Color|nil
---@param ang number
---@param scale number
function draw.RotatedText(text, font, x, y, color, ang, scale)
  render.PushFilterMag(TEXFILTER.ANISOTROPIC)
  render.PushFilterMin(TEXFILTER.ANISOTROPIC)

  local m = Matrix()
  m:Translate(Vector(x, y, 0))
  m:Rotate(Angle(0, ang, 0))
  m:Scale(vector_one * (scale or 1))

  surface.SetFont(font)
  local w, h = surface.GetTextSize(text)

  m:Translate(Vector(-w / 2, -h / 2, 0))

  cam.PushModelMatrix(m, true)
    draw.DrawText(text, font, 0, 0, color)
  cam.PopModelMatrix()

  render.PopFilterMag()
  render.PopFilterMin()
end