local p = require('neg.palette')

return {
  WhichKey={fg=p.fg_keyword_3, bold=true},
  WhichKeyGroup={fg=p.fg_literal_3},
  WhichKeyDesc={fg=p.fg_default},
  WhichKeySeparator={fg=p.fg_comment},
  WhichKeyFloat={bg='#111d26', fg=p.fg_default},
  WhichKeyBorder={link='FloatBorder'},
  WhichKeyValue={fg=p.fg_comment},
}
