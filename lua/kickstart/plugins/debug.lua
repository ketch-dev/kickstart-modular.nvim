-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

local function continue_or_run_first_config()
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

local dap_hover_view
local dap_hover_autocmd

local function close_dap_hover(view)
  if dap_hover_autocmd then
    pcall(vim.api.nvim_del_autocmd, dap_hover_autocmd)
    dap_hover_autocmd = nil
  end

  if view and view.close then view.close() end
  if dap_hover_view == view then dap_hover_view = nil end
end

local function focus_or_open_dap_hover()
  if dap_hover_view and dap_hover_view.win and vim.api.nvim_win_is_valid(dap_hover_view.win) then
    vim.api.nvim_set_current_win(dap_hover_view.win)
    return
  end

  local source_win = vim.api.nvim_get_current_win()
  local source_buf = vim.api.nvim_get_current_buf()
  local view = require('dap.ui.widgets').hover()
  dap_hover_view = view

  if vim.api.nvim_win_is_valid(source_win) then vim.api.nvim_set_current_win(source_win) end

  vim.schedule(function()
    if dap_hover_view ~= view or not vim.api.nvim_buf_is_valid(source_buf) then return end

    if dap_hover_autocmd then pcall(vim.api.nvim_del_autocmd, dap_hover_autocmd) end
    dap_hover_autocmd = vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = source_buf,
      callback = function() close_dap_hover(view) end,
    })
  end)
end

---@module 'lazy'
---@type LazySpec
return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    {
      'theHamsta/nvim-dap-virtual-text',
      config = function() require('nvim-dap-virtual-text').setup {} end,
    },

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    { '<leader>du', function() require('dapui').toggle() end, desc = '[u]i' },
    {
      '<leader>dm',
      function()
        if not require('dap').session() then require('dap').continue() end
      end,
      desc = '[m]enu',
    },
    { '<leader>dc', continue_or_run_first_config, desc = '[c]ontinue' },
    { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'run to [C]ursor' },
    { '<leader>dh', focus_or_open_dap_hover, desc = '[h]over', mode = { 'n', 'x' } },
    { '<leader>de', function() require('dapui').eval() end, desc = '[e]val', mode = { 'n', 'x' } },
    { '<leader>di', function() require('dap').step_into() end, desc = 'step [i]nto' },
    { '<leader>d<Down>', function() require('dap').down() end, desc = '[] frame' },
    { '<leader>d<Up>', function() require('dap').up() end, desc = '[] frame' },
    { '<leader>do', function() require('dap').step_over() end, desc = 'step [o]ver' },
    { '<leader>dO', function() require('dap').step_out() end, desc = 'step [O]ut' },
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = '[b]reakpoint' },
    { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'conditional [B]reakpoint' },
    { '<leader>dr', function() require('dap').run_last() end, desc = '[r]erun' },
    { '<leader>dp', function() require('dap').pause() end, desc = '[p]ause' },
    { '<leader>ds', function() require('dap').terminate() end, desc = '[s]top' },
    {
      '<leader>dt',
      function()
        require('lazy').load { plugins = { 'neotest' } }
        require('neotest').run.run { strategy = 'dap' }
      end,
      desc = 'debug [t]est',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    ---@diagnostic disable-next-line: missing-fields
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '', collapsed = '', current_frame = '' },
      ---@diagnostic disable-next-line: missing-fields
      controls = {
        icons = {
          pause = '',
          play = '',
          step_into = '',
          step_over = '',
          step_out = '',
          step_back = '',
          run_last = '',
          terminate = '',
          disconnect = '',
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#c85151' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#5f87af' })
    vim.api.nvim_set_hl(0, 'DapActualStop', { fg = '#87af87' })

    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      local linehl = (type == 'Stopped') and 'debugPC' or ''
      vim.fn.sign_define(tp, { text = icon, texthl = hl, linehl = linehl, numhl = hl })
    end

    local actual_stop_sign_group = 'dap_actual_stop'
    vim.fn.sign_define('DapActualStopped', {
      text = breakpoint_icons.Stopped,
      texthl = 'DapActualStop',
      linehl = 'debugPC',
      numhl = 'DapActualStop',
    })

    local function clear_actual_stop_sign() vim.fn.sign_unplace(actual_stop_sign_group) end

    local function actual_stop_source_to_bufnr(session, source)
      if not source then return end

      local source_ref = source.sourceReference
      if not source_ref or source_ref <= 0 then
        if not source.path then return end

        local scheme = source.path:match '^([a-z]+)://.*'
        if scheme then return vim.uri_to_bufnr(source.path) end

        return vim.uri_to_bufnr(vim.uri_from_fname(source.path))
      end

      local fname = string.format('dap-src://%d/%d/%s', session.id, source_ref, source.path or '')
      return vim.uri_to_bufnr(fname)
    end

    local function get_actual_stop_frame(frames)
      for _, frame in ipairs(frames or {}) do
        if frame.source then return frame end
      end

      return frames and frames[1]
    end

    local function place_actual_stop_sign(session, err, response, request)
      local thread_id = request and request.threadId
      if not thread_id or thread_id ~= (session and session.stopped_thread_id) then return end

      clear_actual_stop_sign()
      if err then return end

      local frame = get_actual_stop_frame(response and response.stackFrames)
      if not frame or not frame.line or frame.line < 1 then return end

      local bufnr = actual_stop_source_to_bufnr(session, frame.source)
      if not bufnr or bufnr == 0 then return end

      vim.fn.bufload(bufnr)
      pcall(vim.fn.sign_place, 0, actual_stop_sign_group, 'DapActualStopped', bufnr, {
        lnum = frame.line,
        priority = 30,
      })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.after.stackTrace['dap_actual_stop'] = place_actual_stop_sign
    dap.listeners.before.event_continued['dap_actual_stop'] = clear_actual_stop_sign
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_terminated['dap_actual_stop'] = clear_actual_stop_sign
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dap_actual_stop'] = clear_actual_stop_sign
    dap.listeners.before.disconnect['dap_actual_stop'] = clear_actual_stop_sign

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
