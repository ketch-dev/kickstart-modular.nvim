local api, fn = vim.api, vim.fn

local state = { source_bufnr = nil }

local function set_cursor_clamped(winid, line, col)
  if not (winid and api.nvim_win_is_valid(winid)) then
    return
  end

  local bufnr = api.nvim_win_get_buf(winid)
  local max_line = math.max(api.nvim_buf_line_count(bufnr), 1)
  local target_line = math.min(math.max(line or 1, 1), max_line)
  local text = api.nvim_buf_get_lines(bufnr, target_line - 1, target_line, false)[1] or ''
  local target_col = math.min(math.max(col or 0, 0), #text)

  api.nvim_win_set_cursor(winid, { target_line, target_col })
end

local function close_diffview_with_cursor_sync()
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()

  if not view then
    require('diffview').close()
    return
  end

  local source_bufnr = state.source_bufnr
  local restore = nil

  local main = view.cur_layout and view.cur_layout:get_main_win()
  if source_bufnr and main and main.id and api.nvim_win_is_valid(main.id) and api.nvim_win_get_buf(main.id) == source_bufnr then
    restore = api.nvim_win_get_cursor(main.id)
  end

  require('diffview').close()

  if restore and source_bufnr then
    vim.schedule(function()
      for _, winid in ipairs(api.nvim_tabpage_list_wins(0)) do
        if api.nvim_win_get_buf(winid) == source_bufnr then
          set_cursor_clamped(winid, restore[1], restore[2])
          break
        end
      end
    end)
  end

  state.source_bufnr = nil
end

return {
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = '[G]it [D]iff' },
      {
        '<leader>gf',
        function()
          local msg = 'Current file has no changes.'
          local bufname = api.nvim_buf_get_name(0)
          if vim.bo.buftype ~= '' or bufname == '' then
            vim.notify(msg, vim.log.levels.WARN, { title = 'Diffview' })
            return
          end

          local source_bufnr = api.nvim_get_current_buf()
          local source_cursor = api.nvim_win_get_cursor(0)
          state.source_bufnr = source_bufnr

          local lib = require 'diffview.lib'
          local async = require 'diffview.async'
          local view = lib.diffview_open { '--selected-file=' .. fn.fnamemodify(bufname, ':p') }
          if not view then
            state.source_bufnr = nil
            return
          end

          local selected = view.options and view.options.selected_file
          local ok, err, files = async.pawait(view.get_updated_files, view)

          local has = ok and not err and selected and files
          if has then
            has = false
            for _, file in files:iter() do
              if file.path == selected then
                has = true
                break
              end
            end
          end

          if not has then
            lib.dispose_view(view)
            state.source_bufnr = nil
            if ok and not err then
              vim.notify(msg, vim.log.levels.WARN, { title = 'Diffview' })
            end
            return
          end

          view.emitter:once('files_updated', function()
            view.emitter:once('file_open_post', function()
              vim.schedule(function()
                local main = view.cur_layout and view.cur_layout:get_main_win()
                if main then
                  set_cursor_clamped(main.id, source_cursor[1], source_cursor[2])
                end
              end)
            end)
            view:set_file_by_path(selected, true, true)
          end)

          view:open()
          if view.panel and view.panel:is_open() then
            view.panel:close()
          end
        end,
        desc = '[G]it [F]ile',
      },
    },
    config = function()
      local actions = require 'diffview.actions'
      local lib = require 'diffview.lib'

      local close = { 'n', '<C-c>', close_diffview_with_cursor_sync, { desc = 'Close Diffview' } }

      local function move_and_preview(move)
        return function()
          move()
          local view = lib.get_current_view()
          local item = view and view.panel and view.panel:get_item_at_cursor() or nil
          if item and type(item.collapsed) ~= 'boolean' then
            actions.select_entry()
          end
        end
      end

      local function fold_action(action)
        return function()
          local view = lib.get_current_view()
          local item = view and view.panel and view.panel:get_item_at_cursor() or nil
          if item and type(item.collapsed) == 'boolean' then
            action()
          end
        end
      end

      require('diffview').setup {
        enhanced_diff_hl = true,
        show_help_hints = false,
        icons = { folder_closed = '', folder_open = '' },
        keymaps = {
          file_history_panel = { close },
          option_panel = { close },
          help_panel = { close },
          view = { close },
          file_panel = {
            ['<down>'] = false,
            ['<up>'] = false,
            ['<cr>'] = false,
            close,
            { 'n', '<down>', move_and_preview(actions.next_entry), { desc = 'Next entry + preview file' } },
            { 'n', '<up>', move_and_preview(actions.prev_entry), { desc = 'Prev entry + preview file' } },
            { 'n', '<left>', fold_action(actions.close_fold), { desc = 'Collapse folder' } },
            { 'n', '<right>', fold_action(actions.open_fold), { desc = 'Expand folder' } },
            {
              'n',
              '<cr>',
              function()
                local view = lib.get_current_view()
                if not view or not view:infer_cur_file() then
                  return
                end

                actions.goto_file_edit()

                if view.tabpage and api.nvim_tabpage_is_valid(view.tabpage) then
                  view:close()
                  lib.dispose_view(view)
                end

                state.source_bufnr = nil
              end,
              { desc = 'Open file and close Diffview' },
            },
          },
        },
      }
    end,
  },
}
