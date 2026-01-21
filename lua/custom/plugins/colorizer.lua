-- ========== Show HEX or RGB color as a background ==========
return {
  'norcalli/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup()
  end,
}
