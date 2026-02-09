return {
  {
    'Mofiqul/vscode.nvim',
    cond = not vim.g.vscode,
    lazy = false, -- load during startup
    priority = 1000, -- load before other UI plugins
    config = function()
      require('vscode').setup {
        transparent = false,
        italic_comments = true,
        disable_nvimtree_bg = true, -- if you use nvim-tree and want it to blend
        -- group_overrides = { ... }, -- optional overrides (see below)
      }

      vim.cmd.colorscheme 'vscode'
    end,
  },
}
