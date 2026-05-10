local highlights = require 'custom.plugins.diffview.highlights'
local open_entry = require 'custom.plugins.diffview.open-entry'
local open_view = require 'custom.plugins.diffview.open-view'

return {
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gd', open_view.open_or_refresh_diffview, desc = '[d]iff' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = 'file [h]istory' },
    },
    config = function()
      local close = { 'n', '<C-g>', function() require('diffview').close() end, { desc = 'Close Diffview' } }

      require('diffview').setup {
        enhanced_diff_hl = true,
        show_help_hints = false,
        icons = { folder_closed = '', folder_open = '' },
        keymaps = {
          file_history_panel = {
            { 'n', 'j', function() end, { desc = 'No-op' } },
            { 'n', 'k', function() end, { desc = 'No-op' } },
            { 'n', 'h', function() end, { desc = 'No-op' } },
            { 'n', 'l', function() end, { desc = 'No-op' } },
            close,
          },
          option_panel = { close },
          help_panel = { close },
          view = {
            { 'n', '<cr>', open_entry.open_file_and_close_diffview, { desc = 'Open file and close Diffview' } },
            close,
          },
          file_panel = {
            { 'n', 'j', function() end, { desc = 'No-op' } },
            { 'n', 'k', function() end, { desc = 'No-op' } },
            { 'n', 'h', function() end, { desc = 'No-op' } },
            { 'n', 'l', function() end, { desc = 'No-op' } },
            { 'n', '<cr>', open_entry.open_file_and_close_diffview, { desc = 'Open file and close Diffview' } },
            close,
          },
        },
      }

      highlights.setup()
    end,
  },
}
