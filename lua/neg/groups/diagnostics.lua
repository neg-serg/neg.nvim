local p = require('neg.palette')

-- Diagnostics (Neovim 0.9/0.10)
-- VirtualText*, Underline* (undercurl with sp), Sign*, Floating*
return {
  -- Base severities
  DiagnosticError={fg=p.dred},
  DiagnosticWarn={fg=p.dwarn},
  DiagnosticInfo={fg=p.lbgn},
  DiagnosticHint={fg=p.iden},
  DiagnosticOk={fg=p.dadd},

  -- Virtual text
  DiagnosticVirtualTextError={fg=p.dred},
  DiagnosticVirtualTextWarn={fg=p.dwarn},
  DiagnosticVirtualTextInfo={fg=p.lbgn},
  DiagnosticVirtualTextHint={fg=p.iden},
  DiagnosticVirtualTextOk={fg=p.dadd},

  -- Underlines (prefer undercurl)
  DiagnosticUnderlineError={undercurl=true, sp=p.dred},
  DiagnosticUnderlineWarn={undercurl=true, sp=p.dwarn},
  DiagnosticUnderlineInfo={undercurl=true, sp=p.lbgn},
  DiagnosticUnderlineHint={undercurl=true, sp=p.iden},
  DiagnosticUnderlineOk={undercurl=true, sp=p.dadd},

  -- Signs
  DiagnosticSignError={fg=p.dred},
  DiagnosticSignWarn={fg=p.dwarn},
  DiagnosticSignInfo={fg=p.lbgn},
  DiagnosticSignHint={fg=p.iden},
  DiagnosticSignOk={fg=p.dadd},

  -- Floating windows
  DiagnosticFloatingError={fg=p.dred},
  DiagnosticFloatingWarn={fg=p.dwarn},
  DiagnosticFloatingInfo={fg=p.lbgn},
  DiagnosticFloatingHint={fg=p.iden},
  DiagnosticFloatingOk={fg=p.dadd},

  -- Extras
  DiagnosticDeprecated={strikethrough=true, fg=p.comm},
}

