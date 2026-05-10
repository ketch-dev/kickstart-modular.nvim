-- ========== Quick Text Jumps ==========

return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        'j',
        mode = { 'n', 'x', 'o' },
        function() require('flash').jump() end,
        desc = '[j]ump',
      },
      {
        '<C-w>',
        mode = { 'n', 'x', 'o' },
        function() require('flash').treesitter() end,
        desc = '[w]raps (treesitter)',
      },
    },
  },
}
