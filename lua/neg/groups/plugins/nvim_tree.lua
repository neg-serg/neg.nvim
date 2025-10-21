local p = require('neg.palette')

return {
  NvimTreeNormal={bg='#111d26', fg=p.fg_default},
  NvimTreeNormalNC={bg='#111d26', fg=p.fg_default},
  NvimTreeFolderIcon={fg=p.fg_keyword_2},
  NvimTreeFolderName={fg=p.fg_keyword_2},
  NvimTreeOpenedFolderName={fg=p.fg_keyword_2, bold=true},
  NvimTreeRootFolder={fg=p.fg_preproc_light, bold=true},
  NvimTreeIndentMarker={fg=p.shade_07},
  NvimTreeCursorLine={bg=p.bg_cursorline},
  NvimTreeGitDirty={fg=p.fg_include},
  NvimTreeGitNew={fg=p.fg_diff_add},
  NvimTreeGitDeleted={fg=p.fg_red_blood},
}
