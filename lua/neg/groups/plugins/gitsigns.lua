local p = require('neg.palette')

return {
  GitSignsAdd={fg=p.diff_add_color},
  GitSignsAddNr={fg=p.diff_add_color},
  GitSignsAddLn={fg=p.diff_add_color},

  GitSignsChange={fg=p.diff_change_color},
  GitSignsChangeNr={fg=p.diff_change_color},
  GitSignsChangeLn={fg=p.diff_change_color},

  GitSignsDelete={fg=p.diff_delete_color},
  GitSignsDeleteNr={fg=p.diff_delete_color},
  GitSignsDeleteLn={fg=p.diff_delete_color},

  GitSignsTopdelete={fg=p.diff_delete_color},
  GitSignsChangedelete={fg=p.diff_change_color},
  GitSignsUntracked={fg=p.identifier_color},

  GitSignsCurrentLineBlame={fg=p.comment_color, italic=true},
}
