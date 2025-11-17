local p = require('neg.palette')
local U = require('neg.util')

local icon = p.telekasten_icon or p.dark_color
local bracket = p.telekasten_bracket or U.darken(icon, 10)
local alias = U.lighten(icon, 28)

return {
  tkLink = { fg = p.include_color, bold = true },
  tkAliasedLink = { fg = alias },
  tkBrackets = { fg = bracket },
  tkTag = { fg = p.accent_secondary, bold = true },
  tkTagSep = { fg = bracket },
  tkHighlight = { fg = p.bg_default, bg = p.keyword2_color, bold = true },
  CalNavi = { fg = icon },
}
