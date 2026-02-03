-- ========== Smooth Scrolling ==========

return {
  'karb94/neoscroll.nvim',
  cond = not vim.g.vscode,
  opts = {
    duration_multiplier = 0.35,
  },
}
