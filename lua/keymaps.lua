

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = '[Q]uickfix list' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('v', 'p', 'P') -- Make 'p' to not copy
vim.keymap.set('n', '<Del>', '"_x') -- 'Del' to delete 1 char forward
vim.keymap.set('n', '<BS>', '"_dh') -- 'Backspace' to delete 1 char backward
vim.keymap.set({'i', 'c'}, '<C-BS>', '<C-w>', { desc = 'Delete previous word' })
vim.keymap.set('i', '<C-Del>', '<C-o>dw', { desc = 'Delete forward word' })

-- ========== Disable hjkl ==========
vim.keymap.set({ 'n', 'v' }, 'h', '<Nop>')
vim.keymap.set({ 'n', 'v' }, 'j', '<Nop>')
vim.keymap.set({ 'n', 'v' }, 'k', '<Nop>')
vim.keymap.set({ 'n', 'v' }, 'l', '<Nop>')
-------------------------------------------------------------------------------

-- ========== Move focus with arrows ==========
vim.keymap.set('n', '<C-left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-------------------------------------------------------------------------------

-- ========== Save with ctrl-s ==========
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { noremap = true, silent = true })
vim.keymap.set('v', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true })
-------------------------------------------------------------------------------

-- ========== Undo with ctrl-z ==========
vim.keymap.set('n', '<C-z>', 'u', { noremap = true, silent = true })
vim.keymap.set('i', '<C-z>', '<C-o>u', { noremap = true, silent = true })
vim.keymap.set('n', 'u', '<Nop>', { noremap = true, silent = true }) 
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
local toggle_both_sides = require('utils.neotree-toggle-both-sides').toggle_both_sides
vim.keymap.set('n', '<leader>et', toggle_both_sides, { desc = '[T]oggle' })
vim.keymap.set('n', '<leader>ef', '<cmd>Neotree filesystem reveal left show<CR>', { desc = '[F]iles' })
vim.keymap.set('n', '<leader>eb', '<cmd>Neotree buffers reveal left show<CR>', { desc = '[B]uffers' })
vim.keymap.set('n', '<leader>eg', '<cmd>Neotree git_status reveal right show<CR>', { desc = '[G]it' })
-------------------------------------------------------------------------------

-- ========== Split ==========
vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = '[V]ertical' })
vim.keymap.set('n', '<leader>sh', '<C-w>s', { desc = '[H]orizontal' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = '[E]qual' })
vim.keymap.set('n', '<leader>sk', '<cmd>close<CR>', { desc = '[K]ill' })
-------------------------------------------------------------------------------

-- ========== Tabs ==========
vim.keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = '[O]pen' })
vim.keymap.set('n', '<leader>tk', '<cmd>tabclose<CR>', { desc = '[K]ill' })
vim.keymap.set('n', '<leader>tn', '<cmd>tabn<CR>', { desc = '[N]ext' })
vim.keymap.set('n', '<leader>tp', '<cmd>tabp<CR>', { desc = '[P]revious' })
vim.keymap.set('n', '<leader>tb', '<cmd>tabnew %<CR>', { desc = 'Move [B]uffer to new tab' })
-------------------------------------------------------------------------------
---
vim.keymap.set("n", "<C-S-left>", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<C-S-right>", "<C-w>L", { desc = "Move window to the right" })
vim.keymap.set("n", "<C-S-down>", "<C-w>J", { desc = "Move window to the lower" })
vim.keymap.set("n", "<C-S-up>", "<C-w>K", { desc = "Move window to the upper" })

-- ========== Highlight when yanking (copying) text ==========
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
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