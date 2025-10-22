local p = require('neg.palette')

return {
  -- Git signs (gitgutter)
  GitGutterAdd={fg=p.keyword2_color},
  GitGutterChangeDelete={fg=p.red_blood_color},
  GitGutterChange={fg=p.include_color},
  GitGutterDelete={fg=p.red_blood_color},

  -- Diff (filetype diff / plugins)
  diffAdded={fg=p.keyword4_color},
  DiffAdded={link='@string'},
  diffChanged={fg=p.keyword2_color},
  diffLine={fg=p.preproc_light_color},
  diffNewFile={fg=p.preproc_dark_color},
  diffOldFile={fg=p.preproc_dark_color},
  diffOldLine={fg=p.preproc_dark_color},
  diffRemoved={fg=p.red_blood_color},
  DiffRemoved={link='@constant'},

  -- Merge conflicts
  ConflictMarkerBegin={bg='#2f7366'},
  ConflictMarkerCommonAncestorsHunk={bg='#754a81'},
  ConflictMarkerEnd={bg='#2f628e'},
  ConflictMarkerOurs={bg='#2e5049'},
  ConflictMarkerTheirs={bg='#344f69'},
}
