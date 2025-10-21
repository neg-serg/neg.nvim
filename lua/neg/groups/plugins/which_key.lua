local p = require('neg.palette')

return {
  WhichKey={fg=p.keyword3_color, bold=true},
  WhichKeyGroup={fg=p.literal3_color},
  WhichKeyDesc={fg=p.default_color},
  WhichKeySeparator={fg=p.comment_color},
  WhichKeyFloat={bg='#111d26', fg=p.default_color},
  WhichKeyBorder={link='FloatBorder'},
  WhichKeyValue={fg=p.comment_color},
}
