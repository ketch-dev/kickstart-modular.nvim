-- ========== Add indentation guides even on blank lines ==========

return {
  {
    cond = not vim.g.vscode,
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = { char = '╎' },
    },
  },
}
