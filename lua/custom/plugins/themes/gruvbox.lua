return {
  {
    'morhetz/gruvbox',
    cond = not vim.g.vscode,
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.background = 'dark'
      vim.cmd.colorscheme 'gruvbox'
    end,
  },
}
