-- ========== Autoformat ==========

---@module 'lazy'
---@type LazySpec
return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    init = function()
      if vim.g.autoformat_on_save == nil then vim.g.autoformat_on_save = true end
    end,
    keys = {
      {
        '<C-f>',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = '',
        desc = '[f]ormat buffer',
      },
      {
        '<leader>tf',
        function() vim.g.autoformat_on_save = not vim.g.autoformat_on_save end,
        mode = 'n',
        desc = '[f]ormat on save',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true } -- Disable "format_on_save lsp_fallback" for languages that don't have a well standardized coding style
        if not vim.g.autoformat_on_save then return nil end

        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters = {
        ['golangci-lint'] = {
          cwd = function(_, ctx)
            return vim.fs.root(ctx.dirname, {
              '.golangci.yml',
              '.golangci.yaml',
              '.golangci.toml',
              '.golangci.json',
              'go.work',
              'go.mod',
              '.git',
            })
          end,
        },
      },
      formatters_by_ft = {
        go = { 'golangci-lint' },
        lua = { 'stylua' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        nix = { 'nixfmt' },
        graphql = { 'prettier' },
        liquid = { 'prettier' },
        html = { 'prettier' },
        htmlangular = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
}
