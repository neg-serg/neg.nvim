local p = require('neg.palette')

-- mini.statusline
return {
  MiniStatuslineModeNormal  = { fg = p.dark_color, bg = p.keyword3_color, bold = true },
  MiniStatuslineModeInsert  = { fg = p.dark_color, bg = p.literal2_color, bold = true },
  MiniStatuslineModeVisual  = { fg = p.dark_color, bg = p.violet_color, bold = true },
  MiniStatuslineModeReplace = { fg = p.dark_color, bg = p.red_blood_color, bold = true },
  MiniStatuslineModeCommand = { fg = p.dark_color, bg = p.preproc_light_color, bold = true },
  MiniStatuslineDevinfo     = { fg = p.comment_color, bg = p.bg_default },
  MiniStatuslineFileinfo    = { fg = p.default_color, bg = p.bg_default },
  MiniStatuslineInactive    = { fg = p.comment_color, bg = p.bg_default },
}

