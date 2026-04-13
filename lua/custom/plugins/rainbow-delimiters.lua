return {
  {
    'HiPhish/rainbow-delimiters.nvim',
    config = function()
      vim.api.nvim_set_hl(0, 'Rainbow1', { fg = '#a6b6ff' })
      vim.api.nvim_set_hl(0, 'Rainbow2', { fg = '#7aa2f7' })
      vim.api.nvim_set_hl(0, 'Rainbow3', { fg = '#5b7bd5' })

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
