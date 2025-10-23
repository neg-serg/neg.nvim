-- dashboard-nvim — calm accents
local p = require('neg.palette')
return {
  DashboardHeader = { link = 'Title' },
  DashboardCenter = { link = 'Normal' },
  DashboardFooter = { fg = p.comment_color },
  DashboardShortcut = { fg = p.include_color },
}
