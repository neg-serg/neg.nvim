-- Name:        neg
-- Version:     3.82
-- Last Change: 22-10-2025
-- Maintainer:  Sergey Miroshnichenko <serg.zorg@gmail.com>
-- URL:         https://github.com/neg-serg/neg.nvim
-- About:       neg theme extends Jason W Ryan's miromiro(1) Vim color file
local M = {}
local hi = vim.api.nvim_set_hl
local p = require('neg.palette')
local U = require('neg.util')
-- Forward declaration so M.setup can call it
local define_commands
local commands_defined = false
local autocmds_defined = false

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
    -- additional supported plugins
    alpha = true,
    startify = true,
    mini_statusline = true,
    mini_tabline = true,
    todo_comments = true,
    navic = true,
    lspsaga = true,
    navbuddy = true,
    neotest = true,
    harpoon = true,
    treesitter_playground = true,
    overseer = true,
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
  diagnostics_virtual_bg_mode = 'blend',   -- 'blend' | 'alpha' | 'lighten' | 'darken'
  diagnostics_virtual_bg_strength = 0.15,  -- 0..1 for alpha/lighten/darken strength
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
    do
      local base = (U.get_hl_colors and U.get_hl_colors('Title')) or {}
      local spec = { bold = true }
      if base.fg then spec.fg = base.fg end
      if base.bg then spec.bg = base.bg end
      if base.sp then spec.sp = base.sp end
      hi(0, 'Title', spec)
    end
  elseif preset == 'pro' then
    -- no italics anywhere
    s.comments = 'none'
    -- try to neutralize commonly italic things
    for _, g in ipairs({ 'LspInlayHint','LspCodeLens','@markup.italic' }) do
      local base = (U.get_hl_colors and U.get_hl_colors(g)) or {}
      local spec = { italic = false }
      if base.fg then spec.fg = base.fg end
      if base.bg then spec.bg = base.bg end
      if base.sp then spec.sp = base.sp end
      hi(0, g, spec)
    end
  elseif preset == 'writing' then
    -- emphasize markdown/markup
    for g, spec in pairs({
      ['Title'] = { bold = true },
      ['@markup.heading'] = { bold = true },
      ['@markup.strong'] = { bold = true },
      ['@markup.italic'] = { italic = true },
    }) do
      local base = (U.get_hl_colors and U.get_hl_colors(g)) or {}
      if base.fg then spec.fg = base.fg end
      if base.bg then spec.bg = base.bg end
      if base.sp then spec.sp = base.sp end
      hi(0, g, spec)
    end
  end
end

local function apply_terminal_colors() U.apply_terminal_colors(p) end

local function apply_diagnostics_virtual_bg(cfg)
  local map = {
    DiagnosticVirtualTextError = p.diff_delete_color,
    DiagnosticVirtualTextWarn  = p.warning_color,
    DiagnosticVirtualTextInfo  = p.preproc_light_color,
    DiagnosticVirtualTextHint  = p.identifier_color,
    DiagnosticVirtualTextOk    = p.diff_add_color,
  }
  local mode = (cfg and cfg.diagnostics_virtual_bg_mode) or 'blend'
  local strength = (cfg and cfg.diagnostics_virtual_bg_strength) or 0.15
  local function apply_bg(g, col, extra)
    local base = (U.get_hl_colors and U.get_hl_colors(g)) or {}
    local spec = { bg = col }
    if base.fg then spec.fg = base.fg end
    if base.sp then spec.sp = base.sp end
    if type(extra) == 'table' then for k, v in pairs(extra) do spec[k] = v end end
    hi(0, g, spec)
  end
  if mode == 'blend' then
    for g, col in pairs(map) do
      apply_bg(g, col, { blend = cfg and cfg.diagnostics_virtual_bg_blend or 15 })
    end
  elseif mode == 'alpha' then
    for g, col in pairs(map) do
      local bg = U.alpha(col, p.bg_default, strength)
      apply_bg(g, bg)
    end
  elseif mode == 'lighten' then
    for g, col in pairs(map) do
      local bg = U.lighten(col, strength * 100)
      apply_bg(g, bg)
    end
  elseif mode == 'darken' then
    for g, col in pairs(map) do
      local bg = U.darken(col, strength * 100)
      apply_bg(g, bg)
    end
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
      for _, g in ipairs(groups) do
        local base = (U.get_hl_colors and U.get_hl_colors(g)) or {}
        local spec = {}
        if base.fg then spec.fg = base.fg end
        if base.bg then spec.bg = base.bg end
        if base.sp then spec.sp = base.sp end
        for k, v in pairs(flags) do spec[k] = v end
        hi(0, g, spec)
      end
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
  local force_apply = false
  if type(opts) == 'table' and opts.force ~= nil then force_apply = opts.force and true or false end
  if cfg.force ~= nil then cfg.force = nil end
  M._config = cfg

  -- Idempotent apply: skip if no changes and no function overrides
  if not force_apply and M._applied_key and type(cfg.overrides) ~= 'function' then
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
    alpha = 'neg.groups.plugins.alpha',
    startify = 'neg.groups.plugins.startify',
    mini_statusline = 'neg.groups.plugins.mini_statusline',
    mini_tabline = 'neg.groups.plugins.mini_tabline',
    todo_comments = 'neg.groups.plugins.todo_comments',
    navic = 'neg.groups.plugins.navic',
    lspsaga = 'neg.groups.plugins.lspsaga',
    navbuddy = 'neg.groups.plugins.navbuddy',
    neotest = 'neg.groups.plugins.neotest',
    harpoon = 'neg.groups.plugins.harpoon',
    treesitter_playground = 'neg.groups.plugins.treesitter_playground',
    overseer = 'neg.groups.plugins.overseer',
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
  if cfg.diagnostics_virtual_bg then apply_diagnostics_virtual_bg(cfg) end
  define_commands()
  if not autocmds_defined then
    autocmds_defined = true
    -- Re-apply once after plugins/UI are ready, to defeat late overrides
    pcall(function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        once = true,
        callback = function()
          if vim.g.colors_name == 'neg' then M.setup({ force = true }) end
        end,
      })
      -- If someone calls :colorscheme neg again, ensure we apply with current config
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function(args)
          if args.match == 'neg' then M.setup({ force = true }) end
        end,
      })
      -- Ensure final pass at VimEnter when everything is loaded
      vim.api.nvim_create_autocmd('VimEnter', {
        once = true,
        callback = function()
          if vim.g.colors_name == 'neg' then M.setup({ force = true }) end
        end,
      })
    end)
  end
  M._applied_key = U.config_signature(cfg)
end

-- User commands
define_commands = function()
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
    local msg = (
      'neg.nvim' ..
      '\ntransparent: %s' ..
      '\nterminal_colors: %s' ..
      '\ndiag_bg: %s' ..
      '\n   mode: %s' ..
      '\n   strength: %s' ..
      '\n   blend: %s' ..
      '\nplugins: %s'
    ):format(
      tostring(cfg.transparent),
      tostring(cfg.terminal_colors),
      tostring(cfg.diagnostics_virtual_bg),
      tostring(cfg.diagnostics_virtual_bg_mode),
      tostring(cfg.diagnostics_virtual_bg_strength),
      tostring(cfg.diagnostics_virtual_bg_blend),
      vim.inspect(cfg.plugins)
    )
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

  vim.api.nvim_create_user_command('NegDiagBgMode', function(opts)
    local mode = (opts.args or ''):lower()
    local allowed = { blend=true, alpha=true, lighten=true, darken=true, off=true, on=true }
    if not allowed[mode] then
      print("neg.nvim: unknown mode '" .. mode .. "'. Use: blend|alpha|lighten|darken|off|on")
      return
    end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    if mode == 'off' then
      newcfg.diagnostics_virtual_bg = false
    else
      newcfg.diagnostics_virtual_bg = true
      if mode ~= 'on' then newcfg.diagnostics_virtual_bg_mode = mode end
    end
    M.setup(newcfg)
  end, {
    nargs = 1,
    complete = function()
      return { 'blend', 'alpha', 'lighten', 'darken', 'off', 'on' }
    end,
    desc = 'neg.nvim: Set diagnostics virtual text background mode'
  })

  vim.api.nvim_create_user_command('NegDiagBgStrength', function(opts)
    local v = tonumber(opts.args)
    if not v then
      print("neg.nvim: strength must be a number in 0..1")
      return
    end
    if v < 0 then v = 0 end
    if v > 1 then v = 1 end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.diagnostics_virtual_bg_strength = v
    M.setup(newcfg)
  end, {
    nargs = 1,
    desc = 'neg.nvim: Set diagnostics bg strength (0..1) for alpha/lighten/darken modes'
  })

  vim.api.nvim_create_user_command('NegDiagBgBlend', function(opts)
    local v = tonumber(opts.args)
    if not v then
      print("neg.nvim: blend must be a number in 0..100")
      return
    end
    if v < 0 then v = 0 end
    if v > 100 then v = 100 end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.diagnostics_virtual_bg_blend = v
    M.setup(newcfg)
  end, {
    nargs = 1,
    desc = 'neg.nvim: Set diagnostics bg blend (0..100) when mode=blend'
  })
end

return M
