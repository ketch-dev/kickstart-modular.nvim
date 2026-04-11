return {
  {
    'ThorstenRhau/token',
    cond = not vim.g.vscode,
    name = 'token',
    lazy = false,
    priority = 1000,
    config = function() vim.cmd.colorscheme 'token' end,
  },
}
