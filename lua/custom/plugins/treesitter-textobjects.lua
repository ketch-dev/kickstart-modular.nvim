-- ========== Add new binds based on treesitter parsing ==========
return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  cond = not vim.g.vscode,
  dependencies = { 'nvim-treesitter' },
  config = function()
    require('nvim-treesitter.configs').setup {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
          },
        },
      },
    }
  end,
}
