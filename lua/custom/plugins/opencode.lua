return {
  {
    'nickjvandyke/opencode.nvim',
    version = '*',
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function() _G.__toggleterm_open_ai() end,
        },
      }

      vim.o.autoread = true
      local opencode = require 'opencode'

      vim.keymap.set({ 'n', 'x' }, '<leader>ap', function() opencode.ask('@this: ', { submit = true }) end, { desc = '[p]rompt' })
      vim.keymap.set({ 'n', 'x' }, '<leader>aa', function() opencode.select() end, { desc = '[a]ctions' })
      vim.keymap.set({ 'n', 'x' }, '<leader>as', function() return opencode.operator '@this ' end, { desc = '[s]end', expr = true })
    end,
  },
}
