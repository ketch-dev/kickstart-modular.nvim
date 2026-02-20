return {
  {
    'Mofiqul/vscode.nvim',
    cond = not vim.g.vscode,
    lazy = false,
    priority = 1100, -- Register before the base colorscheme is applied.
    config = function()
      local group = vim.api.nvim_create_augroup('vscode_syntax_blend', { clear = true })
      local opts = {
        transparent = false,
        italic_comments = false,
        italic_inlayhints = false,
        underline_links = false,
        disable_nvimtree_bg = true,
      }

      local function apply_vscode_syntax()
        local ok, vscode_syntax = pcall(require, 'custom.utils.vscode-syntax-overrides')
        if not ok then
          return
        end

        local syntax_overrides = vscode_syntax.get(opts)
        for hl_group, spec in pairs(syntax_overrides) do
          vim.api.nvim_set_hl(0, hl_group, spec)
        end
      end

      vim.api.nvim_create_autocmd('ColorScheme', {
        group = group,
        desc = 'Blend VSCode syntax into active colorscheme',
        callback = apply_vscode_syntax,
      })

      if vim.g.colors_name then
        apply_vscode_syntax()
      end
    end,
  },
}
