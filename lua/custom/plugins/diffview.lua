local cursor_sync_state = {
  source_path = nil,
}

local function notify_current_file_has_no_changes()
  vim.notify('Current file has no changes.', vim.log.levels.WARN, { title = 'Diffview' })
end

local function normalize_path(path)
  if not path or path == '' then
    return nil
  end
  return vim.fn.fnamemodify(path, ':p')
end

local function file_dict_contains_path(files, path)
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

local function set_win_cursor_clamped(winid, line, col)
  if not (winid and vim.api.nvim_win_is_valid(winid)) then
    return
  end

  local bufnr = vim.api.nvim_win_get_buf(winid)
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local target_line = math.min(math.max(line or 1, 1), math.max(line_count, 1))
  local text = vim.api.nvim_buf_get_lines(bufnr, target_line - 1, target_line, false)[1] or ''
  local target_col = math.min(math.max(col or 0, 0), #text)

  vim.api.nvim_win_set_cursor(winid, { target_line, target_col })
end

local function restore_cursor_in_current_tab(path, line, col)
  local target_path = normalize_path(path)
  if not target_path then
    return
  end

  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufnr = vim.api.nvim_win_get_buf(winid)
    local win_path = normalize_path(vim.api.nvim_buf_get_name(bufnr))
    if win_path == target_path then
      set_win_cursor_clamped(winid, line, col)
      return
    end
  end
end

local function open_diffview_for_current_file()
  local args = {}
  local bufname = vim.api.nvim_buf_get_name(0)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local source_path = nil

  if vim.bo.buftype == '' and bufname ~= '' then
    source_path = normalize_path(bufname)
    table.insert(args, '--selected-file=' .. source_path)
  else
    notify_current_file_has_no_changes()
    return
  end
  cursor_sync_state.source_path = source_path

  local lib = require 'diffview.lib'
  local async = require 'diffview.async'
  local view = lib.diffview_open(args)
  if not view then
    cursor_sync_state.source_path = nil
    return
  end

  local selected_file = view.options and view.options.selected_file
  local ok, err, files = async.pawait(view.get_updated_files, view)

  if (not ok) or err then
    lib.dispose_view(view)
    cursor_sync_state.source_path = nil
    return
  end

  if not file_dict_contains_path(files, selected_file) then
    lib.dispose_view(view)
    cursor_sync_state.source_path = nil
    notify_current_file_has_no_changes()
    return
  end

  if selected_file then
    view.emitter:once('files_updated', function()
      view.emitter:once('file_open_post', function()
        vim.schedule(function()
          local main = view.cur_layout and view.cur_layout:get_main_win()
          if main then
            set_win_cursor_clamped(main.id, cursor[1], cursor[2])
          end
        end)
      end)
      view:set_file_by_path(selected_file, true, true)
    end)
  end

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

  local source_path = cursor_sync_state.source_path
  local restore_line = nil
  local restore_col = nil

  local main = view.cur_layout and view.cur_layout:get_main_win()
  if source_path and main and main.id and vim.api.nvim_win_is_valid(main.id) then
    local main_path = (main.file and main.file.absolute_path and normalize_path(main.file.absolute_path))
      or normalize_path(vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(main.id)))

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

  cursor_sync_state.source_path = nil
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

      -- Heuristic: treat the line as a directory if it contains Diffview's folder icon,
      -- or ends with "/" (works even when icons are disabled in some setups).
      local function is_dir_line()
        local line = vim.api.nvim_get_current_line()
        -- Default folder icons are "" (closed) and "" (open). :contentReference[oaicite:1]{index=1}
        if line:find('', 1, true) or line:find('', 1, true) then
          return true
        end
        if line:match '/%s*$' then
          return true
        end
        return false
      end

      local function move_and_preview(next_or_prev)
        return function()
          next_or_prev()
          if not is_dir_line() then
            actions.select_entry()
          end
        end
      end

      local function fold_action(open_or_close)
        return function()
          if is_dir_line() then
            open_or_close()
          end
        end
      end

      require('diffview').setup {
        enhanced_diff_hl = true,
        show_help_hints = false,
        keymaps = {
          file_history_panel = {
            { 'n', '<C-c>', close_diffview_with_cursor_sync, { desc = 'Close Diffview' } },
          },
          option_panel = {
            { 'n', '<C-c>', close_diffview_with_cursor_sync, { desc = 'Close Diffview' } },
          },
          help_panel = {
            { 'n', '<C-c>', close_diffview_with_cursor_sync, { desc = 'Close Diffview' } },
          },
          view = {
            { 'n', '<C-c>', close_diffview_with_cursor_sync, { desc = 'Close Diffview' } },
          },
          file_panel = {
            ['<down>'] = false,
            ['<up>'] = false,
            ['<cr>'] = false,
            { 'n', '<C-c>', close_diffview_with_cursor_sync, { desc = 'Close Diffview' } },
            -- Move and auto-open ONLY files (no folder expand/collapse on movement)
            { 'n', '<down>', move_and_preview(actions.next_entry), { desc = 'Next entry + preview file' } },
            { 'n', '<up>', move_and_preview(actions.prev_entry), { desc = 'Prev entry + preview file' } },

            -- Folder folding on arrows (left = collapse, right = expand)
            { 'n', '<left>', fold_action(actions.close_fold), { desc = 'Collapse folder' } },
            { 'n', '<right>', fold_action(actions.open_fold), { desc = 'Expand folder' } },

            -- Keep Enter as an explicit "open/toggle" action if you want
            { 'n', '<cr>', actions.goto_file_edit, { desc = 'Open file' } },
          },
        },
      }
    end,
  },
}
