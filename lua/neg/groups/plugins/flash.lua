-- flash.nvim — motion hints
local p = require('neg.palette')
return {
  FlashMatch = { underline = true },
  FlashCurrent = { bold = true, underline = true },
  FlashLabel = { link = 'Title' },
  FlashBackdrop = { fg = p.comment_color },
}
