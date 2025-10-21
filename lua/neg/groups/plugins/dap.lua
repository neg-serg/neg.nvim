local p = require('neg.palette')

return {
  DebugBreakpoint={fg=p.fg_red_blood},
  DebugBreakpointCondition={fg=p.fg_warning},
  DebugBreakpointRejected={fg=p.fg_violet},
  DebugStopped={fg=p.fg_diff_add},
  DebugLogPoint={fg=p.fg_keyword_3},
  DebugPC={bg=p.bg_cursorline},
}
