-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

local function get_args(config)
  local args = type(config.args) == 'function' and (config.args() or {}) or config.args or {}
  local args_str = type(args) == 'table' and table.concat(args, ' ') or args

  config = vim.deepcopy(config)
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input('Run with args: ', args_str))
    return require('dap.utils').splitstr(new_args)
  end

  return config
end

---@module 'lazy'
---@type LazySpec
return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    {
      'theHamsta/nvim-dap-virtual-text',
      config = function() require('nvim-dap-virtual-text').setup {} end,
    },

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    { '<leader>da', function() require('dap').continue { before = get_args } end, desc = 'run with [a]rgs' },
    { '<leader>dc', function() require('dap').continue() end, desc = '[c]ontinue' },
    { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'run to [C]ursor' },
    { '<leader>de', function() require('dapui').eval() end, desc = '[e]val', mode = { 'n', 'x' } },
    { '<leader>dE', function() require('dap').repl.toggle() end, desc = '[E]val (repl)' },
    { '<leader>di', function() require('dap').step_into() end, desc = 'step [i]nto' },
    { '<leader>d<Down>', function() require('dap').down() end, desc = '[] frame' },
    { '<leader>d<Up>', function() require('dap').up() end, desc = '[] frame' },
    { '<leader>do', function() require('dap').step_over() end, desc = 'step [o]ver' },
    { '<leader>dO', function() require('dap').step_out() end, desc = 'step [O]ut' },
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = '[b]reakpoint' },
    { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'conditional [B]reakpoint' },
    { '<leader>dr', function() require('dap').run_last() end, desc = '[r]erun' },
    { '<leader>dp', function() require('dap').pause() end, desc = '[p]ause' },
    { '<leader>ds', function() require('dap').terminate() end, desc = '[s]top' },
    {
      '<leader>dt',
      function()
        require('lazy').load { plugins = { 'neotest' } }
        require('neotest').run.run { strategy = 'dap' }
      end,
      desc = 'debug [t]est',
    },
    { '<leader>du', function() require('dapui').toggle() end, desc = '[u]i' },
    { '<leader>dw', function() require('dap.ui.widgets').hover() end, desc = 'hover [w]idget' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    ---@diagnostic disable-next-line: missing-fields
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      ---@diagnostic disable-next-line: missing-fields
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
