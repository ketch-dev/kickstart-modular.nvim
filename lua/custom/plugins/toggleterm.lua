-- ========== Floating Terminal ==========

local AI_ID_BASE = 10000

local kinds = {
  numeric = {
    id_base = 0,
    prefix = '',
    command = nil,
  },
  ai = {
    id_base = AI_ID_BASE,
    prefix = 'AI-',
    command = 'opencode --port',
  },
}

local state = {
  last_index = {
    numeric = 1,
    ai = 1,
  },
  kind_by_id = {},
}

local function get_terms() return require 'toggleterm.terminal' end

local function get_kind_config(kind) return assert(kinds[kind], 'Unknown terminal kind: ' .. tostring(kind)) end

local function get_terminal_id(kind, index)
  local config = get_kind_config(kind)
  return config.id_base + index
end

local function get_terminal_index(kind, terminal_id)
  local config = get_kind_config(kind)
  local index = terminal_id - config.id_base
  if index < 1 then return nil end
  return index
end

local function get_terminal_name(kind, index)
  local config = get_kind_config(kind)
  if config.prefix == '' then return tostring(index) end
  return config.prefix .. index
end

local function detect_kind(terminal)
  if not terminal then return nil end

  local known_kind = state.kind_by_id[terminal.id]
  if known_kind then return known_kind end

  local name = terminal.display_name or ''
  if name:match '^AI%-%d+$' then return 'ai' end

  return 'numeric'
end

local function close_other_open_terms(target_id)
  local terms = get_terms()
  for _, terminal in ipairs(terms.get_all(true)) do
    if terminal.id ~= target_id and terminal:is_open() then terminal:close() end
  end
end

local function ensure_terminal(kind, index)
  local terms = get_terms()
  local config = get_kind_config(kind)
  local terminal_id = get_terminal_id(kind, index)
  local terminal_name = get_terminal_name(kind, index)
  local terminal, created = terms.get_or_create_term(terminal_id, nil, 'float', terminal_name)

  state.kind_by_id[terminal_id] = kind
  terminal.display_name = terminal_name

  if created and config.command then terminal.cmd = config.command end

  return terminal
end

local function open_terminal(kind, index)
  local terminal = ensure_terminal(kind, index)
  close_other_open_terms(terminal.id)

  if terminal:is_open() then
    terminal:focus()
  else
    terminal:open(nil, 'float')
  end

  state.last_index[kind] = index
end

local function open_last_terminal(kind) open_terminal(kind, state.last_index[kind] or 1) end

local function resolve_current_index(kind)
  local terms = get_terms()
  local current_id = terms.get_focused_id() or select(1, terms.identify())
  if current_id then
    local current_terminal = terms.get(current_id, true)
    if current_terminal and detect_kind(current_terminal) == kind then
      local index = get_terminal_index(kind, current_id)
      if index then return index end
    end
  end

  return state.last_index[kind] or 1
end

local function switch_terminal(kind, delta)
  local terms = get_terms()
  local current_index = resolve_current_index(kind)
  local target_index = math.max(1, current_index + delta)
  local target_id = get_terminal_id(kind, target_index)

  local terminal = terms.get(target_id, true)
  if not terminal then
    if delta < 0 then return end
  end

  open_terminal(kind, target_index)
end

local function close_current_terminal()
  local terms = get_terms()
  local current_id = terms.get_focused_id() or select(1, terms.identify())
  if not current_id then return end

  local terminal = terms.get(current_id, true)
  if terminal and terminal:is_open() then terminal:close() end
end

_G.__toggleterm_switch_terminal = switch_terminal
_G.__toggleterm_close_current_terminal = close_current_terminal
_G.__toggleterm_open_ai = function() open_last_terminal 'ai' end

local function bind_terminal_navigation_keys(terminal)
  local kind = detect_kind(terminal) or 'numeric'
  local prev_term_cmd = string.format([[<C-\><C-n><Cmd>lua __toggleterm_switch_terminal('%s', -1)<CR>]], kind)
  local next_term_cmd = string.format([[<C-\><C-n><Cmd>lua __toggleterm_switch_terminal('%s', 1)<CR>]], kind)
  local buffer_options = { buffer = terminal.bufnr, silent = true, noremap = true }

  vim.keymap.set('n', '<C-k>', close_current_terminal, vim.tbl_extend('force', buffer_options, { desc = '[k]ill terminal' }))

  vim.keymap.set('n', '<C-Left>', function() switch_terminal(kind, -1) end, vim.tbl_extend('force', buffer_options, { desc = 'prev terminal' }))

  vim.keymap.set('n', '<C-Right>', function() switch_terminal(kind, 1) end, vim.tbl_extend('force', buffer_options, { desc = 'next terminal' }))

  vim.keymap.set('t', '<C-k>', [[<C-\><C-n><Cmd>lua __toggleterm_close_current_terminal()<CR>]], vim.tbl_extend('force', buffer_options, { desc = '[k]ill terminal' }))
  vim.keymap.set('t', '<C-Left>', prev_term_cmd, vim.tbl_extend('force', buffer_options, { desc = 'prev terminal' }))
  vim.keymap.set('t', '<C-Right>', next_term_cmd, vim.tbl_extend('force', buffer_options, { desc = 'next terminal' }))

  -- Fallback for terminals that send raw ctrl-arrow escape sequences.
  vim.keymap.set('t', '<Esc>[1;5D', prev_term_cmd, vim.tbl_extend('force', buffer_options, { desc = 'prev terminal' }))
  vim.keymap.set('t', '<Esc>[1;5C', next_term_cmd, vim.tbl_extend('force', buffer_options, { desc = 'next terminal' }))
end

local function persist_terminal_buffer(terminal)
  if terminal and terminal.bufnr and vim.api.nvim_buf_is_valid(terminal.bufnr) then vim.bo[terminal.bufnr].bufhidden = 'hide' end
end

vim.pack.add { { src = 'https://github.com/akinsho/toggleterm.nvim', version = vim.version.range '*' } }

vim.keymap.set({ 'n', 'i', 't' }, '<C-t>', function() open_last_terminal 'numeric' end, { desc = 'open last [t]erminal' })
vim.keymap.set('n', '<leader>au', function() open_last_terminal 'ai' end, { desc = '[u]i' })

require('toggleterm').setup {
  open_mapping = false,
  direction = 'float',
  start_in_insert = true,
  persist_mode = false,
  on_create = function(terminal) persist_terminal_buffer(terminal) end,
  on_open = function(terminal)
    persist_terminal_buffer(terminal)
    local kind = detect_kind(terminal)
    local index = kind and get_terminal_index(kind, terminal.id)
    if kind and index then state.last_index[kind] = index end
    bind_terminal_navigation_keys(terminal)
  end,
  highlights = {
    NormalFloat = { link = 'NormalFloat' },
    FloatBorder = { link = 'FloatBorder' },
  },
  float_opts = {
    border = 'rounded',
    width = function() return math.floor(vim.o.columns * 0.9) end,
    height = function() return math.floor(vim.o.lines * 0.84) end,
  },
}
