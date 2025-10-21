local p = require('neg.palette')

return {
  NvimTreeNormal={bg='#111d26', fg=p.norm},
  NvimTreeNormalNC={bg='#111d26', fg=p.norm},
  NvimTreeFolderIcon={fg=p.ops2},
  NvimTreeFolderName={fg=p.ops2},
  NvimTreeOpenedFolderName={fg=p.ops2, bold=true},
  NvimTreeRootFolder={fg=p.lbgn, bold=true},
  NvimTreeIndentMarker={fg=p.col7},
  NvimTreeCursorLine={bg=p.clin},
  NvimTreeGitDirty={fg=p.incl},
  NvimTreeGitNew={fg=p.dadd},
  NvimTreeGitDeleted={fg=p.blod},
}

