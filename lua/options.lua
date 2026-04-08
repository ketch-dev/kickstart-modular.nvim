-- ========== Disable netrw ==========
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-------------------------------------------------------------------------------

-- ========== Map leader before plugins are loaded (otherwise wrong leader will be used) ==========
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-------------------------------------------------------------------------------

-- ========== Sync clipboard between OS and Neovim ==========
vim.schedule(function() vim.opt.clipboard = 'unnamedplus' end)
-------------------------------------------------------------------------------

-- ========== Folding (Tree-sitter) ==========
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = '0'
-------------------------------------------------------------------------------

-- ========== Gutter ==========
vim.opt.signcolumn = 'yes' -- Enable sign column (gutter)
vim.opt.number = true
vim.opt.relativenumber = true
-------------------------------------------------------------------------------

-- ========== Tabs/Spaces ==========
vim.opt.tabstop = 4 -- tabwidth
vim.opt.shiftwidth = 4 -- indent width
vim.opt.softtabstop = 4 -- soft tab stop not tabs on tab/backspace
vim.opt.expandtab = false -- use spaces instead of tabs
vim.opt.smartindent = true -- smart auto-indent
vim.opt.autoindent = true -- copy indent from current line
-------------------------------------------------------------------------------

-- ========== Wrap/Break ==========
vim.opt.wrap = true
vim.opt.linebreak = true -- Break at word boundaries
vim.opt.breakindent = true -- Maintain indent when wrapping
vim.opt.showbreak = '↪'
------------------------------------------------------------------------------

-- ========== Spell ==========
vim.opt.spell = true
vim.opt.spelllang = { 'en' }
vim.opt.spellcapcheck = ''
vim.opt.spelloptions = { 'camel' }
-------------------------------------------------------------------------------

-- ========== Search ==========
vim.opt.ignorecase = true -- Enable case-insensitive searching
vim.opt.smartcase = true -- Enable case-sensitive searching if \C or 1+ capital letters in the search term
vim.opt.hlsearch = true -- Highlight search matches
vim.opt.incsearch = true -- Show matches as you type
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

  -- Folding UI
  foldopen = '',
  foldclose = '',
  foldsep = ' ',
  fold = ' ',
}

vim.opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'context:2',
  'algorithm:histogram',
  'indent-heuristic',
  'inline:word',
  'linematch:60',
  'vertical',
  'iwhiteeol',
  'followwrap',
}
-------------------------------------------------------------------------------

vim.g.have_nerd_font = true
vim.opt.showmode = false -- Don't show mode, it's already in the status line
vim.opt.mouse = 'a' -- Enable mouse
vim.opt.undofile = true -- Save undo history
vim.opt.updatetime = 250 -- Displays symbol under cursor highlight sooner
vim.opt.timeoutlen = 300 -- Displays which-key popup sooner
vim.opt.splitright = true -- New vertical splits right
vim.opt.splitbelow = true -- New horizontal splits below
vim.opt.list = true -- Show whitespace characters
vim.opt.cursorline = true -- Highlight current cursor line
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 10 -- Minimal number of screen lines to keep left and right the cursor
vim.opt.confirm = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'
vim.opt.wildmenu = true
vim.opt.wildignorecase = true
vim.opt.inccommand = 'split'
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Sets how to display whitespace characters. Has to be "opt" instead of "o"
vim.opt.hidden = false
vim.opt.swapfile = false
