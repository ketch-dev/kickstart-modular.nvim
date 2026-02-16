local state = {
  source_path = nil,
}

local function abs_path(path)
  if not path or path == '' then
    return nil
  end
  return vim.fn.fnamemodify(path, ':p')
end

local function warn_no_changes()
  vim.notify('Current file has no changes.', vim.log.levels.WARN, { title = 'Diffview' })
end

local function set_cursor_clamped(winid, line, col)
  if not (winid and vim.api.nvim_win_is_valid(winid)) then
    return
  end

  local bufnr = vim.api.nvim_win_get_buf(winid)
  local max_line = math.max(vim.api.nvim_buf_line_count(bufnr), 1)
  local target_line = math.min(math.max(line or 1, 1), max_line)
  local text = vim.api.nvim_buf_get_lines(bufnr, target_line - 1, target_line, false)[1] or ''
  local target_col = math.min(math.max(col or 0, 0), #text)

  vim.api.nvim_win_set_cursor(winid, { target_line, target_col })
end

local function restore_cursor_in_current_tab(path, line, col)
  local target_path = abs_path(path)
  if not target_path then
    return
  end

  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufnr = vim.api.nvim_win_get_buf(winid)
    if abs_path(vim.api.nvim_buf_get_name(bufnr)) == target_path then
      set_cursor_clamped(winid, line, col)
      return
    end
  end
end

local function file_dict_has_path(files, path)
  if not files or not path then
    return false
  end

  for _, file in files:iter() do
    if file.path == path then
      return true
    end
  end

  return false
end

local function open_diffview_for_current_file()
  local source_path = vim.bo.buftype == '' and abs_path(vim.api.nvim_buf_get_name(0)) or nil
  if not source_path then
    warn_no_changes()
    return
  end

  local source_cursor = vim.api.nvim_win_get_cursor(0)
  state.source_path = source_path

  local lib = require 'diffview.lib'
  local async = require 'diffview.async'
  local view = lib.diffview_open { '--selected-file=' .. source_path }

  if not view then
    state.source_path = nil
    return
  end

  local selected_file = view.options and view.options.selected_file
  local ok, err, files = async.pawait(view.get_updated_files, view)

  if (not ok) or err or not file_dict_has_path(files, selected_file) then
    lib.dispose_view(view)
    state.source_path = nil
    if ok and not err then
      warn_no_changes()
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
    view:set_file_by_path(selected_file, true, true)
  end)

  view:open()
  if view.panel and view.panel:is_open() then
    view.panel:close()
  end
end

local function close_diffview_with_cursor_sync()
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()

  if not view then
    require('diffview').close()
    return
  end

  local source_path = state.source_path
  local restore_line = nil
  local restore_col = nil

  local main = view.cur_layout and view.cur_layout:get_main_win()
  if source_path and main and main.id and vim.api.nvim_win_is_valid(main.id) then
    local main_path = abs_path((main.file and main.file.absolute_path) or vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(main.id)))
    if main_path == source_path then
      local cursor = vim.api.nvim_win_get_cursor(main.id)
      restore_line = cursor[1]
      restore_col = cursor[2]
    end
  end

  require('diffview').close()

  if restore_line then
    vim.schedule(function()
      restore_cursor_in_current_tab(source_path, restore_line, restore_col)
    end)
  end

  state.source_path = nil
end

return {
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = '[G]it [D]iff' },
      { '<leader>gf', open_diffview_for_current_file, desc = '[G]it [F]ile' },
    },
    config = function()
      local actions = require 'diffview.actions'
      local lib = require 'diffview.lib'

      local function close_map()
        return { 'n', '<C-c>', close_diffview_with_cursor_sync, { desc = 'Close Diffview' } }
      end

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
        icons = {
          folder_closed = '',
          folder_open = '',
        },
        keymaps = {
          file_history_panel = {
            close_map(),
          },
          option_panel = {
            close_map(),
          },
          help_panel = {
            close_map(),
          },
          view = {
            close_map(),
          },
          file_panel = {
            ['<down>'] = false,
            ['<up>'] = false,
            ['<cr>'] = false,
            close_map(),
            { 'n', '<down>', move_and_preview(actions.next_entry), { desc = 'Next entry + preview file' } },
            { 'n', '<up>', move_and_preview(actions.prev_entry), { desc = 'Prev entry + preview file' } },
            { 'n', '<left>', fold_action(actions.close_fold), { desc = 'Collapse folder' } },
            { 'n', '<right>', fold_action(actions.open_fold), { desc = 'Expand folder' } },
            {
              'n',
              '<cr>',
              function()
                local view = lib.get_current_view()
                if not view or not view.infer_cur_file or not view:infer_cur_file() then
                  return
                end

                actions.goto_file_edit()

                if view.tabpage and vim.api.nvim_tabpage_is_valid(view.tabpage) then
                  view:close()
                  lib.dispose_view(view)
                end

                state.source_path = nil
              end,
              { desc = 'Open file and close Diffview' },
            },
          },
        },
      }
    end,
  },
}
