return {
  setup = function()
    if vim.g.vscode then return end

    local line = require 'mini.statusline'
    local icon_hl_cache = {}
    local icon_hl_group = vim.api.nvim_create_augroup('custom-mini-statusline-icon-hl', { clear = true })

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = icon_hl_group,
      callback = function() icon_hl_cache = {} end,
    })

    local function file_icon()
      if not vim.g.have_nerd_font or vim.bo.buftype == 'terminal' then return '', nil end

      local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
      if not has_devicons then return '', nil end

      local icon, icon_hl = devicons.get_icon(vim.fn.expand '%:t', nil, { default = true })
      if not icon then return '', nil end

      return icon, icon_hl
    end

    local function file_icon_hl(icon_hl)
      if not icon_hl then return 'MiniStatuslineFilename' end

      local cached_hl = icon_hl_cache[icon_hl]
      if cached_hl and vim.fn.hlexists(cached_hl) == 1 then return cached_hl end

      local merged_hl = 'MiniStatuslineFileIcon_' .. icon_hl:gsub('[^%w_]', '_')
      icon_hl_cache[icon_hl] = merged_hl

      local ok_icon, icon_hl_def = pcall(vim.api.nvim_get_hl, 0, { name = icon_hl, link = false })
      local ok_filename, filename_hl_def = pcall(vim.api.nvim_get_hl, 0, { name = 'MiniStatuslineFilename', link = false })
      if not ok_icon or not ok_filename then return 'MiniStatuslineFilename' end

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

    local function cwd_suffix()
      local cwd = vim.fn.getcwd()
      local cwd_name = vim.fn.fnamemodify(cwd, ':t')
      if cwd_name == '' then cwd_name = cwd end
      return cwd_name
    end

    line.setup {
      use_icons = vim.g.have_nerd_font,
      content = {
        active = function()
          local mode, mode_hl = line.section_mode { trunc_width = 120 }
          local diff = line.section_diff { trunc_width = 75 }
          local diagnostics = (line.section_diagnostics {
            trunc_width = 75,
            icon = '',
            signs = {
              ERROR = ' ',
              WARN = ' ',
              INFO = ' ',
              HINT = '󰌵 ',
            },
          }):gsub('^%s+', '')
          local icon, icon_hl = file_icon()
          local statusline_icon_hl = file_icon_hl(icon_hl)
          local filename = vim.bo.buftype == 'terminal' and '%t' or '%t%m%r'
          local cwd = cwd_suffix()
          local location = line.section_location { trunc_width = 75 }
          local search = line.section_searchcount { trunc_width = 75 }

          return line.combine_groups {
            '%<',
            { hl = statusline_icon_hl, strings = { icon } },
            '%<%#MiniStatuslineFilename#' .. filename,
            { hl = 'WinBarNC', strings = { cwd } },
            '%=',
            { hl = 'MiniStatuslineSearchcount', strings = { search } },
            { hl = 'MiniStatuslineFilename', strings = { location } },
            { hl = 'MiniStatuslineDevinfo', strings = { diff } },
            { hl = 'MiniStatuslineDiagnostics', strings = { diagnostics } },
            { hl = mode_hl, strings = { mode } },
          }
        end,

        inactive = function()
          local icon = file_icon()
          local filename = vim.bo.buftype == 'terminal' and '%t' or '%t%m%r'

          return line.combine_groups {
            { hl = 'MiniStatuslineInactive', strings = { icon } },
            '%<%#MiniStatuslineInactive#' .. filename,
            '%=',
          }
        end,
      },
    }

    ---@diagnostic disable-next-line: duplicate-set-field
    line.section_location = function() return string.format('%7s', string.format('%d:%d', vim.fn.line '.', vim.fn.charcol '.')) end
  end,
}
