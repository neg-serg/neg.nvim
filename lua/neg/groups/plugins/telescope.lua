local p = require('neg.palette')

-- Neutral defaults; enhanced accents are applied conditionally from init.lua
return {
  -- Keep matching neutral by default (no color fill), only underline
  TelescopeMatching = { underline = true },
  -- Neutral selection: reuse Visual (subtle, not bluish)
  TelescopeSelection = { link = 'Visual' },
  -- Borders follow WinSeparator/soft borders
  TelescopeBorder = { link = 'WinSeparator' },
  TelescopePreviewBorder = { link = 'WinSeparator' },
  TelescopePromptBorder = { link = 'WinSeparator' },
  TelescopeResultsBorder = { link = 'WinSeparator' },
  -- Neutral backgrounds for all Telescope panes
  TelescopeNormal = { link = 'Normal' },
  TelescopePreviewNormal = { link = 'Normal' },
  TelescopePromptNormal = { link = 'Normal' },
  TelescopeResultsNormal = { link = 'Normal' },
  TelescopePromptPrefix = { link = 'Normal' },
  TelescopePromptCounter = { link = 'Normal' },
  TelescopePromptTitle = { link = 'WinBar' },
  TelescopeResultsTitle = { link = 'WinBar' },
  TelescopePreviewTitle = { link = 'WinBar' },
  -- Path separators shouldn't stand out
  TelescopePathSeparator = { link = 'Normal' },
}
