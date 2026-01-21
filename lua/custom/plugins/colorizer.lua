-- ========== Show HEX or RGB color as a background ==========
return {
  'norcalli/nvim-colorizer.lua',
  cond = not vim.g.vscode,
  config = function()
    require('colorizer').setup()
  end,
}
