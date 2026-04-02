-- ========== LSP plugins ==========

return {
  {
    'folke/lazydev.nvim',
    cond = not vim.g.vscode,
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    cond = not vim.g.vscode,
    dependencies = {
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gn', vim.lsp.buf.rename, '[N]ame')
          map('ga', vim.lsp.buf.code_action, '[G]oto [A]ction', { 'n', 'x' })
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gs', require('telescope.builtin').lsp_document_symbols, '[G]oto [S]ymbols')
          map('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          map('<C-h>', function()
            local max_width = math.floor(vim.api.nvim_win_get_width(0) * 0.8)

            local _, winid = vim.diagnostic.open_float {
              scope = 'cursor',
              border = 'rounded',
              source = 'if_many',
              focusable = true,
              max_width = max_width,
            }
            if winid then
              return
            end

            _, winid = vim.diagnostic.open_float {
              scope = 'line',
              border = 'rounded',
              source = 'if_many',
              focusable = true,
              max_width = max_width,
            }
            if winid then
              return
            end

            vim.lsp.buf.hover()
          end, 'Diagnostics / Hover')

          -- ========== Resolve a difference between neovim nightly (version 0.11) and stable (version 0.10) ==========
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end
          -------------------------------------------------------------------------------

          -- ========== Highlight references of the word under your cursor when your cursor rests ==========
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client.name == 'typescript-tools' then
            local bufname = vim.api.nvim_buf_get_name(event.buf)
            if bufname ~= '' then
              local angular_json = vim.fs.find('angular.json', { path = vim.fs.dirname(bufname), upward = true })[1]
              if angular_json then
                client.server_capabilities.referencesProvider = false
              end
            end
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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

      -- ========== Diagnostic Config (See :help vim.diagnostic.Opts) ==========
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = false,
        virtual_lines = {
          format = function(diagnostic)
            return diagnostic.message:gsub('\n', ' '):gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')
          end,
        },
      }
      -------------------------------------------------------------------------------

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      -- ========== LSP servers config. LSPs install automatically (See :help lspconfig-all) ==========
      local servers = {
        volar = {},
        angularls = {
          filetypes = { 'typescript', 'htmlangular' },
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

      for server_name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

        if vim.lsp.config then
          vim.lsp.config(server_name, server)
          vim.lsp.enable(server_name)
        else
          require('lspconfig')[server_name].setup(server)
        end
      end
    end,
  },
  {
    'pmizio/typescript-tools.nvim',
    cond = not vim.g.vscode,
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
