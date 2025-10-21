local p = require('neg.palette')

return {
  BufferLineFill={bg=p.bclr},
  BufferLineBackground={fg=p.comm, bg=p.bclr},
  BufferLineBufferSelected={fg=p.norm, bg=p.clin, bold=true},
  BufferLineBufferVisible={fg=p.norm, bg=p.bclr},
  BufferLineTab={fg=p.comm, bg=p.bclr},
  BufferLineTabSelected={fg=p.norm, bg=p.clin, bold=true},
  BufferLineTabClose={fg=p.blod, bg=p.bclr},
  BufferLineIndicatorSelected={fg=p.ops3, bg=p.clin},
  BufferLineIndicatorVisible={fg=p.ops3, bg=p.bclr},
  BufferLineCloseButton={fg=p.comm, bg=p.bclr},
  BufferLineCloseButtonSelected={fg=p.blod, bg=p.clin},
  BufferLineCloseButtonVisible={fg=p.comm, bg=p.bclr},
  BufferLineModified={fg=p.dwarn, bg=p.bclr},
  BufferLineModifiedSelected={fg=p.dwarn, bg=p.clin},
  BufferLineModifiedVisible={fg=p.dwarn, bg=p.bclr},
  BufferLineDuplicate={fg=p.comm, bg=p.bclr},
  BufferLineDuplicateSelected={fg=p.comm, bg=p.clin},
  BufferLineDuplicateVisible={fg=p.comm, bg=p.bclr},
  BufferLineSeparator={fg=p.dark, bg=p.bclr},
  BufferLineSeparatorSelected={fg=p.dark, bg=p.clin},
  BufferLineSeparatorVisible={fg=p.dark, bg=p.bclr},
  BufferLineOffsetSeparator={fg=p.dark, bg=p.bclr},
}

