vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  signs_staged_enable = true,
  signs_staged = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  current_line_blame = true,
  current_line_blame_opts = { virt_text = true, virt_text_pos = 'right_align', delay = 300 },
  on_attach = function(bufnr)
    for _, hl in ipairs {
      'GitSignsStagedAdd',
      'GitSignsStagedChange',
      'GitSignsStagedDelete',
      'GitSignsStagedChangedelete',
      'GitSignsStagedTopdelete',
      'GitSignsStagedUntracked',
      'GitSignsStagedAddNr',
      'GitSignsStagedChangeNr',
      'GitSignsStagedDeleteNr',
      'GitSignsStagedChangedeleteNr',
      'GitSignsStagedTopdeleteNr',
      'GitSignsStagedUntrackedNr',
      'GitSignsStagedAddLn',
      'GitSignsStagedChangeLn',
      'GitSignsStagedChangedeleteLn',
      'GitSignsStagedTopdeleteLn',
      'GitSignsStagedUntrackedLn',
      'GitSignsStagedAddCul',
      'GitSignsStagedChangeCul',
      'GitSignsStagedDeleteCul',
      'GitSignsStagedChangedeleteCul',
      'GitSignsStagedTopdeleteCul',
      'GitSignsStagedUntrackedCul',
    } do
      vim.api.nvim_set_hl(0, hl, { link = 'LineNr' })
    end
    local gitsigns = require 'gitsigns'
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end
    map('n', ']h', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'next [h]unk' })
    map('n', '[h', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'prev [h]unk' })
    map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[s]tage hunk' })
    map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[r]eset hunk' })
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[s]tage hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[r]eset hunk' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[S]tage buffer' })
    map('n', '<leader>hu', gitsigns.stage_hunk, { desc = '[u]ndo stage hunk' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[R]eset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[p]review hunk' })
    map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'preview hunk [i]nline' })
    map('n', '<leader>hb', gitsigns.blame_line, { desc = '[b]lame line' })
    map('n', '<leader>gb', gitsigns.blame, { desc = '[b]lame buffer' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = '[d]iff against index' })
    map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = '[D]iff against last commit' })
    map('n', '<leader>hQ', function() gitsigns.setqflist 'all' end, { desc = '[Q]uickfix all hunks' })
    map('n', '<leader>hq', gitsigns.setqflist, { desc = '[q]uickfix hunks' })
    map('n', '<leader>sb', gitsigns.toggle_current_line_blame, { desc = '[b]lame line' })
    map('n', '<leader>sw', gitsigns.toggle_word_diff, { desc = '[w]ord diff' })
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'inside [h]unk' })
    map({ 'o', 'x' }, 'ah', gitsigns.select_hunk, { desc = 'around [h]unk' })
  end,
}
