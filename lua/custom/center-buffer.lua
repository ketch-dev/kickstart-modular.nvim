if vim.g.vscode then return end

local target_text_width = 122
local min_margin = 4
local pad_buf_var = 'custom_center_buffer_padding'

local ignored_filetypes = {
  DiffviewFiles = true,
  lazy = true,
  mason = true,
  ['neo-tree'] = true,
  qf = true,
}

local group = vim.api.nvim_create_augroup('custom-center-buffer', { clear = true })
local state = {
  applying = false,
  enabled = true,
  refresh_scheduled = false,
}

local pad_window_options = {
  colorcolumn = '',
  cursorcolumn = false,
  cursorline = false,
  foldcolumn = '0',
  list = false,
  number = false,
  relativenumber = false,
  signcolumn = 'no',
  spell = false,
  statuscolumn = '',
  statusline = ' ',
  winbar = '',
  winfixbuf = true,
  winfixwidth = true,
  winhighlight = 'EndOfBuffer:Normal,Normal:Normal,SignColumn:Normal,FoldColumn:Normal',
  wrap = false,
}

local function is_valid_win(win) return type(win) == 'number' and win ~= 0 and vim.api.nvim_win_is_valid(win) end

local function is_valid_buf(buf) return type(buf) == 'number' and buf ~= 0 and vim.api.nvim_buf_is_valid(buf) end

local function is_floating(win) return is_valid_win(win) and vim.api.nvim_win_get_config(win).relative ~= '' end

local function is_padding_buffer(buf)
  if not is_valid_buf(buf) then return false end

  local ok, value = pcall(vim.api.nvim_buf_get_var, buf, pad_buf_var)
  return ok and value == true
end

local function is_padding_window(win) return is_valid_win(win) and is_padding_buffer(vim.api.nvim_win_get_buf(win)) end

local function is_centerable(win)
  if not is_valid_win(win) or is_floating(win) or is_padding_window(win) then return false end

  local buf = vim.api.nvim_win_get_buf(win)
  if not is_valid_buf(buf) then return false end

  if vim.bo[buf].buftype ~= '' then return false end
  if ignored_filetypes[vim.bo[buf].filetype] then return false end
  if vim.wo[win].diff then return false end

  return true
end

local function get_window_info(win) return vim.fn.getwininfo(win)[1] end

local function create_pad_buffer()
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_var(buf, pad_buf_var, true)
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].buflisted = false
  vim.bo[buf].filetype = 'center-buffer-padding'
  vim.bo[buf].modifiable = true
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { '' })
  vim.bo[buf].modifiable = false

  return buf
end

local function configure_pad_window(win)
  for name, value in pairs(pad_window_options) do
    vim.api.nvim_set_option_value(name, value, { scope = 'local', win = win })
  end
end

local function close_pad_window(win)
  if is_valid_win(win) then pcall(vim.api.nvim_win_close, win, true) end
end

local function close_pad_windows(windows)
  for _, win in ipairs(windows) do
    close_pad_window(win)
  end
end

local function compare_window_position(left, right)
  local left_info = get_window_info(left)
  local right_info = get_window_info(right)

  if not left_info or not right_info then return left < right end
  if left_info.wincol == right_info.wincol then return left_info.winrow < right_info.winrow end

  return left_info.wincol < right_info.wincol
end

local function scan_tab(tabpage)
  local layout = {
    main_win = nil,
    pad_windows = {},
    user_windows = {},
  }

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
    if not is_floating(win) then
      if is_padding_window(win) then
        layout.pad_windows[#layout.pad_windows + 1] = win
      else
        layout.user_windows[#layout.user_windows + 1] = win
      end
    end
  end

  table.sort(layout.pad_windows, compare_window_position)

  if #layout.user_windows == 1 and is_centerable(layout.user_windows[1]) then layout.main_win = layout.user_windows[1] end

  return layout
end

local function close_tab_pads(tabpage) close_pad_windows(scan_tab(tabpage).pad_windows) end

local function close_all_pads()
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    close_tab_pads(tabpage)
  end
end

local function get_target_text_width() return math.max(1, math.min(target_text_width, vim.o.columns - (min_margin * 2))) end

local function get_padding_widths(main_win)
  local wininfo = get_window_info(main_win)
  if not wininfo then return 0, 0 end

  local desired_main_width = math.min(vim.o.columns, get_target_text_width() + wininfo.textoff)
  local total_padding = vim.o.columns - desired_main_width
  if total_padding < (min_margin * 2) then return 0, 0 end

  local left = math.floor(total_padding / 2)
  local right = total_padding - left
  return left, right
end

local function open_pad_window(main_win, position)
  local buf = create_pad_buffer()

  vim.api.nvim_set_current_win(main_win)
  vim.cmd(position == 'left' and 'keepalt noautocmd leftabove vsplit' or 'keepalt noautocmd rightbelow vsplit')

  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  configure_pad_window(win)

  return win
end

local function pads_need_recreate(layout, main_win)
  if #layout.pad_windows ~= 2 then return true end

  local main_info = get_window_info(main_win)
  local left_info = get_window_info(layout.pad_windows[1])
  local right_info = get_window_info(layout.pad_windows[2])
  if not main_info or not left_info or not right_info then return true end

  return not (left_info.wincol < main_info.wincol and right_info.wincol > main_info.wincol)
end

local function ensure_tab_pads(tabpage, layout, main_win, left_width, right_width)
  if pads_need_recreate(layout, main_win) then
    close_pad_windows(layout.pad_windows)

    open_pad_window(main_win, 'left')
    vim.api.nvim_set_current_win(main_win)
    open_pad_window(main_win, 'right')
    layout = scan_tab(tabpage)
  end

  if #layout.pad_windows ~= 2 then return end

  local left_pad = layout.pad_windows[1]
  local right_pad = layout.pad_windows[2]

  configure_pad_window(left_pad)
  vim.api.nvim_win_set_width(left_pad, left_width)

  configure_pad_window(right_pad)
  vim.api.nvim_win_set_width(right_pad, right_width)
end

local function restore_focus(tabpage, preferred_win)
  if is_valid_win(preferred_win) and vim.api.nvim_win_get_tabpage(preferred_win) == tabpage and not is_padding_window(preferred_win) then
    pcall(vim.api.nvim_set_current_win, preferred_win)
    return
  end

  local layout = scan_tab(tabpage)
  if layout.main_win then pcall(vim.api.nvim_set_current_win, layout.main_win) end
end

local function refresh()
  if state.applying then return end

  local tabpage = vim.api.nvim_get_current_tabpage()
  local current_win = vim.api.nvim_get_current_win()

  state.applying = true
  local ok, err = xpcall(function()
    local layout = scan_tab(tabpage)

    if not state.enabled then
      close_pad_windows(layout.pad_windows)
      restore_focus(tabpage, current_win)
      return
    end

    if layout.main_win then
      local left_width, right_width = get_padding_widths(layout.main_win)

      if left_width > 0 and right_width > 0 then
        ensure_tab_pads(tabpage, layout, layout.main_win, left_width, right_width)
      else
        close_pad_windows(layout.pad_windows)
      end
    else
      close_pad_windows(layout.pad_windows)
    end

    restore_focus(tabpage, current_win)
  end, debug.traceback)
  state.applying = false

  if not ok then vim.schedule(function() error(err) end) end
end

local function schedule_refresh()
  if not state.enabled or state.applying or state.refresh_scheduled then return end

  state.refresh_scheduled = true
  vim.schedule(function()
    state.refresh_scheduled = false
    refresh()
  end)
end

local function on_layout_event()
  if not state.enabled or state.applying then return end

  local current_win = vim.api.nvim_get_current_win()
  if is_padding_window(current_win) then
    vim.schedule(function()
      if state.applying then return end
      restore_focus(vim.api.nvim_get_current_tabpage(), nil)
    end)
    return
  end

  schedule_refresh()
end

local function on_quit_pre()
  if not state.enabled or state.applying then return end

  local tabpage = vim.api.nvim_get_current_tabpage()
  local layout = scan_tab(tabpage)
  if not layout.main_win or vim.api.nvim_get_current_win() ~= layout.main_win then return end

  state.applying = true
  close_tab_pads(tabpage)
  state.applying = false
end

local function toggle()
  state.enabled = not state.enabled

  if state.enabled then
    schedule_refresh()
    return
  end

  local tabpage = vim.api.nvim_get_current_tabpage()
  local current_win = vim.api.nvim_get_current_win()

  state.applying = true
  close_all_pads()
  state.applying = false

  restore_focus(tabpage, current_win)
end

vim.api.nvim_create_autocmd({
  'BufEnter',
  'BufWinEnter',
  'BufWinLeave',
  'FileType',
  'TabEnter',
  'TermOpen',
  'UIEnter',
  'VimEnter',
  'VimResized',
  'WinClosed',
  'WinEnter',
  'WinNew',
  'WinResized',
}, {
  group = group,
  callback = on_layout_event,
})

vim.api.nvim_create_autocmd('OptionSet', {
  group = group,
  pattern = { 'diff', 'foldcolumn', 'number', 'relativenumber', 'signcolumn' },
  callback = schedule_refresh,
})

vim.api.nvim_create_autocmd('QuitPre', {
  group = group,
  callback = on_quit_pre,
})

vim.api.nvim_create_user_command('CenterBufferToggle', toggle, {
  desc = 'Toggle centered buffer padding',
})

schedule_refresh()
