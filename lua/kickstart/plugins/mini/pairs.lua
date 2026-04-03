return {
  setup = function()
    if vim.g.vscode then
      return
    end

    require('mini.pairs').setup()

    local bracket_pairs = { ['('] = ')', ['['] = ']', ['{'] = '}' }
    local term = function(keys)
      return vim.api.nvim_replace_termcodes(keys, true, true, true)
    end

    local key_left = term '<Left>'
    local key_bs = term '<BS>'
    local key_del = term '<Del>'

    local function char_at(line, idx)
      if idx < 1 or idx > #line then
        return ''
      end
      return line:sub(idx, idx)
    end

    local function is_bracket_pair(open_char, close_char)
      return bracket_pairs[open_char] == close_char
    end

    vim.keymap.set('i', '<Space>', function()
      local col = vim.fn.col '.'
      local line = vim.api.nvim_get_current_line()

      local left = char_at(line, col - 1)
      local right = char_at(line, col)

      if is_bracket_pair(left, right) then
        return '  ' .. key_left
      end

      return ' '
    end, { expr = true, replace_keycodes = false, desc = 'Expand spaces inside brackets' })

    vim.keymap.set('i', '<BS>', function()
      local col = vim.fn.col '.'
      local line = vim.api.nvim_get_current_line()

      local left = char_at(line, col - 1)
      local right = char_at(line, col)
      local left_outer = char_at(line, col - 2)
      local right_outer = char_at(line, col + 1)

      if left == ' ' and right == ' ' and is_bracket_pair(left_outer, right_outer) then
        return key_bs .. key_del
      end

      return MiniPairs.bs()
    end, { expr = true, replace_keycodes = false, desc = 'Contract spaces inside brackets' })
  end,
}
