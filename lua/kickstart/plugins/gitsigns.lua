-- Alternatively, use `config = function() ... end` for full control over the configuration.
-- If you prefer to call `setup` explicitly, use:
--    {
--        'lewis6991/gitsigns.nvim',
--        config = function()
--            require('gitsigns').setup({
--                -- Your gitsigns configuration here
--            })
--        end,
--    }
--
-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`.
--
-- See `:help gitsigns` to understand what the configuration keys do

---@module 'lazy'
---@type LazySpec
return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      signs = {
        add = { text = '+' }, ---@diagnostic disable-line: missing-fields
        change = { text = '~' }, ---@diagnostic disable-line: missing-fields
        delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
      },
      signs_staged_enable = true,
      signs_staged = {
        add = { text = '+' }, ---@diagnostic disable-line: missing-fields
        change = { text = '~' }, ---@diagnostic disable-line: missing-fields
        delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
        topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
        changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'right_align',
        delay = 300,
      },
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

        -- Navigation
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

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[s]tage hunk' })
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[r]eset hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = ' [r]eset hunk' })
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

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[b]lame line' })
        map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[w]ord diff' })

        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
        map({ 'o', 'x' }, 'ah', gitsigns.select_hunk)
      end,
    },
  },
}
