local p = require('neg.palette')

return {
  GitSignsAdd={fg=p.fg_diff_add},
  GitSignsAddNr={fg=p.fg_diff_add},
  GitSignsAddLn={fg=p.fg_diff_add},

  GitSignsChange={fg=p.fg_include},
  GitSignsChangeNr={fg=p.fg_include},
  GitSignsChangeLn={fg=p.fg_include},

  GitSignsDelete={fg=p.fg_red_blood},
  GitSignsDeleteNr={fg=p.fg_red_blood},
  GitSignsDeleteLn={fg=p.fg_red_blood},

  GitSignsTopdelete={fg=p.fg_red_blood},
  GitSignsChangedelete={fg=p.fg_red_blood},
  GitSignsUntracked={fg=p.fg_keyword_3},

  GitSignsCurrentLineBlame={fg=p.fg_comment, italic=true},
}
