-- ========== Collection of various small independent plugins/modules ==========

return {
  {
    'echasnovski/mini.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      -- ========== Improve "a" (around) and "i" (inside) ==========
      require('mini.ai').setup {
        -- va)  - [V]isually select [A]round [)]paren
        -- yinq - [Y]ank [I]nside [N]ext [Q]uote
        -- ci'  - [C]hange [I]nside [']quote
        n_lines = 500,
        custom_textobjects = {
          f = require('mini.ai').gen_spec.treesitter {
            a = '@function.outer',
            i = '@function.inner',
          },
        },
      }
      -------------------------------------------------------------------------------

      -- ========== Add surround ==========
      require('mini.surround').setup {
        -- saiw) - [U]rap [A]dd [I]nner [W]ord [)]Paren
        -- sd'   - [U]rap [D]elete [']quotes
        -- sr)'  - [U]rap [R]eplace [)] [']
        mappings = {
          add = 'u',
          delete = 'ud',
          find = 'uf',
          find_left = 'ut',
          replace = 'ur',
          update_n_lines = '',
          highlight = 'uh',
        },
      }
      -------------------------------------------------------------------------------

      -- ========== Status line ==========
      if not vim.g.vscode then
        local line = require 'mini.statusline'
        line.setup {
          use_icons = vim.g.have_nerd_font,
          content = {
            active = function()
              local mode, mode_hl = line.section_mode { trunc_width = 120 }
              local diff = line.section_diff { trunc_width = 75 }
              local diagnostics = line.section_diagnostics { trunc_width = 75 }
              local filename = vim.bo.buftype == 'terminal' and '%t' or '%t%m%r'
              local location = line.section_location { trunc_width = 75 }
              local search = line.section_searchcount { trunc_width = 75 }

              return line.combine_groups {
                '%<', -- Truncation point
                { hl = 'MiniStatuslineFilename', strings = { filename } },
                '%=', -- Fill space
                { hl = 'MiniStatuslineSearchcount', strings = { search } },
                { hl = 'MiniStatuslineFilename', strings = { location } },
                { hl = 'MiniStatuslineDevinfo', strings = { diff, diagnostics } },
                { hl = mode_hl, strings = { mode } },
              }
            end,

            inactive = function()
              local filename = vim.bo.buftype == 'terminal' and '%t' or '%t%m%r'
              return line.combine_groups {
                { hl = 'MiniStatuslineInactive', strings = { filename } },
                '%=', -- Fill space
              }
            end,
          },
        }
        -- set the section for cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        line.section_location = function()
          return string.format('%7s', string.format('%d:%d', vim.fn.line '.', vim.fn.charcol '.'))
        end
      end
      -------------------------------------------------------------------------------

      -- ========== File Explorer ==========
      if not vim.g.vscode then
        require('mini.files').setup {
          cond = not vim.g.vscode,
          mappings = {
            close = '<C-c>',
            go_in_plus = '<CR>',
            go_out = '<left>',
            synchronize = '=',
          },
        }

        -- ========== [mini.files] View full CWD tree ==========
        vim.keymap.set('n', '-', function()
          local MiniFiles = require 'mini.files'
          local buf_name = vim.api.nvim_buf_get_name(0)
          local cwd = vim.fn.getcwd()

          -- 1. Open MiniFiles normally focused on the current buffer
          MiniFiles.open(buf_name)

          -- Guard: If we're not in a real file or outside CWD, stop here
          if buf_name == '' or not vim.startswith(buf_name, cwd) then
            return
          end

          local current_dir = vim.fs.dirname(buf_name)

          if current_dir == cwd then
            return
          end

          local relative_path = vim.fs.relpath(cwd, current_dir)
          if not relative_path or relative_path == '.' then
            return
          end

          -- 2. Calculate depth
          local depth = 0
          for _ in string.gmatch(relative_path, '[^/]+') do
            depth = depth + 1
          end

          -- 3. Execute navigation
          -- We use a small defer to ensure the UI is ready
          vim.schedule(function()
            for _ = 1, depth do
              MiniFiles.go_out()
            end
            for _ = 1, depth do
              MiniFiles.go_in()
            end
          end)
        end, { desc = 'Mini Files (Tree View)' })
        -------------------------------------------------------------------------------

        -- ========== [mini.files] Create keymap specific to mini.files ==========
        vim.api.nvim_create_autocmd('User', {
          pattern = 'MiniFilesBufferCreate',
          callback = function(args)
            local bufnr = args.data.buf_id

            -- ========== [mini.files] Make right arrow open only dirs ==========
            vim.keymap.set('n', '<right>', function()
              local fs_entry = require('mini.files').get_fs_entry()
              if fs_entry and fs_entry.fs_type == 'directory' then
                require('mini.files').go_in()
              end
            end, { buffer = bufnr, desc = 'Go in dir' })
            -------------------------------------------------------------------------------

            -- ========== [mini.files] Make enter open only files ==========
            vim.keymap.set('n', '<enter>', function()
              local fs_entry = require('mini.files').get_fs_entry()
              if fs_entry and fs_entry.fs_type == 'file' then
                require('mini.files').go_in()
                require('mini.files').close()
              end
            end, { buffer = bufnr, desc = 'Open file' })
            -------------------------------------------------------------------------------

            -- ========== [mini.files] Open file in split ==========
            vim.keymap.set('n', '<C-enter>', function()
              local mini_files = require 'mini.files'
              local entry = mini_files.get_fs_entry()
              if not entry then
                return
              end

              local state = mini_files.get_explorer_state()
              if not state then
                return
              end
              local target_win = state.target_window

              -- Fallback if target window is invalid (rare)
              if not target_win or not vim.api.nvim_win_is_valid(target_win) then
                target_win = vim.api.nvim_get_current_win()
              end

              if entry.fs_type == 'file' then
                local new_win
                vim.api.nvim_win_call(target_win, function()
                  vim.cmd 'vsplit'
                  new_win = vim.api.nvim_get_current_win()
                end)

                mini_files.set_target_window(new_win)
                mini_files.go_in { close_on_file = true }
              end
            end, { buffer = bufnr, desc = 'Open in vertical split' })
            -------------------------------------------------------------------------------
          end,
        })
        -------------------------------------------------------------------------------
      end
      -------------------------------------------------------------------------------
    end,
  },
}
