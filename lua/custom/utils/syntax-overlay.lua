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
    yellow = '#e0af68',
    green = '#9ece6a',
    green1 = '#73daca',
    blue = '#7aa2f7',
    blue1 = '#2ac3de',
    blue5 = '#89ddff',
    blue6 = '#b4f9f8',
    cyan = '#7dcfff',
    magenta = '#bb9af7',
    red = '#f7768e',
    parameter_builtin = '#dab484',
    terminal_black = '#414868',
    tag_delimiter_tsx = '#5d7ab8',
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
    ['@lsp.type.unresolvedReference'] = { undercurl = true, sp = c.error },
    -------------------------------------------------------------------------------

    -- Preprocessor-like syntax, decorators, and module aliases in cyan.
    PreProc = { fg = c.cyan },
    Define = { fg = c.cyan },
    Macro = { fg = c.cyan },
    ['@annotation'] = 'PreProc',
    ['@attribute'] = 'PreProc',
    ['@keyword.directive'] = '@keyword',
    ['@keyword.import'] = '@keyword',
    ['@keyword.directive.define'] = 'Define',
    ['@constant.macro'] = 'Define',
    ['@function.macro'] = 'Macro',
    ['@markup.environment'] = 'Macro',
    ['@module'] = { fg = c.cyan },

    -- Classic keywords stay cyan and italic, while Treesitter/LSP generic keywords use magenta without italics.
    ['@keyword'] = { fg = '#8c8c8c' },
    ['@keyword.coroutine'] = '@keyword',
    ['@keyword.return'] = '@keyword',
    ['@type.qualifier'] = '@keyword',
    ['@lsp.type.keyword'] = '@keyword',
    ['@lsp.type.lifetime'] = '@keyword.storage',
    ['@lsp.typemod.keyword.async'] = '@keyword.coroutine',
    ['@lsp.typemod.keyword.injected'] = '@keyword',

    -- Strong magenta control-flow and declaration-introducing syntax.
    ['@keyword.conditional'] = '@keyword',
    ['@keyword.repeat'] = '@keyword',
    ['@keyword.exception'] = '@keyword',
    ['@keyword.function'] = '@keyword',
    ['@keyword.debug'] = { fg = c.orange },
    ['@constructor'] = '@keyword',
    ['@markup.link.label.symbol'] = { fg = c.magenta },
    ['@tag'] = { fg = c.magenta },

    -- Callable blue and Treesitter labels.
    ['@function'] = { fg = c.blue },
    ['@function.call'] = '@function',
    ['@function.method'] = '@function',
    ['@function.method.call'] = '@function.method',
    ['@lsp.typemod.function.defaultLibrary'] = '@function.builtin',
    ['@lsp.typemod.macro.defaultLibrary'] = '@function.builtin',
    ['@lsp.typemod.method.defaultLibrary'] = '@function.builtin',
    ['@label'] = { fg = c.blue },
    ['@markup.heading'] = { fg = c.blue, bold = true },
    ['@markup.list.unchecked'] = { fg = c.blue },
    ['@markup.raw.markdown_inline'] = { fg = c.blue, bg = c.terminal_black },

    -- Special/type cyan for symbols, delimiters, and type names.
    SpecialChar = { fg = c.blue1 },
    ['@character.printf'] = 'SpecialChar',
    ['@character.special'] = 'SpecialChar',
    ['@constant.builtin'] = { fg = c.cyan },
    ['@function.builtin'] = '@function',
    ['@lsp.type.decorator'] = '@attribute',
    ['@lsp.type.deriveHelper'] = '@attribute',
    ['@module.builtin'] = { fg = c.red },
    ['@constructor.tsx'] = { fg = c.blue1 },
    ['@markup.link.label'] = 'SpecialChar',
    ['@markup.math'] = { fg = c.blue1 },
    ['@tag.delimiter'] = { fg = c.blue1 },
    ['@tag.attribute'] = '@property',
    ['@type'] = { fg = c.blue1 },
    ['@type.definition'] = { fg = c.blue1 },
    ['@keyword.storage'] = { fg = c.blue1 },
    ['@markup.environment.name'] = '@type',
    ['@lsp.type.enum'] = '@type',
    ['@lsp.type.typeAlias'] = '@type.definition',
    ['@lsp.type.builtinType'] = '@type.builtin',
    ['@lsp.typemod.class.defaultLibrary'] = '@type.builtin',
    ['@lsp.typemod.enum.defaultLibrary'] = '@type.builtin',
    ['@lsp.typemod.struct.defaultLibrary'] = '@type.builtin',
    ['@lsp.typemod.type.defaultLibrary'] = '@type.builtin',
    ['@lsp.typemod.typeAlias.defaultLibrary'] = '@type.builtin',

    -- Builtin and interface semantic tokens stay on the main type lane.
    ['@type.builtin'] = '@type',
    ['@lsp.type.interface'] = '@type',

    -- Runtime builtins and TSX tag names stay red.
    ['@variable.builtin'] = { fg = c.red },
    ['@namespace.builtin'] = '@variable.builtin',
    ['@tag.javascript'] = { fg = c.red },
    ['@tag.tsx'] = { fg = c.red },
    ['@lsp.type.selfKeyword'] = '@variable.builtin',
    ['@lsp.type.selfTypeKeyword'] = '@variable.builtin',
    ['@lsp.typemod.variable.defaultLibrary'] = '@variable.builtin',

    -- Neutral variables, members, and parameters.
    ['@variable'] = { fg = c.fg },
    ['@property'] = { fg = c.green1 },
    ['@variable.member'] = '@variable',
    ['@variable.parameter'] = '@variable',
    ['@variable.parameter.builtin'] = { fg = c.parameter_builtin },
    ['@lsp.type.generic'] = '@variable',
    ['@lsp.type.namespace'] = '@module',
    ['@lsp.type.namespace.python'] = '@variable',
    ['@lsp.type.parameter'] = '@variable.parameter',
    ['@lsp.type.property'] = '@property',
    ['@lsp.type.variable'] = {},
    ['@lsp.typemod.variable.callable'] = '@function',
    ['@lsp.typemod.variable.injected'] = '@variable',

    -- Value-like syntax in orange and parameter-adjacent yellow.
    ['@constant'] = { fg = c.cyan },
    ['@boolean'] = { fg = c.orange },
    ['@number'] = { fg = c.orange },
    ['@number.float'] = { fg = c.orange },
    ['@lsp.type.boolean'] = '@boolean',
    ['@lsp.type.enumMember'] = '@constant',
    ['@lsp.type.number'] = '@number',
    ['@lsp.typemod.variable.static'] = '@constant',
    ['@lsp.typemod.enumMember.defaultLibrary'] = '@constant.builtin',
    ['@string.documentation'] = { fg = c.yellow },

    -- Textual syntax in green and regex cyan.
    ['@string'] = { fg = c.green },
    ['@markup.raw'] = '@string',
    ['@character'] = '@string',
    ['@lsp.type.string'] = '@string',
    ['@lsp.typemod.string.injected'] = '@string',
    ['@string.regexp'] = { fg = c.blue6 },
    ['@string.escape'] = '@keyword',
    ['@lsp.type.escapeSequence'] = '@keyword',

    ['@operator'] = '@keyword',
    ['@keyword.operator'] = '@keyword',
    ['@lsp.type.operator'] = '@operator',
    ['@lsp.typemod.operator.injected'] = '@operator',
    ['@markup.list'] = { fg = c.blue5 },
    ['@lsp.type.formatSpecifier'] = '@markup.list',
    ['@punctuation.delimiter'] = '@keyword',
    ['@punctuation.special'] = '@keyword',

    -- Brackets and TSX delimiters.
    ['@punctuation.bracket'] = '@keyword',
    ['@tag.delimiter.tsx'] = { fg = c.tag_delimiter_tsx },

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
