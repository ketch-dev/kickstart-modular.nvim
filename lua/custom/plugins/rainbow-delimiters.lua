return {
  {
    'HiPhish/rainbow-delimiters.nvim',
    cond = not vim.g.vscode,
    config = function()
      -- define highlight groups first
      vim.api.nvim_set_hl(0, 'Rainbow1', { fg = '#ffd900' })
      vim.api.nvim_set_hl(0, 'Rainbow2', { fg = '#da70d6' })
      vim.api.nvim_set_hl(0, 'Rainbow3', { fg = '#87cefa' })

      local rainbow_delimiters = require 'rainbow-delimiters'

      require('rainbow-delimiters.setup').setup {
        highlight = {
          'Rainbow1',
          'Rainbow2',
          'Rainbow3',
        },
      }
    end,
  },
}
