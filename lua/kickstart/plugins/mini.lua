-- ========== Collection of various small independent plugins/modules ==========

---@module 'lazy'
---@type LazySpec
return {
  {
    'echasnovski/mini.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('kickstart.plugins.mini.ai').setup()
      require('kickstart.plugins.mini.surround').setup()
      require('kickstart.plugins.mini.pairs').setup()
      require('kickstart.plugins.mini.diff').setup()
      require('kickstart.plugins.mini.statusline').setup()
      require('kickstart.plugins.mini.files').setup()
    end,
  },
}
