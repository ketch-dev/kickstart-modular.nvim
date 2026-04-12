local M = {}

local function clamp(x, min, max) return math.max(min, math.min(max, x)) end

local function hue_to_rgb(p, q, t)
  if t < 0 then t = t + 1 end
  if t > 1 then t = t - 1 end
  if t < 1 / 6 then return p + (q - p) * 6 * t end
  if t < 1 / 2 then return q end
  if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
  return p
end

function M.to_hex(h, s, l)
  h = ((h % 360) + 360) % 360
  s = clamp(s, 0, 100) / 100
  l = clamp(l, 0, 100) / 100

  local r, g, b

  if s == 0 then
    r, g, b = l, l, l
  else
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    local hk = h / 360

    r = hue_to_rgb(p, q, hk + 1 / 3)
    g = hue_to_rgb(p, q, hk)
    b = hue_to_rgb(p, q, hk - 1 / 3)
  end

  return string.format(
    '#%02x%02x%02x',
    math.floor(clamp(r * 255, 0, 255) + 0.5),
    math.floor(clamp(g * 255, 0, 255) + 0.5),
    math.floor(clamp(b * 255, 0, 255) + 0.5)
  )
end

return M
