local p = require('neg.palette')

return {
  GitSignsAdd={fg=p.diff_add_color},
  GitSignsAddNr={fg=p.diff_add_color},
  GitSignsAddLn={fg=p.diff_add_color},

  GitSignsChange={fg=p.include_color},
  GitSignsChangeNr={fg=p.include_color},
  GitSignsChangeLn={fg=p.include_color},

  GitSignsDelete={fg=p.red_blood_color},
  GitSignsDeleteNr={fg=p.red_blood_color},
  GitSignsDeleteLn={fg=p.red_blood_color},

  GitSignsTopdelete={fg=p.red_blood_color},
  GitSignsChangedelete={fg=p.red_blood_color},
  GitSignsUntracked={fg=p.keyword3_color},

  GitSignsCurrentLineBlame={fg=p.comment_color, italic=true},
}
