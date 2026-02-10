if vim.g.vscode then
  vim.cmd [[
    function! VSCodeMode() abort
      let current_mode = mode(1)
      let mode_names = {
            \ 'n': 'NORMAL',
            \ 'i': 'INSERT',
            \ 'v': 'VISUAL',
            \ 'V': 'V-LINE',
            \ "\<C-v>": 'V-BLOCK',
            \ 'R': 'REPLACE',
            \ 'c': 'COMMAND',
            \ 't': 'TERMINAL'
            \ }
      let mode_text = get(mode_names, current_mode, current_mode)
      return '█ '.mode_text.' █'
    endfunction
  ]]

  -- Set statusline to show the mode
  vim.opt.statusline = [[%{VSCodeMode()}]]

  -- Force updates when mode changes
  vim.cmd [[
    augroup VSCodeModeDisplay
      autocmd!
      autocmd ModeChanged * redrawstatus
    augroup END
  ]]

  -- Initialize immediately
  vim.cmd 'redrawstatus'
end
