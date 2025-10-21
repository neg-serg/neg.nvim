local p = require('neg.palette')

-- Vim syntax highlight groups and language-specific extras
return {
  -- Core syntax
  Boolean={bg=nil, fg=p.literal3_color},
  Comment={bg=nil, fg=p.comment_color, italic=true},
  Conditional={bg=nil, fg=p.keyword1_color},
  Constant={bg=nil, fg=p.literal2_color},
  Debug={bg='NONE', fg=p.red_blood_color},
  Define={bg=nil, fg=p.preproc_dark_color},
  Delimiter={bg=nil, fg=p.delimiter_color},
  Exception={bg=nil, fg=p.red_blood_color},
  Float={bg=nil, fg=p.literal3_color},
  Function={bg=nil, fg=p.function_color},
  Identifier={bg=nil, fg=p.identifier_color},
  Ignore={bg=nil, fg=p.comment_color},
  Include={bg=nil, fg=p.include_color},
  Keyword={bg=nil, fg=p.keyword2_color},
  Label={bg=nil, fg=p.keyword3_color},
  Macro={bg=nil, fg=p.keyword3_color},
  Number={bg=nil, fg=p.keyword1_color},
  Operator={bg=nil, fg=p.keyword2_color},
  PreCondit={bg=nil, fg=p.keyword3_color},
  PreProc={bg=nil, fg=p.preproc_light_color},
  Repeat={bg=nil, fg=p.keyword1_color},
  Special={bg=nil, fg=p.literal1_color},
  SpecialChar={bg=nil, fg=p.literal2_color},
  SpecialComment={bg=nil, fg=p.highlight_color, underline=true},
  SpecialKey={bg=nil, fg=p.tag_color},
  Statement={bg=nil, fg=p.keyword4_color},
  StorageClass={bg=nil, fg=p.keyword1_color},
  String={bg=nil, fg=p.string_color},
  Structure={bg=nil, fg=p.include_color},
  Tag={bg=nil, fg=p.tag_color},
  Type={bg=nil, fg=p.keyword2_color},
  Typedef={bg=nil, fg=p.keyword2_color},

  -- Misc language-specific
  cFunctionTag={bg=nil, fg=p.literal2_color},
  javaScriptNumber={fg=p.tag_color},
  rubySharplbgn={fg=p.preproc_light_color, bold=true},

  -- Vimscript, help
  helpHyperTextJump={fg=p.tag_color},
  vimCommentTitle={fg=p.preproc_light_color},
  vimFold={bg=p.white_color, fg=p.dark_color},

  -- HTML, Perl
  htmlTag={fg=p.keyword2_color},
  htmlEndTag={fg=p.keyword2_color},
  htmlTagName={fg=p.tag_color},

  perlSharplbgn={fg=p.preproc_light_color, bold=true},
  perlStatement={fg=p.keyword3_color},
  perlStatementStorage={fg=p.red_blood_color},
  perlVarPlain2={fg=p.tag_color},
  perlVarPlain={fg=p.literal3_color},
}
