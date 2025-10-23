-- oil.nvim — file explorer in buffer
local p = require('neg.palette')
return {
  OilDir = { link = 'Directory' },
  OilFile = { link = 'Normal' },
  OilHidden = { fg = p.comment_color },
  OilModified = { fg = p.identifier_color },
  OilFloat = { link = 'NormalFloat' },
  OilFloatBorder = { link = 'FloatBorder' },
  OilTitle = { link = 'WinBar' },
  OilCursorLine = { link = 'CursorLine' },
}
