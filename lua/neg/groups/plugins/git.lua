local p = require('neg.palette')

return {
  -- Git signs (gitgutter)
  GitGutterAdd={fg=p.fg_keyword_2},
  GitGutterChangeDelete={fg=p.fg_red_blood},
  GitGutterChange={fg=p.fg_include},
  GitGutterDelete={fg=p.fg_red_blood},

  -- Diff
  DiffAdd={bg='#123425', fg=p.fg_diff_add},
  diffAdded={fg=p.fg_keyword_4},
  DiffAdded={link='String'},
  DiffChange={bg='#122c34', fg=p.fg_diff_change},
  diffChanged={fg=p.fg_keyword_2},
  DiffDelete={bg=p.fg_red_blood, fg=p.fg_diff_delete},
  diffLine={fg=p.fg_preproc_light},
  diffNewFile={fg=p.fg_preproc_dark},
  diffOldFile={fg=p.fg_preproc_dark},
  diffOldLine={fg=p.fg_preproc_dark},
  diffRemoved={fg=p.fg_red_blood},
  DiffRemoved={link='Constant'},
  DiffText={bg='NONE', fg=p.fg_white},

  -- Merge conflicts
  ConflictMarkerBegin={bg='#2f7366'},
  ConflictMarkerCommonAncestorsHunk={bg='#754a81'},
  ConflictMarkerEnd={bg='#2f628e'},
  ConflictMarkerOurs={bg='#2e5049'},
  ConflictMarkerTheirs={bg='#344f69'},
}
