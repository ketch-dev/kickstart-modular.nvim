return {
  {
    'Exafunction/windsurf.nvim',
    build = "sed -i 's/2deb37376016b8eb5f2895a7b7a5f46aa57fb6d6/b58db8747a7dc1c042e3131f1e2246141d466923/' lua/codeium/versions.json",
    config = function()
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
      end, { expr = true, silent = true, desc = 'Accept ghost text' })

      vim.keymap.set('i', '<Tab>', function()
        local ok, vt = pcall(require, 'codeium.virtual_text')
        if ok and vt.get_current_completion_item() then
          vt.cycle_completions(1)
          return ''
        end
        return '<Tab>'
      end, { expr = true, silent = true, desc = 'Cycle ghost text forward' })

      vim.keymap.set('i', '<S-Tab>', function()
        local ok, vt = pcall(require, 'codeium.virtual_text')
        if ok and vt.get_current_completion_item() then
          vt.cycle_completions(-1)
          return ''
        end
        return '<S-Tab>'
      end, { expr = true, silent = true, desc = 'Cycle ghost text backward' })
    end,
  },
}
