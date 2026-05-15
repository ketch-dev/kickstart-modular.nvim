-- ========== Change search, cmd and notifications ==========

vim.pack.add {
  'https://github.com/folke/noice.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/rcarriga/nvim-notify',
}

require('notify').setup {
  top_down = false,
}

require('noice').setup {}
