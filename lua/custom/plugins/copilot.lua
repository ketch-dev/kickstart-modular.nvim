local shortcuts = require 'shortcuts'

vim.pack.add { { src = 'https://github.com/zbirenbaum/copilot.lua', version = vim.version.range '2.*' } }

require('copilot').setup {
  panel = { enabled = false },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = true,
    trigger_on_accept = false,
    keymap = {
      accept = shortcuts.accept_suggestion,
      accept_word = false,
      accept_line = false,
      next = false,
      prev = false,
      dismiss = shortcuts.dismiss_suggestion,
      toggle_auto_trigger = false,
    },
  },
  nes = { enabled = false },
}

local group = vim.api.nvim_create_augroup('copilot-blink', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = group,
  pattern = 'BlinkCmpMenuOpen',
  callback = function() vim.b.copilot_suggestion_hidden = true end,
})
vim.api.nvim_create_autocmd('User', {
  group = group,
  pattern = 'BlinkCmpMenuClose',
  callback = function() vim.b.copilot_suggestion_hidden = false end,
})
