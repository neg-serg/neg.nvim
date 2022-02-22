-- Name:        neg
-- Version:     3.01
-- Last Change: 23-02-2022
-- Maintainer:  Sergey Miroshnichenko <serg.zorg@gmail.com>
-- URL:         https://github.com/neg-serg/neg/blob/master/colors/neg.vim
-- About:       neg theme extends Jason W Ryan's miromiro(1) Vim color file

local norm='#6c7e96' -- default foreground

local bclr='#000000' -- background color hexadecimal
local dark='#121212' -- dark color
local drk2='#223f73' -- dark 2 color
local whit='#d1e5ff' -- white color

local culc='#272727' -- cursor line/column hexadecimal
local comm='#3c4754' -- comment color

local lit1='#017978' -- literal color 1
local lit2='#008787' -- literal color 2
local lit3='#007a51' -- literal color 3
local ops1='#367cb0' -- operations color 1
local ops2='#2b7694' -- operations color 2
local ops3='#005faf' -- operations color 3
local ops4='#395573' -- operations color 4
local otag='#357b63' -- tag highlight color
local lstr='#54667a' -- literal string highlight
local incl='#005f87' -- include color
local dlim='#4779b3' -- delimiter color
local blod='#5f0000' -- bloody red

local visu='#080808' -- visual highlight
local high='#a5c1e6' -- highlight color
local darkhigh='#7387a1' -- darker highlight color

local func='#7095b0' -- function highlight

local dadd='#25533f' -- diff add
local dchg='#00406d' -- diff change

local clin='#131e30' -- cursor line
local pmen='#6c7e96' -- pmenu color
local csel='#005faf' -- search highlight color

local iden='#6289b3' -- identifier color

local lbgn='#7095b0' -- light preprocessor color
local dbng='#506a7d' -- dark preprocessor color

local hi = vim.api.nvim_set_hl

hi(0, 'Boolean', {bg = '', fg = lit3})
hi(0, 'cFunctionTag', {bg = '', fg = lit2})
hi(0, 'Comment', {bg = '', fg = comm, italic=true})
hi(0, 'Conditional', {bg = '', fg = ops1})
hi(0, 'Constant', {bg = '', fg = lit2})
hi(0, 'Debug', {bg = 'NONE', fg = blod})
hi(0, 'Define', {bg = '', fg = dbng})
hi(0, 'Delimiter', {bg = '', fg = dlim})
hi(0, 'Directory', {bg = '', fg = ops2})
hi(0, 'ErrorMsg', {bg = 'NONE', fg = norm})
hi(0, 'Exception', {bg = '', fg = blod})
hi(0, 'Float', {bg = '', fg = lit3})
hi(0, 'Folded', {bg = visu, fg = high})
hi(0, 'Function', {bg = '', fg = func})
hi(0, 'Identifier', {bg = '', fg = iden})
hi(0, 'Ignore', {bg = '', fg = comm})
hi(0, 'Include', {bg = '', fg = incl})
hi(0, 'IncSearch', {bg = dark, fg = csel, italic=true,underline=true})
hi(0, 'Keyword', {bg = '', fg = ops2})
hi(0, 'Label', {bg = '', fg = ops3})
hi(0, 'Macro', {bg = '', fg = ops3})
hi(0, 'MatchParen', {bg = high, fg = dark})
hi(0, 'ModeMsg', {bg = 'NONE', fg = ops3})
hi(0, 'MoreMsg', {bg = 'NONE', fg = ops3})
hi(0, 'NonText', {bg = '', fg = ops2})
hi(0, 'Normal', {bg = '', fg = norm})
hi(0, 'Number', {bg = '', fg = ops1})
hi(0, 'Operator', {bg = '', fg = ops2})
hi(0, 'PreCondit', {bg = '', fg = ops3})
hi(0, 'PreProc', {bg = '', fg = lbgn})
hi(0, 'Question', {bg = 'NONE', fg = lbgn})
hi(0, 'Repeat', {bg = '', fg = ops1})
hi(0, 'Search', {bg = 'NONE', fg = csel, italic=true})
hi(0, 'SpecialChar', {bg = '', fg = lit2})
hi(0, 'SpecialComment', {bg = '', fg = high, underline=true})
hi(0, 'SpecialKey', {bg = '', fg = otag})
hi(0, 'Special', {bg = '', fg = lit1})
hi(0, 'Statement', {bg = '', fg = ops4})
hi(0, 'StatusLineNC', {bg = 'NONE', fg = 'NONE', nil})
hi(0, 'StorageClass', {bg = '', fg = ops1})
hi(0, 'String', {bg = '', fg = lstr})
hi(0, 'Structure', {bg = '', fg = incl})
hi(0, 'Tag', {bg = '', fg = otag})
hi(0, 'Title', {bg = '', fg = lit3})
hi(0, 'Todo', {bg = 'NONE', fg = blod})
hi(0, 'Typedef', {bg = '', fg = ops2})
hi(0, 'Type', {bg = '', fg = ops2})
hi(0, 'Underlined', {bg = '', fg = ops4})
hi(0, 'VertSplit', {bg = dark, fg = bclr})
hi(0, 'Visual', {bg = visu, fg = ops3, bold=true})
hi(0, 'WarningMsg', {bg = 'NONE', fg = norm})
hi(0, 'WildMenu', {bg = dark, fg = incl})

hi(0, 'TabLineFill', {bg = ops2, fg = bclr})
hi(0, 'TabLine', {bg = bclr, fg = drk2, nil})
hi(0, 'TabLineSel', {bg = visu, fg = drk2, nil})

hi(0, 'ColorColumn', {bg = culc, nil})
hi(0, 'CursorColumn', {bg = culc, nil})
hi(0, 'CursorLine', {nil, nil, nil})
hi(0, 'CursorLineNr', {bg = clin, fg = ops3, italic=true, bold=true})
hi(0, 'FoldColumn', {bg = 'NONE', fg = comm})
hi(0, 'SignColumn', {bg = 'NONE', fg = 'NONE'})

hi(0, 'DiffAdd', {bg = whit, fg = dadd})
hi(0, 'DiffChange', {bg = whit, fg = dchg})
hi(0, 'DiffDelete', {bg = blod, fg = bclr})
hi(0, 'DiffText', {bg = 'NONE', fg = whit})

hi(0, 'Error', {bg = blod, fg = bclr})

hi(0, 'Pmenu', {bg = pmen, fg = bclr, italic=true,reverse=true})
hi(0, 'PmenuSbar', {bg = clin, fg = 'NONE'})
hi(0, 'PmenuSel', {bg = clin, fg = ops3, nil})
hi(0, 'PmenuThumb', {bg = ops3, fg = 'NONE'})

hi(0, 'helpHyperTextJump', {fg = otag})
hi(0, 'vimCommentTitle', {fg = lbgn})
hi(0, 'vimFold', {bg = whit, fg = dark})

hi(0, 'javaScriptNumber', {fg = otag})

hi(0, 'htmlTag', {fg = ops2})
hi(0, 'htmlEndTag', {fg = ops2})
hi(0, 'htmlTagName', {fg = otag})

hi(0, 'perlSharplbgn', {fg = lbgn, standout=true})
hi(0, 'perlStatement', {fg = ops3})
hi(0, 'perlStatementStorage', {fg = blod})
hi(0, 'perlVarPlain2', {fg = otag})
hi(0, 'perlVarPlain', {fg = lit3})

hi(0, 'rubySharplbgn', {fg = lbgn, standout=true})

hi(0, 'diffAdded', {fg = ops4})
hi(0, 'diffChanged', {fg = ops2})
hi(0, 'diffLine', {fg = lbgn})
hi(0, 'diffNewFile', {fg = dbng})
hi(0, 'diffOldFile', {fg = dbng})
hi(0, 'diffOldLine', {fg = dbng})
hi(0, 'diffRemoved', {fg = blod})

hi(0, 'GitGutterAdd', {fg = ops2})
hi(0, 'GitGutterChangeDelete', {fg = blod})
hi(0, 'GitGutterChange', {fg = incl})
hi(0, 'GitGutterDelete', {fg = blod})

hi(0, 'ALEErrorSignLineNR', {fg = darkhigh})
hi(0, 'ALEWarningSignLineNR', {fg = darkhigh})

hi(0, 'SpellBad', {underline=true})
hi(0, 'SpellCap', {underline=true})
hi(0, 'SpellLocal', {underline=true})
hi(0, 'SpellRare', {underline=true})

hi(0, 'LineNr', {fg = '#2c3641', bg = nil, italic=true})
hi(0, 'ConflictMarkerBegin', {bg = '#2f7366'})
hi(0, 'ConflictMarkerCommonAncestorsHunk', {bg = '#754a81'})
hi(0, 'ConflictMarkerEnd', {bg = '#2f628e'})
hi(0, 'ConflictMarkerOurs', {bg = '#2e5049'})
hi(0, 'ConflictMarkerTheirs', {bg = '#344f69'})

hi(0, 'CocFloating', {fg = '#266da5'})
hi(0, 'TelescopeBorder', {fg = '#111d26'})
hi(0, 'TelescopePreviewBorder', {fg = '#111d26'})
hi(0, 'TelescopePromptBorder', {fg = '#111d26'})
hi(0, 'TelescopeResultsBorder', {fg = '#111d26'})

hi(0, 'ALEErrorSign', {link = 'Title'})
hi(0, 'ALEWarningSign', {link = 'String'})
hi(0, 'DiagnosticError', {link = 'Title'})
hi(0, 'DiagnosticWarn', {link = 'String'})

hi(0, 'CocFloating', {link = 'Normal'})
hi(0, 'NormalFloat', {link = 'Normal'})

hi(0, 'Conceal', {link = 'Operator'})
hi(0, 'DeclRefExpr', {link = 'Normal'})
hi(0, 'DiffAdded', {link = 'String'})
hi(0, 'DiffRemoved', {link = 'Constant'})
