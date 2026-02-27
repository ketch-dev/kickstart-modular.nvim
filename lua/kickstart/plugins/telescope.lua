-- ========== Fuzzy finder. Press <c-/> (I) or ? (N) to open a window with keymaps for the current picker ==========

return {
  {
    'nvim-telescope/telescope.nvim',
    cond = not vim.g.vscode,
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local actions = require 'telescope.actions'
      local telescope_utils = require 'telescope.utils'

      local function dim_directory_prefix(opts, path)
        local transformed_path = telescope_utils.transform_path(
          vim.tbl_extend('force', opts or {}, {
            path_display = { 'smart' },
          }),
          path
        )

        local filename = telescope_utils.path_tail(transformed_path)
        local directory_prefix_len = #transformed_path - #filename

        if directory_prefix_len > 0 then
          return transformed_path, { { { 0, directory_prefix_len }, 'TelescopeResultsComment' } }
        end

        return transformed_path
      end

      local function set_file_path_highlights()
        vim.api.nvim_set_hl(0, 'TelescopeResultsComment', { link = 'LineNr' })
      end

      set_file_path_highlights()
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('TelescopePathHighlights', { clear = true }),
        callback = set_file_path_highlights,
      })

      require('telescope').setup {
        defaults = {
          path_display = dim_directory_prefix,
          layout_strategy = 'horizontal',
          layout_config = {
            width = 0.91, -- align with toggleterm
            height = 0.92, -- keep 2 rows above and below
            horizontal = {
              preview_width = 0.5,
            },
          },
          mappings = {
            i = {
              ['<C-g>'] = actions.close,
              ['<C-cr>'] = actions.select_vertical,
            },
            n = {
              ['<esc>'] = false,
              ['<C-g>'] = actions.close,
              ['<C-cr>'] = actions.select_vertical,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- ========== Enable Telescope extensions if they are installed ==========
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      -------------------------------------------------------------------------------

      local builtin = require 'telescope.builtin' -- see `:help telescope.builtin`

      vim.keymap.set('n', 'lh', builtin.help_tags, { desc = '[H]elp' })
      vim.keymap.set('n', 'lk', builtin.keymaps, { desc = '[K]eymaps' })
      vim.keymap.set('n', 'lf', builtin.find_files, { desc = '[F]iles' })
      vim.keymap.set('n', 'ls', builtin.builtin, { desc = '[S]elect telescope' })
      vim.keymap.set('n', 'lw', builtin.grep_string, { desc = 'current [W]ord' })
      vim.keymap.set('n', 'lg', builtin.live_grep, { desc = '[G]rep' })
      vim.keymap.set('n', 'ld', builtin.diagnostics, { desc = '[D]iagnostics' })
      vim.keymap.set('n', 'l.', builtin.resume, { desc = 'resume' })
      vim.keymap.set('n', 'lr', builtin.oldfiles, { desc = '[R]ecent files' })
      vim.keymap.set('n', 'lt', '<cmd>TodoTelescope<cr>', { desc = '[T]odo' })
      vim.keymap.set('n', 'll', builtin.buffers, { desc = 'Buffers' })
      vim.keymap.set('n', 'l/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Find in buffer' })
      vim.keymap.set('n', 'ln', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[N]eovim files' })
    end,
  },
}
