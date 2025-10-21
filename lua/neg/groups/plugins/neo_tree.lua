local p = require('neg.palette')

return {
  NeoTreeNormal={bg='#111d26', fg=p.fg_default},
  NeoTreeNormalNC={bg='#111d26', fg=p.fg_default},
  NeoTreeRootName={fg=p.fg_preproc_light, bold=true},
  NeoTreeDirectoryIcon={fg=p.fg_keyword_2},
  NeoTreeDirectoryName={fg=p.fg_keyword_2},
  NeoTreeCursorLine={bg=p.bg_cursorline},
  NeoTreeGitAdded={fg=p.fg_diff_add},
  NeoTreeGitModified={fg=p.fg_include},
  NeoTreeGitDeleted={fg=p.fg_red_blood},
  NeoTreeDimText={fg=p.fg_comment},
}
