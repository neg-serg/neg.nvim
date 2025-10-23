local U = require('neg.util')

local colors = {
    norm='#6c7e96', -- default foreground

    bclr='#000000', -- background color hexadecimal
    dark='#121212', -- dark color
    drk2='#223f73', -- dark 2 color
    whit='#d1e5ff', -- white color

    culc='#272727', -- cursor line/column hexadecimal
    -- Base comment color is derived from default to keep relative contrast stable
    -- Placeholder; overwritten below using darken(default, 50%)
    comm='#3c4754', -- comment color (will be recalculated)

    lit1='#127978', -- literal color 1
    lit2='#148787', -- literal color 2
    lit3='#127a57', -- literal color 3
    ops1='#367cb0', -- operations color 1
    ops2='#2b7694', -- operations color 2
    ops3='#005faf', -- operations color 3
    ops4='#395573', -- operations color 4
    otag='#357b63', -- tag highlight color
    lstr='#54667a', -- literal string highlight
    incl='#005f87', -- include color
    dlim='#4779b3', -- delimiter color
    blod='#5f0000', -- bloody red

    violet='#3D005D', -- violet

    visu='#080808', -- visual highlight
    high='#a5c1e6', -- highlight color
    darkhigh='#7387a1', -- darker highlight color

    var='#7387a1', -- function highlight
    func='#7095b0', -- function highlight

    dadd='#15b22d', -- diff add
    dchg='#00406d', -- diff change
    dred='#ce162b', -- diff red
    dwarn='#e0af68', -- warning (yellow/orange)

    clin='#131e30', -- cursor line
    pmen='#6c7e96', -- pmenu color
    csel='#005faf', -- search highlight color

    cmpdef='#0c2430', -- cmp item

    iden='#6289b3', -- identifier color

    lbgn='#7095b0', -- light preprocessor color
    dbng='#506a7d', -- dark preprocessor color
    col1='#000408',
    col2='#010912',
    col3='#040f1c',
    col4='#071526',
    col5='#0c1c30',
    col6='#10233a',
    col7='#162b44',
    col8='#1c334e',
    col9='#233b58',
    col10='#2b4462',
    col11='#344d6c',
    col12='#3f5876',
    col13='#496280',
    col14='#546c8a',
    col15='#607794',
    col16='#6d839e',
    col17='#7c90a8',
    col18='#8d9eb2',
    col19='#95a7bc',
    col20='#a4b3c6',
    col21='#b7c2d0',
    col22='#bfc8d0',
    col23='#dbdfe4',
    col24='#EEEEEE',

    br1='#4064be',
    br2='#4361b0',
    br3='#455fa3',
    br4='#465e9c',
    br5='#475c94',
    br6='#485a8c',
    br7='#485885',

    dnorm='#15181f'
}

-- Derive comment/dim color from default foreground (about 50% darker)
-- This keeps comments and dimmed UI consistently toned if the base color changes.
colors.comm = U.darken(colors.norm, 50)

-- Backwards-compatible descriptive aliases
-- Base and backgrounds
colors.fg_default = colors.norm
colors.default_color = colors.norm
colors.bg_default = colors.bclr
colors.fg_dark = colors.dark
colors.dark_color = colors.dark
colors.fg_dark_secondary = colors.drk2
colors.dark_secondary_color = colors.drk2
colors.fg_white = colors.whit
colors.white_color = colors.whit
colors.bg_cursorcolumn = colors.culc
colors.fg_comment = colors.comm
colors.comment_color = colors.comm

-- Syntax categories
colors.fg_literal_1 = colors.lit1
colors.literal1_color = colors.lit1
colors.fg_literal_2 = colors.lit2
colors.literal2_color = colors.lit2
colors.fg_literal_3 = colors.lit3
colors.literal3_color = colors.lit3
colors.fg_keyword_1 = colors.ops1
colors.keyword1_color = colors.ops1
colors.fg_keyword_2 = colors.ops2
colors.keyword2_color = colors.ops2
colors.fg_keyword_3 = colors.ops3
colors.keyword3_color = colors.ops3
colors.fg_keyword_4 = colors.ops4
colors.keyword4_color = colors.ops4
colors.fg_tag = colors.otag
colors.tag_color = colors.otag
colors.fg_string = colors.lstr
colors.string_color = colors.lstr
colors.fg_include = colors.incl
colors.include_color = colors.incl
colors.fg_delimiter = colors.dlim
colors.delimiter_color = colors.dlim
colors.fg_red_blood = colors.blod
colors.red_blood_color = colors.blod
colors.fg_violet = colors.violet
colors.violet_color = colors.violet
colors.bg_visual = colors.visu
colors.fg_highlight = colors.high
colors.highlight_color = colors.high
colors.fg_highlight_dark = colors.darkhigh
colors.highlight_dark_color = colors.darkhigh
colors.fg_variable = colors.var
colors.variable_color = colors.var
colors.fg_function = colors.func
colors.function_color = colors.func

-- Diff/diagnostic
colors.fg_diff_add = colors.dadd
colors.diff_add_color = colors.dadd
colors.fg_diff_change = colors.dchg
colors.diff_change_color = colors.dchg
colors.fg_diff_delete = colors.dred
colors.diff_delete_color = colors.dred
colors.fg_warning = colors.dwarn
colors.warning_color = colors.dwarn

-- UI
colors.bg_cursorline = colors.clin
colors.fg_pmenu = colors.pmen
colors.pmenu_color = colors.pmen
colors.fg_search = colors.csel
colors.search_color = colors.csel
colors.fg_cmp_default = colors.cmpdef
colors.cmp_default_color = colors.cmpdef
colors.fg_identifier = colors.iden
colors.identifier_color = colors.iden
colors.fg_preproc_light = colors.lbgn
colors.preproc_light_color = colors.lbgn
colors.fg_preproc_dark = colors.dbng
colors.preproc_dark_color = colors.dbng

-- Shades and rainbow
colors.shade_01=colors.col1; colors.shade_02=colors.col2; colors.shade_03=colors.col3; colors.shade_04=colors.col4;
colors.shade_05=colors.col5; colors.shade_06=colors.col6; colors.shade_07=colors.col7; colors.shade_08=colors.col8;
colors.shade_09=colors.col9; colors.shade_10=colors.col10; colors.shade_11=colors.col11; colors.shade_12=colors.col12;
colors.shade_13=colors.col13; colors.shade_14=colors.col14; colors.shade_15=colors.col15; colors.shade_16=colors.col16;
colors.shade_17=colors.col17; colors.shade_18=colors.col18; colors.shade_19=colors.col19; colors.shade_20=colors.col20;
colors.shade_21=colors.col21; colors.shade_22=colors.col22; colors.shade_23=colors.col23; colors.shade_24=colors.col24;

colors.rainbow_1=colors.br1; colors.rainbow_2=colors.br2; colors.rainbow_3=colors.br3; colors.rainbow_4=colors.br4;
colors.rainbow_5=colors.br5; colors.rainbow_6=colors.br6; colors.rainbow_7=colors.br7;

-- Selection
colors.bg_selection_dim = colors.dnorm

-- Additional convenience aliases (non-breaking; map to existing hues)
-- Neutral defaults derived from base background (avoid bluish tint)
colors.bg_float = U.lighten(colors.bclr, 8)
colors.bg_panel = U.lighten(colors.bclr, 6)
colors.border_color = U.darken(colors.bclr, 10)

-- Severities and statuses
colors.error_color = colors.diff_delete_color
colors.success_color = colors.diff_add_color
colors.info_color = colors.preproc_light_color
colors.hint_color = colors.identifier_color

-- Accents (for UI flourishes)
colors.accent_primary = colors.include_color
colors.accent_secondary = colors.keyword3_color
colors.accent_tertiary = colors.keyword1_color

-- Selection (kitty-inspired defaults, optional usage)
colors.selection_bg = '#0d1824'
colors.selection_fg = '#367bbf'

return colors
