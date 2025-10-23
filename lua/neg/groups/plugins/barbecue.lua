-- barbecue.nvim — winbar breadcrumbs; neutral accents
local p = require('neg.palette')
return {
  BarbecueNormal = { link = 'WinBar' },
  BarbecueContext = { link = 'WinBar' },
  BarbecueDirname = { link = 'WinBar' },
  BarbecueBasename = { link = 'WinBar' },
  BarbecueEllipsis = { fg = p.comment_color },
  BarbecueSeparator = { fg = p.comment_color },
  BarbecueModified = { fg = p.keyword3_color },
}

