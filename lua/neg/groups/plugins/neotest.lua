local p = require('neg.palette')

-- neotest highlight groups
return {
  NeotestPassed        = { fg = p.diff_add_color },
  NeotestFailed        = { fg = p.diff_delete_color },
  NeotestSkipped       = { fg = p.warning_color },
  NeotestRunning       = { fg = p.keyword3_color, italic = true },
  NeotestUnknown       = { fg = p.identifier_color },
  NeotestMarked        = { fg = p.literal2_color },
  NeotestTarget        = { fg = p.tag_color },
  NeotestFocused       = { fg = p.preproc_light_color, bold = true },
  NeotestNamespace     = { fg = p.preproc_dark_color },
  NeotestFile          = { fg = p.include_color },
  NeotestDir           = { fg = p.include_color },
  NeotestAdapterName   = { fg = p.literal1_color, bold = true },
  NeotestIndent        = { fg = p.comment_color },
  NeotestExpandMarker  = { fg = p.comment_color },
  NeotestWinSelect     = { fg = p.search_color, bold = true },
}

