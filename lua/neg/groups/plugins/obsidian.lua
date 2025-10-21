local p = require('neg.palette')

return {
  ObsidianExtLinkIcon={fg=p.keyword1_color},
  ObsidianRefText={fg=p.keyword1_color, underline=true},
  ObsidianBullet={fg=p.keyword3_color, bold=true},
  ObsidianImportant={link='Error'},
  ObsidianTilde={link='Error'},
  ObsidianRightArrow={link='Title'},
  ObsidianDone={fg=p.keyword3_color, bold=true},
  ObsidianTodo={link='Title'},
  ObsidianHighlightText={link='Visual'},
  ObsidianBlockID={fg=p.keyword3_color, italic=true},
  ObsidianTag={fg=p.keyword3_color, italic=true},
}
