local debug_actions = require 'kickstart.utils.debug.actions'
local debug_actual_stop = require 'kickstart.utils.debug.actual_stop'
local debug_hover = require 'kickstart.utils.debug.hover'
local debug_signs = require 'kickstart.utils.debug.signs'

vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/theHamsta/nvim-dap-virtual-text',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/leoluz/nvim-dap-go',
}

require('nvim-dap-virtual-text').setup {}

vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end, { desc = '[u]i' })
vim.keymap.set('n', '<leader>dm', function()
  if not require('dap').session() then require('dap').continue() end
end, { desc = '[m]enu' })
vim.keymap.set('n', '<leader>dc', debug_actions.continue_or_run_first_config, { desc = '[c]ontinue' })
vim.keymap.set('n', '<leader>dC', function() require('dap').run_to_cursor() end, { desc = 'run to [C]ursor' })
vim.keymap.set({ 'n', 'x' }, '<leader>dh', debug_hover.focus_or_open, { desc = '[h]over' })
vim.keymap.set({ 'n', 'x' }, '<leader>de', function() require('dapui').eval() end, { desc = '[e]val' })
vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, { desc = 'step [i]nto' })
vim.keymap.set('n', '<leader>d<tab>', function() require('dap').down() end, { desc = 'frame down' })
vim.keymap.set('n', '<leader>d<s-tab>', function() require('dap').up() end, { desc = 'frame up' })
vim.keymap.set('n', '<leader>do', function() require('dap').step_over() end, { desc = 'step [o]ver' })
vim.keymap.set('n', '<leader>dO', function() require('dap').step_out() end, { desc = 'step [O]ut' })
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = '[b]reakpoint' })
vim.keymap.set('n', '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'conditional [B]reakpoint' })
vim.keymap.set('n', '<leader>dr', function() require('dap').run_last() end, { desc = '[r]erun' })
vim.keymap.set('n', '<leader>dp', function() require('dap').pause() end, { desc = '[p]ause' })
vim.keymap.set('n', '<leader>dk', function() require('dap').terminate() end, { desc = '[k]ill' })

local dap = require 'dap'
local dapui = require 'dapui'
dapui.setup {
  icons = { expanded = '', collapsed = '', current_frame = '' },
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
local breakpoint_icons = debug_signs.setup()
debug_actual_stop.setup(dap, breakpoint_icons.Stopped)
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close
require('dap-go').setup { delve = { detached = vim.fn.has 'win32' == 0 } }
