-- diffview.nvim — neutral defaults
local p = require('neg.palette')
return {
  DiffviewNormal = { link = 'Normal' },
  DiffviewSignColumn = { link = 'SignColumn' },
  DiffviewCursorLine = { link = 'CursorLine' },
  DiffviewStatusLine = { link = 'StatusLine' },

  DiffviewFilePanel = { link = 'Normal' },
  DiffviewFilePanelTitle = { link = 'WinBar' },
  DiffviewFilePanelCounter = { fg = p.comment_color },
  DiffviewFilePanelRootPath = { fg = p.comment_color },
  DiffviewFilePanelPath = { fg = p.comment_color },
  DiffviewFilePanelFileName = { link = 'Normal' },
  DiffviewFilePanelBorder = { link = 'WinSeparator' },
}
