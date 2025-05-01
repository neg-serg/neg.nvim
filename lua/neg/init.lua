-- Name:        neg
-- Version:     3.20
-- Last Change: 02-05-2025
-- Maintainer:  Sergey Miroshnichenko <serg.zorg@gmail.com>
-- URL:         https://github.com/neg-serg/neg.nvim
-- About:       neg theme extends Jason W Ryan's miromiro(1) Vim color file
local M={}
local p=require'neg.palette'
local hi=vim.api.nvim_set_hl

local main={
    Boolean={bg='', fg=p.lit3},
    cFunctionTag={bg='', fg=p.lit2},
    Comment={bg='', fg=p.comm, italic=true},
    Conditional={bg='', fg=p.ops1},
    Constant={bg='', fg=p.lit2},
    Debug={bg='NONE', fg=p.blod},
    Define={bg='', fg=p.dbng},
    Delimiter={bg='', fg=p.dlim},
    Directory={bg='', fg=p.ops2},
    Error={bg=p.bclr, fg=p.violet},
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
    LineNr={fg='#2c3641', bg=nil, italic=true},
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
    Special={bg='', fg=p.lit1},
    SpecialChar={bg='', fg=p.lit2},
    SpecialComment={bg='', fg=p.high, underline=true},
    SpecialKey={bg='', fg=p.otag},
    Statement={bg='', fg=p.ops4},
    StatusLine={bg='NONE', fg=p.func, nil},
    StatusLineNC={bg='NONE', fg='NONE', nil},
    StorageClass={bg='', fg=p.ops1},
    String={bg='', fg=p.lstr},
    Structure={bg='', fg=p.incl},
    Tag={bg='', fg=p.otag},
    Title={bg='', fg=p.lit3},
    Todo={bg='NONE', fg=p.blod},
    Type={bg='', fg=p.ops2},
    Typedef={bg='', fg=p.ops2},
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

    ALEErrorSign={link='Title'},
    ALEWarningSign={link='String'},
    DiagnosticError={link='Title'},
    DiagnosticWarn={link='String'},

    Conceal={link='Operator'},
    DeclRefExpr={link='Normal'},

    ExtraWhitespace={bg=p.lit3, fg='NONE'},
    FloatBorder={link='Vertsplit'},
    WinSeparator={link='Vertsplit'},
}

local spell={
    SpellBad={underline=true},
    SpellCap={underline=true},
    SpellLocal={underline=true},
    SpellRare={underline=true},
}

local html={
    htmlTag={fg=p.ops2},
    htmlEndTag={fg=p.ops2},
    htmlTagName={fg=p.otag},
}

local pmenu={
    Pmenu={bg=p.bclr, fg=p.pmen, italic=true},
    PmenuSbar={bg=p.clin, fg='NONE'},
    PmenuSel={bg=p.clin, fg=p.ops3},
    PmenuThumb={bg=p.ops3, fg='NONE'},
}

local misc={
    javaScriptNumber={fg=p.otag},
    rubySharplbgn={fg=p.lbgn, standout=true},
}

local vim={
    helpHyperTextJump={fg=p.otag},
    vimCommentTitle={fg=p.lbgn},
    vimFold={bg=p.whit, fg=p.dark},
}

local conflicts={
    ConflictMarkerBegin={bg='#2f7366'},
    ConflictMarkerCommonAncestorsHunk={bg='#754a81'},
    ConflictMarkerEnd={bg='#2f628e'},
    ConflictMarkerOurs={bg='#2e5049'},
    ConflictMarkerTheirs={bg='#344f69'},
}

local tabline={
    TabLineFill={bg=p.bclr, fg=p.ops2},
    TabLine={bg=p.bclr, fg=p.drk2, nil},
    TabLineSel={bg=p.visu, fg=p.drk2, nil},
}

local perl={
    perlSharplbgn={fg=p.lbgn, standout=true},
    perlStatement={fg=p.ops3},
    perlStatementStorage={fg=p.blod},
    perlVarPlain2={fg=p.otag},
    perlVarPlain={fg=p.lit3},
}

local cmp={
    CmpItemKindDefault={fg=p.cmpdef, bg='NONE'},
    CmpItemKindFunction={fg=p.blod, bg='NONE'},
    CmpItemKindInterface={fg=p.ops3, bg='NONE'},
    CmpItemKindKeyword={fg=p.lit3, bg='NONE'},
    CmpItemKindMethod={fg=p.blod, bg='NONE'},
    CmpItemKindProperty={fg=p.lit3, bg='NONE'},
    CmpItemKindVariable={fg=p.ops3, bg='NONE'},
}

local gitgutter={
    GitGutterAdd={fg=p.ops2},
    GitGutterChangeDelete={fg=p.blod},
    GitGutterChange={fg=p.incl},
    GitGutterDelete={fg=p.blod},
}

local diff={
    DiffAdd={bg=p.whit, fg=p.dadd},
    diffAdded={fg=p.ops4},
    DiffAdded={link='String'},
    DiffChange={bg=p.whit, fg=p.dchg},
    diffChanged={fg=p.ops2},
    DiffDelete={bg=p.blod, fg=p.bclr},
    diffLine={fg=p.lbgn},
    diffNewFile={fg=p.dbng},
    diffOldFile={fg=p.dbng},
    diffOldLine={fg=p.dbng},
    diffRemoved={fg=p.blod},
    DiffRemoved={link='Constant'},
    DiffText={bg='NONE', fg=p.whit},
}

local telescope={
    TelescopeMatching={bg='NONE', fg=p.col19, italic=true},
    TelescopeSelection={fg=p.col17},
    TelescopeBorder={fg='#111d26'},
    TelescopePreviewBorder={fg='#111d26'},
    TelescopePromptBorder={fg='#111d26'},
    TelescopeResultsBorder={fg='#111d26'},
    TelescopePathSeparator={link='Normal'},
}

local rainbow={
   RainbowDelimiterRed={fg=p.br1},
   RainbowDelimiterYellow={fg=p.br2},
   RainbowDelimiterBlue={fg=p.br3},
   RainbowDelimiterOrange={fg=p.br4},
   RainbowDelimiterGreen={fg=p.br5},
   RainbowDelimiterViolet={fg=p.br6},
   RainbowDelimiterCyan={fg=p.br7},
}

local noice={
    Cursor={bg=p.csel},
    NoiceCursor={bg=p.csel},
    NoiceCmdLine={fg='#6c7e96',italic=true},
    FlashLabel={link='Todo'},
}

local headline={
    Headline1={bg=p.visu},
    Headline2={bg=p.visu},
    CodeBlock={bg=p.visu},
    Dash={bg=p.visu,bold=true}
}

local treesitter_compatibility={
    -- tree-sitter "standard capture names"
    ['@variable.parameter']={link='@parameter'},
    ['@variable.member']={link='@field'},
    ['@module']={link='@namespace'},
    ['@number.float']={link='@float'},
    ['@string.special.symbol']={link='@symbol'},
    ['@string.regexp']={link='@string.regex'},
    ['@markup.strong']={link='@text.strong'},
    ['@markup.italic']={link='@text.emphasis'},
    ['@markup.underline']={link='@text.underline'},
    ['@markup.strikethrough']={link='@text.strike'},
    ['@markup.heading']={link='@text.title'},
    ['@markup.quote']={link='@text.quote'},
    ['@markup.link.url']={link='@text.uri'},
    ['@markup.math']={link='@text.math'},
    ['@markup.environment']={link='@text.environment'},
    ['@markup.environment.name']={link='@text.environment.name'},
    ['@markup.link']={link='@text.reference'},
    ['@markup.raw']={link='@text.literal'},
    ['@markup.raw.block']={link='@text.literal.block'},
    ['@markup.link.label']={link='@string.special'},
    ['@markup.list']={link='@punctuation.special'},
    -- Helix captures
    ['@function.method']={link='@method'},
    ['@function.method.call']={link='@method.call'},
    ['@comment.todo']={link='@text.todo'},
    ['@comment.error']={link='@text.danger'},
    ['@comment.warning']={link='@text.warning'},
    ['@comment.hint']={link='@text.note'},
    ['@comment.info']={link='@text.note'},
    ['@comment.note']={link='@text.note'},
    ['@comment.ok']={link='@text.note'},
    ['@diff.plus']={link='@text.diff.add'},
    ['@diff.minus']={link='@text.diff.delete'},
    ['@diff.delta']={link='@text.diff.change'},
    ['@string.special.url']={link='@text.uri'},
    ['@keyword.directive']={link='@preproc'},
    ['@keyword.storage']={link='@storageclass'},
    ['@keyword.directive']={link='@define'},
    ['@keyword.conditional']={link='@conditional'},
    ['@keyword.debug']={link='@debug'},
    ['@keyword.exception']={link='@exception'},
    ['@keyword.import']={link='@include'},
    ['@keyword.repeat']={link='@repeat'},

    ['@variable']={fg=p.var},
}

function M.setup()
    for _, group in ipairs({
        main,
        cmp,
        conflicts,
        diff,
        gitgutter,
        pmenu,
        spell,
        telescope,
        vim,
        rainbow,
        noice,
        headline,
        treesitter_compatibility
    }) do for name, style in pairs(group) do hi(0, name, style) end end
    if "" then
        for _, group in ipairs({tabline,perl,html,misc}) do
            for name, style in pairs(group) do hi(0, name, style) end
        end
    end
end

return M
