local p = require('neg.palette')

-- UI/editor highlight groups and diagnostics
return {
  -- Core UI and editor
  Directory={bg=nil, fg=p.keyword2_color},
  Error={bg=p.bg_default, fg=p.violet_color},
  ErrorMsg= {bg='NONE', fg=p.default_color},
  Folded={bg=p.bg_visual, fg=p.highlight_color},
  LineNr={fg='#2c3641', bg=nil, italic=true},
  MatchParen={bg=p.highlight_color, fg=p.dark_color},
  ModeMsg={bg='NONE', fg=p.keyword3_color},
  MoreMsg={bg='NONE', fg=p.keyword3_color},
  NonText={bg=nil, fg=p.keyword2_color},
  -- Use explicit background when not in transparent mode; apply_transparent() can override to NONE
  Normal={bg=p.bg_default, fg=p.default_color},
  NormalNC={link='Normal'},
  -- Floats use the same background as Normal by default (no extra tint)
  NormalFloat={link='Normal'},
  FloatTitle={fg=p.keyword3_color, bold=true},
  WinBar={fg=p.keyword3_color},
  WinBarNC={fg=p.comment_color},
  QuickFixLine={bg=p.bg_cursorline, fg=p.default_color, bold=true},
  Substitute={bg=p.search_color, fg=p.dark_color, bold=true},
  MsgArea={fg=p.default_color},
  MsgSeparator={fg=p.dark_color},
  Search={bg='NONE', fg=p.search_color, italic=true},
  IncSearch={bg=p.dark_color, fg=p.search_color, italic=true,underline=true},
  CurSearch={bg=p.dark_color, fg=p.search_color, italic=true, bold=true},
  -- Keep statusline neutral by default; statusline plugins will recolor.
  StatusLine={bg='NONE', fg=p.function_color},
  StatusLineNC={bg='NONE', fg='NONE'},
  Title={bg=nil, fg=p.literal3_color},
  Underlined={bg=nil, fg=p.keyword4_color},
  VertSplit={bg='NONE', fg=p.dark_color},
  Visual={bg=p.bg_selection_dim, fg='NONE', bold=true},
  WarningMsg={bg='NONE', fg=p.default_color},
  WildMenu={bg=p.dark_color, fg=p.include_color},

  ColorColumn={bg=p.bg_cursorcolumn},
  CursorColumn={bg=p.bg_cursorcolumn},
  CursorLine={},
  CursorLineNr={bg=p.bg_cursorline, fg=p.keyword3_color, italic=true, bold=true},
  TermCursor={reverse=true},
  TermCursorNC={reverse=true},
  FoldColumn={bg='NONE', fg=p.comment_color},
  SignColumn={bg='NONE', fg='NONE'},

  Conceal={link='@operator'},
  DeclRefExpr={link='Normal'},

  ExtraWhitespace={bg=p.literal3_color, fg='NONE'},
  FloatBorder={link='VertSplit'},
  WinSeparator={link='VertSplit'},

  -- Diff (core Neovim groups)
  DiffAdd={bg='#123425', fg=p.diff_add_color},
  DiffChange={bg='#122c34', fg=p.diff_change_color},
  DiffDelete={bg=p.red_blood_color, fg=p.diff_delete_color},
  DiffText={bg='NONE', fg=p.white_color},

  -- Spell
  SpellBad={underline=true},
  SpellCap={underline=true},
  SpellLocal={underline=true},
  SpellRare={underline=true},

  -- Pmenu
  Pmenu={bg=p.bg_default, fg=p.pmenu_color, italic=true},
  PmenuSbar={bg=p.bg_cursorline, fg='NONE'},
  PmenuSel={bg=p.bg_cursorline, fg=p.keyword3_color},
  PmenuThumb={bg=p.keyword3_color, fg='NONE'},

  -- Tabline
  TabLineFill={bg=p.bg_default, fg=p.keyword2_color},
  TabLine={bg=p.bg_default, fg=p.dark_secondary_color},
  TabLineSel={bg=p.bg_visual, fg=p.dark_secondary_color},

  -- Diagnostics moved to neg.groups.diagnostics
}
