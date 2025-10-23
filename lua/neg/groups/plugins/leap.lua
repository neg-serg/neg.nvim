-- leap.nvim — motion hints
local p = require('neg.palette')
return {
  LeapMatch = { underline = true },
  LeapLabelPrimary = { link = 'Title' },
  LeapLabelSecondary = { fg = p.identifier_color },
  LeapBackdrop = { fg = p.comment_color },
}
