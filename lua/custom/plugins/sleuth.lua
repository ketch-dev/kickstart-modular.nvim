-- ========== Override default tabs/spaces in current buffer ==========

return {
  'tpope/vim-sleuth',
  cond = not vim.g.vscode,
}
