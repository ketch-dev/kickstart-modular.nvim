local function current_path()
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then return vim.fn.getcwd() end
  return path
end

local function current_package_path()
  local path = current_path()
  if vim.fn.isdirectory(path) == 1 then return path end
  return vim.fs.dirname(path)
end

local function current_root_path() return vim.fs.root(current_path(), { 'go.work', 'go.mod', '.git' }) or vim.fn.getcwd() end

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-go',
  },
  keys = {
    {
      '<leader>tn',
      function() require('neotest').run.run() end,
      desc = 'run [n]earest test',
    },
    {
      '<leader>tf',
      function() require('neotest').run.run(current_path()) end,
      desc = 'run [f]ile',
    },
    {
      '<leader>tp',
      function() require('neotest').run.run(current_package_path()) end,
      desc = 'run [p]ackage',
    },
    {
      '<leader>ta',
      function() require('neotest').run.run(current_root_path()) end,
      desc = 'run [a]ll',
    },
    {
      '<leader>tr',
      function() require('neotest').run.run_last() end,
      desc = '[r]erun',
    },
    {
      '<leader>td',
      function() require('neotest').run.run { strategy = 'dap' } end,
      desc = '[d]ebug nearest test',
    },
    {
      '<leader>tP',
      function() require('neotest').summary.toggle() end,
      desc = '[P]anel',
    },
    {
      '<leader>to',
      function() require('neotest').output.open { enter = false, auto_close = true } end,
      desc = '[o]utput',
    },
    {
      '<leader>tO',
      function() require('neotest').output_panel.toggle() end,
      desc = '[O]utput panel',
    },
    {
      '<leader>ts',
      function() require('neotest').run.stop() end,
      desc = '[s]top',
    },
    {
      '<leader>tw',
      function() require('neotest').watch.toggle(current_path()) end,
      desc = '[w]atch file',
    },
  },
  config = function()
    require('neotest').setup {
      output = {
        open_on_run = true,
      },
      adapters = {
        require 'neotest-go' {
          recursive_run = true,
        },
      },
    }
  end,
}
