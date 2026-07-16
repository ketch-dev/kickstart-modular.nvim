local M = {}

local function cycle_copilot(direction)
  local suggestion = require 'copilot.suggestion'
  if not suggestion.is_visible() then return end

  if direction > 0 then
    suggestion.next()
  else
    suggestion.prev()
  end
  return true
end

function M.cycle_copilot_next() return cycle_copilot(1) end

function M.cycle_copilot_prev() return cycle_copilot(-1) end

return M
