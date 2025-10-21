local p = require('neg.palette')

return {
  TroubleNormal={bg='#111d26', fg=p.default_color},
  TroubleText={fg=p.default_color},
  TroubleCount={fg=p.keyword3_color, bold=true},
  TroubleFoldIcon={fg=p.comment_color},
  TroubleLocation={fg=p.comment_color},
  TroubleFilename={fg=p.include_color},
  TroubleIndent={fg=p.shade_07},
  TroubleSignError={fg=p.diff_delete_color},
  TroubleSignWarning={fg=p.warning_color},
  TroubleSignInformation={fg=p.preproc_light_color},
  TroubleSignHint={fg=p.identifier_color},
}
