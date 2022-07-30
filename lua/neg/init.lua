-- Name:        neg
-- Version:     3.06
-- Last Change: 24-07-2022
-- Maintainer:  Sergey Miroshnichenko <serg.zorg@gmail.com>
-- URL:         https://github.com/neg-serg/neg/blob/master/colors/neg.vim
-- About:       neg theme extends Jason W Ryan's miromiro(1) Vim color file
local M={}
local p=require'neg.palette'
local hi=vim.api.nvim_set_hl

local all_styles={
    Boolean={bg='', fg=p.lit3},
    cFunctionTag={bg='', fg=p.lit2},
    Comment={bg='', fg=p.comm, italic=true},
    Conditional={bg='', fg=p.ops1},
    Constant={bg='', fg=p.lit2},
    Debug={bg='NONE', fg=p.blod},
    Define={bg='', fg=p.dbng},
    Delimiter={bg='', fg=p.dlim},
    Directory={bg='', fg=p.ops2},
    ErrorMsg= {bg='NONE', fg=p.norm},
    Exception={bg='', fg=p.blod},
    Float={bg='', fg=p.lit3},
    Folded={bg=p.visu, fg=p.high},
    Function={bg='', fg=p.func},
    Identifier={bg='', fg=p.iden},
    Ignore={bg='', fg=p.comm},
    Include={bg='', fg=p.incl},
    IncSearch={bg=p.dark, fg=p.csel, italic=true,underline=true},
    Keyword={bg='', fg=p.ops2},
    Label={bg='', fg=p.ops3},
    Macro={bg='', fg=p.ops3},
    MatchParen={bg=p.high, fg=p.dark},
    ModeMsg={bg='NONE', fg=p.ops3},
    MoreMsg={bg='NONE', fg=p.ops3},
    NonText={bg='', fg=p.ops2},
    Normal={bg='', fg=p.norm},
    Number={bg='', fg=p.ops1},
    Operator={bg='', fg=p.ops2},
    PreCondit={bg='', fg=p.ops3},
    PreProc={bg='', fg=p.lbgn},
    Question={bg='NONE', fg=p.lbgn},
    Repeat={bg='', fg=p.ops1},
    Search={bg='NONE', fg=p.csel, italic=true},
    SpecialChar={bg='', fg=p.lit2},
    SpecialComment={bg='', fg=p.high, underline=true},
    SpecialKey={bg='', fg=p.otag},
    Special={bg='', fg=p.lit1},
    Statement={bg='', fg=p.ops4},
    StatusLine={bg='NONE', fg=p.func, nil},
    StatusLineNC={bg='NONE', fg='NONE', nil},
    StorageClass={bg='', fg=p.ops1},
    String={bg='', fg=p.lstr},
    Structure={bg='', fg=p.incl},
    Tag={bg='', fg=p.otag},
    Title={bg='', fg=p.lit3},
    Todo={bg='NONE', fg=p.blod},
    Typedef={bg='', fg=p.ops2},
    Type={bg='', fg=p.ops2},
    Underlined={bg='', fg=p.ops4},
    VertSplit={bg='NONE', fg=p.dark},
    Visual={bg=p.visu, fg=p.ops3, bold=true},
    WarningMsg={bg='NONE', fg=p.norm},
    WildMenu={bg=p.dark, fg=p.incl},

    TabLineFill={bg=p.ops2, fg=p.bclr},
    TabLine={bg=p.bclr, fg=p.drk2, nil},
    TabLineSel={bg=p.visu, fg=p.drk2, nil},

    ColorColumn={bg=p.culc, nil},
    CursorColumn={bg=p.culc, nil},
    CursorLine={nil, nil, nil},
    CursorLineNr={bg=p.clin, fg=p.ops3, italic=true, bold=true},
    FoldColumn={bg='NONE', fg=p.comm},
    SignColumn={bg='NONE', fg='NONE'},

    DiffAdd={bg=p.whit, fg=p.dadd},
    DiffChange={bg=p.whit, fg=p.dchg},
    DiffDelete={bg=p.blod, fg=p.bclr},
    DiffText={bg='NONE', fg=p.whit},

    Error={bg=p.bclr, fg=p.violet},

    Pmenu={bg=p.pmen, fg=p.bclr, italic=true,reverse=true},
    PmenuSbar={bg=p.clin, fg='NONE'},
    PmenuSel={bg=p.clin, fg=p.ops3, nil},
    PmenuThumb={bg=p.ops3, fg='NONE'},

    helpHyperTextJump={fg=p.otag},
    vimCommentTitle={fg=p.lbgn},
    vimFold={bg=p.whit, fg=p.dark},

    javaScriptNumber={fg=p.otag},

    htmlTag={fg=p.ops2},
    htmlEndTag={fg=p.ops2},
    htmlTagName={fg=p.otag},

    perlSharplbgn={fg=p.lbgn, standout=true},
    perlStatement={fg=p.ops3},
    perlStatementStorage={fg=p.blod},
    perlVarPlain2={fg=p.otag},
    perlVarPlain={fg=p.lit3},

    rubySharplbgn={fg=p.lbgn, standout=true},

    diffAdded={fg=p.ops4},
    diffChanged={fg=p.ops2},
    diffLine={fg=p.lbgn},
    diffNewFile={fg=p.dbng},
    diffOldFile={fg=p.dbng},
    diffOldLine={fg=p.dbng},
    diffRemoved={fg=p.blod},

    GitGutterAdd={fg=p.ops2},
    GitGutterChangeDelete={fg=p.blod},
    GitGutterChange={fg=p.incl},
    GitGutterDelete={fg=p.blod},

    SpellBad={underline=true},
    SpellCap={underline=true},
    SpellLocal={underline=true},
    SpellRare={underline=true},

    LineNr={fg='#2c3641', bg=nil, italic=true},
    ConflictMarkerBegin={bg='#2f7366'},
    ConflictMarkerCommonAncestorsHunk={bg='#754a81'},
    ConflictMarkerEnd={bg='#2f628e'},
    ConflictMarkerOurs={bg='#2e5049'},
    ConflictMarkerTheirs={bg='#344f69'},

    TelescopeBorder={fg='#111d26'},
    TelescopePreviewBorder={fg='#111d26'},
    TelescopePromptBorder={fg='#111d26'},
    TelescopeResultsBorder={fg='#111d26'},

    ALEErrorSign={link='Title'},
    ALEWarningSign={link='String'},
    DiagnosticError={link='Title'},
    DiagnosticWarn={link='String'},

    CocFloating={link='Normal'},
    NormalFloat={link='Normal'},

    Conceal={link='Operator'},
    DeclRefExpr={link='Normal'},
    DiffAdded={link='String'},
    DiffRemoved={link='Constant'},

    ExtraWhitespace={bg=p.lit3, fg='NONE'},

    CmpItemKindFunction={bg=p.blod, fg='NONE'},
    CmpItemKindInterface={bg=p.ops3, fg='NONE'},
    CmpItemKindKeyword={bg=p.lit3, fg='NONE'},
    CmpItemKindMethod={bg=p.blod, fg='NONE'},
    CmpItemKindProperty={bg=p.lit3, fg='NONE'},
    CmpItemKindVariable={bg=p.ops3, fg='NONE'},
}

function M.setup()
    for name, style in pairs(all_styles) do
        hi(0, name, style)
    end
end

return M
