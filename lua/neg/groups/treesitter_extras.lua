local p = require('neg.palette')

-- Subtle extra captures enabled by cfg.treesitter.extras (default on)
return {
  -- Strings/templates
  ['@string.template']={ link = '@string' },

  -- Booleans
  ['@boolean.true']={ link = '@boolean' },
  ['@boolean.false']={ link = '@boolean' },

  -- Nil/null
  ['@nil']={ link = '@constant.builtin' },
  ['@null']={ link = '@constant.builtin' },

  -- Markup extras
  ['@markup.math']={ fg = p.literal2_color },
  ['@markup.environment']={ fg = p.preproc_dark_color },
  ['@markup.environment.name']={ fg = p.tag_color },
  ['@markup.link.text']={ link = '@markup.link.label' },

  -- LSP types
  ['@lsp.type.decorator']={link='@function.macro'},
  ['@lsp.type.annotation']={link='@attribute'},

  -- LSP typemods (declarations/static/readonly/abstract)
  ['@lsp.typemod.variable.declaration']={link='@variable'},
  ['@lsp.typemod.class.declaration']={link='@type'},
  ['@lsp.typemod.type.declaration']={link='@type'},
  ['@lsp.typemod.property.declaration']={link='@property'},
  ['@lsp.typemod.enumMember.declaration']={link='@constant'},
  ['@lsp.typemod.function.declaration']={link='@function'},
  ['@lsp.typemod.method.declaration']={link='@method'},
  ['@lsp.typemod.property.static']={link='@property'},
  ['@lsp.typemod.function.static']={link='@function'},
  ['@lsp.typemod.enumMember.static']={link='@constant'},
  ['@lsp.typemod.enumMember.readonly']={link='@constant'},
  ['@lsp.typemod.type.abstract']={link='@type'},
  ['@lsp.typemod.class.abstract']={link='@type'},

  -- Punctuation families
  ['@punctuation.parenthesis']={ link = '@punctuation.bracket' },
  ['@punctuation.brace']={ link = '@punctuation.bracket' },

  -- Types extensions
  ['@type.enum']={ link = '@type' },
  ['@type.union']={ link = '@type' },
  ['@type.interface']={ link = '@type' },

  -- String documentation (docstrings)
  ['@string.documentation']={ fg = p.comment_color, italic = true },

  -- Builtin constant refinements
  ['@constant.builtin.boolean']={ link = '@boolean' },
  ['@constant.builtin.numeric']={ link = '@number' },
}
