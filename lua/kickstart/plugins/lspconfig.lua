-- LSP Plugins
---@module 'lazy'
---@type LazySpec
return {
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gn', vim.lsp.buf.rename, '[n]ame')
          map('ga', vim.lsp.buf.code_action, '[g]oto [a]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')

          map('<C-h>', function()
            local max_width = math.floor(vim.api.nvim_win_get_width(0) * 0.8)

            local _, winid = vim.diagnostic.open_float {
              scope = 'cursor',
              border = 'rounded',
              source = 'if_many',
              focusable = true,
              max_width = max_width,
            }
            if winid then return end

            _, winid = vim.diagnostic.open_float {
              scope = 'line',
              border = 'rounded',
              source = 'if_many',
              focusable = true,
              max_width = max_width,
            }
            if winid then return end

            vim.lsp.buf.hover()
          end, 'Diagnostics / Hover')

          -- ========== Highlight references of the word under your cursor when your cursor rests ==========
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if #vim.lsp.get_clients { bufnr = event.buf, method = 'textDocument/inlayHint' } > 0 then
            map(
              '<leader>sh',
              function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf }) end,
              'inlay [h]ints'
            )
          end

          if client and client.name == 'typescript-tools' then
            local bufname = vim.api.nvim_buf_get_name(event.buf)
            if bufname ~= '' then
              local angular_json = vim.fs.find('angular.json', { path = vim.fs.dirname(bufname), upward = true })[1]
              if angular_json then client.server_capabilities.referencesProvider = false end
            end
          end

          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
          -------------------------------------------------------------------------------
        end,
      })

      -- ========== LSP servers config. LSPs install automatically (See :help lspconfig-all) ==========
      ---@type table<string, vim.lsp.Config>
      local servers = {
        volar = {},
        angularls = {
          filetypes = { 'typescript', 'htmlangular' },
        },
        gopls = {
          settings = {
            gopls = {
              staticcheck = false,
              usePlaceholders = true,
              analyses = {
                shadow = true,
                unusedparams = true,
              },
              vulncheck = 'Imports',
              linksInHover = true,
              hints = {
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        nixd = {},
      }
      -------------------------------------------------------------------------------

      for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = function()
      return {
        filetypes = {
          'javascript',
          'javascriptreact',
          'javascript.jsx',
          'typescript',
          'typescriptreact',
          'typescript.tsx',
          'vue',
        },
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = 'insert_leave',
          tsserver_plugins = {
            '@vue/typescript-plugin',
          },
          tsserver_max_memory = 'auto',
          code_lens = 'off',
        },
      }
    end,
  },
}
