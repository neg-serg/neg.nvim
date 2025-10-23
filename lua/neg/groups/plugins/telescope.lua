local p = require('neg.palette')

-- Neutral defaults; enhanced accents are applied conditionally from init.lua
return {
  TelescopeMatching = { underline = true },
  TelescopeSelection = { link = 'CursorLine' },
  TelescopeBorder = { link = 'WinSeparator' },
  TelescopePreviewBorder = { link = 'WinSeparator' },
  TelescopePromptBorder = { link = 'WinSeparator' },
  TelescopeResultsBorder = { link = 'WinSeparator' },
  TelescopePathSeparator = { link = 'Normal' },
}
