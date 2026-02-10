-- ========== Disable netrw ==========
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-------------------------------------------------------------------------------

-- ========== Map leader before plugins are loaded (otherwise wrong leader will be used) ==========
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-------------------------------------------------------------------------------

-- ========== Sync clipboard between OS and Neovim ==========
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
-------------------------------------------------------------------------------

-- ========== Wrap/Break ==========
vim.o.wrap = true
vim.o.linebreak = true -- Break at word boundaries
vim.o.breakindent = true -- Maintain indent when wrapping
vim.o.showbreak = '↪ '
-------------------------------------------------------------------------------
-- ========== Git Diff ==========
vim.opt.fillchars = {
  diff = '╱',
  horiz = '█',
  horizup = '█',
  horizdown = '█',
  vert = '█',
  vertleft = '█',
  vertright = '█',
  verthoriz = '█',
}

vim.opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'context:12',
  'algorithm:histogram',
  'indent-heuristic',
  'inline:char',
}
-------------------------------------------------------------------------------

vim.g.have_nerd_font = true
vim.o.showmode = false -- Don't show mode, it's already in the status line
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a' -- Enable mouse
vim.o.undofile = true -- Save undo history
vim.o.ignorecase = true -- Enable case-insensitive searching
vim.o.smartcase = true -- Enable case-sensitive searching if \C or 1+ capital letters in the search term
vim.o.signcolumn = 'yes' -- Enable sign column (gutter)
vim.o.updatetime = 250 -- Displays symbol under cursor highlight sooner
vim.o.timeoutlen = 300 -- Displays which-key popup sooner
vim.o.splitright = true -- New vertical splits right
vim.o.splitbelow = true -- New horizontal splits below
vim.o.list = true -- Show whitespace characters
vim.o.inccommand = 'split' -- Preview substitutions live in split
vim.o.cursorline = true -- Highlight current cursor line
vim.o.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor
vim.o.confirm = true
vim.o.backspace = 'indent,eol,start'
vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'
vim.o.wildmenu = true
vim.o.wildignorecase = true
vim.o.inccommand = 'split'
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Sets how to display whitespace characters. Has to be "opt" instead of "o"
