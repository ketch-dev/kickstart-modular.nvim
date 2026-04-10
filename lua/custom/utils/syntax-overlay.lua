local M = {}

local did_setup = false

local function highlights()
  local c = {
    -- ========== Variables ==========
    var = '#b7c6d9',
    const = '#d7e4f2',
    prop = '#94abc4',
    -------------------------------------------------------------------------------

    -- ========== Strings ==========
    str = '#98b79a',
    regex = '#b9d3bc',
    -------------------------------------------------------------------------------

    -- ========== Modules ==========
    builtinModule = '#9cc4de',
    module = '#77a6c6',
    -------------------------------------------------------------------------------

    keyword = '#7f8fa4',
    type = '#73b8b0',
    fn = '#c89a60',
    bool = '#8ba96a',
    num = '#d0b36c',
    preproc = '#c07a53',
    comment = '#6a6677',
    error = '#d16969',
  }

  return {
    -- ========== Comments ==========
    ['@comment'] = { fg = c.comment },
    ['@lsp.type.comment'] = '@comment',
    ['@comment.documentation'] = '@comment',
    ['@comment.error'] = '@comment',
    ['@comment.hint'] = '@comment',
    ['@comment.info'] = '@comment',
    ['@comment.note'] = '@comment',
    ['@comment.todo'] = '@comment',
    ['@comment.warning'] = '@comment',
    -------------------------------------------------------------------------------

    -- ========== Preprocess ==========
    ['@annotation'] = { fg = c.preproc },
    ['@attribute'] = '@annotation',
    ['@keyword.directive.define'] = '@annotation',
    ['@constant.macro'] = '@annotation',
    ['@lsp.type.decorator'] = '@attribute',
    ['@lsp.type.deriveHelper'] = '@attribute',
    -------------------------------------------------------------------------------

    -- ========== Keyword ==========
    ['@keyword'] = { fg = c.keyword },
    ['@keyword.storage'] = '@keyword',
    ['@keyword.debug'] = '@keyword',
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
    ['@string.escape'] = '@keyword',
    ['@lsp.type.escapeSequence'] = '@keyword',
    ['@operator'] = '@keyword',
    ['@character.printf'] = '@keyword',
    ['@character.special'] = '@keyword',
    ['@lsp.type.formatSpecifier'] = '@keyword',
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
    ['@function'] = { fg = c.fn },
    ['@function.macro'] = '@function',
    ['@function.builtin'] = '@function',
    ['@function.call'] = '@function',
    ['@function.method'] = '@function',
    ['@function.method.call'] = '@function.method',
    ['@lsp.typemod.variable.callable'] = '@function',
    ['@lsp.typemod.function.defaultLibrary'] = '@function.builtin',
    ['@lsp.typemod.macro.defaultLibrary'] = '@function.builtin',
    ['@lsp.typemod.method.defaultLibrary'] = '@function.builtin',
    ['@constructor'] = '@function',
    -------------------------------------------------------------------------------

    -- ========== Type ==========
    ['@type'] = { fg = c.type },
    ['@type.builtin'] = '@type',
    ['@lsp.type.interface'] = '@type',
    ['@lsp.type.generic'] = '@type',
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
    ['@module.builtin'] = { fg = c.builtinModule },
    ['@variable.builtin'] = '@module.builtin',
    ['@lsp.type.selfKeyword'] = '@variable.builtin',
    ['@lsp.type.selfTypeKeyword'] = '@variable.builtin',
    ['@namespace.builtin'] = '@variable.builtin',
    ['@lsp.typemod.variable.defaultLibrary'] = '@variable.builtin',
    -------------------------------------------------------------------------------

    -- ========== Variable ==========
    ['@variable'] = { fg = c.var },
    ['@lsp.type.variable'] = '@variable',
    ['@lsp.typemod.variable.injected'] = '@variable',
    ['@label'] = '@variable', -- name of iteration in js

    ['@variable.parameter'] = '@variable',
    ['@lsp.type.parameter'] = '@variable.parameter',

    ['@variable.member'] = '@variable',
    ['@lsp.type.enumMember'] = '@variable.member',
    ['@lsp.typemod.enumMember.defaultLibrary'] = '@variable.member',

    ['@constant'] = { fg = c.const },
    ['@constant.builtin'] = '@constant',
    ['@lsp.typemod.variable.static'] = '@constant',

    ['@property'] = { fg = c.prop },
    ['@lsp.type.property'] = '@property',
    -------------------------------------------------------------------------------

    -- ========== Literals ==========
    ['@boolean'] = { fg = c.bool },
    ['@lsp.type.boolean'] = '@boolean',

    ['@number'] = { fg = c.num },
    ['@number.float'] = '@number',
    ['@lsp.type.number'] = '@number',

    ['@string'] = { fg = c.str },
    ['@lsp.type.string'] = '@string',
    ['@lsp.typemod.string.injected'] = '@string',
    ['@string.documentation'] = '@string',
    ['@character'] = '@string',

    ['@string.regexp'] = { fg = c.regex },
    -------------------------------------------------------------------------------

    -- ========== Modules ==========
    ['@module'] = { fg = c.module },
    ['@lsp.type.namespace.python'] = '@module', -- name of namespace
    ['@lsp.type.namespace'] = '@module', -- name of namespace
    -------------------------------------------------------------------------------

    ['@lsp.type.unresolvedReference'] = { undercurl = true, sp = c.error },

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
