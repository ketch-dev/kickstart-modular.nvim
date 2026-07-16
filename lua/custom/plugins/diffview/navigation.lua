local api = vim.api

local M = {}

local function navigate_tree(direction)
  local view = require('diffview.lib').get_current_view()
  local panel = view and view.panel or nil
  if not panel or panel.listing_style ~= 'tree' or not panel.components then return end

  local start = api.nvim_win_get_cursor(panel.winid)[1]
  local line = start
  local line_count = api.nvim_buf_line_count(panel.bufid)

  repeat
    line = (line - 1 + direction) % line_count + 1
    local component = panel.components.comp:get_comp_on_line(line)
    if component and component.name == 'dir_name' then
      api.nvim_win_set_cursor(panel.winid, { line, 0 })
      return
    end
  until line == start
end

function M.previous_tree_row() navigate_tree(-1) end

function M.next_tree_row() navigate_tree(1) end

return M
