local p = require('neg.palette')

return {
  DebugBreakpoint={fg=p.red_blood_color},
  DebugBreakpointCondition={fg=p.warning_color},
  DebugBreakpointRejected={fg=p.violet_color},
  DebugStopped={fg=p.diff_add_color},
  DebugLogPoint={fg=p.keyword3_color},
  DebugPC={bg=p.bg_cursorline},
}
