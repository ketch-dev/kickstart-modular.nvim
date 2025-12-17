-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  cond = not vim.g.vscode,
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    close_if_last_window = true,
    sources = { "filesystem", "buffers", "git_status" },
    filesystem = {
      window = {
        mappings = {
          ['<space>'] = 'none',
  
          ['h'] = 'none',
          ['j'] = 'none',
          ['k'] = 'none',
          ['l'] = 'none',
  
          ['<left>'] = 'close_node',
          ['<bottom>'] = 'move_down',
          ['<top>'] = 'move_up',
          ['<right>'] = 'open',

          -- ['<C-p>'] = 'prev_source',
          -- ['<C-n>'] = 'next_source',

          -- Restore original functions elsewhere (e.g., <Leader> keys)
          -- ['<Leader>r'] = 'refresh', -- Original 'r' (refresh)
          -- ['<Leader>s'] = 'split', -- Original 's' (split)
          -- ['<Leader>f'] = 'filter', -- Original 'f' (filter)
          -- ['<Leader>t'] = 'open_tab', -- Original 't' (open in tab)

          ['n'] = 'rename',
          ['y'] = 'copy_to_clipboard',
          ['s'] = 'open_vsplit',
          ['k'] = 'close_all_nodes',
          ['K'] = 'expand_all_nodes',
        },
      },
      hide_root_node = true,
      filesystem = {
        hijack_netrw_behavior = 'open_default',
        group_empty_dirs = true,
        follow_current_file = { enabled = true },
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
          folder_closed = '',
          folder_open = '',
          folder_empty = '',
          folder_empty_open = '',
        },
      },
    },
  },
}
