local M = {}

local sign_group = 'dap_actual_stop'

function M.clear() vim.fn.sign_unplace(sign_group) end

local function source_to_bufnr(session, source)
  if not source then return end

  local source_ref = source.sourceReference
  if not source_ref or source_ref <= 0 then
    if not source.path then return end

    local scheme = source.path:match '^([a-z]+)://.*'
    if scheme then return vim.uri_to_bufnr(source.path) end

    return vim.uri_to_bufnr(vim.uri_from_fname(source.path))
  end

  if not session then return end

  local fname = string.format('dap-src://%d/%d/%s', session.id, source_ref, source.path or '')
  return vim.uri_to_bufnr(fname)
end

local function get_top_frame(frames)
  for _, frame in ipairs(frames or {}) do
    if frame.source then return frame end
  end

  return frames and frames[1]
end

function M.place(session, err, response, request)
  local thread_id = request and request.threadId
  if not thread_id or thread_id ~= (session and session.stopped_thread_id) then return end

  M.clear()
  if err then return end

  local frame = get_top_frame(response and response.stackFrames)
  if not frame or not frame.line or frame.line < 1 then return end

  local bufnr = source_to_bufnr(session, frame.source)
  if not bufnr or bufnr == 0 then return end

  vim.fn.bufload(bufnr)
  pcall(vim.fn.sign_place, 0, sign_group, 'DapActualStopped', bufnr, {
    lnum = frame.line,
    priority = 30,
  })
end

function M.setup(dap, stopped_icon)
  vim.fn.sign_define('DapActualStopped', {
    text = stopped_icon,
    texthl = 'DapActualStop',
    linehl = 'debugPC',
    numhl = 'DapActualStop',
  })

  dap.listeners.after.stackTrace['dap_actual_stop'] = M.place
  dap.listeners.before.event_continued['dap_actual_stop'] = M.clear
  dap.listeners.before.event_terminated['dap_actual_stop'] = M.clear
  dap.listeners.before.event_exited['dap_actual_stop'] = M.clear
  dap.listeners.before.disconnect['dap_actual_stop'] = M.clear
end

return M
