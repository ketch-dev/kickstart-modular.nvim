-- ========== Add indentation guides even on blank lines ==========

---@module 'lazy'
---@type LazySpec
return {
  {
    cond = not vim.g.vscode,
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    ---@module 'ibl'
    ---@type ibl.config
    opts = {
      indent = { char = '│' },
    },
  },
}
