local p = require('neg.palette')

return {
  DapUIFloatNormal={bg='#111d26', fg=p.norm},
  DapUIFloatBorder={link='FloatBorder'},
  DapUIVariable={fg=p.norm},
  DapUIDecoration={fg=p.comm},
  DapUIScope={fg=p.ops3},
  DapUIType={fg=p.ops2},
  DapUIValue={fg=p.norm},
  DapUILineNumber={fg=p.comm},
  DapUIBreakpointsPath={fg=p.lbgn},
  DapUIBreakpointsLine={fg=p.comm},
  DapUIBreakpointsCurrentLine={fg=p.csel, bold=true},
  DapUIBreakpointsDisabledLine={fg=p.comm},
  DapUIPlayPause={fg=p.dadd},
  DapUIRestart={fg=p.dadd},
  DapUIStop={fg=p.blod},
  DapUIUnavailable={fg=p.comm},
  DapUIWinSelect={fg=p.ops3, bold=true},
}

