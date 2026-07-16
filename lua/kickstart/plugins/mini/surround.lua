local mappings = {
  add = 'sa',
  delete = 'sd',
  find_left = 'sp',
  find = 'sn',
  replace = 'sr',
  update_n_lines = '',
  highlight = 'sh',
}

require('mini.surround').setup { mappings = mappings }

return mappings
