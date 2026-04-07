vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- Clear highlights on search when pressing <Esc> in normal mode

vim.keymap.set('v', 'p', 'P') -- Make 'p' to not copy
vim.keymap.set('n', '<Del>', '"_x') -- 'Del' to delete 1 char forward
vim.keymap.set('n', '<BS>', '"_dh') -- 'Backspace' to delete 1 char backward
vim.keymap.set({ 'i', 'c' }, '<C-BS>', '<C-w>', { desc = 'Delete previous word' })
vim.keymap.set('i', '<C-Del>', '<C-o>dw', { desc = 'Delete forward word' })
vim.keymap.set('n', '<C-g>', '<cmd>bdelete<cr>', { desc = 'Close buffer' })

-- ========== Exit command mode ==========
vim.keymap.set('c', '<C-g>', '<C-c>', { noremap = true, silent = true, desc = 'Cancel cmdline' })
vim.keymap.set('c', '<Esc>', '<Nop>', { noremap = true, silent = true, desc = 'Disable cmdline Esc' })
-------------------------------------------------------------------------------
-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = false, -- Text shows up at the end of the line
  virtual_lines = true, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = '[d]iagnostic list' })

-- ========== Diagnostics ==========
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'prev [d]iagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'next [d]iagnostic' })
-------------------------------------------------------------------------------

-- ========== Disable hjkl ==========
vim.keymap.set({ 'n', 'v' }, 'j', '<Nop>')
vim.keymap.set({ 'n', 'v' }, 'k', '<Nop>')
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
  { expr = true, silent = true, desc = 'Scroll down without EOF overscroll' }
)
vim.keymap.set(
  { 'n', 'i', 'v' },
  '<ScrollWheelUp>',
  function() return wheel_scroll(-1) end,
  { expr = true, silent = true, desc = 'Scroll up without top overscroll' }
)
-------------------------------------------------------------------------------

-- ========== Focus windows with arrows ==========
vim.keymap.set('n', '<C-left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-------------------------------------------------------------------------------

-- ========== Move windows with arrows ==========
vim.keymap.set('n', '<C-A-left>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-A-right>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-A-down>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-A-up>', '<C-w>K', { desc = 'Move window to the upper' })
-------------------------------------------------------------------------------

-- ========== Save with ctrl-s ==========
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { noremap = true, silent = true })
vim.keymap.set('v', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true })
-------------------------------------------------------------------------------

-- ========== Make 'd' and 'c' to not copy ==========
vim.keymap.set({ 'n', 'v' }, 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'D', '"_D', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'c', '"_c', { noremap = true })
vim.keymap.set('n', 'C', '"_C', { noremap = true })
-------------------------------------------------------------------------------

-- ========== Map 'x' to cut ==========
vim.keymap.set({ 'n', 'v' }, 'x', 'd', { noremap = true })
vim.keymap.set('n', 'X', 'D', { noremap = true })
vim.keymap.set('n', 'xx', 'dd', { noremap = true })
-------------------------------------------------------------------------------

-- ========== Explorer ==========
local toggle_both_sides = require('custom.utils.neotree-toggle-both-sides').toggle_both_sides
vim.keymap.set('n', '<leader>et', toggle_both_sides, { desc = '[t]oggle' })
vim.keymap.set('n', '<leader>ef', '<cmd>Neotree filesystem reveal left show<CR>', { desc = '[f]iles' })
vim.keymap.set('n', '<leader>eb', '<cmd>Neotree buffers reveal left show<CR>', { desc = '[b]uffers' })
vim.keymap.set('n', '<leader>eg', '<cmd>Neotree git_status reveal right show<CR>', { desc = '[g]it' })
-------------------------------------------------------------------------------

-- ========== Split ==========
vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = '[v]ertical' })
vim.keymap.set('n', '<leader>sh', '<C-w>s', { desc = '[h]orizontal' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = '[e]qual' })
vim.keymap.set('n', '<leader>sk', '<cmd>close<CR>', { desc = '[k]ill' })
-------------------------------------------------------------------------------

-- ========== Tabs ==========
vim.keymap.set('n', '<leader>po', '<cmd>tabnew<CR>', { desc = '[o]pen' })
vim.keymap.set('n', '<leader>pk', '<cmd>tabclose<CR>', { desc = '[k]ill' })
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
