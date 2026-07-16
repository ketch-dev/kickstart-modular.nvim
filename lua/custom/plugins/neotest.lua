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

local function current_root_path() return vim.fs.root(current_path(), { 'go.work', 'go.mod', 'package.json', '.git' }) or vim.fn.getcwd() end

local function filter_node_modules(name) return name ~= 'node_modules' end

vim.pack.add {
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/antoinemadec/FixCursorHold.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-neotest/neotest-go',
  'https://github.com/nvim-neotest/neotest-jest',
  'https://github.com/marilari88/neotest-vitest',
  'https://github.com/thenbe/neotest-playwright',
}

vim.keymap.set('n', '<leader>tt', function() require('neotest').run.run() end, { desc = 'run [t]est' })
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(current_path()) end, { desc = 'run [f]ile' })
vim.keymap.set('n', '<leader>tp', function() require('neotest').run.run(current_package_path()) end, { desc = 'run [p]ackage' })
vim.keymap.set('n', '<leader>ta', function() require('neotest').run.run(current_root_path()) end, { desc = 'run [a]ll' })
vim.keymap.set('n', '<leader>tr', function() require('neotest').run.run_last() end, { desc = '[r]erun' })
vim.keymap.set('n', '<leader>tu', function() require('neotest').summary.toggle() end, { desc = '[u]i' })
vim.keymap.set('n', '<leader>to', function() require('neotest').output.open { enter = false, auto_close = true } end, { desc = '[o]utput' })
vim.keymap.set('n', '<leader>tO', function() require('neotest').output_panel.toggle() end, { desc = '[O]utput panel' })
vim.keymap.set('n', '<leader>tk', function() require('neotest').run.stop() end, { desc = '[k]ill' }) -- [shortcuts.kill]
vim.keymap.set('n', '<leader>tw', function() require('neotest').watch.toggle(current_path()) end, { desc = '[w]atch file' })

require('neotest').setup {
  output = {
    open_on_run = true,
  },
  adapters = {
    require 'neotest-go' {
      recursive_run = true,
    },
    require 'neotest-jest' {},
    require 'neotest-vitest' {
      filter_dir = filter_node_modules,
    },
    require('neotest-playwright').adapter {
      options = {
        filter_dir = filter_node_modules,
      },
    },
  },
}
