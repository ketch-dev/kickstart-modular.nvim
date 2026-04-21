local M = {}

function M.open_or_refresh_diffview()
  if require('diffview.lib').get_current_view() then
    vim.cmd 'DiffviewRefresh'
  else
    vim.cmd 'DiffviewOpen'
  end
end

return M
