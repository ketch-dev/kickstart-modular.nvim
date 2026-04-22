local M = {}

local did_setup = false

function M.apply()
  local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
  if normal.bg == nil then return end

  local normal_nc = vim.api.nvim_get_hl(0, { name = 'NormalNC', link = false })
  local line_nr = vim.api.nvim_get_hl(0, { name = 'LineNr', link = false })
  local cursor_line_nr = vim.api.nvim_get_hl(0, { name = 'CursorLineNr', link = false })
  local sign_column = vim.api.nvim_get_hl(0, { name = 'SignColumn', link = false })
  local folded = vim.api.nvim_get_hl(0, { name = 'Folded', link = false })
  local fold_column = vim.api.nvim_get_hl(0, { name = 'FoldColumn', link = false })
  local cursor_line_sign = vim.api.nvim_get_hl(0, { name = 'CursorLineSign', link = false })
  local cursor_line_fold = vim.api.nvim_get_hl(0, { name = 'CursorLineFold', link = false })

  -- ========== [Gutter] Sign Column ==========
  vim.api.nvim_set_hl(0, 'SignColumn', vim.tbl_extend('force', sign_column, { bg = normal.bg }))
  vim.api.nvim_set_hl(0, 'CursorLineSign', vim.tbl_extend('force', cursor_line_sign, { bg = normal.bg }))
  ---------------------------------------------------------------------------------

  -- ========== [Gutter] Line Number ==========
  vim.api.nvim_set_hl(0, 'LineNr', vim.tbl_extend('force', line_nr, { bg = normal.bg }))
  vim.api.nvim_set_hl(0, 'CursorLineNr', vim.tbl_extend('force', cursor_line_nr, { bg = normal.bg, fg = '#bbbbbb' }))
  ---------------------------------------------------------------------------------

  -- ========== [Gutter] Fold ==========
  vim.api.nvim_set_hl(0, 'FoldColumn', vim.tbl_extend('force', fold_column, { bg = normal.bg }))
  vim.api.nvim_set_hl(0, 'CursorLineFold', vim.tbl_extend('force', cursor_line_fold, { bg = normal.bg }))
  ---------------------------------------------------------------------------------

  vim.api.nvim_set_hl(0, 'Folded', vim.tbl_extend('force', folded, { bg = '#1b1b1b', fg = '#2f2f2f', italic = true })) -- folded line
  vim.api.nvim_set_hl(0, 'NormalNC', vim.tbl_extend('force', normal_nc, { bg = normal.bg })) -- unfocused buffer
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
