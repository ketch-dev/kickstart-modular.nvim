-- ========== Show pending keybinds ==========

---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      preset = 'helix',
      sort = { 'local', 'manual', 'order', 'group', 'alphanum', 'mod' },
      show_help = false,
      delay = 1000,
      triggers = {
        { '<auto>', mode = 'nixsotc' },
        { 'l', mode = 'n' },
        { 's', mode = 'n' },
      },
      icons = {
        mappings = vim.g.have_nerd_font,
      },

      -- Document existing key chains
      spec = {
        { '<leader>p', group = '[p]age' },
        { '<leader>w', group = '[w]indow' },
        { '<leader>t', group = '[t]oggle' },
        { '<leader>g', group = '[g]it' },
        { '<leader>h', group = '[h]unk', mode = { 'n', 'v' } },
        { 'l', group = '[l]ookup:' },
        { 's', group = '[s]urround', mode = { 'n', 'x' } },
        { 'sa', desc = '[a]dd', mode = { 'n', 'x' } },
        { 'sd', desc = '[d]elete', mode = { 'n' } },
        { 'sr', desc = '[r]eplace', mode = { 'n' } },
        { 'sh', desc = '[h]ighlight', mode = { 'n' } },
        { 'sf', desc = 'find right', mode = { 'n' } },
        { 'st', desc = 'find left', mode = { 'n' } },
      },
    },
  },
}
