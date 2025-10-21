local M = {}
local p = require('neg.palette')

local bg = p.bg_default
local fg = p.fg_default

M.normal = {
  a = { fg = p.fg_dark, bg = p.fg_keyword_3, gui = 'bold' },
  b = { fg = fg, bg = p.clin },
  c = { fg = fg, bg = bg },
}

M.insert = {
  a = { fg = p.fg_dark, bg = p.fg_literal_2, gui = 'bold' },
  b = { fg = fg, bg = p.clin },
  c = { fg = fg, bg = bg },
}

M.visual = {
  a = { fg = p.fg_dark, bg = p.fg_violet, gui = 'bold' },
  b = { fg = fg, bg = p.clin },
  c = { fg = fg, bg = bg },
}

M.replace = {
  a = { fg = p.fg_dark, bg = p.fg_red_blood, gui = 'bold' },
  b = { fg = fg, bg = p.clin },
  c = { fg = fg, bg = bg },
}

M.command = {
  a = { fg = p.fg_dark, bg = p.fg_preproc_light, gui = 'bold' },
  b = { fg = fg, bg = p.clin },
  c = { fg = fg, bg = bg },
}

M.inactive = {
  a = { fg = p.comm, bg = bg },
  b = { fg = p.comm, bg = bg },
  c = { fg = p.comm, bg = bg },
}

return M
