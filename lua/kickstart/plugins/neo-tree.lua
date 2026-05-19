-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local plugins = {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

if vim.g.have_nerd_font then table.insert(plugins, 'https://github.com/nvim-tree/nvim-web-devicons') end

vim.pack.add(plugins)

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'neotree', silent = true })

require('neo-tree').setup {
  hide_root_node = true,
  retain_hidden_root_indent = false,
  close_if_last_window = true,
  sources = { 'filesystem', 'buffers', 'git_status' },
  window = {
    mappings = {
      ['<Space>'] = 'none',

      ['h'] = 'none',
      ['j'] = 'none',
      ['k'] = 'none',
      ['l'] = 'none',

      ['<Left>'] = 'close_node',
      ['<Down>'] = 'move_down',
      ['<Up>'] = 'move_up',
      ['<Right>'] = 'open',

      ['n'] = 'rename',
      ['y'] = 'copy_to_clipboard',
      ['s'] = 'open_vsplit',
      ['K'] = 'expand_all_nodes',
    },
  },
  filesystem = {
    hijack_netrw_behavior = 'open_default',
    group_empty_dirs = true,
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        'node_modules',
        '.git',
      },
    },
  },
  default_component_configs = {
    icon = {
      folder_closed = '',
      folder_open = '',
      folder_empty = '',
      folder_empty_open = '',
    },
  },
}
