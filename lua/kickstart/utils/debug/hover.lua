local M = {}

local dap_hover_view
local dap_hover_autocmd

function M.close(view)
  if dap_hover_autocmd then
    pcall(vim.api.nvim_del_autocmd, dap_hover_autocmd)
    dap_hover_autocmd = nil
  end

  if view and view.close then view.close() end
  if dap_hover_view == view then dap_hover_view = nil end
end

function M.focus_or_open()
  if dap_hover_view and dap_hover_view.win and vim.api.nvim_win_is_valid(dap_hover_view.win) then
    vim.api.nvim_set_current_win(dap_hover_view.win)
    return
  end

  local source_win = vim.api.nvim_get_current_win()
  local source_buf = vim.api.nvim_get_current_buf()
  local view = require('dap.ui.widgets').hover()
  dap_hover_view = view

  if vim.api.nvim_win_is_valid(source_win) then vim.api.nvim_set_current_win(source_win) end

  vim.schedule(function()
    if dap_hover_view ~= view or not vim.api.nvim_buf_is_valid(source_buf) then return end

    if dap_hover_autocmd then pcall(vim.api.nvim_del_autocmd, dap_hover_autocmd) end
    dap_hover_autocmd = vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = source_buf,
      callback = function() M.close(view) end,
    })
  end)
end

return M
