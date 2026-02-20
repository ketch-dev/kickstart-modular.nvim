local M = {}
local notified_missing_vscode = false

local function patch_hl_upvalue(func, replacement)
  for i = 1, 20 do
    local name, value = debug.getupvalue(func, i)
    if not name then
      break
    end
    if name == 'hl' then
      debug.setupvalue(func, i, replacement)
      return i, value
    end
  end
  return nil, nil
end

local core_syntax_groups = {
  Comment = true,
  Constant = true,
  String = true,
  Character = true,
  Number = true,
  Boolean = true,
  Float = true,
  Identifier = true,
  Function = true,
  Statement = true,
  Conditional = true,
  Repeat = true,
  Label = true,
  Operator = true,
  Keyword = true,
  Exception = true,
  PreProc = true,
  Include = true,
  Define = true,
  Macro = true,
  Type = true,
  StorageClass = true,
  Structure = true,
  Typedef = true,
  Special = true,
  SpecialChar = true,
  Tag = true,
  Delimiter = true,
  SpecialComment = true,
  Error = true,
  Todo = true,
}

local language_prefixes = {
  'markdown',
  'asciidoc',
  'json',
  'html',
  'php',
  'css',
  'js',
  'typescript',
  'xml',
  'ruby',
  'go',
  'python',
  'tex',
  'gitcommit',
  'lua',
  'sh',
  'sql',
  'yaml',
}

local function starts_with(str, prefix)
  return str:sub(1, #prefix) == prefix
end

local function is_language_group(group)
  for _, prefix in ipairs(language_prefixes) do
    if starts_with(group, prefix) then
      return true
    end
  end
  return false
end

local function is_syntax_group(group)
  if core_syntax_groups[group] then
    return true
  end

  if group:sub(1, 1) == '@' then
    return true
  end

  return is_language_group(group)
end

local function capture(vscode_opts)
  local ok_config, config = pcall(require, 'vscode.config')
  local ok_theme, theme = pcall(require, 'vscode.theme')
  if not (ok_config and ok_theme) then
    if not notified_missing_vscode then
      notified_missing_vscode = true
      vim.schedule(function()
        vim.notify('vscode syntax blend: vscode.nvim modules unavailable; skipping syntax overrides', vim.log.levels.WARN)
      end)
    end
    return {}
  end

  config.setup(vscode_opts or {})

  local captured = {}
  local collector = function(_, group, spec)
    captured[group] = vim.deepcopy(spec)
  end

  local set_idx, set_hl = patch_hl_upvalue(theme.set_highlights, collector)
  local link_idx, link_hl = patch_hl_upvalue(theme.link_highlight, collector)

  local global_hl = nil
  if not set_idx or not link_idx then
    global_hl = vim.api.nvim_set_hl
    vim.api.nvim_set_hl = collector
  end

  local ok_set, set_err = pcall(theme.set_highlights, config.opts)
  local ok_link, link_err = pcall(theme.link_highlight)

  if set_idx then
    debug.setupvalue(theme.set_highlights, set_idx, set_hl)
  end
  if link_idx then
    debug.setupvalue(theme.link_highlight, link_idx, link_hl)
  end
  if global_hl then
    vim.api.nvim_set_hl = global_hl
  end

  if not ok_set then
    vim.schedule(function()
      vim.notify(('vscode syntax blend: failed to read vscode highlights: %s'):format(set_err), vim.log.levels.WARN)
    end)
    return {}
  end

  if not ok_link then
    vim.schedule(function()
      vim.notify(('vscode syntax blend: failed to read vscode highlight links: %s'):format(link_err), vim.log.levels.WARN)
    end)
  end

  local syntax = {}
  for group, spec in pairs(captured) do
    if is_syntax_group(group) then
      syntax[group] = spec
    end
  end

  return syntax
end

local cache = nil
local cache_key = nil

local function key_for(opts)
  return vim.o.background .. '|' .. vim.inspect(opts or {})
end

function M.get(vscode_opts)
  local current_key = key_for(vscode_opts)
  if cache and cache_key == current_key then
    return vim.deepcopy(cache)
  end

  cache = capture(vscode_opts)
  cache_key = current_key
  return vim.deepcopy(cache)
end

return M
