local M = {}

local mc = require 'mini.colors'

function M.to_hex(l, c, h)
  return mc.convert({ l = l, c = c, h = h }, 'hex', {
    adjust_lightness = false,
    gamut_clip = 'chroma',
  })
end

return M
