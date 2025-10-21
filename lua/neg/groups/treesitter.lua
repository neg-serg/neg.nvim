local p = require('neg.palette')

-- Treesitter + LSP semantic token links
return {
  ['@variable']={fg=p.var},
  ['@variable.parameter']={link='@parameter'},
  ['@variable.member']={link='@field'},
  ['@module']={link='@namespace'},
  ['@number.float']={link='@float'},
  ['@string.special.symbol']={link='@symbol'},
  ['@string.regexp']={link='@string.regex'},

  -- Additional common captures
  ['@attribute']={link='Identifier'},
  ['@constructor']={link='Function'},
  ['@constant.builtin']={link='Constant'},
  ['@function.builtin']={link='Function'},
  ['@property']={link='Identifier'},
  ['@field']={link='Identifier'},
  ['@punctuation.bracket']={link='Delimiter'},
  ['@punctuation.delimiter']={link='Delimiter'},
  ['@string.escape']={link='SpecialChar'},
  ['@string.special.url']={link='Underlined'},
  ['@character']={link='String'},

  -- Legacy @text.* → modern @markup.*
  ['@text.strong']={link='@markup.strong'},
  ['@text.emphasis']={link='@markup.italic'},
  ['@text.underline']={link='@markup.underline'},
  ['@text.strike']={link='@markup.strikethrough'},
  ['@text.title']={link='@markup.heading'},
  ['@text.quote']={link='@markup.quote'},
  ['@text.uri']={link='@markup.link.url'},
  ['@text.math']={link='@markup.math'},
  ['@text.environment']={link='@markup.environment'},
  ['@text.environment.name']={link='@markup.environment.name'},
  ['@text.reference']={link='@markup.link'},
  ['@text.literal']={link='@markup.raw'},
  ['@text.literal.block']={link='@markup.raw.block'},
  ['@string.special']={link='@markup.link.label'},
  ['@punctuation.special']={link='@markup.list'},

  -- Helix captures
  ['@function.method']={link='@method'},
  ['@function.method.call']={link='@method.call'},

  -- Comment severities
  ['@text.todo']={link='@comment.todo'},
  ['@text.danger']={link='@comment.error'},
  ['@text.warning']={link='@comment.warning'},
  ['@text.note']={link='@comment.note'},

  -- Diff groups
  ['@text.diff.add']={link='@diff.plus'},
  ['@text.diff.delete']={link='@diff.minus'},
  ['@text.diff.change']={link='@diff.delta'},

  -- Keyword families
  ['@keyword.directive']={link='@preproc'},
  ['@keyword.storage']={link='@storageclass'},
  ['@keyword.conditional']={link='@conditional'},
  ['@keyword.debug']={link='@debug'},
  ['@keyword.exception']={link='@exception'},
  ['@keyword.import']={link='@include'},
  ['@keyword.repeat']={link='@repeat'},
  ['@keyword.operator']={link='@operator'},
  ['@keyword.return']={link='@keyword'},

  -- LSP semantic tokens
  ['@lsp.type.class']={link='@type'},
  ['@lsp.type.struct']={link='@type'},
  ['@lsp.type.interface']={link='@type'},
  ['@lsp.type.enum']={link='@type'},
  ['@lsp.type.type']={link='@type'},
  ['@lsp.type.typeAlias']={link='@type.definition'},
  ['@lsp.type.typeParameter']={link='@type'},
  ['@lsp.type.namespace']={link='@namespace'},
  ['@lsp.type.parameter']={link='@parameter'},
  ['@lsp.type.variable']={link='@variable'},
  ['@lsp.type.property']={link='@property'},
  ['@lsp.type.enumMember']={link='@constant'},
  ['@lsp.type.function']={link='@function'},
  ['@lsp.type.macro']={link='@function.macro'},
  ['@lsp.type.method']={link='@method'},
  ['@lsp.type.event']={link='@type'},
  ['@lsp.type.operator']={link='@operator'},
  ['@lsp.type.modifier']={link='@keyword'},
  ['@lsp.type.builtinType']={link='@type.builtin'},
  ['@lsp.type.comment']={link='@comment'},
  ['@lsp.type.string']={link='@string'},
  ['@lsp.type.boolean']={link='@boolean'},
  ['@lsp.type.number']={link='@number'},
  ['@lsp.type.regexp']={link='@string.regex'},
  ['@lsp.type.escapeSequence']={link='@string.escape'},
  ['@lsp.type.formatSpecifier']={link='@string.special'},

  -- LSP modifiers
  ['@lsp.typemod.variable.readonly']={link='@constant'},
  ['@lsp.typemod.variable.global']={link='@constant'},
  ['@lsp.typemod.variable.static']={link='@constant'},
  ['@lsp.typemod.variable.defaultLibrary']={link='@variable.builtin'},
  ['@lsp.typemod.function.defaultLibrary']={link='@function.builtin'},
  ['@lsp.typemod.method.defaultLibrary']={link='@function.builtin'},
  ['@lsp.typemod.class.defaultLibrary']={link='@type.builtin'},
  ['@lsp.typemod.macro.defaultLibrary']={link='@function.macro'},
  ['@lsp.typemod.enum.defaultLibrary']={link='@type.builtin'},
  ['@lsp.typemod.type.defaultLibrary']={link='@type.builtin'},
  ['@lsp.typemod.deprecated']={link='DiagnosticDeprecated'},
}
