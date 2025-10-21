local p = require('neg.palette')

return {
  NvimTreeNormal={bg='#111d26', fg=p.default_color},
  NvimTreeNormalNC={bg='#111d26', fg=p.default_color},
  NvimTreeFolderIcon={fg=p.keyword2_color},
  NvimTreeFolderName={fg=p.keyword2_color},
  NvimTreeOpenedFolderName={fg=p.keyword2_color, bold=true},
  NvimTreeRootFolder={fg=p.preproc_light_color, bold=true},
  NvimTreeIndentMarker={fg=p.shade_07},
  NvimTreeCursorLine={bg=p.bg_cursorline},
  NvimTreeGitDirty={fg=p.include_color},
  NvimTreeGitNew={fg=p.diff_add_color},
  NvimTreeGitDeleted={fg=p.red_blood_color},
}
