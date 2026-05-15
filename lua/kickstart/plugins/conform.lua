-- ========== Autoformat ==========

if vim.g.autoformat_on_save == nil then vim.g.autoformat_on_save = true end

vim.pack.add { 'https://github.com/stevearc/conform.nvim' }
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    if not vim.g.autoformat_on_save then return nil end
    if disable_filetypes[vim.bo[bufnr].filetype] then return nil end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
  formatters = {
    ['golangci-lint'] = {
      cwd = function(_, ctx)
        return vim.fs.root(ctx.dirname, { '.golangci.yml', '.golangci.yaml', '.golangci.toml', '.golangci.json', 'go.work', 'go.mod', '.git' })
      end,
    },
  },
  default_format_opts = { lsp_format = 'fallback' },
  formatters_by_ft = {
    go = { 'golangci-lint' },
    lua = { 'stylua' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    nix = { 'nixfmt' },
    graphql = { 'prettier' },
    liquid = { 'prettier' },
    html = { 'prettier' },
    htmlangular = { 'prettier' },
    vue = { 'prettier' },
    css = { 'prettier' },
    scss = { 'prettier' },
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
  },
}

vim.keymap.set({ 'n', 'v' }, '<C-f>', function() require('conform').format { async = true } end, { desc = '[f]ormat buffer' })
vim.keymap.set('n', '<leader>sf', function() vim.g.autoformat_on_save = not vim.g.autoformat_on_save end, { desc = '[f]ormat on save' })
