local highlights = require 'custom.plugins.diffview.highlights'
local open_entry = require 'custom.plugins.diffview.open-entry'
local open_view = require 'custom.plugins.diffview.open-view'

vim.pack.add {
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
}

vim.keymap.set('n', '<leader>gd', open_view.open_or_refresh_diffview, { desc = '[d]iff' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', { desc = 'file [h]istory' })

local close = { 'n', '<C-k>', function() require('diffview').close() end, { desc = '[k]ill diffview' } }

require('diffview').setup {
  enhanced_diff_hl = true,
  show_help_hints = false,
  icons = { folder_closed = '', folder_open = '' },
  keymaps = {
    file_history_panel = {
      { 'n', 'j', function() end, { desc = 'no-op' } },
      { 'n', 'k', function() end, { desc = 'no-op' } },
      { 'n', 'h', function() end, { desc = 'no-op' } },
      { 'n', 'l', function() end, { desc = 'no-op' } },
      close,
    },
    option_panel = { close },
    help_panel = { close },
    view = {
      { 'n', '<CR>', open_entry.open_file_and_close_diffview, { desc = 'open file' } },
      close,
    },
    file_panel = {
      { 'n', 'j', function() end, { desc = 'no-op' } },
      { 'n', 'k', function() end, { desc = 'no-op' } },
      { 'n', 'h', function() end, { desc = 'no-op' } },
      { 'n', 'l', function() end, { desc = 'no-op' } },
      { 'n', '<CR>', open_entry.open_file_and_close_diffview, { desc = 'open file' } },
      close,
    },
  },
}

highlights.setup()
