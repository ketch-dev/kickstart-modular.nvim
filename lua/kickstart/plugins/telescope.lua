-- ========== Fuzzy finder. Press <c-/> (I) or ? (N) to open a window with keymaps for the current picker ==========

---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
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

        if directory_prefix_len > 0 then return transformed_path, { { { 0, directory_prefix_len }, 'TelescopeResultsComment' } } end

        return transformed_path
      end

      local function set_file_path_highlights() vim.api.nvim_set_hl(0, 'TelescopeResultsComment', { link = 'LineNr' }) end

      set_file_path_highlights()
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('TelescopePathHighlights', { clear = true }),
        callback = set_file_path_highlights,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'TelescopePreviewerLoaded',
        callback = function(args)
          if args.data.filetype ~= 'help' then
            vim.wo.wrap = true
            vim.wo.number = true
          elseif args.data.bufname:match '*.csv' then
            vim.wo.wrap = false
            vim.wo.number = false
          end
        end,
      })

      require('telescope').setup {
        defaults = {
          path_display = dim_directory_prefix,
          layout_strategy = 'horizontal',
          sorting_strategy = 'ascending',
          layout_config = {
            width = 0.91, -- align with toggleterm
            height = 0.92, -- keep 2 rows above and below
            horizontal = {
              prompt_position = 'top',
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
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }

      -- ========== Enable Telescope extensions if they are installed ==========
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      -------------------------------------------------------------------------------

      local builtin = require 'telescope.builtin' -- see `:help telescope.builtin`

      vim.keymap.set('n', 'lh', builtin.help_tags, { desc = '[h]elp' })
      vim.keymap.set('n', 'lk', builtin.keymaps, { desc = '[k]eymaps' })
      vim.keymap.set('n', 'lf', builtin.find_files, { desc = '[f]iles' })
      vim.keymap.set('n', 'ls', builtin.builtin, { desc = '[s]elect telescope' })
      vim.keymap.set({ 'n', 'v' }, 'lw', builtin.grep_string, { desc = 'current [w]ord' })
      vim.keymap.set('n', 'lg', builtin.live_grep, { desc = '[g]rep' })
      vim.keymap.set('n', 'ld', builtin.diagnostics, { desc = '[d]iagnostics' })
      vim.keymap.set('n', 'l.', builtin.resume, { desc = 'resume' })
      vim.keymap.set('n', 'lr', builtin.oldfiles, { desc = '[r]ecent files' })
      vim.keymap.set('n', 'lc', builtin.commands, { desc = '[c]ommands' })
      vim.keymap.set('n', 'lt', '<cmd>TodoTelescope<cr>', { desc = '[t]odo' })
      vim.keymap.set('n', 'll', builtin.buffers, { desc = 'buffers' })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf

          vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = buf, desc = '[g]oto [r]eferences' })
          vim.keymap.set('n', 'gi', builtin.lsp_implementations, { buffer = buf, desc = '[g]oto [i]mplementation' })
          vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = '[g]oto [d]efinition' }) -- To jump back, press <C-t>.
          vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, { buffer = buf, desc = '[g]oto [t]ype Definition' })
          vim.keymap.set('n', 'gs', builtin.lsp_document_symbols, { buffer = buf, desc = 'find document symbols' })
          vim.keymap.set('n', 'gws', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'find workspace symbols' })
        end,
      })

      vim.keymap.set(
        'n',
        'l/',
        function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        { desc = '[/] Find in buffer' }
      )
      vim.keymap.set('n', 'ln', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[n]eovim files' })
    end,
  },
}
