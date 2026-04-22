if vim.g.vscode then return end

local M = {}

local ignored_filetypes = {
  DiffviewFileHistory = true,
  DiffviewFiles = true,
}

local normal_profile = {
  foldcolumn = '0',
  number = true,
  numberwidth = 4,
  relativenumber = true,
  signcolumn = 'yes',
  statuscolumn = "%{%v:virtnum == 0 ? '%C%s%3{v:relnum?v:relnum:v:lnum} ' : '' %}",
}

local panel_profile = {
  foldcolumn = '0',
  number = false,
  numberwidth = 4,
  relativenumber = false,
  signcolumn = 'yes',
  statuscolumn = '',
}

local wide_profile = {
  foldcolumn = '9',
  number = true,
  numberwidth = 20,
  relativenumber = true,
  signcolumn = 'yes',
  statuscolumn = "%{%v:virtnum == 0 ? '%C%s %19{v:relnum?v:relnum:v:lnum} ' : '' %}",
}

local group = vim.api.nvim_create_augroup('custom-adaptive-gutter', { clear = true })
local refresh_scheduled = false

local function is_valid_win(win) return type(win) == 'number' and win ~= 0 and vim.api.nvim_win_is_valid(win) end

local function is_floating(win) return is_valid_win(win) and vim.api.nvim_win_get_config(win).relative ~= '' end

local function is_ignored_filetype(win)
  if not is_valid_win(win) then return false end

  local buf = vim.api.nvim_win_get_buf(win)
  return ignored_filetypes[vim.bo[buf].filetype] == true
end

local function set_gutter_profile(win, profile)
  vim.api.nvim_set_option_value('foldcolumn', profile.foldcolumn, { scope = 'local', win = win })
  vim.api.nvim_set_option_value('number', profile.number, { scope = 'local', win = win })
  vim.api.nvim_set_option_value('numberwidth', profile.numberwidth, { scope = 'local', win = win })
  vim.api.nvim_set_option_value('relativenumber', profile.relativenumber, { scope = 'local', win = win })
  vim.api.nvim_set_option_value('signcolumn', profile.signcolumn, { scope = 'local', win = win })
  vim.api.nvim_set_option_value('statuscolumn', profile.statuscolumn, { scope = 'local', win = win })
end

function M.refresh(tabpage)
  tabpage = tabpage or vim.api.nvim_get_current_tabpage()

  local windows = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
    if not is_floating(win) then windows[#windows + 1] = win end
  end

  local profile = #windows == 1 and wide_profile or normal_profile
  for _, win in ipairs(windows) do
    set_gutter_profile(win, is_ignored_filetype(win) and panel_profile or profile)
  end
end

local function schedule_refresh()
  if refresh_scheduled then return end

  refresh_scheduled = true
  vim.schedule(function()
    refresh_scheduled = false
    M.refresh()
  end)
end

function M.setup()
  vim.api.nvim_create_autocmd({
    'BufWinEnter',
    'FileType',
    'TabEnter',
    'VimEnter',
    'VimResized',
    'WinClosed',
    'WinEnter',
    'WinNew',
  }, {
    group = group,
    callback = schedule_refresh,
  })

  schedule_refresh()
end

return M
