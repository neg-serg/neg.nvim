" Name:        neg
" Version:     2.93
" Last Change: 01-02-2022
" Maintainer:  Sergey Miroshnichenko <serg.zorg@gmail.com>
" URL:         https://github.com/neg-serg/neg/blob/master/colors/neg.vim
" About:       neg theme extends Jason W Ryan's miromiro(1) Vim color file

let s:norm='#6c7e96' " default foreground

let s:bclr='#000000' " background color hexadecimal
let s:dark='#121212' " dark color
let s:drk2='#223f73' " dark 2 color
let s:whit='#d1e5ff' " white color

let s:culc='#272727' " cursor line/column hexadecimal
let s:comm='#3c4754' " comment color

let s:lit1='#017978' " literal color 1
let s:lit2='#008787' " literal color 2
let s:lit3='#007a51' " literal color 3
let s:ops1='#367cb0' " operations color 1
let s:ops2='#2b7694' " operations color 2
let s:ops3='#005faf' " operations color 3
let s:ops4='#395573' " operations color 4
let s:otag='#357b63' " tag highlight color
let s:lstr='#54667a' " literal string highlight
let s:incl='#005f87' " include color
let s:dlim='#4779b3' " delimiter color
let s:blod='#5f0000' " bloody red

let s:visu='#080808' " visual highlight
let s:high='#a5c1e6' " highlight color
let s:darkhigh='#7387a1' " darker highlight color

let s:func='#7095b0' " function highlight

let s:dadd='#25533f' " diff add
let s:dchg='#00406d' " diff change

let s:clin='#131e30' " cursor line
let s:pmen='#6c7e96' " pmenu color
let s:csel='#005faf' " search highlight color

let s:iden='#6289b3' " identifier color

let s:lbgn='#7095b0' " light preprocessor color
let s:dbng='#506a7d' " dark preprocessor color

fun! s:hi(group, bg, fg, attr)
    exec 'hi' a:group
         \ . ' ' . (a:bg   !=# '' ? 'guibg=' . a:bg   : '')
         \ . ' ' . (a:fg   !=# '' ? 'guifg=' . a:fg   : '')
         \ . ' ' . (a:attr !=# '' ? 'gui='   . a:attr : '')
endfun

call s:hi('Boolean',               '',     s:lit3, '')
call s:hi('cFunctionTag',          '',     s:lit2, '')
call s:hi('Comment',               '',     s:comm, 'italic')
call s:hi('Conditional',           '',     s:ops1, '')
call s:hi('Constant',              '',     s:lit2, '')
call s:hi('Debug',                 'NONE', s:blod, '')
call s:hi('Define',                '',     s:dbng, '')
call s:hi('Delimiter',             '',     s:dlim, '')
call s:hi('Directory',             '',     s:ops2, '')
call s:hi('ErrorMsg',              'NONE', s:norm, '')
call s:hi('Exception',             '',     s:blod, '')
call s:hi('Float',                 '',     s:lit3, '')
call s:hi('Folded',                s:visu, s:high, '')
call s:hi('Function',              '',     s:func, '')
call s:hi('Identifier',            '',     s:iden, '')
call s:hi('Ignore',                '',     s:comm, '')
call s:hi('Include',               '',     s:incl, '')
call s:hi('IncSearch',             s:dark, s:csel, 'italic,underline')
call s:hi('Keyword',               '',     s:ops2, '')
call s:hi('Label',                 '',     s:ops3, '')
call s:hi('Macro',                 '',     s:ops3, '')
call s:hi('MatchParen',            s:high, s:dark, '')
call s:hi('ModeMsg',               'NONE', s:ops3, '')
call s:hi('MoreMsg',               'NONE', s:ops3, '')
call s:hi('NonText',               '',     s:ops2, '')
call s:hi('Normal',                '',     s:norm, '')
call s:hi('Number',                '',     s:ops1, '')
call s:hi('Operator',              '',     s:ops2, '')
call s:hi('PreCondit',             '',     s:ops3, '')
call s:hi('PreProc',               '',     s:lbgn, '')
call s:hi('Question',              'NONE', s:lbgn, '')
call s:hi('Repeat',                '',     s:ops1, '')
call s:hi('Search',                'NONE', s:csel, 'italic')
call s:hi('SpecialChar',           '',     s:lit2, '')
call s:hi('SpecialComment',        '',     s:high, 'underline')
call s:hi('SpecialKey',            '',     s:otag, '')
call s:hi('Special',               '',     s:lit1, '')
call s:hi('Statement',             '',     s:ops4, '')
call s:hi('StatusLineNC',          'NONE', 'NONE', 'NONE')
call s:hi('StorageClass',          '',     s:ops1, '')
call s:hi('String',                '',     s:lstr, '')
call s:hi('Structure',             '',     s:incl, '')
call s:hi('Tag',                   '',     s:otag, '')
call s:hi('Title',                 '',     s:lit3, '')
call s:hi('Todo',                  'NONE', s:blod, '')
call s:hi('Typedef',               '',     s:ops2, '')
call s:hi('Type',                  '',     s:ops2, '')
call s:hi('Underlined',            '',     s:ops4, '')
call s:hi('VertSplit',             s:dark, s:bclr, '')
call s:hi('Visual',                s:visu, s:ops3, 'bold')
call s:hi('WarningMsg',            'NONE', s:norm, '')
call s:hi('WildMenu',              s:dark, s:incl, '')

call s:hi('TabLineFill',           s:ops2, s:bclr, '')
call s:hi('TabLine',               s:bclr, s:drk2, 'NONE')
call s:hi('TabLineSel',            s:visu, s:drk2, 'NONE')

call s:hi('ColorColumn',           s:culc, 'NONE', '')
call s:hi('CursorColumn',          s:culc, 'NONE', '')
call s:hi('CursorLine',            'NONE', 'NONE', 'NONE')
call s:hi('CursorLineNr',          s:clin, s:ops3, 'italic,bold')
call s:hi('FoldColumn',            'NONE', s:comm, '')
call s:hi('SignColumn',            'NONE', 'NONE', '')

call s:hi('DiffAdd',               s:whit, s:dadd, '')
call s:hi('DiffChange',            s:whit, s:dchg, '')
call s:hi('DiffDelete',            s:blod, s:bclr, '')
call s:hi('DiffText',              'NONE', s:whit, '')

call s:hi('Error',                 s:blod, s:bclr, '')

call s:hi('Pmenu',                 s:pmen, s:bclr, 'italic,reverse')
call s:hi('PmenuSbar',             s:clin, 'NONE', '')
call s:hi('PmenuSel',              s:clin, s:ops3, 'NONE')
call s:hi('PmenuThumb',            s:ops3, 'NONE', '')

call s:hi('helpHyperTextJump',     '',     s:otag, '')
call s:hi('vimCommentTitle',       '',     s:lbgn, '')
call s:hi('vimFold',               s:whit, s:dark, '')

call s:hi('javaScriptNumber',      '',     s:otag, '')

call s:hi('htmlTag',               '',     s:ops2, '')
call s:hi('htmlEndTag',            '',     s:ops2, '')
call s:hi('htmlTagName',           '',     s:otag, '')

call s:hi('perlSharplbgn',         '',     s:lbgn, 'standout')
call s:hi('perlStatement',         '',     s:ops3, '')
call s:hi('perlStatementStorage',  '',     s:blod, '')
call s:hi('perlVarPlain2',         '',     s:otag, '')
call s:hi('perlVarPlain',          '',     s:lit3, '')

call s:hi('rubySharplbgn',         '',     s:lbgn, 'standout')

call s:hi('diffAdded',             '',     s:ops4, '')
call s:hi('diffChanged',           '',     s:ops2, '')
call s:hi('diffLine',              '',     s:lbgn, '')
call s:hi('diffNewFile',           '',     s:dbng, '')
call s:hi('diffOldFile',           '',     s:dbng, '')
call s:hi('diffOldLine',           '',     s:dbng, '')
call s:hi('diffRemoved',           '',     s:blod, '')

call s:hi('GitGutterAdd',          '', s:ops2, '')
call s:hi('GitGutterChangeDelete', '', s:blod, '')
call s:hi('GitGutterChange',       '', s:incl, '')
call s:hi('GitGutterDelete',       '', s:blod, '')

call s:hi('ALEErrorSignLineNR',    '', s:darkhigh, '')
call s:hi('ALEErrorSign',          '', s:blod, '')
call s:hi('ALEWarningSignLineNR',  '', s:darkhigh, '')
call s:hi('ALEWarningSign',        '', s:ops2, '')

hi link CocFloating Normal
hi link NormalFloat Normal

hi! link Conceal Operator
hi! link DeclRefExpr Normal
hi! link DiffAdded String
hi! link DiffRemoved Constant

hi link ALEErrorSign Title
hi link ALEWarningSign String

if has('spell')
    hi clear SpellBad
    hi clear SpellCap
    hi clear SpellLocal
    hi clear SpellRare
    call s:hi('SpellBad',   '', '', 'underline')
    call s:hi('SpellCap',   '', '', 'underline')
    call s:hi('SpellLocal', '', '', 'underline')
    call s:hi('SpellRare',  '', '', 'underline')
endif

hi LineNr guifg=#2c3641 guibg=NONE gui=italic
hi PmenuSel blend=0

hi ConflictMarkerBegin guibg=#2f7366
hi ConflictMarkerCommonAncestorsHunk guibg=#754a81
hi ConflictMarkerEnd guibg=#2f628e
hi ConflictMarkerOurs guibg=#2e5049
hi ConflictMarkerTheirs guibg=#344f69

hi CocFloating guifg=#266da5
hi TelescopeBorder guifg=#111d26
hi TelescopePreviewBorder guifg=#111d26
hi TelescopePromptBorder guifg=#111d26
hi TelescopeResultsBorder guifg=#111d26
