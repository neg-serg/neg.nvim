local p = require('neg.palette')

return {
  WhichKey={fg=p.ops3, bold=true},
  WhichKeyGroup={fg=p.lit3},
  WhichKeyDesc={fg=p.norm},
  WhichKeySeparator={fg=p.comm},
  WhichKeyFloat={bg='#111d26', fg=p.norm},
  WhichKeyBorder={link='FloatBorder'},
  WhichKeyValue={fg=p.comm},
}

