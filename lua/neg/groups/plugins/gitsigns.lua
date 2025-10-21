local p = require('neg.palette')

return {
  GitSignsAdd={fg=p.dadd},
  GitSignsAddNr={fg=p.dadd},
  GitSignsAddLn={fg=p.dadd},

  GitSignsChange={fg=p.incl},
  GitSignsChangeNr={fg=p.incl},
  GitSignsChangeLn={fg=p.incl},

  GitSignsDelete={fg=p.blod},
  GitSignsDeleteNr={fg=p.blod},
  GitSignsDeleteLn={fg=p.blod},

  GitSignsTopdelete={fg=p.blod},
  GitSignsChangedelete={fg=p.blod},
  GitSignsUntracked={fg=p.ops3},

  GitSignsCurrentLineBlame={fg=p.comm, italic=true},
}

