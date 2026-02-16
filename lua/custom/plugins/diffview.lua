local cursor_sync_state = {
  source_path = nil,
}

local function normalize_path(path)
  if not path or path == '' then
    return nil
  end
  return vim.fn.fnamemodify(path, ':p')
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
  end
  cursor_sync_state.source_path = source_path

  local lib = require 'diffview.lib'
  local view = lib.diffview_open(args)
  if not view then
    cursor_sync_state.source_path = nil
    return
  end

  local selected_file = view.options and view.options.selected_file
  if selected_file then
    view.emitter:once('files_updated', function()
      local has_selected_file = false

      for _, file in view.files:iter() do
        if file.path == selected_file then
          has_selected_file = true
          break
        end
      end

      if has_selected_file then
        view.emitter:once('file_open_post', function()
          vim.schedule(function()
            local main = view.cur_layout and view.cur_layout:get_main_win()
            if main then
              set_win_cursor_clamped(main.id, cursor[1], cursor[2])
            end
          end)
        end)
        view:set_file_by_path(selected_file, true, true)
      end
    end)
  end

  view:open()
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
      { '<leader>gd', open_diffview_for_current_file, desc = '[G]it [D]iffview' },
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
          view = {
            { 'n', '<C-c>', close_diffview_with_cursor_sync, { desc = 'Close Diffview' } },
          },
          file_panel = {
            { 'n', '<C-c>', close_diffview_with_cursor_sync, { desc = 'Close Diffview' } },
            -- Move and auto-open ONLY files (no folder expand/collapse on movement)
            { 'n', '<Down>', move_and_preview(actions.next_entry), { desc = 'Next entry + preview file' } },
            { 'n', '<Up>', move_and_preview(actions.prev_entry), { desc = 'Prev entry + preview file' } },

            -- Folder folding on arrows (left = collapse, right = expand)
            { 'n', '<Left>', fold_action(actions.close_fold), { desc = 'Collapse folder' } },
            { 'n', '<Right>', fold_action(actions.open_fold), { desc = 'Expand folder' } },

            -- Keep Enter as an explicit "open/toggle" action if you want
            { 'n', '<CR>', actions.goto_file_edit, { desc = 'Open file' } },
          },
          file_history_panel = {
            { 'n', '<C-c>', close_diffview_with_cursor_sync, { desc = 'Close Diffview' } },
          },
          option_panel = {
            { 'n', '<C-c>', close_diffview_with_cursor_sync, { desc = 'Close Diffview' } },
          },
          help_panel = {
            { 'n', '<C-c>', close_diffview_with_cursor_sync, { desc = 'Close Diffview' } },
          },
        },
      }
    end,
  },
}
