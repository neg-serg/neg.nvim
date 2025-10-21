local p = require('neg.palette')

return {
  TroubleNormal={bg='#111d26', fg=p.fg_default},
  TroubleText={fg=p.fg_default},
  TroubleCount={fg=p.fg_keyword_3, bold=true},
  TroubleFoldIcon={fg=p.fg_comment},
  TroubleLocation={fg=p.fg_comment},
  TroubleFilename={fg=p.fg_include},
  TroubleIndent={fg=p.shade_07},
  TroubleSignError={fg=p.fg_diff_delete},
  TroubleSignWarning={fg=p.fg_warning},
  TroubleSignInformation={fg=p.fg_preproc_light},
  TroubleSignHint={fg=p.fg_identifier},
}
