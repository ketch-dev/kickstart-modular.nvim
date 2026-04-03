return {
  setup = function()
    local ai = require 'mini.ai'

    ai.setup {
      n_lines = 500,
      custom_textobjects = {
        f = ai.gen_spec.treesitter {
          a = '@function.outer',
          i = '@function.inner',
        },
      },
    }
  end,
}
