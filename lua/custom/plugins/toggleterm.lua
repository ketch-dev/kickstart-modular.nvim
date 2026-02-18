-- ========== Floating Terminal ==========

local state = {
  last_terminal_id = 1,
}

local function get_terms()
  return require 'toggleterm.terminal'
end

local function close_other_open_terms(target_id)
  local terms = get_terms()
  for _, terminal in ipairs(terms.get_all(true)) do
    if terminal.id ~= target_id and terminal:is_open() then
      terminal:close()
    end
  end
end

local function ensure_terminal(id)
  local terms = get_terms()
  local terminal = terms.get(id, true)
  if terminal then
    if not terminal.display_name or terminal.display_name == '' then
      terminal.display_name = tostring(id)
    end
    return terminal
  end

  terminal = terms.get_or_create_term(id, nil, 'float', tostring(id))
  terminal.display_name = terminal.display_name or tostring(id)
  return terminal
end

local function open_terminal(terminal)
  close_other_open_terms(terminal.id)

  if terminal:is_open() then
    terminal:focus()
  else
    terminal:open(nil, 'float')
  end

  state.last_terminal_id = terminal.id
end

local function open_last_terminal()
  local terminal = ensure_terminal(state.last_terminal_id or 1)
  open_terminal(terminal)
end

local function switch_terminal(delta)
  local terms = get_terms()
  local current_id = terms.get_focused_id() or select(1, terms.identify()) or state.last_terminal_id or 1
  local target_id = math.max(1, current_id + delta)

  local terminal = terms.get(target_id, true)
  if not terminal then
    if delta < 0 then
      return
    end
    terminal = ensure_terminal(target_id)
  end

  open_terminal(terminal)
end

local function close_current_terminal()
  local terms = get_terms()
  local current_id = terms.get_focused_id() or select(1, terms.identify())
  if not current_id then
    return
  end

  local terminal = terms.get(current_id, true)
  if terminal and terminal:is_open() then
    terminal:close()
  end
end

_G.__toggleterm_switch_terminal = switch_terminal
_G.__toggleterm_close_current_terminal = close_current_terminal

local function bind_terminal_navigation_keys(terminal)
  local buffer_options = { buffer = terminal.bufnr, silent = true, noremap = true }

  vim.keymap.set('n', '<C-g>', close_current_terminal, vim.tbl_extend('force', buffer_options, { desc = 'Close terminal' }))

  vim.keymap.set('n', '<C-Left>', function()
    switch_terminal(-1)
  end, vim.tbl_extend('force', buffer_options, { desc = 'Previous terminal' }))

  vim.keymap.set('n', '<C-Right>', function()
    switch_terminal(1)
  end, vim.tbl_extend('force', buffer_options, { desc = 'Next terminal' }))

  vim.keymap.set('t', '<C-g>', [[<C-\><C-n><Cmd>lua __toggleterm_close_current_terminal()<CR>]], buffer_options)
  vim.keymap.set('t', '<C-Left>', [[<C-\><C-n><Cmd>lua __toggleterm_switch_terminal(-1)<CR>]], buffer_options)
  vim.keymap.set('t', '<C-Right>', [[<C-\><C-n><Cmd>lua __toggleterm_switch_terminal(1)<CR>]], buffer_options)

  -- Fallback for terminals that send raw ctrl-arrow escape sequences.
  vim.keymap.set('t', '<Esc>[1;5D', [[<C-\><C-n><Cmd>lua __toggleterm_switch_terminal(-1)<CR>]], buffer_options)
  vim.keymap.set('t', '<Esc>[1;5C', [[<C-\><C-n><Cmd>lua __toggleterm_switch_terminal(1)<CR>]], buffer_options)
end

return {
  {
    'akinsho/toggleterm.nvim',
    cond = not vim.g.vscode,
    version = '*',
    cmd = { 'ToggleTerm', 'TermExec' },
    keys = {
      {
        '<C-t>',
        open_last_terminal,
        mode = { 'n', 'i', 't' },
        desc = 'Open last terminal',
      },
    },
    opts = {
      open_mapping = false,
      direction = 'float',
      start_in_insert = true,
      persist_mode = false,
      on_open = function(terminal)
        state.last_terminal_id = terminal.id
        bind_terminal_navigation_keys(terminal)
      end,
      highlights = {
        NormalFloat = { link = 'NormalFloat' },
        FloatBorder = { link = 'FloatBorder' },
      },
      float_opts = {
        border = 'rounded',
      },
    },
  },
}
