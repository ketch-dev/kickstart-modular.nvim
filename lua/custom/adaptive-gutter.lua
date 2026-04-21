if vim.g.vscode then return end

local M = {}

local normal_profile = {
  foldcolumn = '0',
  numberwidth = 4,
  signcolumn = 'yes',
  statuscolumn = "%{%v:virtnum == 0 ? '%C%3{v:relnum?v:relnum:v:lnum} %s' : '' %}",
}

local wide_profile = {
  foldcolumn = '9',
  numberwidth = 20,
  signcolumn = 'yes',
  statuscolumn = "%{%v:virtnum == 0 ? '%C%19{v:relnum?v:relnum:v:lnum} %s' : '' %}",
}

local group = vim.api.nvim_create_augroup('custom-adaptive-gutter', { clear = true })
local refresh_scheduled = false

local function is_valid_win(win) return type(win) == 'number' and win ~= 0 and vim.api.nvim_win_is_valid(win) end

local function is_floating(win) return is_valid_win(win) and vim.api.nvim_win_get_config(win).relative ~= '' end

local function set_gutter_profile(win, profile)
  vim.api.nvim_set_option_value('foldcolumn', profile.foldcolumn, { scope = 'local', win = win })
  vim.api.nvim_set_option_value('numberwidth', profile.numberwidth, { scope = 'local', win = win })
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
    set_gutter_profile(win, profile)
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
