local p = require('neg.palette')

-- Legacy Vim syntax groups (non-Treesitter)
-- Kept minimal to ensure sane defaults when legacy syntax is active
return {
  -- Core syntax
  String     = { fg = p.string_color },
  Character  = { fg = p.string_color },
  Number     = { fg = p.keyword1_color },
  Float      = { fg = p.literal3_color },
  Boolean    = { fg = p.literal3_color },
  Identifier = { fg = p.identifier_color },
  Function   = { fg = p.function_color },
  Type       = { fg = p.keyword2_color },
  Keyword    = { fg = p.keyword2_color },
  Constant   = { fg = p.literal2_color },
  PreProc    = { fg = p.preproc_light_color },
  Include    = { fg = p.include_color },
  Operator   = { fg = p.keyword2_color },
  Delimiter  = { fg = p.delimiter_color },
  Special    = { fg = p.delimiter_color },
  Statement  = { fg = p.keyword1_color },
  Comment    = { fg = p.comment_color, italic = true },
}

