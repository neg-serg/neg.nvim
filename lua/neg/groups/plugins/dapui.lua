local p = require('neg.palette')

return {
  DapUIFloatNormal={bg='#111d26', fg=p.fg_default},
  DapUIFloatBorder={link='FloatBorder'},
  DapUIVariable={fg=p.fg_default},
  DapUIDecoration={fg=p.fg_comment},
  DapUIScope={fg=p.fg_keyword_3},
  DapUIType={fg=p.fg_keyword_2},
  DapUIValue={fg=p.fg_default},
  DapUILineNumber={fg=p.fg_comment},
  DapUIBreakpointsPath={fg=p.fg_preproc_light},
  DapUIBreakpointsLine={fg=p.fg_comment},
  DapUIBreakpointsCurrentLine={fg=p.fg_search, bold=true},
  DapUIBreakpointsDisabledLine={fg=p.fg_comment},
  DapUIPlayPause={fg=p.fg_diff_add},
  DapUIRestart={fg=p.fg_diff_add},
  DapUIStop={fg=p.fg_red_blood},
  DapUIUnavailable={fg=p.fg_comment},
  DapUIWinSelect={fg=p.fg_keyword_3, bold=true},
}
