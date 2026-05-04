local M = {}

function M.continue_or_run_first_config()
  local dap = require 'dap'

  if dap.session() then
    dap.continue()
    return
  end

  local configs = dap.configurations[vim.bo.filetype]
  if configs and configs[1] then
    dap.run(configs[1])
  else
    dap.continue()
  end
end

return M
