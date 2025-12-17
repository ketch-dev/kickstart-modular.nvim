-- ========== Collection of various small independent plugins/modules ==========

return {
  { 
    'echasnovski/mini.nvim',
    config = function()
      -- va)  - [V]isually select [A]round [)]paren
      -- yinq - [Y]ank [I]nside [N]ext [Q]uote
      -- ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }
      -- saiw) - [U]rap [A]dd [I]nner [W]ord [)]Paren
      -- sd'   - [U]rap [D]elete [']quotes
      -- sr)'  - [U]rap [R]eplace [)] [']
      require('mini.surround').setup({
        mappings = {
          add = 'u',
          delete = 'ud',
          find = 'uf',
          find_left = 'ut',
          replace = 'ur',
          update_n_lines = '',
          highlight = 'uh',
        },
      })

      if not vim.g.vscode then
        local statusline = require 'mini.statusline'
        statusline.setup { use_icons = vim.g.have_nerd_font }
  
        -- set the section for cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
          return '%2l:%-2v'
        end
      end
    end,
  },
}
