local api = vim.api

local M = {}

local function close_and_dispose_view(view)
  if view.tabpage and api.nvim_tabpage_is_valid(view.tabpage) then
    view:close()
    require('diffview.lib').dispose_view(view)
  end
end

local function open_buf_in_prev_tab(bufnr, cursor)
  local lib = require 'diffview.lib'
  local target_tab = lib.get_prev_non_view_tabpage()

  if target_tab then
    api.nvim_set_current_tabpage(target_tab)
    api.nvim_win_set_buf(0, bufnr)
  else
    vim.cmd 'tabnew'
    local temp_bufnr = api.nvim_get_current_buf()
    api.nvim_win_set_buf(0, bufnr)

    if temp_bufnr ~= bufnr and api.nvim_buf_is_valid(temp_bufnr) then api.nvim_buf_delete(temp_bufnr, { force = true }) end
  end

  if cursor then pcall(api.nvim_win_set_cursor, 0, cursor) end
end

local function create_snapshot_buf(file, source_bufnr)
  local source_name = api.nvim_buf_get_name(source_bufnr)
  local base_name = source_name ~= '' and source_name:gsub('^diffview://', 'diffview-open://', 1) or ('diffview-open://' .. (file.oldpath or file.path))
  local snapshot_name = base_name
  local suffix = 2

  while vim.fn.bufexists(snapshot_name) == 1 do
    snapshot_name = string.format('%s (%d)', base_name, suffix)
    suffix = suffix + 1
  end

  local snapshot_bufnr = api.nvim_create_buf(true, false)
  local lines = api.nvim_buf_get_lines(source_bufnr, 0, -1, false)

  api.nvim_buf_set_name(snapshot_bufnr, snapshot_name)
  vim.bo[snapshot_bufnr].buftype = 'nofile'
  vim.bo[snapshot_bufnr].bufhidden = 'hide'
  vim.bo[snapshot_bufnr].swapfile = false
  vim.bo[snapshot_bufnr].modifiable = true
  api.nvim_buf_set_lines(snapshot_bufnr, 0, -1, false, lines)
  vim.bo[snapshot_bufnr].modifiable = false
  vim.bo[snapshot_bufnr].modified = false
  vim.bo[snapshot_bufnr].readonly = true
  vim.bo[snapshot_bufnr].filetype = vim.bo[source_bufnr].filetype

  return snapshot_bufnr
end

function M.open_file_and_close_diffview()
  local actions = require 'diffview.actions'
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()
  local entry = view and view:infer_cur_file() or nil

  if not view or not entry then return end

  if not view.panel:is_focused() then
    local current_win = api.nvim_get_current_win()
    local current_layout = view.cur_layout
    local diff_win

    for _, win in ipairs(current_layout and current_layout.windows or {}) do
      if win.id == current_win then
        diff_win = win
        break
      end
    end

    if diff_win and diff_win.file and diff_win.file.symbol == 'a' then
      if diff_win:is_nulled() then return end

      -- Diffview disposes non-local revision buffers on close, so copy the
      -- visible left-side content into a standalone read-only buffer first.
      local source_bufnr = api.nvim_get_current_buf()
      local cursor = api.nvim_win_get_cursor(current_win)
      local snapshot_bufnr = create_snapshot_buf(entry, source_bufnr)

      open_buf_in_prev_tab(snapshot_bufnr, cursor)
      close_and_dispose_view(view)
      return
    end
  end

  actions.goto_file_edit()
  close_and_dispose_view(view)
end

return M
