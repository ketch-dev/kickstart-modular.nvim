local M = {}

local hsl = require('custom.utils.hsl').to_hex

local did_setup = false

local function highlights()
  local neutral = '#aaaaaa'
  local builtin = hsl(0, 52, 64)
  local mod = hsl(15, 51, 60)
  local preproc = hsl(35, 51, 60)
  local fn = hsl(62, 39, 58)
  -- local mod = hsl(95, 27, 57)
  local string = hsl(125, 22, 55)
  local boolean = hsl(165, 29, 56)
  local variable = hsl(205, 39, 60)
  local type = hsl(235, 34, 62)
  local number = hsl(275, 32, 65)

  -- bool, module, built-in module, type
  local c = {
    -- ========== Outside palette ==========
    error = '#c85151',
    comment = '#555555',
    keyword = neutral,
    -------------------------------------------------------------------------------

    -- ========== Modules ==========
    builtinModule = builtin,
    module = mod,
    -------------------------------------------------------------------------------

    -- ========== Vars ==========
    var = variable,
    type = type,
    -------------------------------------------------------------------------------

    -- ========== Act ==========
    fn = fn,
    preproc = preproc,
    -------------------------------------------------------------------------------

    num = number,
    str = string,
    bool = boolean,
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
    ['@keyword'] = { fg = neutral, italic = true },
    ['@keyword.type'] = '@keyword',
    ['@keyword.modifier'] = '@keyword',
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

    -- ========== Neutral ==========
    ['@string.escape'] = { fg = neutral },
    ['@lsp.type.escapeSequence'] = { fg = neutral },
    ['@operator'] = { fg = neutral },
    ['@character.printf'] = { fg = neutral },
    ['@character.special'] = { fg = neutral },
    ['@lsp.type.formatSpecifier'] = { fg = neutral },
    ['@lsp.type.operator'] = { fg = neutral },
    ['@lsp.typemod.operator.injected'] = { fg = neutral },
    -------------------------------------------------------------------------------

    -- ========== Punctuation ==========
    ['@punctuation.bracket'] = { fg = neutral },
    ['@punctuation.delimiter'] = { fg = neutral },
    ['@punctuation.special'] = { fg = neutral },
    ['@variable.parameter.builtin'] = { fg = neutral }, -- "..." spread parameter in JS
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

    ['@constant'] = '@variable',
    ['@constant.builtin'] = '@constant',
    ['@lsp.typemod.variable.static'] = '@constant',

    ['@property'] = '@variable',
    ['@lsp.type.property'] = '@property',
    -------------------------------------------------------------------------------

    -- ========== Literals ==========
    ['@boolean'] = { fg = c.bool },
    ['@lsp.type.boolean'] = '@boolean',

    ['@number'] = { fg = c.num },
    ['@lsp.type.number'] = '@number',
    ['@number.float'] = '@number',

    ['@string'] = { fg = c.str },
    ['@lsp.type.string'] = '@string',
    ['@lsp.typemod.string.injected'] = '@string',
    ['@string.documentation'] = '@string',
    ['@character'] = '@string',

    ['@string.regexp'] = { fg = c.str, italic = true },
    -------------------------------------------------------------------------------

    -- ========== Modules ==========
    ['@module'] = { fg = c.module },
    ['@lsp.type.namespace.python'] = '@module', -- name of namespace
    ['@lsp.type.namespace'] = '@module', -- name of namespace
    -------------------------------------------------------------------------------

    -- ========== HTML ==========
    ['@tag'] = '@module',
    ['@tag.builtin'] = '@module.builtin',
    ['@tag.attribute'] = { fg = neutral },
    ['@none.html'] = '@string',
    ['@none.angular'] = '@string',
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
