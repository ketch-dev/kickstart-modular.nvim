-- ========== Autocompletion ==========

local function get_import_source(ctx)
  if ctx.label_description ~= '' then return ctx.label_description end

  local item = ctx.item or {}
  local is_module = item.kind == vim.lsp.protocol.CompletionItemKind.Module or item.kind_name == 'Module'

  if type(item.source) == 'string' and item.source ~= '' then return item.source end

  local data = item.data
  if type(data) == 'table' and type(data.entryNames) == 'table' then
    local entry = data.entryNames[1]
    if type(entry) == 'table' and type(entry.source) == 'string' and entry.source ~= '' then return entry.source end
  end

  if type(item.detail) == 'string' then
    local detail_source = item.detail:match 'from%s+"([^"]+)"'
      or item.detail:match '^Auto import from ([^\n]+)'
      or (is_module and item.detail:match '^"([^"]+)"$')
    if detail_source and detail_source ~= '' then return detail_source end
  end

  return ''
end

---@module 'lazy'
---@type LazySpec
return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- ========== Snippet Engine ==========
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',
        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        menu = {
          draw = {
            columns = {
              { 'kind_icon' },
              { 'label', 'import_source', gap = 1 },
            },
            components = {
              import_source = {
                width = { max = 40 },
                text = get_import_source,
                highlight = 'BlinkCmpLabelDescription',
              },
            },
          },
        },
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      signature = { enabled = true }, -- Shows a signature help window while you type arguments for a function
    },
    config = function(_, opts)
      require('blink.cmp').setup(opts)

      require('mini.keymap').map_multistep('i', '<CR>', { 'blink_accept', 'minipairs_cr' }, {
        desc = 'Accept completion or pair-aware newline',
        silent = true,
      })
    end,
  },
}
