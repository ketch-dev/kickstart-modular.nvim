-- ========== Quick Text Jumps ==========

return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        '<C-m>',
        mode = { 'n', 'x', 'o' },
        function() require('flash').jump() end,
        desc = '[m]ove cursor',
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
