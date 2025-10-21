local p = require('neg.palette')

return {
  ObsidianExtLinkIcon={fg=p.fg_keyword_1},
  ObsidianRefText={fg=p.fg_keyword_1, underline=true},
  ObsidianBullet={fg=p.fg_keyword_3, bold=true},
  ObsidianImportant={link='Error'},
  ObsidianTilde={link='Error'},
  ObsidianRightArrow={link='Title'},
  ObsidianDone={fg=p.fg_keyword_3, bold=true},
  ObsidianTodo={link='Title'},
  ObsidianHighlightText={link='Visual'},
  ObsidianBlockID={fg=p.fg_keyword_3, italic=true},
  ObsidianTag={fg=p.fg_keyword_3, italic=true},
}
