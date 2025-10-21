local p = require('neg.palette')

-- UI/editor highlight groups and diagnostics
return {
  -- Core UI and editor
  Directory={bg='', fg=p.ops2},
  Error={bg=p.bclr, fg=p.violet},
  ErrorMsg= {bg='NONE', fg=p.norm},
  Folded={bg=p.visu, fg=p.high},
  LineNr={fg='#2c3641', bg=nil, italic=true},
  MatchParen={bg=p.high, fg=p.dark},
  ModeMsg={bg='NONE', fg=p.ops3},
  MoreMsg={bg='NONE', fg=p.ops3},
  NonText={bg='', fg=p.ops2},
  Normal={bg='', fg=p.norm},
  Search={bg='NONE', fg=p.csel, italic=true},
  IncSearch={bg=p.dark, fg=p.csel, italic=true,underline=true},
  CurSearch={bg=p.dark, fg=p.csel, italic=true, bold=true},
  StatusLine={bg='NONE', fg=p.func, nil},
  StatusLineNC={bg='NONE', fg='NONE', nil},
  Title={bg='', fg=p.lit3},
  Todo={bg='NONE', fg=p.blod},
  Underlined={bg='', fg=p.ops4},
  VertSplit={bg='NONE', fg=p.dark},
  Visual={bg=p.dnorm, fg='NONE', bold=true},
  WarningMsg={bg='NONE', fg=p.norm},
  WildMenu={bg=p.dark, fg=p.incl},

  ColorColumn={bg=p.culc, nil},
  CursorColumn={bg=p.culc, nil},
  CursorLine={nil, nil, nil},
  CursorLineNr={bg=p.clin, fg=p.ops3, italic=true, bold=true},
  FoldColumn={bg='NONE', fg=p.comm},
  SignColumn={bg='NONE', fg='NONE'},

  Conceal={link='Operator'},
  DeclRefExpr={link='Normal'},

  ExtraWhitespace={bg=p.lit3, fg='NONE'},
  FloatBorder={link='VertSplit'},
  WinSeparator={link='VertSplit'},

  -- Spell
  SpellBad={underline=true},
  SpellCap={underline=true},
  SpellLocal={underline=true},
  SpellRare={underline=true},

  -- Pmenu
  Pmenu={bg=p.bclr, fg=p.pmen, italic=true},
  PmenuSbar={bg=p.clin, fg='NONE'},
  PmenuSel={bg=p.clin, fg=p.ops3},
  PmenuThumb={bg=p.ops3, fg='NONE'},

  -- Tabline
  TabLineFill={bg=p.bclr, fg=p.ops2},
  TabLine={bg=p.bclr, fg=p.drk2, nil},
  TabLineSel={bg=p.visu, fg=p.drk2, nil},

  -- Diagnostics moved to neg.groups.diagnostics
}
