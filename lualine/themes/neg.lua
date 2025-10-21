local M = {}
local p = require('neg.palette')

local bg = p.bclr
local fg = p.norm

M.normal = {
  a = { fg = p.dark, bg = p.ops3, gui = 'bold' },
  b = { fg = fg, bg = p.clin },
  c = { fg = fg, bg = bg },
}

M.insert = {
  a = { fg = p.dark, bg = p.lit2, gui = 'bold' },
  b = { fg = fg, bg = p.clin },
  c = { fg = fg, bg = bg },
}

M.visual = {
  a = { fg = p.dark, bg = p.violet, gui = 'bold' },
  b = { fg = fg, bg = p.clin },
  c = { fg = fg, bg = bg },
}

M.replace = {
  a = { fg = p.dark, bg = p.blod, gui = 'bold' },
  b = { fg = fg, bg = p.clin },
  c = { fg = fg, bg = bg },
}

M.command = {
  a = { fg = p.dark, bg = p.lbgn, gui = 'bold' },
  b = { fg = fg, bg = p.clin },
  c = { fg = fg, bg = bg },
}

M.inactive = {
  a = { fg = p.comm, bg = bg },
  b = { fg = p.comm, bg = bg },
  c = { fg = p.comm, bg = bg },
}

return M

