local api = vim.api

local function clear_group_bg(group)
  local ok, hl = pcall(api.nvim_get_hl, 0, { name = group, link = false })
  if not ok or vim.tbl_isempty(hl) then return end

  hl.bg = nil
  hl.ctermbg = nil
  hl.link = nil
  api.nvim_set_hl(0, group, hl)
end

local function clear_diffview_stats_bg()
  for _, group in ipairs {
    'DiffviewFilePanelInsertions',
    'DiffviewFilePanelDeletions',
    'DiffviewStatusAdded',
    'DiffviewStatusUntracked',
    'DiffviewStatusModified',
    'DiffviewStatusRenamed',
    'DiffviewStatusCopied',
    'DiffviewStatusTypeChange',
    'DiffviewStatusTypeChanged',
    'DiffviewStatusUnmerged',
    'DiffviewStatusUnknown',
    'DiffviewStatusDeleted',
    'DiffviewStatusBroken',
    'DiffviewStatusIgnored',
  } do
    clear_group_bg(group)
  end
end

local function close_diffview() require('diffview').close() end

local function open_or_refresh_diffview()
  if require('diffview.lib').get_current_view() then
    vim.cmd 'DiffviewRefresh'
  else
    vim.cmd 'DiffviewOpen'
  end
end

return {
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gd', open_or_refresh_diffview, desc = '[d]iff' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = 'file [h]istory' },
    },
    config = function()
      local actions = require 'diffview.actions'
      local lib = require 'diffview.lib'
      local augroup = api.nvim_create_augroup('custom_diffview_highlights', { clear = true })

      api.nvim_create_autocmd('ColorScheme', {
        group = augroup,
        callback = clear_diffview_stats_bg,
      })

      local close = { 'n', '<C-g>', close_diffview, { desc = 'Close Diffview' } }

      local function open_file_and_close_diffview()
        local view = lib.get_current_view()
        if not view or not view:infer_cur_file() then return end

        actions.goto_file_edit()

        if view.tabpage and api.nvim_tabpage_is_valid(view.tabpage) then
          view:close()
          lib.dispose_view(view)
        end
      end

      local function move_and_preview(move)
        return function()
          move()
          local view = lib.get_current_view()
          local item = view and view.panel and view.panel:get_item_at_cursor() or nil
          if item and type(item.collapsed) ~= 'boolean' then actions.select_entry() end
        end
      end

      local function fold_action(action)
        return function()
          local view = lib.get_current_view()
          local item = view and view.panel and view.panel:get_item_at_cursor() or nil
          if item and type(item.collapsed) == 'boolean' then action() end
        end
      end

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
            { 'n', '<down>', move_and_preview(actions.next_entry), { desc = 'Next entry + preview commit' } },
            { 'n', '<up>', move_and_preview(actions.prev_entry), { desc = 'Prev entry + preview commit' } },
          },
          option_panel = { close },
          help_panel = { close },
          view = {
            ['<cr>'] = false,
            close,
            { 'n', '<cr>', open_file_and_close_diffview, { desc = 'Open file and close Diffview' } },
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
            { 'n', '<down>', move_and_preview(actions.next_entry), { desc = 'Next entry + preview file' } },
            { 'n', '<up>', move_and_preview(actions.prev_entry), { desc = 'Prev entry + preview file' } },
            { 'n', '<left>', fold_action(actions.close_fold), { desc = 'Collapse folder' } },
            { 'n', '<right>', fold_action(actions.open_fold), { desc = 'Expand folder' } },
            { 'n', '<cr>', open_file_and_close_diffview, { desc = 'Open file and close Diffview' } },
          },
        },
      }
      clear_diffview_stats_bg()
    end,
  },
}
