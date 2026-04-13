-- ========== Smooth Scrolling ==========

return {
  'karb94/neoscroll.nvim',
  opts = {
    duration_multiplier = 0.35,
    mappings = { '<C-u>', '<C-d>', 'zt', 'zz', 'zb' },
  },
}
