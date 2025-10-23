local p = require('neg.palette')

return {
  NoiceCursor = { bg = p.search_color },
  NoiceCmdLine = { fg = p.default_color, italic = true },

  -- Cmdline/popup variants
  NoiceCmdlinePopup = { bg = '#111d26', fg = p.default_color },
  NoiceCmdlinePopupBorder = { link = 'FloatBorder' },
  NoicePopup = { bg = '#111d26', fg = p.default_color },
  NoicePopupBorder = { link = 'FloatBorder' },
  NoicePopupmenu = { bg = '#111d26', fg = p.default_color },
  NoicePopupmenuBorder = { link = 'FloatBorder' },
}
