vim.pack.add {
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
}

vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<CR>', { desc = 'neogit' })
