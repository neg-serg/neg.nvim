-- Name:        neg
-- Version:     3.44
-- Last Change: 21-10-2025
-- Maintainer:  Sergey Miroshnichenko <serg.zorg@gmail.com>
-- URL:         https://github.com/neg-serg/neg.nvim
-- About:       neg theme extends Jason W Ryan's miromiro(1) Vim color file
local M = {}
local hi = vim.api.nvim_set_hl
local p = require('neg.palette')

local function apply(tbl)
  for name, style in pairs(tbl) do hi(0, name, style) end
end

local function safe_apply(modname)
  local ok, tbl = pcall(require, modname)
  if ok and type(tbl) == 'table' then apply(tbl) end
end

local function flags_from(v)
  local f = {}
  if type(v) == 'string' then
    local s = v:lower()
    if s == 'none' or s == 'off' then
      f.italic=false; f.bold=false; f.underline=false; f.undercurl=false
    else
      if s:find('italic', 1, true) then f.italic=true end
      if s:find('bold', 1, true) then f.bold=true end
      if s:find('underline', 1, true) then f.underline=true end
      if s:find('undercurl', 1, true) then f.undercurl=true end
    end
  elseif type(v) == 'table' then
    for k, val in pairs(v) do if type(val) == 'boolean' then f[k]=val end end
  elseif type(v) == 'boolean' then
    f.italic = v
  end
  return f
end

local default_config = {
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = 'italic',
    keywords = 'none',
    functions = 'none',
    strings = 'none',
    variables = 'none',
  },
  plugins = {
    cmp = true,
    telescope = true,
    git = true,
    gitsigns = true,
    noice = true,
    obsidian = true,
    rainbow = true,
    headline = true,
    indent = true,
  },
  overrides = nil,
}

local function apply_transparent()
  local groups = {
    'Normal','NormalNC','NormalFloat','SignColumn','FoldColumn',
    'StatusLine','StatusLineNC','TabLine','TabLineFill','TabLineSel',
    'Pmenu'
  }
  for _, g in ipairs(groups) do hi(0, g, { bg='NONE' }) end
end

local function apply_terminal_colors()
  local colors = {
    p.bclr,   -- 0: black
    p.dred,   -- 1: red
    p.dadd,   -- 2: green
    p.dwarn,  -- 3: yellow
    p.incl,   -- 4: blue
    p.violet, -- 5: magenta
    p.lit2,   -- 6: cyan
    p.whit,   -- 7: white
  }
  for i = 0, 7 do
    vim.g['terminal_color_'..i] = colors[i+1]
    vim.g['terminal_color_'..(i+8)] = colors[i+1]
  end
end

local function apply_styles(styles)
  local map = {
    comments = { 'Comment','SpecialComment' },
    keywords = { 'Keyword','Statement','Conditional','Repeat','Label','Operator','PreProc','Include','Define','Macro','PreCondit','Type','StorageClass','Structure','Typedef' },
    functions = { 'Function' },
    strings = { 'String','SpecialChar' },
    variables = { 'Identifier' },
  }
  for key, groups in pairs(map) do
    local flags = flags_from(styles[key])
    if next(flags) ~= nil then
      for _, g in ipairs(groups) do hi(0, g, flags) end
    end
  end
  -- Plugin-adjacent styles (best-effort)
  local fn_flags = flags_from(styles.functions)
  if next(fn_flags) ~= nil then
    for _, g in ipairs({ 'CmpItemKindFunction','CmpItemKindMethod' }) do hi(0, g, fn_flags) end
  end
end

local function apply_overrides(overrides)
  if not overrides then return end
  local tbl = overrides
  if type(overrides) == 'function' then
    local ok, res = pcall(overrides, p)
    if ok and type(res) == 'table' then tbl = res else return end
  end
  if type(tbl) == 'table' then apply(tbl) end
end

function M.setup(opts)
  local cfg
  if type(opts) == 'table' and next(opts) ~= nil then
    cfg = vim.tbl_deep_extend('force', default_config, opts)
  else
    cfg = M._config or default_config
  end
  M._config = cfg

  -- Core groups
  apply(require('neg.groups.syntax'))
  apply(require('neg.groups.editor'))
  apply(require('neg.groups.diagnostics'))
  apply(require('neg.groups.lsp'))
  apply(require('neg.groups.treesitter'))

  -- Plugins (toggleable)
  for key, mod in pairs({
    cmp = 'neg.groups.plugins.cmp',
    telescope = 'neg.groups.plugins.telescope',
    git = 'neg.groups.plugins.git',
    gitsigns = 'neg.groups.plugins.gitsigns',
    noice = 'neg.groups.plugins.noice',
    obsidian = 'neg.groups.plugins.obsidian',
    rainbow = 'neg.groups.plugins.rainbow',
    headline = 'neg.groups.plugins.headline',
    indent = 'neg.groups.plugins.indent',
  }) do
    if cfg.plugins[key] ~= false then safe_apply(mod) end
  end

  -- Post-processing
  if cfg.transparent then apply_transparent() end
  if cfg.terminal_colors then apply_terminal_colors() end
  apply_styles(cfg.styles)
  apply_overrides(cfg.overrides)
end

return M
