local M = {}

function M.move_and_preview(move)
  return function()
    move()

    local view = require('diffview.lib').get_current_view()
    local item = view and view.panel and view.panel:get_item_at_cursor() or nil

    if item and type(item.collapsed) ~= 'boolean' then require('diffview.actions').select_entry() end
  end
end

return M
