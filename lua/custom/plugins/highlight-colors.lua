return {
  {
    'brenoprata10/nvim-highlight-colors',
    cond = not vim.g.vscode,
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      render = 'virtual',
      virtual_symbol = '██',
      virtual_symbol_prefix = '',
      virtual_symbol_suffix = '',
      enable_hex = true,
      enable_short_hex = true,
      enable_rgb = true,
      enable_hsl = true,
      enable_named_colors = true,
      enable_var_usage = true,
      enable_ansi = false,
      enable_xterm256 = false,
      enable_xtermTrueColor = false,
      enable_hsl_without_function = false,
    },
    config = function(_, opts)
      local hc = require 'nvim-highlight-colors'
      hc.setup(opts)
    end,
  },
}
