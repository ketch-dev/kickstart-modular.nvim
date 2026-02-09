return {
  {
    'projekt0n/github-nvim-theme',
    cond = not vim.g.vscode,
    name = 'github-theme',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup {
        groups = {
          all = {
            -- Keep syntax highlighting by NOT forcing a foreground color.
            -- (fg = "NONE" means “don’t override fg”, so keywords/strings still show.)
            DiffAdd = { bg = '#1f3d2a', fg = 'NONE' },
            DiffChange = { bg = '#3a2f10', fg = 'NONE' },
            DiffDelete = { bg = '#3f1f1f', fg = 'NONE' },
            DiffText = { bg = '#5a3d18', fg = 'NONE' },
          },
        },
      }

      vim.cmd.colorscheme 'github_dark_default'
    end,
  },
}
