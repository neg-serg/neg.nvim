local p = require('neg.palette')

-- Diagnostics (Neovim 0.9/0.10)
-- VirtualText*, Underline* (undercurl with sp), Sign*, Floating*
return {
  -- Base severities
  DiagnosticError={fg=p.diff_delete_color},
  DiagnosticWarn={fg=p.warning_color},
  DiagnosticInfo={fg=p.preproc_light_color},
  DiagnosticHint={fg=p.identifier_color},
  DiagnosticOk={fg=p.diff_add_color},

  -- Virtual text
  DiagnosticVirtualTextError={fg=p.diff_delete_color},
  DiagnosticVirtualTextWarn={fg=p.warning_color},
  DiagnosticVirtualTextInfo={fg=p.preproc_light_color},
  DiagnosticVirtualTextHint={fg=p.identifier_color},
  DiagnosticVirtualTextOk={fg=p.diff_add_color},

  -- Underlines (prefer undercurl)
  DiagnosticUnderlineError={undercurl=true, sp=p.diff_delete_color},
  DiagnosticUnderlineWarn={undercurl=true, sp=p.warning_color},
  DiagnosticUnderlineInfo={undercurl=true, sp=p.preproc_light_color},
  DiagnosticUnderlineHint={undercurl=true, sp=p.identifier_color},
  DiagnosticUnderlineOk={undercurl=true, sp=p.diff_add_color},

  -- Signs
  DiagnosticSignError={fg=p.diff_delete_color},
  DiagnosticSignWarn={fg=p.warning_color},
  DiagnosticSignInfo={fg=p.preproc_light_color},
  DiagnosticSignHint={fg=p.identifier_color},
  DiagnosticSignOk={fg=p.diff_add_color},

  -- Floating windows
  DiagnosticFloatingError={fg=p.diff_delete_color},
  DiagnosticFloatingWarn={fg=p.warning_color},
  DiagnosticFloatingInfo={fg=p.preproc_light_color},
  DiagnosticFloatingHint={fg=p.identifier_color},
  DiagnosticFloatingOk={fg=p.diff_add_color},

  -- Extras
  DiagnosticDeprecated={strikethrough=true, fg=p.comment_color},
}
