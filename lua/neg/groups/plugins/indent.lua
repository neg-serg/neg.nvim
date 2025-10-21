local p = require('neg.palette')

return {
  -- indent-blankline.nvim (legacy)
  IndentBlanklineChar={fg=p.col7, nocombine=true},
  IndentBlanklineSpaceChar={fg=p.col7, nocombine=true},
  IndentBlanklineSpaceCharBlankline={fg=p.col7, nocombine=true},
  IndentBlanklineContextChar={fg=p.col10, nocombine=true},
  IndentBlanklineContextStart={sp=p.col11, underline=true},

  -- ibl.nvim (new)
  IblIndent={fg=p.col7, nocombine=true},
  IblWhitespace={fg=p.col7, nocombine=true},
  IblScope={fg=p.col10, nocombine=true},
}

