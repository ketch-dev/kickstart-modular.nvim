-- ========== Show Scrollbar ==========

return {
  'petertriho/nvim-scrollbar',
  cond = not vim.g.vscode,
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
