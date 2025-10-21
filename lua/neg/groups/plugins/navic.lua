local p = require('neg.palette')

-- nvim-navic
local M = {
  NavicText      = { fg = p.comment_color },
  NavicSeparator = { fg = p.dark_color },
}

-- Icon groups (best-effort; navic defines many)
local icons = {
  File = p.default_color,
  Module = p.preproc_dark_color,
  Namespace = p.preproc_dark_color,
  Package = p.preproc_dark_color,
  Class = p.keyword2_color,
  Method = p.function_color,
  Property = p.identifier_color,
  Field = p.identifier_color,
  Constructor = p.function_color,
  Enum = p.preproc_light_color,
  Interface = p.keyword2_color,
  Function = p.function_color,
  Variable = p.variable_color,
  Constant = p.literal2_color,
  String = p.string_color,
  Number = p.literal3_color,
  Boolean = p.keyword1_color,
  Array = p.delimiter_color,
  Object = p.delimiter_color,
  Key = p.tag_color,
  Null = p.comment_color,
  EnumMember = p.literal2_color,
  Struct = p.keyword2_color,
  Event = p.violet_color,
  Operator = p.keyword2_color,
  TypeParameter = p.keyword2_color,
}
for name, col in pairs(icons) do
  M['NavicIcons' .. name] = { fg = col }
end

return M

