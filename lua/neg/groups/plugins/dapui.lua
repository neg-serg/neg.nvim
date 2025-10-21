local p = require('neg.palette')

return {
  DapUIFloatNormal={bg='#111d26', fg=p.default_color},
  DapUIFloatBorder={link='FloatBorder'},
  DapUIVariable={fg=p.default_color},
  DapUIDecoration={fg=p.comment_color},
  DapUIScope={fg=p.keyword3_color},
  DapUIType={fg=p.keyword2_color},
  DapUIValue={fg=p.default_color},
  DapUILineNumber={fg=p.comment_color},
  DapUIBreakpointsPath={fg=p.preproc_light_color},
  DapUIBreakpointsLine={fg=p.comment_color},
  DapUIBreakpointsCurrentLine={fg=p.search_color, bold=true},
  DapUIBreakpointsDisabledLine={fg=p.comment_color},
  DapUIPlayPause={fg=p.diff_add_color},
  DapUIRestart={fg=p.diff_add_color},
  DapUIStop={fg=p.red_blood_color},
  DapUIUnavailable={fg=p.comment_color},
  DapUIWinSelect={fg=p.keyword3_color, bold=true},
}
