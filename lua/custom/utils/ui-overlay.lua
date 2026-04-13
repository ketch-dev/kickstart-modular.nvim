local M = {}

local did_setup = false

local function set_bg_from_normal(group)
  local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
  local current = vim.api.nvim_get_hl(0, { name = group, link = false })

  if normal.bg == nil then return end

  vim.api.nvim_set_hl(0, group, vim.tbl_extend('force', current, { bg = normal.bg }))
end

function M.apply()
  -- ========== Builtin ==========
  set_bg_from_normal 'NormalNC'
  set_bg_from_normal 'LineNr'
  set_bg_from_normal 'SignColumn'
  set_bg_from_normal 'FoldColumn'
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
