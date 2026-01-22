-- ========== Collection of various small independent plugins/modules ==========

return {
  {
    'echasnovski/mini.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      -- va)  - [V]isually select [A]round [)]paren
      -- yinq - [Y]ank [I]nside [N]ext [Q]uote
      -- ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup {
        n_lines = 500,
        custom_textobjects = {
          f = require('mini.ai').gen_spec.treesitter {
            a = '@function.outer',
            i = '@function.inner',
          },
        },
      }
      -- saiw) - [U]rap [A]dd [I]nner [W]ord [)]Paren
      -- sd'   - [U]rap [D]elete [']quotes
      -- sr)'  - [U]rap [R]eplace [)] [']
      require('mini.surround').setup {
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

      -- Setup mini.files (file explorer)
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
          -- windows = {
          --   preview = true,     -- Show preview of file under cursor
          --   width_focus = 30,
          --   width_nofocus = 15,
          -- },
        }

        -- This opens it at the directory of the current buffer (or cwd if no file)
        vim.keymap.set('n', '-', function()
          local miniFiles = require 'mini.files'
          local buf_path = vim.api.nvim_buf_get_name(0)

          -- If the explorer is already open, close it
          if miniFiles.close() then
            return
          end

          -- If we are in a file, open it (this focuses the file)
          if buf_path ~= '' then
            -- miniFiles.open(buf_path, true)
            miniFiles.open(buf_path)
          -- Ideally, we would 'reveal' the path from root here, but mini.files
          -- truncates history by design.
          -- Workaround: You can map a key inside mini.files to "Go to Root"
          -- or just manually press 'h' until you hit root.
          else
            -- If no file, open CWD
            -- miniFiles.open(nil, true) -- Open at cwd, focused
            miniFiles.open(vim.uv.cwd())
          end
        end, { desc = 'Open mini.files' })
      end
    end,
  },
}
