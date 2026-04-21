local plugins = {
  require 'custom.plugins.flash',
  require 'custom.plugins.diffview.diffview',
  require 'custom.plugins.treesitter-textobjects',
  require 'kickstart.plugins.mini',
  require 'kickstart.plugins.treesitter',
}

if not vim.g.vscode then
  vim.list_extend(plugins, {
    require 'custom.plugins.themes.token',
    -- require 'custom.plugins.themes.github-theme',
    -- require 'custom.plugins.themes.vscode',
    -- require 'custom.plugins.themes.vscode-syntax-blend',
    -- require 'custom.plugins.themes.kanagawa',

    -- require 'custom.plugins.bufferline',
    require 'custom.plugins.neogit',
    require 'custom.plugins.neoscroll',
    require 'custom.plugins.toggleterm',
    require 'custom.plugins.scrollbar',
    require 'custom.plugins.fidget',
    require 'custom.plugins.sleuth',
    require 'custom.plugins.noice',
    -- require 'custom.plugins.rainbow-delimiters',
    require 'custom.plugins.highlight-colors',
    require 'custom.plugins.render-markdown',

    require 'kickstart.plugins.gitsigns',
    require 'kickstart.plugins.which-key',
    require 'kickstart.plugins.telescope',
    require 'kickstart.plugins.lspconfig',
    require 'kickstart.plugins.conform',
    require 'kickstart.plugins.blink-cmp',
    -- require 'kickstart.plugins.todo-comments',

    -- require 'kickstart.plugins.debug',
    require 'kickstart.plugins.indent_line',
    -- require 'kickstart.plugins.lint',
    -- require 'kickstart.plugins.autopairs',
    -- require 'kickstart.plugins.neo-tree',
  })
end

require('lazy').setup(plugins, { ---@diagnostic disable-line: missing-fields
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
