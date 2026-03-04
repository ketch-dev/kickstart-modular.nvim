-- ========== Render Markdown in buffer ==========

return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    cond = not vim.g.vscode,
    ft = { 'markdown' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.nvim',
    },
    opts = {},
  },
}
