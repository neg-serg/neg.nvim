local p = require('neg.palette')

-- mini.tabline
return {
  MiniTablineCurrent         = { fg = p.default_color, bg = p.bg_cursorline, bold = true },
  MiniTablineVisible         = { fg = p.default_color, bg = p.bg_default },
  MiniTablineHidden          = { fg = p.comment_color, bg = p.bg_default },
  MiniTablineModifiedCurrent = { fg = p.warning_color, bg = p.bg_cursorline, bold = true },
  MiniTablineModifiedVisible = { fg = p.warning_color, bg = p.bg_default },
  MiniTablineModifiedHidden  = { fg = p.warning_color, bg = p.bg_default },
  MiniTablineFill            = { fg = p.dark_color, bg = p.bg_default },
  MiniTablineTabpagesection  = { fg = p.default_color, bg = p.bg_cursorline },
}

