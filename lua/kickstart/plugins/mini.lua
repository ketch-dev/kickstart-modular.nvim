vim.pack.add { 'https://github.com/echasnovski/mini.nvim' }
if vim.g.have_nerd_font then vim.pack.add { 'https://github.com/nvim-tree/nvim-web-devicons' } end

require 'kickstart.plugins.mini.ai'
require 'kickstart.plugins.mini.surround'
require 'kickstart.plugins.mini.pairs'
require 'kickstart.plugins.mini.diff'
require 'kickstart.plugins.mini.statusline'
require 'kickstart.plugins.mini.files'
