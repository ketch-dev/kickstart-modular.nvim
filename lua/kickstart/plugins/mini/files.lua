return {
  setup = function()
    if vim.g.vscode then
      return
    end

    local mini_files = require 'mini.files'

    mini_files.setup {
      cond = not vim.g.vscode,
      mappings = {
        close = '<C-g>',
        go_in_plus = '<CR>',
        go_out = '<left>',
        synchronize = '<C-s>',
      },
      content = {
        prefix = function(fs_entry)
          if fs_entry.fs_type == 'directory' then
            return '', 'MiniFilesFile'
          end

          return mini_files.default_prefix(fs_entry)
        end,
      },
    }

    vim.keymap.set('n', '<C-e>', function()
      local buf_name = vim.api.nvim_buf_get_name(0)
      local cwd = vim.fn.getcwd()

      mini_files.open(buf_name)

      if buf_name == '' or not vim.startswith(buf_name, cwd) then
        return
      end

      local current_dir = vim.fs.dirname(buf_name)
      if current_dir == cwd then
        return
      end

      local relative_path = vim.fs.relpath(cwd, current_dir)
      if not relative_path or relative_path == '.' then
        return
      end

      local depth = 0
      for _ in string.gmatch(relative_path, '[^/]+') do
        depth = depth + 1
      end

      vim.schedule(function()
        for _ = 1, depth do
          mini_files.go_out()
        end

        for _ = 1, depth do
          mini_files.go_in()
        end
      end)
    end, { desc = 'Mini Files (Tree View)' })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local bufnr = args.data.buf_id

        vim.keymap.set('n', '<right>', function()
          local fs_entry = mini_files.get_fs_entry()
          if fs_entry and fs_entry.fs_type == 'directory' then
            mini_files.go_in()
          end
        end, { buffer = bufnr, desc = 'Go in dir' })

        vim.keymap.set('n', '<enter>', function()
          local fs_entry = mini_files.get_fs_entry()
          if fs_entry and fs_entry.fs_type == 'file' then
            mini_files.go_in()
            mini_files.close()
          end
        end, { buffer = bufnr, desc = 'Open file' })

        vim.keymap.set('n', '<C-cr>', function()
          local entry = mini_files.get_fs_entry()
          if not entry then
            return
          end

          local state = mini_files.get_explorer_state()
          if not state then
            return
          end

          local target_win = state.target_window
          if not target_win or not vim.api.nvim_win_is_valid(target_win) then
            target_win = vim.api.nvim_get_current_win()
          end

          if entry.fs_type == 'file' then
            local new_win
            vim.api.nvim_win_call(target_win, function()
              vim.cmd 'vsplit'
              new_win = vim.api.nvim_get_current_win()
            end)

            mini_files.set_target_window(new_win)
            mini_files.go_in { close_on_file = true }
          end
        end, { buffer = bufnr, desc = 'Open in vertical split' })
      end,
    })
  end,
}
