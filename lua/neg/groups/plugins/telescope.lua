local p = require('neg.palette')

-- Neutral defaults; enhanced accents are applied conditionally from init.lua
return {
  -- Keep matching neutral by default (no color fill), only underline
  TelescopeMatching = { underline = true },
  -- Neutral selection: reuse Visual (subtle, not bluish)
  TelescopeSelection = { link = 'Visual' },
  -- Subtle caret for selection
  TelescopeSelectionCaret = { fg = p.include_color },
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
  -- Preview matches (kept neutral by default; accented in apply_telescope_accents)
  TelescopePreviewMatch = { underline = true },
  -- Result diff indicators — align with theme diff colors
  TelescopeResultsDiffAdd = { fg = p.diff_add_color },
  TelescopeResultsDiffChange = { fg = p.diff_change_color },
  TelescopeResultsDiffDelete = { fg = p.diff_delete_color },
}
