local shortcuts = require 'shortcuts'
local suffixes = require 'shortcut_suffixes'

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'clear search highlights' })
vim.keymap.set('v', 'p', 'P', { desc = 'paste' })
vim.keymap.set('n', '<Del>', '"_x', { desc = 'delete forward' })
vim.keymap.set('n', '<BS>', '"_dh', { desc = 'delete backward' })
vim.keymap.set({ 'i', 'c' }, '<C-BS>', '<C-w>', { desc = 'delete word forward' })
vim.keymap.set('i', '<C-Del>', '<C-o>dw', { desc = 'delete word backward' })
vim.keymap.set('n', shortcuts.kill_buffer, '<cmd>bdelete<CR>', { desc = '[k]ill buffer' })
vim.keymap.set('n', 'U', '<C-r>', { desc = 'redo' })

-- ========== Exit command mode ==========
vim.keymap.set('c', shortcuts.leave, '<C-c>', { noremap = true, silent = true, desc = '[l]eave cmdline' })
vim.keymap.set('c', '<Esc>', '<Nop>', { noremap = true, silent = true, desc = 'disable cmdline ESC' })
-------------------------------------------------------------------------------

-- ========== Prevent closing cmdline on backspace when empty ==========
vim.keymap.set(
  'c',
  '<BS>',
  function() return vim.fn.getcmdpos() <= 1 and '' or '<BS>' end,
  { expr = true, noremap = true, desc = 'prevent closing cmdline on backspace when empty' }
)
-------------------------------------------------------------------------------

-- ========== Diagnostic ==========
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  signs = false,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = false, -- Text shows up at the end of the line
  virtual_lines = true,
  jump = { float = true },
}
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'prev [d]iagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'next [d]iagnostic' })
vim.keymap.set('n', '<leader>sd', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = '[d]iagnostic' })
-------------------------------------------------------------------------------

-- ========== Disable hjkl ==========
vim.keymap.set({ 'n', 'v' }, 'h', '<Nop>', { desc = 'disable h' })
vim.keymap.set({ 'n', 'v' }, 'j', '<Nop>', { desc = 'disable j' })
vim.keymap.set({ 'n', 'v' }, 'k', '<Nop>', { desc = 'disable k' })
vim.keymap.set({ 'n', 'v' }, 'l', '<Nop>', { desc = 'disable l' })
-------------------------------------------------------------------------------

-- ========== Mouse wheel scroll without EOF overscroll ==========
local function wheel_scroll(direction)
  local at_edge = (direction > 0 and vim.fn.line 'w$' >= vim.fn.line '$') or (direction < 0 and vim.fn.line 'w0' <= 1)
  if at_edge then return '' end

  local keys = direction > 0 and '3<C-e>' or '3<C-y>'
  if vim.api.nvim_get_mode().mode:sub(1, 1) == 'i' then return '<C-o>' .. keys end
  return keys
end

vim.keymap.set(
  { 'n', 'i', 'v' },
  '<ScrollWheelDown>',
  function() return wheel_scroll(1) end,
  { expr = true, silent = true, desc = 'scroll down without overscroll' }
)
vim.keymap.set(
  { 'n', 'i', 'v' },
  '<ScrollWheelUp>',
  function() return wheel_scroll(-1) end,
  { expr = true, silent = true, desc = 'scroll up without overscroll' }
)

-- ========== Horizontal scroll with Shift+MouseWheel ==========
local function horizontal_wheel_scroll(direction)
  local keys = direction > 0 and '5zl' or '5zh'
  if vim.api.nvim_get_mode().mode:sub(1, 1) == 'i' then return '<C-o>' .. keys end
  return keys
end

vim.keymap.set(
  { 'n', 'i', 'v' },
  '<S-ScrollWheelDown>',
  function() return horizontal_wheel_scroll(1) end,
  { expr = true, silent = true, desc = 'scroll right' }
)
vim.keymap.set({ 'n', 'i', 'v' }, '<S-ScrollWheelUp>', function() return horizontal_wheel_scroll(-1) end, { expr = true, silent = true, desc = 'scroll left' })
vim.keymap.set({ 'n', 'i', 'v' }, '<ScrollWheelRight>', function() return horizontal_wheel_scroll(1) end, { expr = true, silent = true, desc = 'scroll right' })
vim.keymap.set({ 'n', 'i', 'v' }, '<ScrollWheelLeft>', function() return horizontal_wheel_scroll(-1) end, { expr = true, silent = true, desc = 'scroll left' })
vim.keymap.set({ 'n', 'i', 'v' }, '<S-Left>', function() return horizontal_wheel_scroll(-1) end, { expr = true, silent = true, desc = 'scroll left' })
vim.keymap.set({ 'n', 'i', 'v' }, '<S-Right>', function() return horizontal_wheel_scroll(1) end, { expr = true, silent = true, desc = 'scroll right' })
-------------------------------------------------------------------------------

-- ========== Focus windows with arrows ==========
vim.keymap.set('n', '<C-Left>', '<C-w><C-h>', { desc = 'move focus to the left window' })
vim.keymap.set('n', '<C-Right>', '<C-w><C-l>', { desc = 'move focus to the right window' })
vim.keymap.set('n', '<C-Down>', '<C-w><C-j>', { desc = 'move focus to the lower window' })
vim.keymap.set('n', '<C-Up>', '<C-w><C-k>', { desc = 'move focus to the upper window' })
-------------------------------------------------------------------------------

-- ========== Move windows with arrows ==========
vim.keymap.set('n', '<C-A-Left>', '<C-w>H', { desc = 'move window to the left' })
vim.keymap.set('n', '<C-A-Right>', '<C-w>L', { desc = 'move window to the right' })
vim.keymap.set('n', '<C-A-Down>', '<C-w>J', { desc = 'move window to the lower' })
vim.keymap.set('n', '<C-A-Up>', '<C-w>K', { desc = 'move window to the upper' })
-------------------------------------------------------------------------------

-- ========== Save with ctrl-s ==========
vim.keymap.set('n', shortcuts.save, ':w<CR>', { noremap = true, silent = true, desc = '[s]ave' })
vim.keymap.set('i', shortcuts.save, '<Esc>:w<CR>a', { noremap = true, silent = true, desc = '[s]ave' })
vim.keymap.set('v', shortcuts.save, '<Esc>:w<CR>', { noremap = true, silent = true, desc = '[s]ave' })
-------------------------------------------------------------------------------

-- ========== Make 'd' and 'c' to not copy ==========
vim.keymap.set({ 'n', 'v' }, 'd', '"_d', { noremap = true, desc = 'delete' })
vim.keymap.set('n', 'D', '"_D', { noremap = true, desc = 'delete to line end' })
vim.keymap.set({ 'n', 'v' }, 'c', '"_c', { noremap = true, desc = 'change' })
vim.keymap.set('n', 'C', '"_C', { noremap = true, desc = 'change line' })
-------------------------------------------------------------------------------

-- ========== Map 'x' to cut ==========
vim.keymap.set({ 'n', 'v' }, 'x', 'd', { noremap = true, desc = 'cut' })
vim.keymap.set('n', 'X', 'D', { noremap = true, desc = 'cut to line end' })
vim.keymap.set('n', 'xx', 'dd', { noremap = true, desc = 'cut line' })
-------------------------------------------------------------------------------

-- ========== Window ==========
vim.keymap.set('n', '<leader>ws', '<C-w>v', { desc = '[s]plit' })
vim.keymap.set('n', '<leader>wh', '<C-w>s', { desc = '[h]orizontal split' })
vim.keymap.set('n', '<leader>we', '<C-w>=', { desc = '[e]qual' })
vim.keymap.set('n', '<leader>w' .. suffixes.kill, '<cmd>close<CR>', { desc = '[k]ill' })
-------------------------------------------------------------------------------

-- ========== Tabs ==========
vim.keymap.set('n', '<leader>po', '<cmd>tabnew<CR>', { desc = '[o]pen' })
vim.keymap.set('n', '<leader>p' .. suffixes.kill, '<cmd>tabclose<CR>', { desc = '[k]ill' })
vim.keymap.set('n', '<leader>pn', '<cmd>tabn<CR>', { desc = '[n]ext' })
vim.keymap.set('n', '<leader>pp', '<cmd>tabp<CR>', { desc = '[p]rev' })
vim.keymap.set('n', '<leader>pb', '<cmd>tabnew %<CR>', { desc = 'move [b]uffer to new tab' })
-------------------------------------------------------------------------------

-- ========== Highlight when yanking (copying) text ==========
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})
-------------------------------------------------------------------------------

-- ========== Disable line numbers in terminal mode ==========
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})
-------------------------------------------------------------------------------
