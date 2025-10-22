local p = require('neg.palette')

-- Optional baseline UI enhancements (gated by ui.core_enhancements)
return {
  -- Line numbers above/below
  LineNrAbove={link='LineNr'},
  LineNrBelow={link='LineNr'},
  -- Active/inactive line number helpers
  NegLineNrDim={ fg=p.comment_color },

  -- Whitespace and end of buffer
  Whitespace={fg=p.comment_color},
  EndOfBuffer={fg=p.bg_default},

  -- Floating window shadows (Neovim 0.10+)
  FloatShadow={bg=p.bg_default, blend=18},
  FloatShadowThrough={bg=p.bg_default, blend=24},

  -- Questions and VisualNOS
  Question={fg=p.keyword2_color},
  VisualNOS={bg=p.bg_selection_dim, fg='NONE'},

  -- Pmenu matches
  PmenuMatch={fg=p.search_color, underline=true},
  PmenuMatchSel={fg=p.search_color, underline=true},

  -- Cursor variants (in addition to TermCursor)
  Cursor={reverse=true},
  lCursor={reverse=true},
  CursorIM={reverse=true},
}
