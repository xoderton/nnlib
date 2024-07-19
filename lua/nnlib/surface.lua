-- This file is part of nnlib which is released under MIT License.
-- See file LICENSE or go to https://github.com/xoderton/nnlib/blob/main/LICENSE for full license details.

local error_material = Material("error")
local cached_materials = {}

---Fetches an BufferData from provided URL and saves it in user's `data/` folder<br>
---
---It doesn't have any limits built-in, so you'll need to do it on yourself<br>
---and also you might need to create folder specifically for this function<br>
---[surl/] sounds good.<br>
---
---Source: https://gist.github.com/mattkrins/5455b96631cc2ebdf0e577a71d1a3d54<br>
---@param url string
---@return IMaterial
function surface.GetURL(url)
  if url == nil then return error_material end
  if cached_materials[url] then return cached_materials[url] end

  local name = string.GetFileName(url)
  if name == nil then return error_material end

  http.Fetch(url, function(body)
    local url_material = Material("../data/" .. name)

    cached_materials[url] = url_material
    file.Write(name, body)
  end)

  return cached_materials[url]
end