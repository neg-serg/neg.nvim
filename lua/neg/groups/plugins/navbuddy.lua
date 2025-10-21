local p = require('neg.palette')

-- navbuddy (SmiteshP/nvim-navbuddy)
-- Best-effort float/window styling
return {
  NavbuddyNormal        = { bg = '#111d26', fg = p.default_color },
  NavbuddyBorder        = { link = 'FloatBorder' },
  NavbuddyTitle         = { link = 'FloatTitle' },

  NavbuddyFloatNormal   = { bg = '#111d26', fg = p.default_color },
  NavbuddyFloatBorder   = { link = 'FloatBorder' },
  NavbuddyPreviewNormal = { bg = '#111d26', fg = p.default_color },
  NavbuddyPreviewBorder = { link = 'FloatBorder' },

  NavbuddyCursorLine    = { bg = p.bg_cursorline },
  NavbuddyScope         = { fg = p.preproc_dark_color },
  NavbuddyScopeIcon     = { fg = p.tag_color },
}

