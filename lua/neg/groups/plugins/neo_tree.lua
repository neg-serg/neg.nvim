local p = require('neg.palette')

return {
  NeoTreeNormal={bg='#111d26', fg=p.default_color},
  NeoTreeNormalNC={bg='#111d26', fg=p.default_color},
  NeoTreeRootName={fg=p.preproc_light_color, bold=true},
  NeoTreeDirectoryIcon={fg=p.keyword2_color},
  NeoTreeDirectoryName={fg=p.keyword2_color},
  NeoTreeCursorLine={bg=p.bg_cursorline},
  NeoTreeGitAdded={fg=p.diff_add_color},
  NeoTreeGitModified={fg=p.include_color},
  NeoTreeGitDeleted={fg=p.red_blood_color},
  NeoTreeDimText={fg=p.comment_color},
}
