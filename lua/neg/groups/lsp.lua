local p = require('neg.palette')

return {
  LspInlayHint={fg=p.comment_color, italic=true},
  LspCodeLens={fg=p.comment_color, italic=true},
  LspReferenceText={bg=p.bg_visual},
  LspReferenceRead={bg=p.bg_visual},
  LspReferenceWrite={bg=p.bg_visual},
}
