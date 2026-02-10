-- ========== Show pending keybinds ==========

return {
  {
    'folke/which-key.nvim',
    cond = not vim.g.vscode,
    event = 'VimEnter',
    opts = {
      preset = 'helix',
      sort = { 'local', 'order', 'group', 'manual', 'alphanum', 'mod' },
      show_help = false,
      delay = 1000,
      triggers = {
        { '<auto>', mode = 'nixsotc' },
        { 'l', mode = 'n' },
        { 's', mode = 'n' },
      },
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { 'l', group = '[L]ookup:' },

        { 's', group = '[S]urround', mode = { 'n', 'x' } },
        { 'sa', desc = '[A]dd', mode = { 'n', 'x' } },
        { 'sd', desc = '[D]elete', mode = { 'n' } },
        { 'sr', desc = '[R]eplace', mode = { 'n' } },
        { 'sh', desc = '[H]ighlight', mode = { 'n' } },
        { 'sf', desc = 'Find right', mode = { 'n' } },
        { 'st', desc = 'Find left', mode = { 'n' } },
      },
    },
  },
}
