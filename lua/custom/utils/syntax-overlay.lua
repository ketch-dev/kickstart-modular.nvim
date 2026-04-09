local M = {}

local did_setup = false

local function highlights()
  local c = {
    bg = '#1a1b26',
    comment = '#565f89',
    error = '#db4b4b',
    warning = '#e0af68',
    info = '#0db9d7',
    hint = '#1abc9c',
    fg = '#c0caf5',
    fg_dark = '#a9b1d6',
    orange = '#ff9e64',
    yellow = '#e0af68',
    green = '#9ece6a',
    green1 = '#73daca',
    teal = '#1abc9c',
    blue = '#7aa2f7',
    blue1 = '#2ac3de',
    blue5 = '#89ddff',
    blue6 = '#b4f9f8',
    cyan = '#7dcfff',
    purple = '#9d7cd8',
    magenta = '#bb9af7',
    red = '#f7768e',
    parameter_builtin = '#dab484',
    terminal_black = '#414868',
    tag_delimiter_tsx = '#5d7ab8',
    diff_add = '#243e4a',
    diff_change = '#1f2231',
    diff_delete = '#4a272f',
    heading_bg_1 = '#24293b',
    heading_bg_2 = '#2e2a2d',
    heading_bg_3 = '#272d2d',
    heading_bg_4 = '#1a2b32',
    heading_bg_5 = '#2a283b',
    heading_bg_6 = '#272538',
    heading_bg_7 = '#31282c',
    heading_bg_8 = '#302430',
  }

  return {
    -- Muted prose and comment diagnostics.
    Comment = { fg = c.comment },
    Error = { fg = c.error },
    Todo = { fg = c.bg, bg = c.warning },
    helpExample = { fg = c.comment },
    ['@comment'] = 'Comment',
    ['@comment.error'] = { fg = c.error },
    ['@comment.hint'] = { fg = c.hint },
    ['@comment.info'] = { fg = c.info },
    ['@comment.note'] = { fg = c.hint },
    ['@comment.todo'] = { fg = c.blue },
    ['@comment.warning'] = { fg = c.warning },
    ['@comment.documentation'] = 'Comment',
    ['@lsp.type.comment'] = '@comment',
    ['@lsp.type.unresolvedReference'] = { undercurl = true, sp = c.error },

    -- Preprocessor-like syntax, decorators, and module aliases in cyan.
    PreProc = { fg = c.cyan },
    Include = { fg = c.cyan },
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
    ['@module'] = 'Include',

    -- Classic keywords stay cyan and italic, while Treesitter/LSP generic keywords use magenta without italics.
    Keyword = { fg = c.cyan, italic = true },
    ['@keyword'] = { fg = c.magenta },
    ['@keyword.coroutine'] = '@keyword',
    ['@keyword.return'] = '@keyword',
    ['@type.qualifier'] = '@keyword',
    ['@lsp.type.keyword'] = '@keyword',
    ['@lsp.type.lifetime'] = '@keyword.storage',
    ['@lsp.typemod.keyword.async'] = '@keyword.coroutine',
    ['@lsp.typemod.keyword.injected'] = '@keyword',

    -- Strong magenta control-flow and declaration-introducing syntax.
    Statement = { fg = c.magenta },
    Conditional = { fg = c.magenta },
    Repeat = { fg = c.magenta },
    Exception = { fg = c.magenta },
    Identifier = { fg = c.magenta },
    Label = { fg = c.magenta },
    Debug = { fg = c.orange },
    htmlH1 = { fg = c.magenta, bold = true },
    ['@keyword.conditional'] = 'Conditional',
    ['@keyword.repeat'] = 'Repeat',
    ['@keyword.exception'] = 'Exception',
    ['@keyword.function'] = { fg = c.magenta },
    ['@keyword.debug'] = 'Debug',
    ['@constructor'] = { fg = c.magenta },
    ['@markup.link.label.symbol'] = 'Identifier',
    ['@tag'] = 'Label',

    -- Callable blue and Treesitter labels.
    Function = { fg = c.blue },
    Title = { fg = c.blue, bold = true },
    htmlH2 = { fg = c.blue, bold = true },
    helpCommand = { fg = c.blue, bg = c.terminal_black },
    ['@function'] = 'Function',
    ['@function.call'] = '@function',
    ['@function.method'] = 'Function',
    ['@function.method.call'] = '@function.method',
    ['@lsp.typemod.function.defaultLibrary'] = '@function.builtin',
    ['@lsp.typemod.macro.defaultLibrary'] = '@function.builtin',
    ['@lsp.typemod.method.defaultLibrary'] = '@function.builtin',
    ['@label'] = { fg = c.blue },
    ['@markup.heading'] = 'Title',
    ['@markup.list.unchecked'] = { fg = c.blue },
    ['@markup.raw.markdown_inline'] = { fg = c.blue, bg = c.terminal_black },

    -- Special/type cyan for symbols, delimiters, and type names.
    Special = { fg = c.blue1 },
    SpecialChar = { fg = c.blue1 },
    Delimiter = { fg = c.blue1 },
    Type = { fg = c.blue1 },
    StorageClass = { fg = c.blue1 },
    Structure = { fg = c.blue1 },
    Typedef = { fg = c.blue1 },
    Tag = { fg = c.blue1 },
    SpecialComment = { fg = c.blue1 },
    ['@character.printf'] = 'SpecialChar',
    ['@character.special'] = 'SpecialChar',
    ['@constant.builtin'] = { fg = c.cyan },
    ['@function.builtin'] = '@function',
    ['@lsp.type.decorator'] = '@attribute',
    ['@lsp.type.deriveHelper'] = '@attribute',
    ['@module.builtin'] = { fg = c.red },
    ['@constructor.tsx'] = { fg = c.blue1 },
    ['@markup.link.label'] = 'SpecialChar',
    ['@markup.math'] = 'Special',
    ['@tag.delimiter'] = 'Delimiter',
    ['@tag.attribute'] = '@property',
    ['@type'] = 'Type',
    ['@type.definition'] = 'Typedef',
    ['@keyword.storage'] = 'StorageClass',
    ['@markup.environment.name'] = 'Type',
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
    dosIniLabel = '@property',
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
    Constant = { fg = c.cyan },
    Boolean = { fg = c.orange },
    Number = { fg = c.orange },
    Float = { fg = c.orange },
    ['@constant'] = 'Constant',
    ['@boolean'] = 'Boolean',
    ['@number'] = 'Number',
    ['@number.float'] = 'Float',
    ['@lsp.type.boolean'] = '@boolean',
    ['@lsp.type.enumMember'] = '@constant',
    ['@lsp.type.number'] = '@number',
    ['@lsp.typemod.variable.static'] = '@constant',
    ['@lsp.typemod.enumMember.defaultLibrary'] = '@constant.builtin',
    ['@string.documentation'] = { fg = c.yellow },

    -- Textual syntax in green and regex cyan.
    String = { fg = c.green },
    Character = { fg = c.green },
    ['@string'] = 'String',
    ['@markup.raw'] = 'String',
    ['@character'] = 'Character',
    ['@lsp.type.string'] = '@string',
    ['@lsp.typemod.string.injected'] = '@string',
    ['@string.regexp'] = { fg = c.blue6 },
    ['@string.escape'] = { fg = c.magenta },
    ['@lsp.type.escapeSequence'] = '@string.escape',

    -- Classic Operator stays bright blue-cyan, but Treesitter/LSP operator and selected punctuation captures use the keyword lane.
    Operator = { fg = c.blue5 },
    ['@operator'] = '@keyword',
    ['@keyword.operator'] = '@keyword',
    ['@lsp.type.operator'] = '@operator',
    ['@lsp.typemod.operator.injected'] = '@operator',
    ['@markup.list'] = { fg = c.blue5 },
    ['@lsp.type.formatSpecifier'] = '@markup.list',
    ['@punctuation.delimiter'] = '@keyword',
    ['@punctuation.special'] = '@keyword',

    -- Brackets and TSX delimiters stay slightly calmer.
    ['@punctuation.bracket'] = { fg = c.fg_dark },
    ['@tag.delimiter.tsx'] = { fg = c.tag_delimiter_tsx },

    -- Markup-specific emphasis and link styling.
    Underlined = { underline = true },
    ['@none'] = {},
    ['@markup'] = '@none',
    ['@markup.emphasis'] = { italic = true },
    ['@markup.italic'] = { italic = true },
    ['@markup.strong'] = { bold = true },
    ['@markup.underline'] = { underline = true },
    ['@markup.strikethrough'] = { strikethrough = true },
    ['@markup.link'] = { fg = c.teal },
    ['@markup.link.url'] = 'Underlined',
    ['@markup.list.checked'] = { fg = c.green1 },
    ['@markup.list.markdown'] = { fg = c.orange, bold = true },
    ['@punctuation.special.markdown'] = { fg = c.orange },
    ['@markup.heading.1.markdown'] = { fg = c.blue, bg = c.heading_bg_1, bold = true },
    ['@markup.heading.2.markdown'] = { fg = c.yellow, bg = c.heading_bg_2, bold = true },
    ['@markup.heading.3.markdown'] = { fg = c.green, bg = c.heading_bg_3, bold = true },
    ['@markup.heading.4.markdown'] = { fg = c.teal, bg = c.heading_bg_4, bold = true },
    ['@markup.heading.5.markdown'] = { fg = c.magenta, bg = c.heading_bg_5, bold = true },
    ['@markup.heading.6.markdown'] = { fg = c.purple, bg = c.heading_bg_6, bold = true },
    ['@markup.heading.7.markdown'] = { fg = c.orange, bg = c.heading_bg_7, bold = true },
    ['@markup.heading.8.markdown'] = { fg = c.red, bg = c.heading_bg_8, bold = true },

    -- Diff captures get their own direct backgrounds so they stay stable across base themes.
    ['@diff.plus'] = { bg = c.diff_add },
    ['@diff.delta'] = { bg = c.diff_change },
    ['@diff.minus'] = { bg = c.diff_delete },
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
