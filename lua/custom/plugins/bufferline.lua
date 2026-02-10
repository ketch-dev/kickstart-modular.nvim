-- ========== Show Tabs ==========

return {
  {
    'akinsho/bufferline.nvim',
    cond = not vim.g.vscode,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    version = '*',
    init = function()
      _G.__bufferline_new_tab = function()
        vim.cmd 'tabnew'
        vim.cmd 'tabmove'
      end
    end,
    opts = {
      options = {
        separator_style = 'slant',
        mode = 'tabs',
        always_show_bufferline = true,
        show_buffer_icons = false,
        color_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        name_formatter = function(tab)
          local tabs = vim.api.nvim_list_tabpages()
          local index = vim.fn.index(tabs, tab.tabnr)
          return tostring(index + 1)
        end,
        middle_mouse_command = function(id)
          local close = require('bufferline.config').options.close_command
          if type(close) == 'function' then
            pcall(close, id)
          elseif type(close) == 'string' then
            pcall(vim.cmd, string.format(close, id))
          end
        end,
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)

      if not _G.__bufferline_plus_after_tabs_wrapped then
        local original = _G.nvim_bufferline
        _G.nvim_bufferline = function()
          local line, segments = original()
          if type(line) == 'string' and not line:find('v:lua.__bufferline_new_tab', 1, true) then
            line = line:gsub('%%=', '%%T%%@v:lua.__bufferline_new_tab@ + %%T%%=', 1)
          end
          return line, segments
        end
        _G.__bufferline_plus_after_tabs_wrapped = true
      end
    end,
  },
}
