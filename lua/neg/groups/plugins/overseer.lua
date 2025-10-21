local p = require('neg.palette')

-- stevearc/overseer.nvim (task runner)
return {
  OverseerNormal  = { bg = '#111d26', fg = p.default_color },
  OverseerBorder  = { link = 'FloatBorder' },
  OverseerTitle   = { link = 'FloatTitle' },

  OverseerPending = { fg = p.preproc_light_color },
  OverseerRunning = { fg = p.keyword3_color, italic = true },
  OverseerSuccess = { fg = p.diff_add_color },
  OverseerFailed  = { fg = p.diff_delete_color },
  OverseerCanceled= { fg = p.comment_color },
  OverseerError   = { fg = p.red_blood_color },

  OverseerTask    = { fg = p.default_color },
  OverseerComponent = { fg = p.comment_color },
  OverseerField   = { fg = p.identifier_color },
  OverseerOutput  = { fg = p.default_color },
}

