local M = {}

function M.get_breakpoint_icons()
  return vim.g.have_nerd_font and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
end

function M.setup()
  vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#c85151' })
  vim.api.nvim_set_hl(0, 'DapStop', { fg = '#5f87af' })
  vim.api.nvim_set_hl(0, 'DapActualStop', { fg = '#87af87' })

  local breakpoint_icons = M.get_breakpoint_icons()
  for type, icon in pairs(breakpoint_icons) do
    local tp = 'Dap' .. type
    local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    local linehl = (type == 'Stopped') and 'debugPC' or ''
    vim.fn.sign_define(tp, { text = icon, texthl = hl, linehl = linehl, numhl = hl })
  end

  return breakpoint_icons
end

return M
