local M = {}

local oklch = require('custom.utils.oklch').to_hex

local did_setup = false

local function hue(h) return oklch(70, 9, h) end

local function highlights()
  local nc45 = oklch(45, 0, 0)
  local nc70 = oklch(70, 0, 0)

  local c1_red = hue(0)
  local c2_orange = hue(30)
  local c3_yellow = hue(60)
  local c4_lime = hue(90)
  local c5_green = hue(120)
  local c6_teal = hue(150)
  local c7_cyan = hue(180)
  local c8_sky = hue(210)
  local c9_blue = hue(240)
  local c10_violet = hue(270)
  local c11_magenta = hue(300)
  local c12_pink = hue(330)

  local c = {
    -- ========== Neutral ==========
    comment = nc45,
    keyword = nc70,
    -------------------------------------------------------------------------------

    -- ========== Modules ==========
    builtinModule = c7_cyan,
    module = c8_sky,
    -------------------------------------------------------------------------------

    -- ========== Vars ==========
    var = c9_blue,
    type = c10_violet,
    -------------------------------------------------------------------------------

    -- ========== Act ==========
    fn = c3_yellow,
    preproc = c2_orange,
    -------------------------------------------------------------------------------

    -- ========== Strings ==========
    str = c5_green,
    regex = c4_lime,
    -------------------------------------------------------------------------------

    -- ========== Numbers ==========
    num = c11_magenta,
    float = c12_pink,
    -------------------------------------------------------------------------------

    bool = c6_teal,
    error = c1_red,
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
    ['@number.float'] = { fg = c.float },

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
