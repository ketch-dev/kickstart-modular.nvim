if vim.g.vscode then return end

local M = {}

local target_text_width = 100
local min_margin = 4

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
  refresh_scheduled = false,
  tabs = {},
}

local function is_valid_win(win) return type(win) == 'number' and win ~= 0 and vim.api.nvim_win_is_valid(win) end

local function is_valid_buf(buf) return type(buf) == 'number' and buf ~= 0 and vim.api.nvim_buf_is_valid(buf) end

local function is_floating(win) return is_valid_win(win) and vim.api.nvim_win_get_config(win).relative ~= '' end

local function get_buf_var(buf, name)
  local ok, value = pcall(vim.api.nvim_buf_get_var, buf, name)
  if ok then return value end
  return nil
end

local function is_padding_buffer(buf) return is_valid_buf(buf) and get_buf_var(buf, 'custom_center_buffer_padding') == true end

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

local function create_pad_buffer()
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_var(buf, 'custom_center_buffer_padding', true)
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'center-buffer-padding'
  vim.bo[buf].modifiable = true
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { '' })
  vim.bo[buf].modifiable = false

  return buf
end

local function configure_pad_window(win)
  local local_options = {
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
    winfixwidth = true,
    winhighlight = 'EndOfBuffer:Normal,Normal:Normal,SignColumn:Normal,FoldColumn:Normal',
    wrap = false,
  }

  for name, value in pairs(local_options) do
    vim.api.nvim_set_option_value(name, value, { scope = 'local', win = win })
  end
end

local function close_pad_window(win)
  if is_valid_win(win) then pcall(vim.api.nvim_win_close, win, true) end
end

local function close_tab_pads(tabpage)
  local entry = state.tabs[tabpage]
  if not entry then return end

  state.tabs[tabpage] = nil
  close_pad_window(entry.left_win)
  close_pad_window(entry.right_win)
end

local function list_user_windows(tabpage)
  local windows = {}

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
    if not is_floating(win) and not is_padding_window(win) then windows[#windows + 1] = win end
  end

  return windows
end

local function get_single_main_window(tabpage)
  local windows = list_user_windows(tabpage)
  if #windows ~= 1 then return nil end

  local main_win = windows[1]
  if not is_centerable(main_win) then return nil end

  return main_win
end

local function get_target_text_width() return math.max(1, math.min(target_text_width, vim.o.columns - (min_margin * 2))) end

local function get_padding_widths(main_win)
  local wininfo = vim.fn.getwininfo(main_win)[1]
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

  return win, buf
end

local function ensure_tab_pads(tabpage, main_win, left_width, right_width)
  local entry = state.tabs[tabpage]
  local needs_recreate = not entry or entry.main_win ~= main_win or not is_valid_win(entry.left_win) or not is_valid_win(entry.right_win)

  if needs_recreate then
    close_tab_pads(tabpage)

    entry = { main_win = main_win }
    entry.left_win, entry.left_buf = open_pad_window(main_win, 'left')

    vim.api.nvim_set_current_win(main_win)
    entry.right_win, entry.right_buf = open_pad_window(main_win, 'right')
    state.tabs[tabpage] = entry
  end

  entry.main_win = main_win

  if is_valid_win(entry.left_win) then
    configure_pad_window(entry.left_win)
    vim.api.nvim_win_set_width(entry.left_win, left_width)
  end

  if is_valid_win(entry.right_win) then
    configure_pad_window(entry.right_win)
    vim.api.nvim_win_set_width(entry.right_win, right_width)
  end
end

local function restore_focus(tabpage, preferred_win)
  if is_valid_win(preferred_win) and vim.api.nvim_win_get_tabpage(preferred_win) == tabpage and not is_padding_window(preferred_win) then
    pcall(vim.api.nvim_set_current_win, preferred_win)
    return
  end

  local entry = state.tabs[tabpage]
  if entry and is_valid_win(entry.main_win) and vim.api.nvim_win_get_tabpage(entry.main_win) == tabpage then
    pcall(vim.api.nvim_set_current_win, entry.main_win)
  end
end

local function refresh()
  if state.applying then return end

  local tabpage = vim.api.nvim_get_current_tabpage()
  local current_win = vim.api.nvim_get_current_win()
  local main_win = get_single_main_window(tabpage)

  state.applying = true

  if main_win then
    local left_width, right_width = get_padding_widths(main_win)

    if left_width > 0 and right_width > 0 then
      ensure_tab_pads(tabpage, main_win, left_width, right_width)
    else
      close_tab_pads(tabpage)
    end
  else
    close_tab_pads(tabpage)
  end

  restore_focus(tabpage, current_win)
  state.applying = false
end

local function schedule_refresh()
  if state.applying or state.refresh_scheduled then return end

  state.refresh_scheduled = true
  vim.schedule(function()
    state.refresh_scheduled = false
    refresh()
  end)
end

M.refresh = refresh

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
  callback = function()
    if state.applying then return end

    local current_win = vim.api.nvim_get_current_win()
    if is_padding_window(current_win) then
      vim.schedule(function()
        if state.applying then return end
        restore_focus(vim.api.nvim_get_current_tabpage(), nil)
      end)
      return
    end

    schedule_refresh()
  end,
})

vim.api.nvim_create_autocmd('OptionSet', {
  group = group,
  pattern = { 'diff', 'foldcolumn', 'number', 'relativenumber', 'signcolumn' },
  callback = schedule_refresh,
})

vim.api.nvim_create_autocmd('QuitPre', {
  group = group,
  callback = function()
    if state.applying then return end

    local tabpage = vim.api.nvim_get_current_tabpage()
    local entry = state.tabs[tabpage]
    if not entry or vim.api.nvim_get_current_win() ~= entry.main_win then return end

    state.applying = true
    close_tab_pads(tabpage)
    state.applying = false
  end,
})

schedule_refresh()

return M
