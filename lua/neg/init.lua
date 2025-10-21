-- Name:        neg
-- Version:     3.60
-- Last Change: 21-10-2025
-- Maintainer:  Sergey Miroshnichenko <serg.zorg@gmail.com>
-- URL:         https://github.com/neg-serg/neg.nvim
-- About:       neg theme extends Jason W Ryan's miromiro(1) Vim color file
local M = {}
local hi = vim.api.nvim_set_hl
local p = require('neg.palette')
local U = require('neg.util')

local function apply(tbl)
  for name, style in pairs(tbl) do hi(0, name, style) end
end

local function safe_apply(modname)
  local ok, tbl = pcall(require, modname)
  if ok and type(tbl) == 'table' then apply(tbl) end
end

local flags_from = U.flags_from

local default_config = {
  transparent = false,
  terminal_colors = true,
  preset = nil, -- one of: 'soft', 'hard', 'pro', 'writing'
  styles = {
    comments = 'italic',
    keywords = 'none',
    functions = 'none',
    strings = 'none',
    variables = 'none',
    types = 'none',
    operators = 'none',
    numbers = 'none',
    booleans = 'none',
    constants = 'none',
    punctuation = 'none',
  },
  plugins = {
    cmp = true,
    telescope = true,
    git = true,
    gitsigns = true,
    bufferline = true,
    noice = true,
    obsidian = true,
    rainbow = true,
    headline = true,
    indent = true,
    which_key = true,
    nvim_tree = false,
    neo_tree = true,
    dap = true,
    dapui = true,
    trouble = true,
    notify = true,
    treesitter_context = true,
    hop = true,
  },
  overrides = nil,
  diagnostics_virtual_bg = false,
  diagnostics_virtual_bg_blend = 15,
}

local apply_transparent = function(cfg) return U.apply_transparent(cfg) end

local function apply_preset(preset, cfg)
  if not preset or preset == '' then return end
  preset = tostring(preset):lower()
  local s = cfg.styles or {}
  if preset == 'soft' then
    -- keep defaults: subtle, with italic comments
  elseif preset == 'hard' then
    s.keywords = s.keywords ~= 'none' and s.keywords or 'bold'
    s.functions = s.functions ~= 'none' and s.functions or 'bold'
    s.types = s.types ~= 'none' and s.types or 'bold'
    s.constants = s.constants ~= 'none' and s.constants or 'bold'
    s.booleans = s.booleans ~= 'none' and s.booleans or 'bold'
    s.numbers = s.numbers ~= 'none' and s.numbers or 'bold'
    hi(0, 'Title', { bold = true })
  elseif preset == 'pro' then
    -- no italics anywhere
    s.comments = 'none'
    -- try to neutralize commonly italic things
    hi(0, 'LspInlayHint', { italic = false })
    hi(0, 'LspCodeLens', { italic = false })
    hi(0, '@markup.italic', { italic = false })
  elseif preset == 'writing' then
    -- emphasize markdown/markup
    hi(0, 'Title', { bold = true })
    hi(0, '@markup.heading', { bold = true })
    hi(0, '@markup.strong', { bold = true })
    hi(0, '@markup.italic', { italic = true })
  end
end

local function apply_terminal_colors() U.apply_terminal_colors(p) end

local function apply_diagnostics_virtual_bg(blend)
  local map = {
    DiagnosticVirtualTextError = p.dred,
    DiagnosticVirtualTextWarn  = p.dwarn,
    DiagnosticVirtualTextInfo  = p.lbgn,
    DiagnosticVirtualTextHint  = p.iden,
    DiagnosticVirtualTextOk    = p.dadd,
  }
  for g, col in pairs(map) do
    hi(0, g, { bg = col, blend = blend or 15 })
  end
end

local function apply_styles(styles)
  local map = {
    comments = { 'Comment','SpecialComment' },
    keywords = { 'Keyword','Statement','Conditional','Repeat','Label','PreProc','Include','Define','Macro','PreCondit' },
    functions = { 'Function' },
    strings = { 'String','SpecialChar' },
    variables = { 'Identifier' },
    types = { 'Type','StorageClass','Structure','Typedef' },
    operators = { 'Operator' },
    numbers = { 'Number' },
    booleans = { 'Boolean' },
    constants = { 'Constant' },
    punctuation = { 'Delimiter' },
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

local function apply_overrides(overrides) U.apply_overrides(overrides, p) end

function M.setup(opts)
  local cfg
  if type(opts) == 'table' and next(opts) ~= nil then
    cfg = vim.tbl_deep_extend('force', default_config, opts)
  else
    cfg = M._config or default_config
  end
  M._config = cfg

  -- Idempotent apply: skip if no changes and no function overrides
  if M._applied_key and type(cfg.overrides) ~= 'function' then
    local key = U.config_signature(cfg)
    if vim.deep_equal(key, M._applied_key) then return end
  end

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
    bufferline = 'neg.groups.plugins.bufferline',
    noice = 'neg.groups.plugins.noice',
    obsidian = 'neg.groups.plugins.obsidian',
    rainbow = 'neg.groups.plugins.rainbow',
    headline = 'neg.groups.plugins.headline',
    indent = 'neg.groups.plugins.indent',
    which_key = 'neg.groups.plugins.which_key',
    nvim_tree = 'neg.groups.plugins.nvim_tree',
    neo_tree = 'neg.groups.plugins.neo_tree',
    dap = 'neg.groups.plugins.dap',
    dapui = 'neg.groups.plugins.dapui',
    trouble = 'neg.groups.plugins.trouble',
    notify = 'neg.groups.plugins.notify',
    treesitter_context = 'neg.groups.plugins.treesitter_context',
    hop = 'neg.groups.plugins.hop',
  }) do
    if cfg.plugins[key] ~= false then safe_apply(mod) end
  end

  -- Post-processing
  if cfg.transparent then apply_transparent(cfg.transparent) end
  if cfg.terminal_colors then apply_terminal_colors() end
  apply_styles(cfg.styles)
  apply_preset(cfg.preset, cfg)
  apply_overrides(cfg.overrides)
  if cfg.diagnostics_virtual_bg then apply_diagnostics_virtual_bg(cfg.diagnostics_virtual_bg_blend) end
  define_commands()
  M._applied_key = U.config_signature(cfg)
end

-- User commands
local commands_defined = false
local function define_commands()
  if commands_defined then return end
  commands_defined = true
  vim.api.nvim_create_user_command('NegToggleTransparent', function()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.transparent = not (cfg.transparent == true)
    M.setup(newcfg)
  end, { desc = 'neg.nvim: Toggle transparent backgrounds' })

  vim.api.nvim_create_user_command('NegReload', function()
    M.setup(M._config or default_config)
  end, { desc = 'neg.nvim: Reload highlights with current config' })

  vim.api.nvim_create_user_command('NegInfo', function()
    local cfg = M._config or default_config
    local ok_notify, _ = pcall(require, 'notify')
    local msg = ('neg.nvim\ntransparent: %s\nterminal_colors: %s\nplugins: %s')
      :format(tostring(cfg.transparent), tostring(cfg.terminal_colors), vim.inspect(cfg.plugins))
    if ok_notify and vim.notify then vim.notify(msg) else print(msg) end
  end, { desc = 'neg.nvim: Show current config' })

  vim.api.nvim_create_user_command('NegToggleTransparentZone', function(opts)
    local zone = (opts.args or ''):lower()
    if zone ~= 'float' and zone ~= 'sidebar' and zone ~= 'statusline' then
      print("neg.nvim: unknown zone '" .. zone .. "'. Use: float|sidebar|statusline")
      return
    end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    local t = newcfg.transparent
    if t == true then
      t = { float = true, sidebar = true, statusline = true }
    elseif t == false or t == nil then
      t = { float = false, sidebar = false, statusline = false }
    elseif type(t) ~= 'table' then
      t = { float = false, sidebar = false, statusline = false }
    end
    t[zone] = not t[zone]
    newcfg.transparent = t
    M.setup(newcfg)
  end, {
    nargs = 1,
    complete = function()
      return { 'float', 'sidebar', 'statusline' }
    end,
    desc = 'neg.nvim: Toggle transparent zone (float|sidebar|statusline)'
  })

  vim.api.nvim_create_user_command('NegPreset', function(opts)
    local preset = (opts.args or ''):lower()
    local allowed = { soft=true, hard=true, pro=true, writing=true, none=true }
    if not allowed[preset] then
      print("neg.nvim: unknown preset '" .. preset .. "'. Use: soft|hard|pro|writing|none")
      return
    end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    if preset == 'none' then preset = nil end
    newcfg.preset = preset
    M.setup(newcfg)
  end, {
    nargs = 1,
    complete = function()
      return { 'soft', 'hard', 'pro', 'writing', 'none' }
    end,
    desc = 'neg.nvim: Apply style preset (soft|hard|pro|writing|none)'
  })
end

return M
