return {
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local actions = require 'diffview.actions'

      -- Heuristic: treat the line as a directory if it contains Diffview's folder icon,
      -- or ends with "/" (works even when icons are disabled in some setups).
      local function is_dir_line()
        local line = vim.api.nvim_get_current_line()
        -- Default folder icons are "" (closed) and "" (open). :contentReference[oaicite:1]{index=1}
        if line:find('', 1, true) or line:find('', 1, true) then
          return true
        end
        if line:match '/%s*$' then
          return true
        end
        return false
      end

      local function move_and_preview(next_or_prev)
        return function()
          next_or_prev()
          if not is_dir_line() then
            actions.select_entry()
          end
        end
      end

      local function fold_action(open_or_close)
        return function()
          if is_dir_line() then
            open_or_close()
          end
        end
      end

      require('diffview').setup {
        keymaps = {
          file_panel = {
            -- Move and auto-open ONLY files (no folder expand/collapse on movement)
            { 'n', '<Down>', move_and_preview(actions.next_entry), { desc = 'Next entry + preview file' } },
            { 'n', '<Up>', move_and_preview(actions.prev_entry), { desc = 'Prev entry + preview file' } },

            -- Folder folding on arrows (left = collapse, right = expand)
            { 'n', '<Left>', fold_action(actions.close_fold), { desc = 'Collapse folder' } },
            { 'n', '<Right>', fold_action(actions.open_fold), { desc = 'Expand folder' } },

            -- Keep Enter as an explicit "open/toggle" action if you want
            { 'n', '<CR>', actions.goto_file_edit, { desc = 'Open file' } },
          },
        },
      }
    end,
  },
}
