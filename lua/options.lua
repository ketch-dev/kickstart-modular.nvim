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
  vim.opt.clipboard = 'unnamedplus'
end)
-------------------------------------------------------------------------------

-- ========== Wrap/Break ==========
vim.opt.wrap = true
vim.opt.linebreak = true -- Break at word boundaries
vim.opt.breakindent = true -- Maintain indent when wrapping
vim.opt.showbreak = '↪'
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
  'context:4',
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
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a' -- Enable mouse
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Enable case-insensitive searching
vim.opt.smartcase = true -- Enable case-sensitive searching if \C or 1+ capital letters in the search term
vim.opt.signcolumn = 'yes' -- Enable sign column (gutter)
vim.opt.updatetime = 250 -- Displays symbol under cursor highlight sooner
vim.opt.timeoutlen = 300 -- Displays which-key popup sooner
vim.opt.splitright = true -- New vertical splits right
vim.opt.splitbelow = true -- New horizontal splits below
vim.opt.list = true -- Show whitespace characters
vim.opt.inccommand = 'split' -- Preview substitutions live in split
vim.opt.cursorline = true -- Highlight current cursor line
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor
vim.opt.confirm = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'
vim.opt.wildmenu = true
vim.opt.wildignorecase = true
vim.opt.inccommand = 'split'
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Sets how to display whitespace characters. Has to be "opt" instead of "o"
vim.opt.spell = true
vim.opt.spelllang = { 'en' }
vim.opt.spellcapcheck = ''
vim.opt.spelloptions = { 'camel' }
vim.opt.hidden = false
