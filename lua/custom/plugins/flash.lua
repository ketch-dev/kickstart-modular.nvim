vim.pack.add { 'https://github.com/folke/flash.nvim' }
require('flash').setup {
  labels = 'shtalegynicfdoruwpmjxvkzqb',
}

vim.keymap.set({ 'n', 'x', 'o' }, 'j', function() require('flash').jump() end, { desc = '[j]ump' })
vim.keymap.set({ 'n', 'x', 'o' }, '<C-w>', function() require('flash').treesitter() end, { desc = '[w]raps (treesitter)' })
