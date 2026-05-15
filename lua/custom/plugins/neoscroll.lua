-- ========== Smooth Scrolling ==========

vim.pack.add { 'https://github.com/karb94/neoscroll.nvim' }
require('neoscroll').setup {
  duration_multiplier = 0.35,
  mappings = { '<C-u>', '<C-d>', 'zt', 'zz', 'zb' },
}
