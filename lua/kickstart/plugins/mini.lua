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
        local statusline = require 'mini.statusline'
        statusline.setup {
          use_icons = vim.g.have_nerd_font,
          content = {
            active = function()
              local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
              local diff = MiniStatusline.section_diff { trunc_width = 75 }
              local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
              local filename = MiniStatusline.section_filename { trunc_width = 999999 } -- Forces relative path
              local location = MiniStatusline.section_location { trunc_width = 75 }
              local search = MiniStatusline.section_searchcount { trunc_width = 75 }

              return MiniStatusline.combine_groups {
                { hl = mode_hl, strings = { mode } },
                { hl = 'MiniStatuslineDevinfo', strings = { diff, diagnostics } },
                '%<', -- Truncation point
                { hl = 'MiniStatuslineFilename', strings = { filename } },
                '%=',
                { hl = mode_hl, strings = { location } },
                { hl = 'MiniStatuslineSearchcount', strings = { search } },
              }
            end,

            inactive = function()
              local filename = MiniStatusline.section_filename { trunc_width = 999999 } -- Forces relative for inactive too
              return '%#MiniStatuslineInactive#' .. filename .. '%='
            end,
          },
        }
        -- set the section for cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
          return '%2l:%-2v'
        end
      end
      -------------------------------------------------------------------------------

      -- ========== File Explorer ==========
      if not vim.g.vscode then
        require('mini.files').setup {
          cond = not vim.g.vscode,
          mappings = {
            close = 'q',
            go_in = '<right>',
            go_in_plus = '<CR>',
            go_out = '<left>',
            -- go_out_plus = "H",
            synchronize = '=', -- Save changes
          },
        }

        -- ========== [mini.files] View full CWD tree ==========
        vim.keymap.set('n', '-', function()
          local MiniFiles = require 'mini.files'
          local buf_name = vim.api.nvim_buf_get_name(0)
          local cwd = vim.fn.getcwd()

          -- 1. Open MiniFiles normally focused on the current buffer
          MiniFiles.open(buf_name)

          -- Guard clause: If current buffer is not inside CWD, do nothing more
          if not vim.startswith(buf_name, cwd) then
            return
          end

          -- 2. Calculate the depth to travel
          -- We get the directory of the current file
          local current_dir = vim.fs.dirname(buf_name)

          -- Using native vim.fs to find relative path components
          local relative_path = vim.fs.relpath(cwd, current_dir)

          if not relative_path then
            return
          end

          -- Count how many directories deep we are
          -- (e.g., "components/menu" has 2 slashes/parts)
          local depth = 0
          for _ in string.gmatch(relative_path, '[^/]+') do
            depth = depth + 1
          end

          -- 3. Automate the navigation
          -- We use a small defer to ensure the UI is ready
          vim.schedule(function()
            -- Go out N times to reveal parents up to CWD
            for _ = 1, depth do
              MiniFiles.go_out()
            end

            -- Go back in N times to restore focus to original directory
            for _ = 1, depth do
              MiniFiles.go_in()
            end
          end)
        end, { desc = 'Mini Files (Tree View)' })
        -------------------------------------------------------------------------------

        -- ========== [mini.files] Open split ==========
        vim.api.nvim_create_autocmd('User', {
          pattern = 'MiniFilesBufferCreate',
          callback = function(args)
            local bufnr = args.data.buf_id

            vim.keymap.set('n', '<C-v>', function()
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
          end,
        })
        -------------------------------------------------------------------------------
      end
      -------------------------------------------------------------------------------
    end,
  },
}
