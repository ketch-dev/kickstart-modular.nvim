-- ========== Show Tabs ==========

return {
  {
    'akinsho/bufferline.nvim',
    cond = not vim.g.vscode,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    version = '*',
    opts = {
      options = {
        separator_style = 'slant',
        mode = 'tabs',
        name_formatter = function(tab)
          local tabs = vim.api.nvim_list_tabpages()
          local index = vim.fn.index(tabs, tab.tabnr)
          return tostring(index + 1)
        end,
        always_show_bufferline = false,
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
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
  },
}
