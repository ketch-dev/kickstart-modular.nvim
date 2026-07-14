-- ========== Autocompletion ==========

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name ~= 'LuaSnip' then return end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end
    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' ~= 1 then return end
    local result = vim.system({ 'make', 'install_jsregexp' }, { cwd = ev.data.path }):wait()
    if result.code ~= 0 then vim.notify(('Build failed for LuaSnip:\n%s'):format(result.stderr or result.stdout), vim.log.levels.ERROR) end
  end,
})

vim.pack.add { 'https://github.com/xzbdmw/colorful-menu.nvim' }
require('colorful-menu').setup()

vim.pack.add { { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

vim.pack.add { 'https://github.com/rafamadriz/friendly-snippets' }
require('luasnip.loaders.from_vscode').lazy_load()

vim.pack.add { { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
  keymap = {
    preset = 'default',
    ['<C-space>'] = { 'hide', 'show' },
    ['<C-k>'] = { 'hide', 'fallback' },
    ['<Tab>'] = { 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    ['<C-n>'] = false,
    ['<C-p>'] = false,
    ['<Left>'] = false,
    ['<Right>'] = false,
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
  },
  appearance = { nerd_font_variant = 'mono' },
  cmdline = {
    keymap = { preset = 'cmdline', ['<C-n>'] = false, ['<C-p>'] = false, ['<Left>'] = false, ['<Right>'] = false, ['<Up>'] = false, ['<Down>'] = false },
    completion = { menu = { auto_show = function() return vim.fn.getcmdtype() == ':' end } },
  },
  completion = {
    ghost_text = { enabled = true },
    menu = {
      draw = {
        columns = { { 'kind_icon' }, { 'label', gap = 1 } },
        components = {
          label = {
            text = function(ctx) return require('colorful-menu').blink_components_text(ctx) end,
            highlight = function(ctx) return require('colorful-menu').blink_components_highlight(ctx) end,
          },
        },
      },
    },
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },
  sources = { default = { 'lsp', 'path', 'snippets' } },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = { enabled = true },
}
