local p = require('neg.palette')

-- nvim-treesitter/playground (best-effort)
return {
  TSPlaygroundFocus   = { fg = p.search_color, bold = true },
  TSPlaygroundLang    = { fg = p.preproc_light_color },
  TSPlaygroundQuery   = { fg = p.literal1_color },
  TSPlaygroundHelp    = { fg = p.comment_color },
}

