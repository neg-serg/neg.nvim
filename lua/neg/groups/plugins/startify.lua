local p = require('neg.palette')

-- Startify (mhinz/vim-startify)
return {
  StartifyNumber   = { fg = p.keyword3_color },
  StartifyPath     = { fg = p.comment_color },
  StartifySlash    = { fg = p.comment_color },
  StartifyBracket  = { fg = p.dark_color },
  StartifyFile     = { fg = p.default_color },
  StartifyVar      = { fg = p.identifier_color },
  StartifySpecial  = { fg = p.preproc_light_color },
  StartifyHeader   = { fg = p.keyword3_color, bold = true },
  StartifyFooter   = { fg = p.comment_color },
  StartifySection  = { fg = p.literal1_color, bold = true },
  StartifySelect   = { fg = p.search_color, bold = true },
}

