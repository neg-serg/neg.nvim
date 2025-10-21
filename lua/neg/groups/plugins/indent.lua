local p = require('neg.palette')

return {
  -- indent-blankline.nvim (legacy)
  IndentBlanklineChar={fg=p.shade_07, nocombine=true},
  IndentBlanklineSpaceChar={fg=p.shade_07, nocombine=true},
  IndentBlanklineSpaceCharBlankline={fg=p.shade_07, nocombine=true},
  IndentBlanklineContextChar={fg=p.shade_10, nocombine=true},
  IndentBlanklineContextStart={sp=p.shade_11, underline=true},

  -- ibl.nvim (new)
  IblIndent={fg=p.shade_07, nocombine=true},
  IblWhitespace={fg=p.shade_07, nocombine=true},
  IblScope={fg=p.shade_10, nocombine=true},

  -- mini.indentscope
  MiniIndentscopeSymbol={fg=p.shade_10, nocombine=true},
  MiniIndentscopePrefix={nocombine=true},
}
