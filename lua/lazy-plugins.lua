require('lazy').setup({
  require 'custom.plugins.flash'

  if not vim.g.vscode then
    require 'custom.plugins.bufferline'
    require 'custom.plugins.lazygit'
    require 'custom.plugins.neogit'
    require 'custom.plugins.neoscroll'
    require 'custom.plugins.scrollbal'

    'NMAC427/guess-indent.nvim',
    require 'kickstart.plugins.gitsigns',
    require 'kickstart.plugins.which-key', --pending
    require 'kickstart.plugins.telescope',
    require 'kickstart.plugins.lspconfig', --pending
    require 'kickstart.plugins.conform',
    require 'kickstart.plugins.blink-cmp',
    require 'kickstart.plugins.tokyonight',--pending
    require 'kickstart.plugins.todo-comments',--pending
    require 'kickstart.plugins.mini',--pending
    require 'kickstart.plugins.treesitter',--pending

    -- require 'kickstart.plugins.debug',
    require 'kickstart.plugins.indent_line',--pending
    -- require 'kickstart.plugins.lint',
    require 'kickstart.plugins.autopairs',--pending
    require 'kickstart.plugins.neo-tree',--pending
  end
}, {
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
