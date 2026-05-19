vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name ~= 'windsurf.nvim' then return end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end
    local result = vim
      .system(
        { 'sed', '-i', 's/2deb37376016b8eb5f2895a7b7a5f46aa57fb6d6/b58db8747a7dc1c042e3131f1e2246141d466923/', 'lua/codeium/versions.json' },
        { cwd = ev.data.path }
      )
      :wait()
    if result.code ~= 0 then vim.notify(('Build failed for windsurf.nvim:\n%s'):format(result.stderr or result.stdout), vim.log.levels.ERROR) end
  end,
})

vim.pack.add { 'https://github.com/Exafunction/windsurf.nvim' }

require('codeium').setup {
  quiet = true,
  enable_cmp_source = false,
  virtual_text = {
    enabled = true,
    map_keys = false,
  },
  tools = {
    language_server = vim.fn.exepath 'codeium_language_server',
  },
}

vim.keymap.set('i', '<C-y>', function()
  local ok, vt = pcall(require, 'codeium.virtual_text')
  if ok and vt.get_current_completion_item() then return vt.accept() end
  return '<C-y>'
end, { expr = true, silent = true, desc = 'accept ghost text' })

vim.keymap.set('i', '<Tab>', function()
  local ok, vt = pcall(require, 'codeium.virtual_text')
  if ok and vt.get_current_completion_item() then
    vt.cycle_completions(1)
    return ''
  end
  return '<Tab>'
end, { expr = true, silent = true, desc = 'next ghost text' })

vim.keymap.set('i', '<S-Tab>', function()
  local ok, vt = pcall(require, 'codeium.virtual_text')
  if ok and vt.get_current_completion_item() then
    vt.cycle_completions(-1)
    return ''
  end
  return '<S-Tab>'
end, { expr = true, silent = true, desc = 'prev ghost text' })
