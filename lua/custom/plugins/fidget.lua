-- ========== See if LSP and Formatter are ready in a buffer ==========
return {
  'j-hui/fidget.nvim',
  cond = not vim.g.vscode,
}
