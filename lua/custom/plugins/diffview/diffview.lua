local highlights = require 'custom.plugins.diffview.highlights'
local open_entry = require 'custom.plugins.diffview.open-entry'
local open_view = require 'custom.plugins.diffview.open-view'
local shortcuts = require 'shortcuts'

vim.pack.add {
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
}

vim.keymap.set('n', '<leader>gd', open_view.open_or_refresh_diffview, { desc = '[d]iff' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', { desc = 'file [h]istory' })

local close = { 'n', '<C-l>', function() require('diffview').close() end, { desc = '[l]eave diffview' } }
local disable_kill = { 'n', shortcuts.kill_buffer, '<Nop>', { desc = 'disable kill buffer' } }

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
      disable_kill,
    },
    option_panel = { close, disable_kill },
    help_panel = { close, disable_kill },
    view = {
      { 'n', '<CR>', open_entry.open_file_and_close_diffview, { desc = 'open file' } },
      close,
      disable_kill,
    },
    file_panel = {
      { 'n', 'j', function() end, { desc = 'no-op' } },
      { 'n', 'k', function() end, { desc = 'no-op' } },
      { 'n', 'h', function() end, { desc = 'no-op' } },
      { 'n', 'l', function() end, { desc = 'no-op' } },
      { 'n', '<cr>', open_entry.open_file_at_first_change, { desc = 'open file at first change' } },
      close,
      disable_kill,
    },
  },
}

highlights.setup()
