local M = {}

local did_setup = false

function M.apply()
  local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
  if normal.bg == nil then return end

  local normal_nc = vim.api.nvim_get_hl(0, { name = 'NormalNC', link = false })
  local line_nr = vim.api.nvim_get_hl(0, { name = 'LineNr', link = false })
  local sign_column = vim.api.nvim_get_hl(0, { name = 'SignColumn', link = false })
  local fold_column = vim.api.nvim_get_hl(0, { name = 'FoldColumn', link = false })
  local cursor_line_sign = vim.api.nvim_get_hl(0, { name = 'CursorLineSign', link = false })
  local cursor_line_fold = vim.api.nvim_get_hl(0, { name = 'CursorLineFold', link = false })

  vim.api.nvim_set_hl(0, 'NormalNC', vim.tbl_extend('force', normal_nc, { bg = normal.bg }))
  vim.api.nvim_set_hl(0, 'LineNr', vim.tbl_extend('force', line_nr, { bg = normal.bg }))
  vim.api.nvim_set_hl(0, 'SignColumn', vim.tbl_extend('force', sign_column, { bg = normal.bg }))
  vim.api.nvim_set_hl(0, 'FoldColumn', vim.tbl_extend('force', fold_column, { bg = normal.bg }))
  vim.api.nvim_set_hl(0, 'CursorLineSign', vim.tbl_extend('force', cursor_line_sign, { bg = normal.bg }))
  vim.api.nvim_set_hl(0, 'CursorLineFold', vim.tbl_extend('force', cursor_line_fold, { bg = normal.bg }))
  -------------------------------------------------------------------------------
end

function M.setup()
  if did_setup then return end
  did_setup = true

  local group = vim.api.nvim_create_augroup('custom_ui_overlay', { clear = true })

  vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    desc = 'Apply custom UI overlay',
    callback = M.apply,
  })

  if vim.g.colors_name then M.apply() end
end

return M
