return {
  setup = function()
    if vim.g.vscode then return end

    local diff = require 'mini.diff'
    local overlay_enabled = false

    local function is_overlay_allowed(buf)
      if not vim.api.nvim_buf_is_valid(buf) then return false end

      if vim.startswith(vim.api.nvim_buf_get_name(buf), 'diffview://') then return false end

      for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        if vim.api.nvim_win_is_valid(win) and vim.wo[win].diff then return false end
      end

      return true
    end

    local function sync_overlay(buf)
      local data = diff.get_buf_data(buf)
      local should_enable = overlay_enabled and is_overlay_allowed(buf)

      if data and data.overlay ~= should_enable then diff.toggle_overlay(buf) end
    end

    local function sync_all_overlays()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        sync_overlay(buf)
      end
    end

    diff.setup {
      view = {
        style = 'sign',
        signs = {
          add = '',
          change = '',
          delete = '',
        },
      },
      mappings = {
        apply = '',
        reset = '',
        textobject = '',
        goto_first = '',
        goto_prev = '',
        goto_next = '',
        goto_last = '',
      },
    }

    vim.keymap.set('n', '<leader>so', function()
      overlay_enabled = not overlay_enabled
      sync_all_overlays()
    end, { desc = '[o]verlay' })

    local overlay_group = vim.api.nvim_create_augroup('custom-mini-diff-overlay', { clear = true })

    vim.api.nvim_create_autocmd('User', {
      group = overlay_group,
      pattern = 'MiniDiffUpdated',
      callback = function(args) sync_overlay(args.buf) end,
    })

    vim.api.nvim_create_autocmd('VimEnter', {
      group = overlay_group,
      callback = function() vim.schedule(sync_all_overlays) end,
    })

    vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter', 'WinClosed' }, {
      group = overlay_group,
      callback = function() vim.schedule(sync_all_overlays) end,
    })
  end,
}
