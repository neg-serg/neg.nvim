local p = require('neg.palette')

return {
  TroubleNormal={bg='#111d26', fg=p.norm},
  TroubleText={fg=p.norm},
  TroubleCount={fg=p.ops3, bold=true},
  TroubleFoldIcon={fg=p.comm},
  TroubleLocation={fg=p.comm},
  TroubleFilename={fg=p.incl},
  TroubleIndent={fg=p.col7},
  TroubleSignError={fg=p.dred},
  TroubleSignWarning={fg=p.dwarn},
  TroubleSignInformation={fg=p.lbgn},
  TroubleSignHint={fg=p.iden},
}

