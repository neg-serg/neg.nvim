-- Name:        neg
-- Version:     3.04
-- Last Change: 02-06-2022
-- Maintainer:  Sergey Miroshnichenko <serg.zorg@gmail.com>
-- URL:         https://github.com/neg-serg/neg/blob/master/colors/neg.vim
-- About:       neg theme extends Jason W Ryan's miromiro(1) Vim color file
local M = {}
local p = require("neg.palette")

function M.setup()

    local hi = vim.api.nvim_set_hl

    hi(0, 'Boolean', {bg = '', fg = p.lit3})
    hi(0, 'cFunctionTag', {bg = '', fg = p.lit2})
    hi(0, 'Comment', {bg = '', fg = p.comm, italic=true})
    hi(0, 'Conditional', {bg = '', fg = p.ops1})
    hi(0, 'Constant', {bg = '', fg = p.lit2})
    hi(0, 'Debug', {bg = 'NONE', fg = p.blod})
    hi(0, 'Define', {bg = '', fg = p.dbng})
    hi(0, 'Delimiter', {bg = '', fg = p.dlim})
    hi(0, 'Directory', {bg = '', fg = p.ops2})
    hi(0, 'ErrorMsg', {bg = 'NONE', fg = p.norm})
    hi(0, 'Exception', {bg = '', fg = p.blod})
    hi(0, 'Float', {bg = '', fg = p.lit3})
    hi(0, 'Folded', {bg = p.visu, fg = p.high})
    hi(0, 'Function', {bg = '', fg = p.func})
    hi(0, 'Identifier', {bg = '', fg = p.iden})
    hi(0, 'Ignore', {bg = '', fg = p.comm})
    hi(0, 'Include', {bg = '', fg = p.incl})
    hi(0, 'IncSearch', {bg = p.dark, fg = p.csel, italic=true,underline=true})
    hi(0, 'Keyword', {bg = '', fg = p.ops2})
    hi(0, 'Label', {bg = '', fg = p.ops3})
    hi(0, 'Macro', {bg = '', fg = p.ops3})
    hi(0, 'MatchParen', {bg = p.high, fg = p.dark})
    hi(0, 'ModeMsg', {bg = 'NONE', fg = p.ops3})
    hi(0, 'MoreMsg', {bg = 'NONE', fg = p.ops3})
    hi(0, 'NonText', {bg = '', fg = p.ops2})
    hi(0, 'Normal', {bg = '', fg = p.norm})
    hi(0, 'Number', {bg = '', fg = p.ops1})
    hi(0, 'Operator', {bg = '', fg = p.ops2})
    hi(0, 'PreCondit', {bg = '', fg = p.ops3})
    hi(0, 'PreProc', {bg = '', fg = p.lbgn})
    hi(0, 'Question', {bg = 'NONE', fg = p.lbgn})
    hi(0, 'Repeat', {bg = '', fg = p.ops1})
    hi(0, 'Search', {bg = 'NONE', fg = p.csel, italic=true})
    hi(0, 'SpecialChar', {bg = '', fg = p.lit2})
    hi(0, 'SpecialComment', {bg = '', fg = p.high, underline=true})
    hi(0, 'SpecialKey', {bg = '', fg = p.otag})
    hi(0, 'Special', {bg = '', fg = p.lit1})
    hi(0, 'Statement', {bg = '', fg = p.ops4})
    hi(0, 'StatusLine', {bg = 'NONE', fg = p.lit1, nil})
    hi(0, 'StatusLineNC', {bg = 'NONE', fg = 'NONE', nil})
    hi(0, 'StorageClass', {bg = '', fg = p.ops1})
    hi(0, 'String', {bg = '', fg = p.lstr})
    hi(0, 'Structure', {bg = '', fg = p.incl})
    hi(0, 'Tag', {bg = '', fg = p.otag})
    hi(0, 'Title', {bg = '', fg = p.lit3})
    hi(0, 'Todo', {bg = 'NONE', fg = p.blod})
    hi(0, 'Typedef', {bg = '', fg = p.ops2})
    hi(0, 'Type', {bg = '', fg = p.ops2})
    hi(0, 'Underlined', {bg = '', fg = p.ops4})
    hi(0, 'VertSplit', {bg = 'NONE', fg = p.dark})
    hi(0, 'Visual', {bg = p.visu, fg = p.ops3, bold=true})
    hi(0, 'WarningMsg', {bg = 'NONE', fg = p.norm})
    hi(0, 'WildMenu', {bg = p.dark, fg = p.incl})

    hi(0, 'TabLineFill', {bg = p.ops2, fg = p.bclr})
    hi(0, 'TabLine', {bg = p.bclr, fg = p.drk2, nil})
    hi(0, 'TabLineSel', {bg = p.visu, fg = p.drk2, nil})

    hi(0, 'ColorColumn', {bg = p.culc, nil})
    hi(0, 'CursorColumn', {bg = p.culc, nil})
    hi(0, 'CursorLine', {nil, nil, nil})
    hi(0, 'CursorLineNr', {bg = p.clin, fg = p.ops3, italic=true, bold=true})
    hi(0, 'FoldColumn', {bg = 'NONE', fg = p.comm})
    hi(0, 'SignColumn', {bg = 'NONE', fg = 'NONE'})

    hi(0, 'DiffAdd', {bg = p.whit, fg = p.dadd})
    hi(0, 'DiffChange', {bg = p.whit, fg = p.dchg})
    hi(0, 'DiffDelete', {bg = p.blod, fg = p.bclr})
    hi(0, 'DiffText', {bg = 'NONE', fg = p.whit})

    hi(0, 'Error', {bg = p.blod, fg = p.bclr})

    hi(0, 'Pmenu', {bg = p.pmen, fg = p.bclr, italic=true,reverse=true})
    hi(0, 'PmenuSbar', {bg = p.clin, fg = 'NONE'})
    hi(0, 'PmenuSel', {bg = p.clin, fg = p.ops3, nil})
    hi(0, 'PmenuThumb', {bg = p.ops3, fg = 'NONE'})

    hi(0, 'helpHyperTextJump', {fg = p.otag})
    hi(0, 'vimCommentTitle', {fg = p.lbgn})
    hi(0, 'vimFold', {bg = p.whit, fg = p.dark})

    hi(0, 'javaScriptNumber', {fg = p.otag})

    hi(0, 'htmlTag', {fg = p.ops2})
    hi(0, 'htmlEndTag', {fg = p.ops2})
    hi(0, 'htmlTagName', {fg = p.otag})

    hi(0, 'perlSharplbgn', {fg = p.lbgn, standout=true})
    hi(0, 'perlStatement', {fg = p.ops3})
    hi(0, 'perlStatementStorage', {fg = p.blod})
    hi(0, 'perlVarPlain2', {fg = p.otag})
    hi(0, 'perlVarPlain', {fg = p.lit3})

    hi(0, 'rubySharplbgn', {fg = p.lbgn, standout=true})

    hi(0, 'diffAdded', {fg = p.ops4})
    hi(0, 'diffChanged', {fg = p.ops2})
    hi(0, 'diffLine', {fg = p.lbgn})
    hi(0, 'diffNewFile', {fg = p.dbng})
    hi(0, 'diffOldFile', {fg = p.dbng})
    hi(0, 'diffOldLine', {fg = p.dbng})
    hi(0, 'diffRemoved', {fg = p.blod})

    hi(0, 'GitGutterAdd', {fg = p.ops2})
    hi(0, 'GitGutterChangeDelete', {fg = p.blod})
    hi(0, 'GitGutterChange', {fg = p.incl})
    hi(0, 'GitGutterDelete', {fg = p.blod})

    hi(0, 'ALEErrorSignLineNR', {fg = p.darkhigh})
    hi(0, 'ALEWarningSignLineNR', {fg = p.darkhigh})

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

    hi(0, 'ExtraWhitespace', {bg = p.lit3, fg = 'NONE'})

    hi(0, 'CmpItemKindFunction', {bg = p.blod, fg = 'NONE'})
    hi(0, 'CmpItemKindInterface', {bg = p.ops3, fg = 'NONE'})
    hi(0, 'CmpItemKindKeyword', {bg = p.lit3, fg = 'NONE'})
    hi(0, 'CmpItemKindMethod', {bg = p.blod, fg = 'NONE'})
    hi(0, 'CmpItemKindProperty', {bg = p.lit3, fg = 'NONE'})
    hi(0, 'CmpItemKindVariable', {bg = p.ops3, fg = 'NONE'})
end

return M
