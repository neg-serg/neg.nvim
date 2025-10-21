local p = require('neg.palette')

return {
  NeoTreeNormal={bg='#111d26', fg=p.norm},
  NeoTreeNormalNC={bg='#111d26', fg=p.norm},
  NeoTreeRootName={fg=p.lbgn, bold=true},
  NeoTreeDirectoryIcon={fg=p.ops2},
  NeoTreeDirectoryName={fg=p.ops2},
  NeoTreeCursorLine={bg=p.clin},
  NeoTreeGitAdded={fg=p.dadd},
  NeoTreeGitModified={fg=p.incl},
  NeoTreeGitDeleted={fg=p.blod},
  NeoTreeDimText={fg=p.comm},
}

