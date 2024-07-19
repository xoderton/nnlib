-- This file is part of nnlib which is released under MIT License.
-- See file LICENSE or go to https://github.com/xoderton/nnlib/blob/main/LICENSE for full license details.

local cached_materials = {}

-- it doesn't have any limits built-in, so you need to do it on yourself
-- and also you might need to create folder specifically for this function
-- [surl/] should be good
--
-- src: https://gist.github.com/mattkrins/5455b96631cc2ebdf0e577a71d1a3d54
-- edited/fixed call it whatever you want
function surface.GetURL(url)
  if url == nil then return error_material end
  if cached_materials[url] then return cached_materials[url] end

  local name = string.GetFileName(url)

  http.Fetch(url, function(body)
    local url_material = Material("../data/" .. name)

    cached_materials[url] = url_material
    file.Write(name, body)
  end)

  return cached_materials[url]
end