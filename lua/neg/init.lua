-- Name:        neg
-- Version:     3.32
-- Last Change: 21-10-2025
-- Maintainer:  Sergey Miroshnichenko <serg.zorg@gmail.com>
-- URL:         https://github.com/neg-serg/neg.nvim
-- About:       neg theme extends Jason W Ryan's miromiro(1) Vim color file
local M = {}
local hi = vim.api.nvim_set_hl
local function apply(tbl)
  for name, style in pairs(tbl) do hi(0, name, style) end
end

function M.setup()
  -- Core groups
  apply(require('neg.groups.syntax'))
  apply(require('neg.groups.editor'))
  apply(require('neg.groups.diagnostics'))
  apply(require('neg.groups.treesitter'))

  -- Plugins
  apply(require('neg.groups.plugins.cmp'))
  apply(require('neg.groups.plugins.telescope'))
  apply(require('neg.groups.plugins.git'))
  apply(require('neg.groups.plugins.noice'))
  apply(require('neg.groups.plugins.obsidian'))
  apply(require('neg.groups.plugins.rainbow'))
  apply(require('neg.groups.plugins.headline'))
end

return M
