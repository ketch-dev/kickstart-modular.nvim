-- ========== Show Scrollbar ==========

return {
  'petertriho/nvim-scrollbar',
  opts = {
    handlers = {
      cursor = false,
      diagnostic = true,
      gitsigns = true,
      handle = true,
      search = false,
      ale = false,
    },
  },
}
