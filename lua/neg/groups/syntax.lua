local p = require('neg.palette')

-- Vim syntax highlight groups and language-specific extras
return {
  -- Core syntax
  Boolean={bg=nil, fg=p.lit3},
  Comment={bg=nil, fg=p.comm, italic=true},
  Conditional={bg=nil, fg=p.ops1},
  Constant={bg=nil, fg=p.lit2},
  Debug={bg='NONE', fg=p.blod},
  Define={bg=nil, fg=p.dbng},
  Delimiter={bg=nil, fg=p.dlim},
  Exception={bg=nil, fg=p.blod},
  Float={bg=nil, fg=p.lit3},
  Function={bg=nil, fg=p.func},
  Identifier={bg=nil, fg=p.iden},
  Ignore={bg=nil, fg=p.comm},
  Include={bg=nil, fg=p.incl},
  Keyword={bg=nil, fg=p.ops2},
  Label={bg=nil, fg=p.ops3},
  Macro={bg=nil, fg=p.ops3},
  Number={bg=nil, fg=p.ops1},
  Operator={bg=nil, fg=p.ops2},
  PreCondit={bg=nil, fg=p.ops3},
  PreProc={bg=nil, fg=p.lbgn},
  Repeat={bg=nil, fg=p.ops1},
  Special={bg=nil, fg=p.lit1},
  SpecialChar={bg=nil, fg=p.lit2},
  SpecialComment={bg=nil, fg=p.high, underline=true},
  SpecialKey={bg=nil, fg=p.otag},
  Statement={bg=nil, fg=p.ops4},
  StorageClass={bg=nil, fg=p.ops1},
  String={bg=nil, fg=p.lstr},
  Structure={bg=nil, fg=p.incl},
  Tag={bg=nil, fg=p.otag},
  Type={bg=nil, fg=p.ops2},
  Typedef={bg=nil, fg=p.ops2},

  -- Misc language-specific
  cFunctionTag={bg=nil, fg=p.lit2},
  javaScriptNumber={fg=p.otag},
  rubySharplbgn={fg=p.lbgn, bold=true},

  -- Vimscript, help
  helpHyperTextJump={fg=p.otag},
  vimCommentTitle={fg=p.lbgn},
  vimFold={bg=p.whit, fg=p.dark},

  -- HTML, Perl
  htmlTag={fg=p.ops2},
  htmlEndTag={fg=p.ops2},
  htmlTagName={fg=p.otag},

  perlSharplbgn={fg=p.lbgn, bold=true},
  perlStatement={fg=p.ops3},
  perlStatementStorage={fg=p.blod},
  perlVarPlain2={fg=p.otag},
  perlVarPlain={fg=p.lit3},
}
