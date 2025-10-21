local p = require('neg.palette')

-- folke/todo-comments.nvim
return {
  TodoError       = { fg = p.default_color, bg = p.diff_delete_color },
  TodoWarn        = { fg = p.dark_color,   bg = p.warning_color },
  TodoInfo        = { fg = p.dark_color,   bg = p.preproc_light_color },
  TodoHint        = { fg = p.dark_color,   bg = p.identifier_color },
  TodoDeprecated  = { fg = p.dark_color,   bg = p.comment_color, strikethrough = true },
  TodoOk          = { fg = p.dark_color,   bg = p.diff_add_color },
}

