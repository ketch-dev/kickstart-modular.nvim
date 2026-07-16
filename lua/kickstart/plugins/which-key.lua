vim.pack.add { 'https://github.com/folke/which-key.nvim' }
local surround = require 'kickstart.plugins.mini.surround'

require('which-key').setup {
  preset = 'helix',
  sort = { 'local', 'manual', 'order', 'group', 'alphanum', 'mod' },
  show_help = false,
  delay = 500,
  triggers = { { '<auto>', mode = 'nixsotc' }, { 's', mode = 'n' } },
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>p', group = '[p]age' },
    { '<leader>w', group = '[w]indow' },
    { '<leader>d', group = '[d]ebug' },
    { '<leader>s', group = '[s]witch' },
    { '<leader>t', group = '[t]est' },
    { '<leader>g', group = '[g]it' },
    { '<leader>h', group = '[h]unk', mode = { 'n', 'v' } },
    { '<leader>f', group = '[f]ind' },
    { '<leader>a', group = '[a]i', mode = { 'n', 'x' } },
    { 's', group = '[s]urround', mode = { 'n', 'x' } },
    { surround.add, desc = '[a]dd', mode = { 'n', 'x' } },
    { surround.delete, desc = '[d]elete', mode = { 'n' } },
    { surround.replace, desc = '[r]eplace', mode = { 'n' } },
    { surround.highlight, desc = '[h]ighlight', mode = { 'n' } },
    { surround.find_left, desc = 'find prev', mode = { 'n' } },
    { surround.find, desc = 'find next', mode = { 'n' } },
  },
}
