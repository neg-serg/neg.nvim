-- fidget.nvim — neutral defaults
local p = require('neg.palette')
return {
  FidgetTitle = { link = 'WinBar' },
  FidgetTask = { fg = p.comment_color },
  FidgetProgress = { link = 'Title' },
}
