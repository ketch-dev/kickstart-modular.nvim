-- ========== Colorscheme ==========

return {
  {
    'rebelot/kanagawa.nvim',
    cond = not vim.g.vscode,
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = 'none',
              },
            },
          },
        },
      }

      vim.cmd.colorscheme 'kanagawa-wave'
    end,
  },
}
