local p = require('neg.palette')

return {
  -- Git signs (gitgutter)
  GitGutterAdd={fg=p.ops2},
  GitGutterChangeDelete={fg=p.blod},
  GitGutterChange={fg=p.incl},
  GitGutterDelete={fg=p.blod},

  -- Diff
  DiffAdd={bg='#123425', fg=p.dadd},
  diffAdded={fg=p.ops4},
  DiffAdded={link='String'},
  DiffChange={bg='#122c34', fg=p.dchg},
  diffChanged={fg=p.ops2},
  DiffDelete={bg=p.blod, fg=p.dred},
  diffLine={fg=p.lbgn},
  diffNewFile={fg=p.dbng},
  diffOldFile={fg=p.dbng},
  diffOldLine={fg=p.dbng},
  diffRemoved={fg=p.blod},
  DiffRemoved={link='Constant'},
  DiffText={bg='NONE', fg=p.whit},

  -- Merge conflicts
  ConflictMarkerBegin={bg='#2f7366'},
  ConflictMarkerCommonAncestorsHunk={bg='#754a81'},
  ConflictMarkerEnd={bg='#2f628e'},
  ConflictMarkerOurs={bg='#2e5049'},
  ConflictMarkerTheirs={bg='#344f69'},
}

