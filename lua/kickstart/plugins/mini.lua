-- ========== Collection of various small independent plugins/modules ==========

return {
  {
    'echasnovski/mini.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
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
        -- saiw) - [S]urround [A]dd [I]nside [W]ord [)]Paren
        -- sd'   - [S]urround [D]elete [']quotes
        -- sr)'  - [S]urround [R]eplace [)] [']
        mappings = {
          add = 'sa',
          delete = 'sd',
          find = 'sf',
          find_left = 'st',
          replace = 'sr',
          update_n_lines = '',
          highlight = 'sh',
        },
      }
      -------------------------------------------------------------------------------

      -- ========== Add corresponding pair ==========
      if not vim.g.vscode then
        require('mini.pairs').setup()

        local bracket_pairs = { ['('] = ')', ['['] = ']', ['{'] = '}' }
        local term = function(keys)
          return vim.api.nvim_replace_termcodes(keys, true, true, true)
        end

        local key_left = term '<Left>'
        local key_bs = term '<BS>'
        local key_del = term '<Del>'

        local function char_at(line, idx)
          if idx < 1 or idx > #line then
            return ''
          end
          return line:sub(idx, idx)
        end

        local function is_bracket_pair(open_char, close_char)
          return bracket_pairs[open_char] == close_char
        end

        vim.keymap.set('i', '<Space>', function()
          local col = vim.fn.col '.'
          local line = vim.api.nvim_get_current_line()

          local left = char_at(line, col - 1)
          local right = char_at(line, col)

          if is_bracket_pair(left, right) then
            return '  ' .. key_left
          end

          return ' '
        end, { expr = true, replace_keycodes = false, desc = 'Expand spaces inside brackets' })

        vim.keymap.set('i', '<BS>', function()
          local col = vim.fn.col '.'
          local line = vim.api.nvim_get_current_line()

          local left = char_at(line, col - 1)
          local right = char_at(line, col)
          local left_outer = char_at(line, col - 2)
          local right_outer = char_at(line, col + 1)

          if left == ' ' and right == ' ' and is_bracket_pair(left_outer, right_outer) then
            return key_bs .. key_del
          end

          return MiniPairs.bs()
        end, { expr = true, replace_keycodes = false, desc = 'Contract spaces inside brackets' })
      end
      -------------------------------------------------------------------------------

      -- ========== Status line ==========
      if not vim.g.vscode then
        local line = require 'mini.statusline'
        local icon_hl_cache = {}
        local icon_hl_group = vim.api.nvim_create_augroup('custom-mini-statusline-icon-hl', { clear = true })

        vim.api.nvim_create_autocmd('ColorScheme', {
          group = icon_hl_group,
          callback = function()
            icon_hl_cache = {}
          end,
        })

        local function file_icon()
          if not vim.g.have_nerd_font or vim.bo.buftype == 'terminal' then
            return '', nil
          end

          local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
          if not has_devicons then
            return '', nil
          end

          local icon, icon_hl = devicons.get_icon(vim.fn.expand '%:t', nil, { default = true })
          if not icon then
            return '', nil
          end

          return icon, icon_hl
        end

        local function file_icon_hl(icon_hl)
          if not icon_hl then
            return 'MiniStatuslineFilename'
          end

          local cached_hl = icon_hl_cache[icon_hl]
          if cached_hl and vim.fn.hlexists(cached_hl) == 1 then
            return cached_hl
          end

          local merged_hl = 'MiniStatuslineFileIcon_' .. icon_hl:gsub('[^%w_]', '_')
          icon_hl_cache[icon_hl] = merged_hl

          local ok_icon, icon_hl_def = pcall(vim.api.nvim_get_hl, 0, { name = icon_hl, link = false })
          local ok_filename, filename_hl_def = pcall(vim.api.nvim_get_hl, 0, { name = 'MiniStatuslineFilename', link = false })
          if not ok_icon or not ok_filename then
            return 'MiniStatuslineFilename'
          end

          vim.api.nvim_set_hl(0, merged_hl, {
            fg = icon_hl_def.fg or filename_hl_def.fg,
            bg = filename_hl_def.bg,
            ctermfg = icon_hl_def.ctermfg or filename_hl_def.ctermfg,
            ctermbg = filename_hl_def.ctermbg,
            bold = icon_hl_def.bold,
            italic = icon_hl_def.italic,
            underline = icon_hl_def.underline,
            undercurl = icon_hl_def.undercurl,
            strikethrough = icon_hl_def.strikethrough,
            nocombine = icon_hl_def.nocombine,
          })

          return merged_hl
        end

        line.setup {
          use_icons = vim.g.have_nerd_font,
          content = {
            active = function()
              local mode, mode_hl = line.section_mode { trunc_width = 120 }
              local diff = line.section_diff { trunc_width = 75 }
              local diagnostics = line.section_diagnostics { trunc_width = 75 }
              local icon, icon_hl = file_icon()
              local statusline_icon_hl = file_icon_hl(icon_hl)
              local filename = vim.bo.buftype == 'terminal' and '%t' or '%t%m%r'
              local location = line.section_location { trunc_width = 75 }
              local search = line.section_searchcount { trunc_width = 75 }

              return line.combine_groups {
                '%<', -- Truncation point
                { hl = statusline_icon_hl, strings = { icon } },
                '%<%#MiniStatuslineFilename#' .. filename,
                '%=', -- Fill space
                { hl = 'MiniStatuslineSearchcount', strings = { search } },
                { hl = 'MiniStatuslineFilename', strings = { location } },
                { hl = 'MiniStatuslineDevinfo', strings = { diff, diagnostics } },
                { hl = mode_hl, strings = { mode } },
              }
            end,

            inactive = function()
              local icon = file_icon()
              local filename = vim.bo.buftype == 'terminal' and '%t' or '%t%m%r'
              return line.combine_groups {
                { hl = 'MiniStatuslineInactive', strings = { icon } },
                '%<%#MiniStatuslineInactive#' .. filename,
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
        local mini_files = require 'mini.files'

        require('mini.files').setup {
          cond = not vim.g.vscode,
          mappings = {
            close = '<C-c>',
            go_in_plus = '<CR>',
            go_out = '<left>',
            synchronize = '<C-s>',
          },
          content = {
            prefix = function(fs_entry)
              if fs_entry.fs_type == 'directory' then
                return '', 'MiniFilesFile'
              end

              return mini_files.default_prefix(fs_entry)
            end,
          },
        }

        -- ========== [mini.files] View full CWD tree ==========
        vim.keymap.set('n', '<C-e>', function()
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
