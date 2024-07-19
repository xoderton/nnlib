local sets = { {97, 122}, {65, 90}, {48, 57} }

---Generates a "random" string with specific length.
---@param len number
---@return string
function string.Random(len)
  local str = ""
  math.randomseed(os.clock() ^ 5)

  for i = 1, len do
    local set = sets[math.random(#sets)]
    str = str .. string.char(math.random(set[1], set[2]))
  end

  return str
end

---Transforms RGB to HEX as integer value.
---@param r number
---@param g number
---@param b number
---@param a number
---@return number
function string.RGBToHex(r, g, b, a)
  return bit.bor(bit.lshift(r, 24), bit.lshift(g, 16), bit.lshift(b, 8), a or 255)
end

---Transforms HEX to RGBA.
---@param hex number
---@return number
---@return number
---@return number
---@return number
function string.HexToRGBA(hex)
  return bit.rshift(hex, 24), bit.rshift(bit.band(hex, 0x00ff0000), 16), bit.rshift(bit.band(hex, 0x0000f00), 8), bit.band(hex, 0x000000ff)
end

---Function Name.
---@param str string
---@return string|nil
function string.GetFileName(str)
  return string.match(str, "([%w%s!-={-|]+)[_%.].+")
end

---Function Name.
---@param str string
---@return string|nil
function string.GetFileExtension(str)
  return string.match(str, "^.+(%..+)$")
end

---Function Name, should be used for these durations `3d100min50sec`
---@param str string
---@return number
function string.ParseDuration(str)
  local days = tonumber(string.match(str, "(%d+)d")) or 0
  days = days * 60 * 60 * 24

  local hours = tonumber(string.match(str, "(%d+)h")) or 0
  hours = hours * 60 * 60

  local minutes = tonumber(string.match(str, "(%d+)min")) or 0
  minutes = minutes * 60

  local seconds = tonumber(string.match(str, "(%d+)sec")) or 0

  return days + hours + minutes + seconds
end