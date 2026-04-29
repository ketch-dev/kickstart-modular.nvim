local highlights = require 'custom.plugins.diffview.highlights'
local open_entry = require 'custom.plugins.diffview.open-entry'
local open_view = require 'custom.plugins.diffview.open-view'
local preview_entry = require 'custom.plugins.diffview.preview-entry'

local function fold_action(action)
  return function()
    local view = require('diffview.lib').get_current_view()
    local item = view and view.panel and view.panel:get_item_at_cursor() or nil

    if item and type(item.collapsed) == 'boolean' then action() end
  end
end

return {
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gd', open_view.open_or_refresh_diffview, desc = '[d]iff' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = 'file [h]istory' },
    },
    config = function()
      local actions = require 'diffview.actions'
      local close = { 'n', '<C-g>', function() require('diffview').close() end, { desc = 'Close Diffview' } }

      require('diffview').setup {
        enhanced_diff_hl = true,
        show_help_hints = false,
        icons = { folder_closed = '', folder_open = '' },
        keymaps = {
          file_history_panel = {
            ['h'] = false,
            ['j'] = false,
            ['k'] = false,
            ['l'] = false,
            ['<down>'] = false,
            ['<up>'] = false,
            close,
            { 'n', '<down>', preview_entry.move_and_preview(actions.next_entry), { desc = 'Next entry + preview commit' } },
            { 'n', '<up>', preview_entry.move_and_preview(actions.prev_entry), { desc = 'Prev entry + preview commit' } },
          },
          option_panel = { close },
          help_panel = { close },
          view = {
            ['<cr>'] = false,
            close,
            { 'n', '<cr>', open_entry.open_file_and_close_diffview, { desc = 'Open file and close Diffview' } },
          },
          file_panel = {
            ['h'] = false,
            ['j'] = false,
            ['k'] = false,
            ['l'] = false,
            ['<down>'] = false,
            ['<up>'] = false,
            ['<cr>'] = false,
            close,
            { 'n', '<down>', preview_entry.move_and_preview(actions.next_entry), { desc = 'Next entry + preview file' } },
            { 'n', '<up>', preview_entry.move_and_preview(actions.prev_entry), { desc = 'Prev entry + preview file' } },
            { 'n', '<left>', fold_action(actions.close_fold), { desc = 'Collapse folder' } },
            { 'n', '<right>', fold_action(actions.open_fold), { desc = 'Expand folder' } },
            { 'n', '<cr>', open_entry.open_file_and_close_diffview, { desc = 'Open file and close Diffview' } },
          },
        },
      }

      highlights.setup()
    end,
  },
}
