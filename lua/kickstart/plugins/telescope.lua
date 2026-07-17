vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name ~= 'telescope-fzf-native.nvim' then return end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end
    if vim.fn.executable 'make' ~= 1 then return end
    local result = vim.system({ 'make' }, { cwd = ev.data.path }):wait()
    if result.code ~= 0 then vim.notify(('Build failed for telescope-fzf-native.nvim:\n%s'):format(result.stderr or result.stdout), vim.log.levels.ERROR) end
  end,
})

local telescope_plugins = {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
}
if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, 'https://github.com/nvim-telescope/telescope-fzf-native.nvim') end
if vim.g.have_nerd_font then table.insert(telescope_plugins, 'https://github.com/nvim-tree/nvim-web-devicons') end

vim.pack.add(telescope_plugins)

local actions = require 'telescope.actions'
local shortcuts = require 'shortcuts'
local telescope_utils = require 'telescope.utils'

local function close_diffview_before_file_open()
  if require('diffview.lib').get_current_view() then require('diffview').close() end
  return 0
end

local function dim_directory_prefix(opts, path)
  local transformed_path = telescope_utils.transform_path(vim.tbl_extend('force', opts or {}, { path_display = { 'smart' } }), path)
  local filename = telescope_utils.path_tail(transformed_path)
  local directory_prefix_len = #transformed_path - #filename
  if directory_prefix_len > 0 then return transformed_path, { { { 0, directory_prefix_len }, 'TelescopeResultsComment' } } end
  return transformed_path
end

local function set_file_path_highlights() vim.api.nvim_set_hl(0, 'TelescopeResultsComment', { link = 'LineNr' }) end
set_file_path_highlights()
vim.api.nvim_create_autocmd(
  'ColorScheme',
  { group = vim.api.nvim_create_augroup('TelescopePathHighlights', { clear = true }), callback = set_file_path_highlights }
)

require('telescope').setup {
  defaults = {
    get_selection_window = close_diffview_before_file_open,
    path_display = dim_directory_prefix,
    scroll_strategy = 'limit',
    layout_strategy = 'horizontal',
    sorting_strategy = 'ascending',
    layout_config = { width = 0.91, height = 0.92, horizontal = { prompt_position = 'top', preview_width = 0.5 } },
    mappings = {
      i = {
        [shortcuts.leave] = actions.close,
        [shortcuts.kill_buffer] = actions.nop,
        [shortcuts.open_vertical_split] = actions.select_vertical,
        [shortcuts.navigate_down] = actions.move_selection_next,
        [shortcuts.navigate_up] = actions.move_selection_previous,
        [shortcuts.cycle_suggestion] = actions.nop,
        [shortcuts.cycle_suggestion_backward] = actions.nop,
        ['<C-n>'] = false,
        ['<C-p>'] = false,
        ['<Left>'] = false,
        ['<Right>'] = false,
      },
      n = {
        ['<Esc>'] = false,
        [shortcuts.leave] = actions.close,
        [shortcuts.kill_buffer] = actions.nop,
        [shortcuts.open_vertical_split] = actions.select_vertical,
        [shortcuts.navigate_down] = actions.move_selection_next,
        [shortcuts.navigate_up] = actions.move_selection_previous,
        [shortcuts.cycle_suggestion] = actions.nop,
        [shortcuts.cycle_suggestion_backward] = actions.nop,
        ['<C-n>'] = false,
        ['<C-p>'] = false,
        ['<Left>'] = false,
        ['<Right>'] = false,
        ['h'] = false,
        ['j'] = false,
        ['k'] = false,
        ['l'] = false,
      },
    },
  },
  extensions = { ['ui-select'] = { require('telescope.themes').get_dropdown() } },
}
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[h]elp' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[k]eymaps' })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[f]iles' })
vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[s]elect telescope' })
vim.keymap.set({ 'n', 'v' }, '<leader>fw', builtin.grep_string, { desc = 'current [w]ord' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[g]rep' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[d]iagnostics' })
vim.keymap.set('n', '<leader>f.', builtin.resume, { desc = 'resume' })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[r]ecent files' })
vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = '[c]ommands' })
vim.keymap.set('n', '<leader>fb', function()
  builtin.buffers {
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<C-Del>', actions.delete_buffer)
      return true
    end,
  }
end, { desc = '[b]uffers' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf
    vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = buf, desc = '[g]oto [r]eferences' })
    vim.keymap.set('n', 'gi', builtin.lsp_implementations, { buffer = buf, desc = '[g]oto [i]mplementation' })
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = '[g]oto [d]efinition' })
    vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, { buffer = buf, desc = '[g]oto [t]ype Definition' })
    vim.keymap.set('n', 'gs', builtin.lsp_document_symbols, { buffer = buf, desc = 'find document symbols' })
    vim.keymap.set('n', 'gws', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'find workspace symbols' })
  end,
})

vim.keymap.set(
  'n',
  '<leader>f/',
  function() builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false }) end,
  { desc = '[/] Find in buffer' }
)
vim.keymap.set('n', '<leader>fn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[n]eovim files' })
