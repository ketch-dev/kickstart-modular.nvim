local api = vim.api

local M = {}

local function clear_group_bg(group)
  local ok, hl = pcall(api.nvim_get_hl, 0, { name = group, link = false })
  if not ok or vim.tbl_isempty(hl) then return end

  hl.bg = nil
  hl.ctermbg = nil
  hl.link = nil
  api.nvim_set_hl(0, group, hl)
end

function M.clear_diffview_stats_bg()
  for _, group in ipairs {
    'DiffviewFilePanelInsertions',
    'DiffviewFilePanelDeletions',
    'DiffviewStatusAdded',
    'DiffviewStatusUntracked',
    'DiffviewStatusModified',
    'DiffviewStatusRenamed',
    'DiffviewStatusCopied',
    'DiffviewStatusTypeChange',
    'DiffviewStatusTypeChanged',
    'DiffviewStatusUnmerged',
    'DiffviewStatusUnknown',
    'DiffviewStatusDeleted',
    'DiffviewStatusBroken',
    'DiffviewStatusIgnored',
  } do
    clear_group_bg(group)
  end
end

function M.setup()
  local augroup = api.nvim_create_augroup('custom_diffview_highlights', { clear = true })

  api.nvim_create_autocmd('ColorScheme', {
    group = augroup,
    callback = M.clear_diffview_stats_bg,
  })

  M.clear_diffview_stats_bg()
end

return M
