-- ========== Smooth Scrolling ==========

return {
  'karb94/neoscroll.nvim',
  cond = not vim.g.vscode,
  opts = {
    duration_multiplier = 0.35,
    mappings = { '<C-u>', '<C-d>', 'zt', 'zz', 'zb' },
  },
}
