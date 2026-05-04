-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

local function continue_or_run_first_config()
  local dap = require 'dap'

  if dap.session() then
    dap.continue()
    return
  end

  local configs = dap.configurations[vim.bo.filetype]
  if configs and configs[1] then
    dap.run(configs[1])
  else
    dap.continue()
  end
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
    { '<leader>du', function() require('dapui').toggle() end, desc = '[u]i' },
    {
      '<leader>dm',
      function()
        if not require('dap').session() then require('dap').continue() end
      end,
      desc = '[m]enu',
    },
    { '<leader>dc', continue_or_run_first_config, desc = '[c]ontinue' },
    { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'run to [C]ursor' },
    { '<leader>dh', function() require('dap.ui.widgets').hover() end, desc = '[h]over', mode = { 'n', 'x' } },
    { '<leader>de', function() require('dapui').eval() end, desc = '[e]val', mode = { 'n', 'x' } },
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
      icons = { expanded = '', collapsed = '', current_frame = '' },
      ---@diagnostic disable-next-line: missing-fields
      controls = {
        icons = {
          pause = '',
          play = '',
          step_into = '',
          step_over = '',
          step_out = '',
          step_back = '',
          run_last = '',
          terminate = '',
          disconnect = '',
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#c85151' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#5f87af' })

    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      local linehl = (type == 'Stopped') and 'debugPC' or ''
      vim.fn.sign_define(tp, { text = icon, texthl = hl, linehl = linehl, numhl = hl })
    end

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
