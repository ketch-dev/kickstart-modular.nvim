vim.pack.add { 'https://github.com/Exafunction/windsurf.nvim' }

local language_server = vim.fn.exepath 'codeium_language_server'

do
  local ok, versions = pcall(require, 'codeium.versions')
  if ok and language_server ~= '' then
    local version = vim.system({ language_server, '--version' }, { text = true }):wait()
    local stamp = vim.system({ language_server, '--stamp' }, { text = true }):wait()
    local version_output = (version.stdout or '') .. (version.stderr or '')
    local stamp_output = (stamp.stdout or '') .. (stamp.stderr or '')

    versions.extension = version_output:match '%f[%d](%d+%.%d+%.%d+)%f[%D]' or versions.extension
    versions.extension_stamp = stamp_output:match 'STABLE_BUILD_SCM_REVISION:%s*(%S+)' or versions.extension_stamp
  end
end

do
  local ok, Server = pcall(require, 'codeium.api')
  if ok then
    local request = Server.request
    function Server:request(fn, payload, callback)
      if fn == 'CancelRequest' then
        if callback then callback(nil, nil) end
        return
      end
      return request(self, fn, payload, callback)
    end
  end
end

require('codeium').setup {
  quiet = true,
  enable_chat = false,
  enable_cmp_source = false,
  virtual_text = {
    enabled = true,
    map_keys = false,
  },
  tools = {
    language_server = language_server,
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
