local M = {}
local p = require('neg.palette')

local bg = p.bg_default
local fg = p.default_color

M.normal = {
  a = { fg = p.dark_color, bg = p.keyword3_color, gui = 'bold' },
  b = { fg = fg, bg = p.bg_cursorline },
  c = { fg = fg, bg = bg },
}

M.insert = {
  a = { fg = p.dark_color, bg = p.literal2_color, gui = 'bold' },
  b = { fg = fg, bg = p.bg_cursorline },
  c = { fg = fg, bg = bg },
}

M.visual = {
  a = { fg = p.dark_color, bg = p.violet_color, gui = 'bold' },
  b = { fg = fg, bg = p.bg_cursorline },
  c = { fg = fg, bg = bg },
}

M.replace = {
  a = { fg = p.dark_color, bg = p.red_blood_color, gui = 'bold' },
  b = { fg = fg, bg = p.bg_cursorline },
  c = { fg = fg, bg = bg },
}

M.command = {
  a = { fg = p.dark_color, bg = p.preproc_light_color, gui = 'bold' },
  b = { fg = fg, bg = p.bg_cursorline },
  c = { fg = fg, bg = bg },
}

M.inactive = {
  a = { fg = p.comment_color, bg = bg },
  b = { fg = p.comment_color, bg = bg },
  c = { fg = p.comment_color, bg = bg },
}

return M
