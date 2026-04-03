return {
  setup = function()
    require('mini.surround').setup {
      mappings = {
        add = 'sa',
        delete = 'sd',
        find = 'sf',
        find_left = 'st',
        replace = 'sr',
        update_n_lines = '',
        highlight = 'sh',
      },
    }
  end,
}
