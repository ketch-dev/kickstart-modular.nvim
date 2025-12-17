

local M = {}
-- Utility to check if a Neo-tree source is open
function is_source_open(src)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.fn.getbufvar(buf, 'neo_tree_source') == src then
      return true
    end
  end
  return false
end

-- Function to toggle both buffers (left) and git_status (right)
function M.toggle_both_sides()
  local is_filesystem_open = is_source_open('filesystem')
  local is_buffers_open = is_source_open('buffers')
  local is_git_open = is_source_open('git_status')

  if is_filesystem_open or is_buffers_open or is_git_open then
    vim.cmd('Neotree action=close source=filesystem')
    vim.cmd('Neotree action=close source=buffers')
    vim.cmd('Neotree action=close source=git_status')
  else
    vim.cmd('Neotree source=filesystem reveal position=left show')
    vim.cmd('Neotree source=git_status reveal position=right show')
  end
end

return M