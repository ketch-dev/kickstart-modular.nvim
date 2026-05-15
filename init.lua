require 'options'
require 'keymaps'
require 'plugins'

if not vim.g.vscode then
  require('custom.syntax-overlay').setup()
  require('custom.ui-overlay').setup()
  require('custom.adaptive-gutter').setup()
end
