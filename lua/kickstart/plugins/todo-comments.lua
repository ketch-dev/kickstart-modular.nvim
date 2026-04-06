-- ========== Highlight todo, notes, etc in comments ==========

---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/todo-comments.nvim',
    cond = not vim.g.vscode,
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },
}
