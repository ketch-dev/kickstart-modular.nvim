local M = {}

local did_setup = false

local function highlights()
  local c = {
    comment = '#565f89',
    error = '#db4b4b',
    warning = '#e0af68',
    info = '#0db9d7',
    hint = '#1abc9c',
    fg = '#c0caf5',
    orange = '#ff9e64',
    green = '#9ece6a',
    green1 = '#73daca',
    blue = '#7aa2f7',
    blue1 = '#2ac3de',
    blue5 = '#89ddff',
    blue6 = '#b4f9f8',
    cyan = '#7dcfff',
    magenta = '#bb9af7',
    red = '#f7768e',
  }

  return {
    -- ========== Comments ==========
    ['@comment'] = { fg = c.comment },
    ['@lsp.type.comment'] = '@comment',
    ['@comment.documentation'] = '@comment',
    ['@comment.error'] = { fg = c.error },
    ['@comment.hint'] = { fg = c.hint },
    ['@comment.info'] = { fg = c.info },
    ['@comment.note'] = { fg = c.hint },
    ['@comment.todo'] = { fg = c.blue },
    ['@comment.warning'] = { fg = c.warning },
    -------------------------------------------------------------------------------

    -- Preprocessor-like syntax, decorators, and module aliases in cyan.
    PreProc = { fg = c.cyan },
    Define = { fg = c.cyan },
    ['@annotation'] = 'PreProc',
    ['@attribute'] = 'PreProc',
    ['@keyword.directive.define'] = 'Define',
    ['@constant.macro'] = 'Define',
    ['@module'] = { fg = c.cyan },

    -- ========== Keyword ==========
    ['@keyword'] = { fg = '#8c8c8c' },
    ['@keyword.debug'] = { fg = c.red },
    ['@keyword.operator'] = '@keyword',
    ['@keyword.import'] = '@keyword',
    ['@keyword.directive'] = '@keyword',
    ['@keyword.conditional'] = '@keyword',
    ['@keyword.function'] = '@keyword',
    ['@keyword.exception'] = '@keyword',
    ['@keyword.repeat'] = '@keyword',
    ['@keyword.return'] = '@keyword',
    ['@keyword.coroutine'] = '@keyword',
    ['@lsp.type.keyword'] = '@keyword',
    ['@lsp.typemod.keyword.injected'] = '@keyword',
    ['@type.qualifier'] = '@keyword',
    ['@lsp.typemod.keyword.async'] = '@keyword.coroutine',
    ['@lsp.type.lifetime'] = '@keyword.storage',
    -------------------------------------------------------------------------------

    -- ========== Keyword-like ==========
    ['@constructor'] = '@keyword',
    ['@string.escape'] = '@keyword',
    ['@lsp.type.escapeSequence'] = '@keyword',
    ['@operator'] = '@keyword',
    ['@lsp.type.operator'] = '@operator',
    ['@lsp.typemod.operator.injected'] = '@operator',
    -------------------------------------------------------------------------------

    -- ========== Punctuation ==========
    ['@punctuation.bracket'] = '@keyword',
    ['@punctuation.delimiter'] = '@keyword',
    ['@punctuation.special'] = '@keyword',
    ['@variable.parameter.builtin'] = '@keyword', -- "..." spread parameter in JS
    -------------------------------------------------------------------------------

    -- ========== Callable ==========
    ['@function'] = { fg = c.blue },
    ['@function.macro'] = '@function',
    ['@function.builtin'] = '@function',
    ['@function.call'] = '@function',
    ['@function.method'] = '@function',
    ['@function.method.call'] = '@function.method',
    ['@lsp.typemod.variable.callable'] = '@function',
    ['@lsp.typemod.function.defaultLibrary'] = '@function.builtin',
    ['@lsp.typemod.macro.defaultLibrary'] = '@function.builtin',
    ['@lsp.typemod.method.defaultLibrary'] = '@function.builtin',
    ['@label'] = { fg = c.blue },
    -------------------------------------------------------------------------------

    -- Special/type cyan for symbols, delimiters, and type names.
    SpecialChar = { fg = c.blue1 },
    ['@character.printf'] = 'SpecialChar',
    ['@character.special'] = 'SpecialChar',
    ['@constant.builtin'] = { fg = c.cyan },
    ['@lsp.type.decorator'] = '@attribute',
    ['@lsp.type.deriveHelper'] = '@attribute',
    ['@module.builtin'] = { fg = c.red },
    ['@constructor.tsx'] = { fg = c.blue1 },
    ['@tag.delimiter'] = { fg = c.blue1 },
    ['@tag.attribute'] = '@property',
    ['@keyword.storage'] = { fg = c.blue1 },

    -- ========== Type ==========
    ['@type'] = { fg = c.blue1 },
    ['@type.builtin'] = '@type',
    ['@lsp.type.interface'] = '@type',
    ['@type.definition'] = '@type',
    ['@lsp.type.enum'] = '@type',
    ['@lsp.type.typeAlias'] = '@type.definition',
    ['@lsp.type.builtinType'] = '@type.builtin',
    ['@lsp.typemod.class.defaultLibrary'] = '@type.builtin',
    ['@lsp.typemod.enum.defaultLibrary'] = '@type.builtin',
    ['@lsp.typemod.struct.defaultLibrary'] = '@type.builtin',
    ['@lsp.typemod.type.defaultLibrary'] = '@type.builtin',
    ['@lsp.typemod.typeAlias.defaultLibrary'] = '@type.builtin',
    -------------------------------------------------------------------------------

    -- ========== Builtin ==========
    ['@variable.builtin'] = { fg = c.red },
    ['@lsp.type.selfKeyword'] = '@variable.builtin',
    ['@lsp.type.selfTypeKeyword'] = '@variable.builtin',
    ['@namespace.builtin'] = '@variable.builtin',
    ['@lsp.typemod.variable.defaultLibrary'] = '@variable.builtin',
    -------------------------------------------------------------------------------

    -- ========== Variable ==========
    ['@variable'] = { fg = c.fg },
    ['@constant'] = { fg = c.cyan },
    ['@property'] = { fg = c.green1 },
    ['@variable.member'] = '@variable',
    ['@variable.parameter'] = '@variable',
    ['@lsp.type.generic'] = '@variable',
    ['@lsp.type.namespace.python'] = '@variable',
    ['@lsp.type.parameter'] = '@variable.parameter',
    ['@lsp.type.variable'] = '@variable',
    ['@lsp.type.enumMember'] = '@variable.member',
    ['@lsp.type.property'] = '@property',
    ['@lsp.typemod.variable.injected'] = '@variable',
    ['@lsp.typemod.variable.static'] = '@constant',
    ['@lsp.typemod.enumMember.defaultLibrary'] = '@constant.builtin',
    ['@lsp.type.namespace'] = '@module', -- name of namespace
    -------------------------------------------------------------------------------

    -- ========== Literals ==========
    ['@boolean'] = { fg = c.orange },
    ['@lsp.type.boolean'] = '@boolean',

    ['@number'] = { fg = c.orange },
    ['@number.float'] = '@number',
    ['@lsp.type.number'] = '@number',

    ['@string'] = { fg = c.green },
    ['@character'] = '@string',
    ['@lsp.type.string'] = '@string',
    ['@lsp.typemod.string.injected'] = '@string',
    ['@string.documentation'] = '@string',

    ['@string.regexp'] = { fg = c.blue6 },
    -------------------------------------------------------------------------------

    ['@tag'] = { fg = c.magenta },
    ['@tag.javascript'] = { fg = c.red },
    ['@tag.tsx'] = { fg = c.red },
    ['@lsp.type.formatSpecifier'] = { fg = c.blue5 },
    ['@lsp.type.unresolvedReference'] = { undercurl = true, sp = c.error },

    -- Diff captures get their own direct backgrounds so they stay stable across base themes.
    -- ['@diff.plus'] = { bg = c.diff_add },
    -- ['@diff.delta'] = { bg = c.diff_change },
    -- ['@diff.minus'] = { bg = c.diff_delete },
  }
end

M.get = highlights

function M.apply()
  local syntax = M.get()
  local links = {}

  for group, spec in pairs(syntax) do
    if type(spec) == 'string' then
      links[group] = spec
    else
      vim.api.nvim_set_hl(0, group, spec)
    end
  end

  for group, target in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = target })
  end
end

function M.setup()
  if did_setup then return end
  did_setup = true

  local group = vim.api.nvim_create_augroup('custom_syntax_overlay', { clear = true })

  vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    desc = 'Apply custom syntax overlay',
    callback = M.apply,
  })

  if vim.g.colors_name then M.apply() end
end

return M
