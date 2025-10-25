-- Name:        neg
-- Version:     4.67
-- Last Change: 25-10-2025
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
M._scenarios = M._scenarios or {}

local function deepcopy_tbl(t)
  return vim.deepcopy(t)
end

local function pick_scenario_fields(cfg)
  local out = {
    saturation = cfg.saturation,
    alpha_overlay = cfg.alpha_overlay,
    transparent = cfg.transparent,
    terminal_colors = cfg.terminal_colors,
    preset = cfg.preset,
    operator_colors = cfg.operator_colors,
    number_colors = cfg.number_colors,
    styles = cfg.styles,
    treesitter = cfg.treesitter,
    ui = cfg.ui,
    diagnostics_virtual_bg = cfg.diagnostics_virtual_bg,
    diagnostics_virtual_bg_blend = cfg.diagnostics_virtual_bg_blend,
    diagnostics_virtual_bg_mode = cfg.diagnostics_virtual_bg_mode,
    diagnostics_virtual_bg_strength = cfg.diagnostics_virtual_bg_strength,
  }
  return deepcopy_tbl(out)
end

local function apply_scenario_tbl(tbl, mode)
  local cfg = M._config or default_config
  local newcfg
  if mode == 'replace' then
    -- Start from current config to preserve plugin flags; override with scenario
    newcfg = vim.tbl_deep_extend('force', deepcopy_tbl(cfg), tbl)
  else
    -- merge (default)
    newcfg = vim.tbl_deep_extend('force', deepcopy_tbl(cfg), tbl)
  end
  M.setup(newcfg)
end

local function default_scenarios_path()
  local ok, stdpath = pcall(vim.fn.stdpath, 'config')
  local base = ok and stdpath or '.'
  return (base .. '/neg/scenarios.json')
end

local function apply(tbl)
  for name, style in pairs(tbl) do hi(0, name, style) end
end

local function safe_apply(modname)
  local ok, tbl = pcall(require, modname)
  if ok and type(tbl) == 'table' then apply(tbl) end
end

local flags_from = U.flags_from

-- Invalidate cached group modules so they recompute with the current palette
local function invalidate_group_modules()
  local loaded = package.loaded or {}
  for name, _ in pairs(loaded) do
    if type(name) == 'string' and name:match('^neg%.groups') then
      package.loaded[name] = nil
    end
  end
end

  local default_config = {
    -- Global saturation scale (0..100). 100 = original palette, 0 = grayscale.
    saturation = 100,
    -- Global soft backgrounds alpha (0..30). Controls subtle bg fill on Search/CurSearch/Visual and DiagnosticVirtualText* overlays.
    alpha_overlay = 0,
    transparent = false,
    terminal_colors = true,
  preset = nil, -- one of: 'soft', 'hard', 'pro', 'writing', 'accessibility', 'focus', 'presentation'
    -- Operators coloring: 'families' (different subtle hues per family),
    -- 'mono' (single color), or 'mono+' (single color with a slightly stronger accent)
    operator_colors = 'families',
  -- Number coloring: 'mono' (single hue) or ramp presets for subtle single‑hue variants:
  -- 'ramp' (balanced), 'ramp-soft', 'ramp-balanced', 'ramp-strong'
  number_colors = 'ramp',
    -- UI options
    ui = {
      -- When true, define extra baseline UI groups missing in stock setup
      -- (Whitespace, EndOfBuffer, PmenuMatch*, FloatShadow*, Cursor*, VisualNOS, LineNrAbove/Below, Question)
      core_enhancements = true,
      -- Dim inactive windows (NormalNC/WinBarNC) and line numbers via winhighlight mapping
      dim_inactive = false,
      -- Mode-aware accents for CursorLine/StatusLine by Vim mode (Normal/Insert/Visual)
      mode_accent = true,
      -- Focus caret: if overall contrast is low, slightly boost CursorLine visibility
      focus_caret = true,
      -- Soft borders: lighten WinSeparator/FloatBorder to reduce visual noise
      soft_borders = false,
      -- Float background model: when true, use a slightly lighter panel-like bg for NormalFloat
      float_panel_bg = false,
      -- Auto-tune float/panel backgrounds when terminal background is transparent
      auto_transparent_panels = true,
      -- Diff focus: stronger Diff* backgrounds when any window is in :diff mode
      diff_focus = true,
      -- Light signs: soften sign icons (DiagnosticSign*, GitSigns*) without changing their hue
      light_signs = false,
      -- Accessibility options (independent toggles)
      accessibility = {
        deuteranopia = false,      -- shift additions to blue‑ish hue; keep warnings distinct
        achromatopsia = false,     -- monochrome/high-contrast assist: reduce reliance on hue
        hc = 'off',                -- high-contrast pack for achromatopsia: 'off' | 'soft' | 'strong'
      },
      -- Diagnostics pattern presets: 'none' | 'minimal' | 'strong'
      diag_pattern = 'none',
      -- Lexeme cues: 'off' | 'minimal' | 'strong' (underline for functions; underline+bold for types)
      lexeme_cues = 'off',
      -- Thick cursor/selection in TUI
      thick_cursor = false,
      -- Window/float outlines (active vs inactive)
      outlines = false,
      -- Reading mode: near-monochrome syntax with clearer structure
      reading_mode = false,
      -- Search visibility preset: 'default' | 'soft' | 'strong'
      search_visibility = 'default',
      -- Screenreader friendly: reduce dynamic accents and colored backgrounds
      screenreader_friendly = false,
      -- Enhanced accents for Telescope (matching/selection/borders)
      telescope_accents = true,
      -- Path separator tint (non-Telescope): when true, color path separators in a kitty-like blue
      path_separator_blue = false,
      -- Optional color override for path separators: '#rrggbb' or palette key (e.g. 'include_color').
      -- Applies only when path_separator_blue = true; when nil, uses include_color.
      path_separator_color = nil,
      -- Selection model: 'default' (theme) or 'kitty' (match kitty selection colors)
      selection_model = 'kitty',
    },
    treesitter = {
      -- When true, apply subtle extra captures (math/environment, string.template,
      -- boolean true/false, nil/null, decorator/annotation, declaration/static/abstract links)
      extras = true,
      -- Punctuation family differentiation (parenthesis/brace vs bracket)
      punct_family = false,
    },
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
  -- Optional fine-grained markup preferences
  -- Set to false to disable, or provide a table to override defaults.
  -- Example:
  -- markup = {
  --   headings = { h1 = '#ff8800', h2 = '#ffaa00' },
  --   lists = { checked = '#00aa88' },
  -- }
  markup = nil,
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
    -- phase 1 additions
    diffview = true,
    fidget = true,
    toggleterm = true,
    dashboard = true,
    heirline = true,
    oil = true,
    blink = true,
    leap = true,
    flash = true,
    ufo = true,
    bqf = true,
    -- phase 2 additions
    glance = true,
    barbecue = true,
    illuminate = true,
    hlslens = true,
    virt_column = true,
    dap_virtual_text = true,
    mini_pick = true,
    snacks = true,
    fzf_lua = true,
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
  elseif preset == 'accessibility' then
    -- higher contrast, minimal italics, stronger lines/numbers
    s.comments = 'none'
    -- disable soft virtual backgrounds for diagnostics for clarity
    if cfg then cfg.diagnostics_virtual_bg = false end
    -- Lines and numbers
    hi(0, 'LineNr', { fg = p.white_color, bold = true, italic = false })
    do
      local base = (U.get_hl_colors and U.get_hl_colors('CursorLineNr')) or {}
      local spec = { fg = p.white_color, bold = true, italic = false }
      if base.bg then spec.bg = base.bg end
      hi(0, 'CursorLineNr', spec)
    end
    -- Stronger separators/borders
    hi(0, 'VertSplit', { fg = p.border_color })
    hi(0, 'WinSeparator', { fg = p.border_color })
    -- Clear, slightly darker line/column backgrounds
    hi(0, 'CursorLine', { bg = U.darken(p.bg_default, 8) })
    hi(0, 'ColorColumn', { bg = U.darken(p.bg_default, 12) })
    -- Selection more visible (no bold noise)
    hi(0, 'Visual', { bg = U.darken(p.bg_default, 16) })
  elseif preset == 'focus' then
    if cfg then
      cfg.ui = cfg.ui or {}
      cfg.ui.dim_inactive = true
      cfg.ui.soft_borders = true
    end
    -- Dim inactive windows; soften separators
    do
      local base = (U.get_hl_colors and U.get_hl_colors('NormalNC')) or {}
      local spec = { fg = p.comment_color, bg = U.darken(p.bg_default, 8) }
      if base.bg and base.bg ~= '' and base.bg ~= 'NONE' then spec.bg = U.darken(base.bg, 6) end
      hi(0, 'NormalNC', spec)
    end
    hi(0, 'WinBarNC', { fg = p.comment_color })
    local soft_sep = U.darken(p.bg_default, 10)
    hi(0, 'VertSplit', { fg = soft_sep })
    hi(0, 'WinSeparator', { fg = soft_sep })
  elseif preset == 'presentation' then
    -- Brighter accents; emphasize cursor line and its number
    do
      local base = (U.get_hl_colors and U.get_hl_colors('CursorLine')) or {}
      local spec = { bg = U.darken(p.bg_default, 10) }
      if base.bg and base.bg ~= '' and base.bg ~= 'NONE' then spec.bg = U.darken(base.bg, 6) end
      hi(0, 'CursorLine', spec)
    end
    do
      local base = (U.get_hl_colors and U.get_hl_colors('CursorLineNr')) or {}
      local spec = { fg = p.keyword3_color, bold = true, italic = false }
      if base.bg then spec.bg = base.bg end
      hi(0, 'CursorLineNr', spec)
    end
    -- Slightly stronger Title and Search accents
    do
      local base = (U.get_hl_colors and U.get_hl_colors('Title')) or {}
      local spec = { bold = true }
      if base.fg then spec.fg = base.fg end
      if base.bg then spec.bg = base.bg end
      hi(0, 'Title', spec)
    end
    do
      local base = (U.get_hl_colors and U.get_hl_colors('Search')) or {}
      local spec = { italic = false, underline = true, fg = base.fg or p.search_color, bg = base.bg }
      hi(0, 'Search', spec)
      local base2 = (U.get_hl_colors and U.get_hl_colors('CurSearch')) or {}
      local spec2 = { bold = true, italic = false, fg = base2.fg or p.search_color, bg = base2.bg }
      hi(0, 'CurSearch', spec2)
    end
  end
end

local function apply_terminal_colors() U.apply_terminal_colors(p) end

-- Global saturation control: adjust all palette hex colors via HSL scaling
local function set_palette_saturation(percent)
  local v = tonumber(percent) or 100
  if v < 0 then v = 0 end
  if v > 100 then v = 100 end
  -- Keep a pristine copy of the palette for idempotent transforms
  if not M._palette_base then M._palette_base = vim.deepcopy(p) end
  local base = M._palette_base
  local function is_hex(s)
    return type(s) == 'string' and s:match('^#%x%x%x%x%x%x$') ~= nil
  end
  local function hex_to_rgb(hex)
    return tonumber(hex:sub(2,3),16), tonumber(hex:sub(4,5),16), tonumber(hex:sub(6,7),16)
  end
  local function rgb_to_hsl(r, g, b)
    r, g, b = r/255, g/255, b/255
    local max = math.max(r,g,b); local min = math.min(r,g,b)
    local h, s, l
    l = (max + min) / 2
    if max == min then
      h, s = 0, 0
    else
      local d = max - min
      s = d / (1 - math.abs(2*l - 1))
      if max == r then
        h = ((g - b) / d) % 6
      elseif max == g then
        h = ((b - r) / d) + 2
      else
        h = ((r - g) / d) + 4
      end
      h = h * 60
      if h < 0 then h = h + 360 end
    end
    return h, s, l
  end
  local function hsl_to_rgb(h, s, l)
    local c = (1 - math.abs(2*l - 1)) * s
    local x = c * (1 - math.abs(((h/60) % 2) - 1))
    local m = l - c/2
    local r1, g1, b1
    if h < 60 then r1, g1, b1 = c, x, 0
    elseif h < 120 then r1, g1, b1 = x, c, 0
    elseif h < 180 then r1, g1, b1 = 0, c, x
    elseif h < 240 then r1, g1, b1 = 0, x, c
    elseif h < 300 then r1, g1, b1 = x, 0, c
    else r1, g1, b1 = c, 0, x end
    local r = math.floor((r1 + m) * 255 + 0.5)
    local g = math.floor((g1 + m) * 255 + 0.5)
    local b = math.floor((b1 + m) * 255 + 0.5)
    if r < 0 then r = 0 elseif r > 255 then r = 255 end
    if g < 0 then g = 0 elseif g > 255 then g = 255 end
    if b < 0 then b = 0 elseif b > 255 then b = 255 end
    return string.format('#%02x%02x%02x', r, g, b)
  end
  local scale = v / 100
  for k, val in pairs(base) do
    if is_hex(val) then
      local r, g, b = hex_to_rgb(val)
      local h, s, l = rgb_to_hsl(r, g, b)
      local s2 = s * scale
      p[k] = hsl_to_rgb(h, s2, l)
    else
      p[k] = val
    end
  end
end

-- Selection coloring model
local function apply_selection_model(cfg)
  local ui = cfg and cfg.ui or {}
  local model = ui and ui.selection_model or 'default'
  if model ~= 'kitty' then return end
  -- Match kitty selection: foreground/background from palette (selection_fg/bg)
  hi(0, 'Visual',   { bg = p.selection_bg, fg = p.selection_fg, bold = false, underline = false })
  hi(0, 'VisualNOS',{ bg = p.selection_bg, fg = p.selection_fg })
end

-- Global soft backgrounds alpha for Search/CurSearch/Visual and DiagnosticVirtualText*
local function apply_alpha_overlay(cfg)
  local v = (cfg and cfg.alpha_overlay) or 0
  if not v or v <= 0 then return end
  if v > 30 then v = 30 end
  local a = v / 100 -- convert to 0..0.30 alpha for blending
  -- Search background: overlay search hue over base
  do
    local base = (U.get_hl_colors and U.get_hl_colors('Search')) or {}
    local spec = { bg = (U.alpha and U.alpha(p.search_color, p.bg_default, a)) or base.bg }
    if base.fg then spec.fg = base.fg end
    if base.sp then spec.sp = base.sp end
    hi(0, 'Search', spec)
  end
  -- CurSearch: slightly stronger overlay
  do
    local base = (U.get_hl_colors and U.get_hl_colors('CurSearch')) or {}
    local aa = math.min(0.6, a * 1.4)
    local spec = { bg = (U.alpha and U.alpha(p.search_color, p.bg_default, aa)) or base.bg }
    if base.fg then spec.fg = base.fg end
    if base.sp then spec.sp = base.sp end
    hi(0, 'CurSearch', spec)
  end
  -- Visual: darken base bg proportional to overlay
  do
    local base = (U.get_hl_colors and U.get_hl_colors('Visual')) or {}
    local delta = 8 + math.floor(a * 40 + 0.5) -- ≈ 8..20
    local spec = { bg = U.darken(p.bg_default, delta) }
    if base.fg then spec.fg = base.fg end
    if base.sp then spec.sp = base.sp end
    if base.bold ~= nil then spec.bold = base.bold end
    hi(0, 'Visual', spec)
  end
  -- Diagnostics virtual text: apply alpha overlay if virtual bg is enabled
  if cfg and cfg.diagnostics_virtual_bg then
    local map = {
      DiagnosticVirtualTextError = p.diff_delete_color,
      DiagnosticVirtualTextWarn  = p.warning_color,
      DiagnosticVirtualTextInfo  = p.preproc_light_color,
      DiagnosticVirtualTextHint  = p.identifier_color,
      DiagnosticVirtualTextOk    = p.diff_add_color,
    }
    for g, col in pairs(map) do
      local base = (U.get_hl_colors and U.get_hl_colors(g)) or {}
      local spec = { bg = (U.alpha and U.alpha(col, p.bg_default, math.min(0.6, a))) or base.bg }
      if base.fg then spec.fg = base.fg end
      if base.sp then spec.sp = base.sp end
      hi(0, g, spec)
    end
  end
end

local function apply_mode_accent(cfg)
  local ui = cfg and cfg.ui or {}
  local enable = ui and ui.mode_accent == true
  local ok_api = (vim and vim.api and vim.api.nvim_create_autocmd)
  local grp = ok_api and vim.api.nvim_create_augroup('NegModeAccent', { clear = true }) or nil
  local function set_for_mode(mode)
    mode = tostring(mode or '')
    local function cursorline_bg()
      if mode:match('^i') then
        return (U.alpha and U.alpha(p.include_color, p.bg_default, 0.14)) or U.lighten(p.bg_default, 6)
      elseif mode:match('^v') or mode == 'V' or mode == '\22' then -- visual/line/block
        return (U.alpha and U.alpha(p.tag_color, p.bg_default, 0.14)) or U.darken(p.bg_default, 10)
      else
        return U.darken(p.bg_default, 8)
      end
    end
    local function statusline_fg()
      if mode:match('^i') then return p.include_color
      elseif mode:match('^v') or mode == 'V' or mode == '\22' then return p.tag_color
      else return p.function_color end
    end
    local base_cl = (U.get_hl_colors and U.get_hl_colors('CursorLine')) or {}
    local cl_spec = { bg = cursorline_bg() }
    if base_cl.fg then cl_spec.fg = base_cl.fg end
    if base_cl.sp then cl_spec.sp = base_cl.sp end
    hi(0, 'CursorLine', cl_spec)
    local base_sl = (U.get_hl_colors and U.get_hl_colors('StatusLine')) or {}
    local sl_spec = { fg = statusline_fg(), bg = base_sl.bg or 'NONE' }
    hi(0, 'StatusLine', sl_spec)
  end
  if enable and ok_api then
    -- Set initial based on current mode
    local cur = (vim.api.nvim_get_mode and vim.api.nvim_get_mode().mode) or ''
    set_for_mode(cur)
    vim.api.nvim_create_autocmd('ModeChanged', {
      group = grp,
      callback = function()
        local m = (vim.v and vim.v.event and vim.v.event.new_mode) or ''
        set_for_mode(m)
      end,
    })
    vim.api.nvim_create_autocmd('WinEnter', { group = grp, callback = function()
      local m = (vim.api.nvim_get_mode and vim.api.nvim_get_mode().mode) or ''
      set_for_mode(m)
    end })
  elseif ok_api then
    -- Disabled: clear group and restore StatusLine fg to default function color; do not force CursorLine
    vim.api.nvim_create_augroup('NegModeAccent', { clear = true })
    local base_sl = (U.get_hl_colors and U.get_hl_colors('StatusLine')) or {}
    local spec = { fg = p.function_color, bg = base_sl.bg or 'NONE' }
    hi(0, 'StatusLine', spec)
  end
end

local function apply_soft_borders(cfg)
  local ui = cfg and cfg.ui or {}
  local enable = ui and ui.soft_borders == true
  if enable then
    local sep = U.darken(p.bg_default, 10)
    local float_bg = (p.bg_float or p.bg_default)
    local fsep = U.darken(float_bg, 8)
    hi(0, 'WinSeparator', { fg = sep, bg = 'NONE' })
    hi(0, 'FloatBorder',  { fg = fsep, bg = 'NONE' })
  else
    -- Restore default linking to VertSplit
    hi(0, 'WinSeparator', { link = 'VertSplit' })
    hi(0, 'FloatBorder',  { link = 'VertSplit' })
  end
end

local function apply_float_panel_bg(cfg)
  local ui = cfg and cfg.ui or {}
  local enable = ui and ui.float_panel_bg == true
  if enable then
    local base = (U.get_hl_colors and U.get_hl_colors('NormalFloat')) or {}
    local spec = { bg = p.bg_panel }
    if base.fg then spec.fg = base.fg else spec.fg = (U.get_hl_colors and (U.get_hl_colors('Normal').fg)) or p.default_color end
    if base.sp then spec.sp = base.sp end
    hi(0, 'NormalFloat', spec)
  else
    -- Restore to inherit Normal (no extra tint)
    hi(0, 'NormalFloat', { link = 'Normal' })
  end
end

local function apply_focus_caret(cfg)
  local ui = cfg and cfg.ui or {}
  local enable = ui and ui.focus_caret == true
  local ok_api = (vim and vim.api and vim.api.nvim_create_autocmd)
  local function compute_and_apply()
    local function as_hex(v)
      if type(v) == 'number' then return string.format('#%06x', v) end
      if type(v) == 'string' then return v end
      return nil
    end
    local function hex_to_rgb(hex)
      if type(hex) ~= 'string' or not hex:match('^#%x%x%x%x%x%x$') then return nil end
      return tonumber(hex:sub(2,3),16), tonumber(hex:sub(4,5),16), tonumber(hex:sub(6,7),16)
    end
    local function srgb_to_linear(c) c=c/255; if c<=0.03928 then return c/12.92 end; return ((c+0.055)/1.055)^2.4 end
    local function rel_lum(hex)
      local r,g,b = hex_to_rgb(hex); if not r then return nil end
      r,g,b = srgb_to_linear(r), srgb_to_linear(g), srgb_to_linear(b)
      return 0.2126*r + 0.7152*g + 0.0722*b
    end
    local function contrast(fg,bg)
      local L1, L2 = rel_lum(fg), rel_lum(bg)
      if not L1 or not L2 then return nil end
      if L1 < L2 then L1, L2 = L2, L1 end
      return (L1 + 0.05) / (L2 + 0.05)
    end
    local normal = (U.get_hl_colors and U.get_hl_colors('Normal')) or {}
    local fg = normal.fg or as_hex((vim.api.nvim_get_hl and vim.api.nvim_get_hl(0,{name='Normal'}).fg) or 0) or p.default_color
    local bg = normal.bg or p.bg_default
    local ratio = contrast(fg, bg) or 7.0
    if ratio >= 4.5 then return end
    local base = (U.get_hl_colors and U.get_hl_colors('CursorLine')) or {}
    local delta
    if ratio < 3.0 then delta = 16 else delta = 12 end
    local spec = { bg = U.darken(p.bg_default, delta) }
    if base.fg then spec.fg = base.fg end
    if base.sp then spec.sp = base.sp end
    hi(0, 'CursorLine', spec)
  end
  if enable and ok_api then
    local grp = vim.api.nvim_create_augroup('NegFocusCaret', { clear = true })
    compute_and_apply()
    vim.api.nvim_create_autocmd({ 'ModeChanged','WinEnter','VimResized' }, { group = grp, callback = compute_and_apply })
  elseif ok_api then
    vim.api.nvim_create_augroup('NegFocusCaret', { clear = true })
  end
end

local function apply_auto_transparent_panels(cfg)
  local ui = cfg and cfg.ui or {}
  if not (ui and ui.auto_transparent_panels) then return end
  -- Skip if transparent floats are explicitly enabled; they already use NONE
  local t = cfg and cfg.transparent
  if t == true or (type(t) == 'table' and t.float) then return end
  local base = (U.get_hl_colors and U.get_hl_colors('Normal')) or {}
  local bg = base.bg
  if not bg or bg == '' or bg == 'NONE' then
    -- Terminal background is transparent; give floats/panels a subtle backdrop
    local float_bg = U.lighten(p.bg_default, 8)
    local panel_bg = U.lighten(p.bg_default, 6)
    hi(0, 'NormalFloat', { bg = float_bg })
    hi(0, 'Pmenu', { bg = panel_bg })
  end
end

local function apply_punct_family(cfg)
  local ts = cfg and cfg.treesitter or {}
  if ts and ts.punct_family then
    local base = p.delimiter_color
    local paren = (U.lighten and U.lighten(base, 6)) or base
    local brace = (U.darken and U.darken(base, 6)) or base
    hi(0, '@punctuation.parenthesis', { fg = paren })
    hi(0, '@punctuation.brace', { fg = brace })
  else
    -- unify to bracket color
    hi(0, '@punctuation.parenthesis', { link = '@punctuation.bracket' })
    hi(0, '@punctuation.brace', { link = '@punctuation.bracket' })
  end
end

local function apply_diff_focus(cfg)
  local ui = cfg and cfg.ui or {}
  local enable = ui and ui.diff_focus ~= false
  if not enable then
    -- restore baseline if previously strengthened
    if M._diff_strong and M._diff_base then
      for name, prev in pairs(M._diff_base) do
        local spec = {}
        if prev.fg then spec.fg = prev.fg end
        if prev.bg then spec.bg = prev.bg end
        if prev.sp then spec.sp = prev.sp end
        hi(0, name, spec)
      end
    end
    M._diff_strong, M._diff_base = false, nil
    return
  end
  local ok_api = (vim and vim.api and vim.api.nvim_list_wins)
  if not ok_api then return end
  local function any_diff_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local ok, val = pcall(vim.api.nvim_win_get_option, win, 'diff')
      if ok and val then return true end
    end
    return false
  end
  local function set_strong()
    if not M._diff_base then
      M._diff_base = {
        DiffAdd    = (U.get_hl_colors and U.get_hl_colors('DiffAdd')) or {},
        DiffChange = (U.get_hl_colors and U.get_hl_colors('DiffChange')) or {},
        DiffDelete = (U.get_hl_colors and U.get_hl_colors('DiffDelete')) or {},
        DiffText   = (U.get_hl_colors and U.get_hl_colors('DiffText')) or {},
      }
    end
    local add_bg    = (U.alpha and U.alpha(p.diff_add_color,    p.bg_default, 0.22)) or p.diff_add_color
    local change_bg = (U.alpha and U.alpha(p.diff_change_color, p.bg_default, 0.22)) or p.diff_change_color
    local del_bg    = (U.alpha and U.alpha(p.diff_delete_color, p.bg_default, 0.20)) or p.diff_delete_color
    local text_bg   = (U.alpha and U.alpha(p.include_color,     p.bg_default, 0.25)) or p.include_color
    hi(0, 'DiffAdd',    { bg = add_bg,    fg = 'NONE' })
    hi(0, 'DiffChange', { bg = change_bg, fg = 'NONE' })
    hi(0, 'DiffDelete', { bg = del_bg,    fg = 'NONE' })
    hi(0, 'DiffText',   { bg = text_bg,   fg = 'NONE', bold = true })
    M._diff_strong = true
  end
  local function restore_if_needed()
    if M._diff_strong and M._diff_base then
      for name, prev in pairs(M._diff_base) do
        local spec = {}
        if prev.fg then spec.fg = prev.fg end
        if prev.bg then spec.bg = prev.bg end
        if prev.sp then spec.sp = prev.sp end
        hi(0, name, spec)
      end
      M._diff_strong, M._diff_base = false, nil
    end
  end
  -- initial
  if any_diff_win() then set_strong() else restore_if_needed() end
  local grp = vim.api.nvim_create_augroup('NegDiffFocus', { clear = true })
  vim.api.nvim_create_autocmd({ 'WinEnter','WinClosed','BufWinEnter','OptionSet' }, {
    group = grp,
    pattern = { '*','diff' },
    callback = function()
      if any_diff_win() then set_strong() else restore_if_needed() end
    end,
  })
end

local function apply_light_signs(cfg)
  local ui = cfg and cfg.ui or {}
  local enable = ui and ui.light_signs == true
  if not enable then
    if M._light_signs and M._light_signs.base then
      for name, prev in pairs(M._light_signs.base) do
        local spec = {}
        if prev.fg then spec.fg = prev.fg end
        if prev.bg then spec.bg = prev.bg end
        if prev.sp then spec.sp = prev.sp end
        hi(0, name, spec)
      end
    end
    M._light_signs = nil
    return
  end
  local map = {
    DiagnosticSignError = p.diff_delete_color,
    DiagnosticSignWarn  = p.warning_color,
    DiagnosticSignInfo  = p.preproc_light_color,
    DiagnosticSignHint  = p.identifier_color,
    DiagnosticSignOk    = p.diff_add_color,
    GitSignsAdd         = p.diff_add_color,
    GitSignsChange      = p.diff_change_color,
    GitSignsDelete      = p.diff_delete_color,
    GitSignsTopdelete   = p.diff_delete_color,
    GitSignsChangedelete= p.diff_change_color,
    GitSignsUntracked   = p.identifier_color,
  }
  M._light_signs = { base = {} }
  local strength = 0.45
  for g, col in pairs(map) do
    if not M._light_signs.base[g] then
      M._light_signs.base[g] = (U.get_hl_colors and U.get_hl_colors(g)) or {}
    end
    local fg = (U.alpha and U.alpha(col, p.bg_default, strength)) or col
    hi(0, g, { fg = fg })
  end
end

local function apply_accessibility_opts(cfg)
  local ui = cfg and cfg.ui or {}
  local acc = ui and ui.accessibility or {}
  -- Deuteranopia-friendly: make additions blue-ish, keep deletes red and warnings orange
  if acc.deuteranopia then
    local add = p.include_color
    local add_bg = (U.alpha and U.alpha(add, p.bg_default, 0.18)) or add
    for _, g in ipairs({ '@diff.plus' }) do hi(0, g, { fg = add }) end
    hi(0, 'DiffAdd', { fg = add, bg = add_bg })
    for _, g in ipairs({ 'GitSignsAdd','GitGutterAdd','DiagnosticOk','DiagnosticSignOk','DiagnosticVirtualTextOk' }) do hi(0, g, { fg = add }) end
  end
  -- (removed) strong_undercurl option
  -- (removed) strong_tui_cursor
  -- Achromatopsia-friendly adjustments: try to remove hue reliance
  if acc.achromatopsia then
    -- 1) Syntax emphasis via styles rather than hue
    for _, g in ipairs({ '@keyword' }) do hi(0, g, { fg = p.default_color, bold = true, italic = false }) end
    for _, g in ipairs({ '@function','@method' }) do hi(0, g, { fg = p.default_color, italic = false }) end
    for _, g in ipairs({ '@type','@type.builtin','@type.definition' }) do hi(0, g, { fg = p.default_color, underline = true, italic = false }) end
    for _, g in ipairs({ '@string','@character' }) do hi(0, g, { fg = p.default_color, italic = false }) end
    for _, g in ipairs({ '@number','@boolean','@operator','@constant','@variable','@property','@field','@namespace','@tag' }) do hi(0, g, { fg = p.default_color, italic = false }) end
    for _, g in ipairs({ '@punctuation.bracket','@punctuation.delimiter','@punctuation.special' }) do hi(0, g, { fg = p.default_color }) end
    -- 2) Links/URLs always underlined
    hi(0, '@markup.link.url', { underline = true, fg = p.default_color })
    -- 3) Diagnostics: grayscale luminance ramp and visible backgrounds
    local w = p.white_color
    local err = U.darken(w, 0)     -- brightest
    local warn = U.darken(w, 20)
    local info = U.darken(w, 35)
    local hint = U.darken(w, 50)
    local ok = U.darken(w, 25)
    hi(0, 'DiagnosticError', { fg = err })
    hi(0, 'DiagnosticWarn',  { fg = warn })
    hi(0, 'DiagnosticInfo',  { fg = info })
    hi(0, 'DiagnosticHint',  { fg = hint })
    hi(0, 'DiagnosticOk',    { fg = ok })
    -- virtual text: neutral backgrounds by lightening base bg
    hi(0, 'DiagnosticVirtualTextError', { fg = p.default_color, bg = U.lighten(p.bg_default, 16) })
    hi(0, 'DiagnosticVirtualTextWarn',  { fg = p.default_color, bg = U.lighten(p.bg_default, 12) })
    hi(0, 'DiagnosticVirtualTextInfo',  { fg = p.default_color, bg = U.lighten(p.bg_default, 10) })
    hi(0, 'DiagnosticVirtualTextHint',  { fg = p.default_color, bg = U.lighten(p.bg_default, 8) })
    hi(0, 'DiagnosticVirtualTextOk',    { fg = p.default_color, bg = U.lighten(p.bg_default, 14) })
    -- 4) Diff: grayscale backgrounds
    hi(0, 'DiffAdd',    { bg = U.lighten(p.bg_default, 12), fg = 'NONE' })
    hi(0, 'DiffChange', { bg = U.lighten(p.bg_default, 8),  fg = 'NONE' })
    hi(0, 'DiffDelete', { bg = U.darken(p.bg_default, 10),  fg = 'NONE' })
    hi(0, 'DiffText',   { bg = U.lighten(p.bg_default, 16), fg = 'NONE', bold = true })
    -- 4.1) Structure zones: make Folded/ColorColumn slightly more visible even without hue
    do
      local folded_base = (U.get_hl_colors and U.get_hl_colors('Folded')) or {}
      local f_spec = { bg = U.darken(p.bg_default, 8) }
      if folded_base.fg then f_spec.fg = folded_base.fg else f_spec.fg = p.default_color end
      hi(0, 'Folded', f_spec)
    end
    do
      local cc_base = (U.get_hl_colors and U.get_hl_colors('ColorColumn')) or {}
      local cc_spec = { bg = U.darken(p.bg_default, 12) }
      hi(0, 'ColorColumn', cc_spec)
    end
    -- 5) Comments without italics
    hi(0, '@comment', { fg = p.comment_color, italic = false })
  end
  -- High-contrast pack for achromatopsia (applies regardless, but intended to pair with it)
  if acc.hc and acc.hc ~= 'off' then
    local soft = (acc.hc == 'soft')
    local function tweak(bg_delta)
      return soft and bg_delta or (bg_delta * 1.6)
    end
    hi(0, 'Visual',      { bg = U.darken(p.bg_default, tweak(14)) })
    hi(0, 'ColorColumn', { bg = U.darken(p.bg_default, tweak(18)) })
    do
      local base = (U.get_hl_colors and U.get_hl_colors('StatusLine')) or {}
      hi(0, 'StatusLine', { fg = p.white_color, bg = base.bg or 'NONE', bold = true })
    end
    hi(0, 'NormalFloat', { bg = U.darken(p.bg_float or p.bg_default, tweak(10)) })
    hi(0, 'Pmenu',       { bg = U.darken(p.bg_default, tweak(8)) })
    hi(0, 'FloatBorder', { fg = p.border_color })
  end
end

local function apply_diag_pattern(cfg)
  local ui = cfg and cfg.ui or {}
  local mode = (ui and ui.diag_pattern) or 'none'
  if mode == 'none' then return end
  -- Minimal: underline warn/info; Strong: error undercurl+underline + bold VText
  if mode == 'minimal' or mode == 'strong' then
    hi(0, 'DiagnosticUnderlineWarn', { underline = true, undercurl = false, sp = p.warning_color })
    hi(0, 'DiagnosticUnderlineInfo', { underline = true, undercurl = false, sp = p.preproc_light_color })
    hi(0, 'DiagnosticUnderlineHint', { underline = true, undercurl = false, sp = p.identifier_color })
  end
  if mode == 'strong' then
    hi(0, 'DiagnosticUnderlineError', { underline = true, undercurl = true, sp = p.diff_delete_color })
    for _, g in ipairs({ 'DiagnosticVirtualTextError','DiagnosticVirtualTextWarn','DiagnosticVirtualTextInfo','DiagnosticVirtualTextHint' }) do
      local base = (U.get_hl_colors and U.get_hl_colors(g)) or {}
      local spec = { bold = true }
      if base.fg then spec.fg = base.fg end
      if base.bg then spec.bg = base.bg end
      if base.sp then spec.sp = base.sp end
      hi(0, g, spec)
    end
  end
end

local function apply_lexeme_cues(cfg)
  local ui = cfg and cfg.ui or {}
  local mode = (ui and ui.lexeme_cues) or 'off'
  if mode == 'off' then return end
  if mode == 'minimal' or mode == 'strong' then
    for _, g in ipairs({ '@function','@method' }) do
      local base = (U.get_hl_colors and U.get_hl_colors(g)) or {}
      local spec = { underline = true }
      if base.fg then spec.fg = base.fg end
      if base.bg then spec.bg = base.bg end
      hi(0, g, spec)
    end
  end
  if mode == 'strong' then
    for _, g in ipairs({ '@type','@type.builtin','@type.definition' }) do
      local base = (U.get_hl_colors and U.get_hl_colors(g)) or {}
      local spec = { underline = true, bold = true }
      if base.fg then spec.fg = base.fg end
      if base.bg then spec.bg = base.bg end
      hi(0, g, spec)
    end
  end
end

local function apply_thick_cursor(cfg)
  local ui = cfg and cfg.ui or {}
  if not (ui and ui.thick_cursor) then return end
  hi(0, 'CursorLine', { bg = U.darken(p.bg_default, 14) })
  do
    local base = (U.get_hl_colors and U.get_hl_colors('CursorLineNr')) or {}
    local spec = { bold = true }
    if base.fg then spec.fg = base.fg end
    if base.bg then spec.bg = base.bg end
    hi(0, 'CursorLineNr', spec)
  end
  hi(0, 'Cursor', { reverse = true, bold = true })
  hi(0, 'TermCursor', { reverse = true, bold = true })
end

local function apply_outlines(cfg)
  local ui = cfg and cfg.ui or {}
  local enable = ui and ui.outlines
  local ok = (vim and vim.api and vim.api.nvim_create_autocmd)
  if not ok then return end
  local grp = vim.api.nvim_create_augroup('NegOutlines', { clear = true })
  if not enable then
    vim.api.nvim_create_autocmd({ 'WinEnter','BufWinEnter' }, { group = grp, callback = function()
      pcall(vim.api.nvim_set_option_value, 'winhighlight', '', { scope = 'local' })
    end })
    return
  end
  hi(0, 'NegWinSepActive',   { fg = p.border_color })
  hi(0, 'NegWinSepInactive', { fg = U.darken(p.bg_default, 12) })
  vim.api.nvim_create_autocmd('WinEnter', { group = grp, callback = function()
    local prev = vim.wo.winhighlight or ''
    local mapped = 'WinSeparator:NegWinSepActive'
    if prev ~= '' then
      if not prev:match('WinSeparator:') then prev = prev .. (prev:sub(-1) == ',' and '' or ',') .. mapped
      else prev = prev:gsub('WinSeparator:[^,]+', mapped) end
    else prev = mapped end
    pcall(vim.api.nvim_set_option_value, 'winhighlight', prev, { scope = 'local' })
  end })
  vim.api.nvim_create_autocmd('WinLeave', { group = grp, callback = function()
    local prev = vim.wo.winhighlight or ''
    local mapped = 'WinSeparator:NegWinSepInactive'
    if prev ~= '' then
      if not prev:match('WinSeparator:') then prev = prev .. (prev:sub(-1) == ',' and '' or ',') .. mapped
      else prev = prev:gsub('WinSeparator:[^,]+', mapped) end
    else prev = mapped end
    pcall(vim.api.nvim_set_option_value, 'winhighlight', prev, { scope = 'local' })
  end })
end

local function apply_reading_mode(cfg)
  local ui = cfg and cfg.ui or {}
  if not (ui and ui.reading_mode) then return end
  -- Near-monochrome syntax (leave UI accents)
  for _, g in ipairs({ '@keyword','@function','@method','@type','@type.builtin','@type.definition','@string','@number','@boolean','@operator','@constant','@variable','@property','@field','@namespace','@tag','@punctuation.bracket','@punctuation.delimiter','@punctuation.special' }) do
    hi(0, g, { fg = p.default_color })
  end
  hi(0, 'Whitespace', { fg = U.lighten(p.comment_color, 12) })
  hi(0, 'Visual', { bg = U.darken(p.bg_default, 10) })
  hi(0, 'ColorColumn', { bg = U.darken(p.bg_default, 14) })
end

local function apply_search_visibility(cfg)
  local ui = cfg and cfg.ui or {}
  local mode = (ui and ui.search_visibility) or 'default'
  if mode == 'default' then return end
  if mode == 'soft' then
    local b = (U.get_hl_colors and U.get_hl_colors('Search')) or {}
    hi(0, 'Search', { underline = true, italic = false, fg = b.fg or p.search_color, bg = 'NONE' })
    local c = (U.get_hl_colors and U.get_hl_colors('CurSearch')) or {}
    hi(0, 'CurSearch', { bold = true, underline = true, fg = c.fg or p.search_color, bg = c.bg })
  elseif mode == 'strong' then
    local b = (U.get_hl_colors and U.get_hl_colors('Search')) or {}
    hi(0, 'Search', { underline = true, italic = false, fg = b.fg or p.search_color, bg = 'NONE' })
    local c = (U.get_hl_colors and U.get_hl_colors('CurSearch')) or {}
    hi(0, 'CurSearch', { bold = true, underline = true, fg = p.white_color, bg = U.darken(p.bg_default, 18) })
  end
end

local function apply_screenreader(cfg)
  local ui = cfg and cfg.ui or {}
  if not (ui and ui.screenreader_friendly) then return end
  -- Minimize dynamic accents: reset StatusLine/CursorLine to stable, disable strong diff focus backgrounds
  do
    local base = (U.get_hl_colors and U.get_hl_colors('StatusLine')) or {}
    hi(0, 'StatusLine', { fg = p.function_color, bg = base.bg or 'NONE' })
    local cl = (U.get_hl_colors and U.get_hl_colors('CursorLine')) or {}
    hi(0, 'CursorLine', { bg = cl.bg or U.darken(p.bg_default, 8) })
  end
  -- Clear diff focus strengthening if any
  if M._diff_strong and M._diff_base then
    for name, prev in pairs(M._diff_base) do
      local spec = {}
      if prev.fg then spec.fg = prev.fg end
      if prev.bg then spec.bg = prev.bg end
      if prev.sp then spec.sp = prev.sp end
      hi(0, name, spec)
    end
    M._diff_strong, M._diff_base = false, nil
  end
end

local function apply_telescope_accents(cfg)
  local ui = cfg and cfg.ui or {}
  local mode = ui and ui.telescope_accents
  if mode == nil or mode == false then
    -- Enforce neutral defaults even if other plugins recolor later
    hi(0, 'TelescopeMatching', { underline = true, italic = false, fg = nil })
    hi(0, 'TelescopeSelection', { link = 'Visual' })
    return
  end
  -- Normalize: true -> 'default'
  if mode == true then mode = 'default' end
  mode = tostring(mode):lower()
  local match_fg = p.search_color or p.include_color or p.keyword3_color
  if mode == 'soft' then
    hi(0, 'TelescopeMatching', { underline = true, italic = false, fg = nil })
  elseif mode == 'strong' then
    hi(0, 'TelescopeMatching', { fg = match_fg, underline = true, italic = false })
  else -- 'default'
    hi(0, 'TelescopeMatching', { fg = match_fg, underline = false, italic = false })
  end
  -- Selection: use CursorLine background; caret gets include_color by default
  local cl = (U.get_hl_colors and U.get_hl_colors('CursorLine')) or {}
  local sel = {}
  if cl.bg then sel.bg = cl.bg end
  hi(0, 'TelescopeSelection', sel)
  -- Preview matches follow matching style
  if mode == 'soft' then
    hi(0, 'TelescopePreviewMatch', { underline = true, italic = false, fg = nil })
  elseif mode == 'strong' then
    hi(0, 'TelescopePreviewMatch', { fg = match_fg, underline = true, italic = false })
  else
    hi(0, 'TelescopePreviewMatch', { fg = match_fg, underline = false, italic = false })
  end
  -- Borders follow WinSeparator via links; nothing to do
end

-- Optional blue path separators (TelescopePathSeparator)
local function apply_path_separator(cfg)
  local ui = cfg and cfg.ui or {}
  if ui and ui.path_separator_blue then
    local col = p.include_color or p.keyword3_color
    local custom = ui.path_separator_color
    if type(custom) == 'string' and custom ~= '' then
      if custom:match('^#%x%x%x%x%x%x$') then
        col = custom
      elseif p[custom] and type(p[custom]) == 'string' then
        col = p[custom]
      end
    end
    -- Startify
    if not (cfg.plugins and cfg.plugins.startify == false) then
      hi(0, 'StartifySlash', { fg = col })
    end
    -- Navic breadcrumbs
    if not (cfg.plugins and cfg.plugins.navic == false) then
      hi(0, 'NavicSeparator', { fg = col })
    end
    -- which-key separator
    if not (cfg.plugins and cfg.plugins.which_key == false) then
      hi(0, 'WhichKeySeparator', { fg = col })
    end
  else
    -- Restore neutral defaults
    if not (cfg.plugins and cfg.plugins.startify == false) then
      hi(0, 'StartifySlash', { fg = p.comment_color })
    end
    if not (cfg.plugins and cfg.plugins.navic == false) then
      hi(0, 'NavicSeparator', { fg = p.dark_color })
    end
    if not (cfg.plugins and cfg.plugins.which_key == false) then
      hi(0, 'WhichKeySeparator', { fg = p.comment_color })
    end
  end
end

local function apply_dim_inactive(cfg)
  local ui = cfg and cfg.ui or {}
  local enable = ui and ui.dim_inactive == true
  local ok_api = (vim and vim.api and vim.api.nvim_create_autocmd)
  -- Highlight tweaks
  if enable then
    -- Dim non-current window base and winbar
    local nnc = { fg = p.comment_color }
    local base = (U.get_hl_colors and U.get_hl_colors('Normal')) or {}
    if base.bg then nnc.bg = U.darken(base.bg, 6) else nnc.bg = U.darken(p.bg_default, 6) end
    hi(0, 'NormalNC', nnc)
    hi(0, 'WinBarNC', { fg = p.comment_color })
    -- Dimmed line numbers group
    hi(0, 'NegLineNrDim', { fg = p.comment_color })
  else
    -- Restore default link for NormalNC if previously altered
    hi(0, 'NormalNC', { link = 'Normal' })
  end
  if not ok_api then return end
  -- Manage autocmds to map line numbers per window
  local grp = vim.api.nvim_create_augroup('NegDimInactive', { clear = true })
  if enable then
    vim.api.nvim_create_autocmd({ 'WinEnter','BufWinEnter' }, {
      group = grp,
      callback = function()
        pcall(vim.api.nvim_set_option_value, 'winhighlight', '', { scope = 'local' })
      end,
    })
    vim.api.nvim_create_autocmd('WinLeave', {
      group = grp,
      callback = function()
        local prev = vim.wo.winhighlight or ''
        local mapped = 'LineNr:NegLineNrDim'
        if prev ~= '' then
          -- keep existing mappings, just ensure LineNr is mapped
          if not prev:match('LineNr:') then prev = prev .. (prev:sub(-1) == ',' and '' or (prev == '' and '' or ',')) .. mapped
          else prev = prev:gsub('LineNr:[^,]+', mapped) end
          pcall(vim.api.nvim_set_option_value, 'winhighlight', prev, { scope = 'local' })
        else
          pcall(vim.api.nvim_set_option_value, 'winhighlight', mapped, { scope = 'local' })
        end
      end,
    })
  else
    -- Clear mappings when disabled
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      pcall(vim.api.nvim_set_option_value, 'winhighlight', '', { scope = 'local', win = win })
    end
  end
end

local function apply_operator_colors(mode)
  if mode == 'mono' or mode == 'mono+' or mode == 'mono_plus' then
    local groups = {
      '@operator.assignment','@operator.assignment.compound','@operator.assignment.augmented',
      '@operator.comparison','@operator.comparison.equality','@operator.comparison.relational',
      '@operator.arithmetic','@operator.arithmetic.add','@operator.arithmetic.sub','@operator.arithmetic.mul','@operator.arithmetic.div','@operator.arithmetic.mod','@operator.arithmetic.pow',
      '@operator.logical','@operator.logical.and','@operator.logical.or','@operator.logical.not','@operator.logical.xor',
      '@operator.bitwise','@operator.bitwise.and','@operator.bitwise.or','@operator.bitwise.xor','@operator.bitwise.shift','@operator.bitwise.not','@operator.bitwise.left_shift','@operator.bitwise.right_shift',
      '@operator.ternary','@operator.unary','@operator.increment','@operator.decrement','@operator.range','@operator.spread','@operator.pipe','@operator.arrow','@operator.coalesce',
    }
    for _, g in ipairs(groups) do
      hi(0, g, { link = '@operator' })
    end
    -- In 'mono+' preset, give @operator a slightly stronger accent
    if mode == 'mono+' or mode == 'mono_plus' then
      local base = (U.get_hl_colors and U.get_hl_colors('@operator')) or {}
      local spec = { fg = p.keyword1_color }
      if base.bg then spec.bg = base.bg end
      if base.sp then spec.sp = base.sp end
      hi(0, '@operator', spec)
    end
  end
end

local function apply_number_colors(mode)
  mode = tostring(mode or ''):lower()
  if mode == 'mono' or mode == '' then return end
  if not mode:match('^ramp') then return end
  local base = p.keyword1_color
  local hex_l, bin_l, oct_d = 6, 3, 6 -- balanced default
  if mode == 'ramp-soft' or mode == 'ramp:soft' then
    hex_l, bin_l, oct_d = 4, 2, 4
  elseif mode == 'ramp-strong' or mode == 'ramp:strong' then
    hex_l, bin_l, oct_d = 10, 5, 10
  else
    -- ramp / ramp-balanced / ramp:balanced
    hex_l, bin_l, oct_d = 6, 3, 6
  end
  local ramp = {
    integer = base,
    hex     = U.lighten(base, hex_l),
    octal   = U.darken(base,  oct_d),
    binary  = U.lighten(base, bin_l),
  }
  hi(0, '@number.integer', { fg = ramp.integer })
  hi(0, '@number.hex',     { fg = ramp.hex })
  hi(0, '@number.octal',   { fg = ramp.octal })
  hi(0, '@number.binary',  { fg = ramp.binary })
end

local function apply_markup_prefs(cfg)
  local m = cfg and cfg.markup
  if m == false then return end
  m = m or {}
  -- Headings colors (levels 1..6)
  do
    local h = m.headings or {}
    -- Build a cohesive single-hue ramp from include_color
    local base = p.include_color
    local ramp = {
      U.lighten(base, 25), -- h1 brightest
      U.lighten(base, 15), -- h2
      base,                -- h3
      U.darken(base, 10),  -- h4
      U.darken(base, 20),  -- h5
      U.darken(base, 30),  -- h6 darkest
    }
    for i = 1, 6 do
      local fg = h['h'..i] or ramp[i]
      if type(fg) == 'string' and fg ~= '' then
        hi(0, '@markup.heading.'..i, { fg = fg, bold = true })
      end
    end
  end
  -- Lists
  do
    local l = m.lists or {}
    local base = l.base or p.comment_color
    local checked = l.checked or p.identifier_color
    local unchecked = l.unchecked or p.comment_color
    local numbered = l.numbered or p.comment_color
    hi(0, '@markup.list', { fg = base })
    hi(0, '@markup.list.checked', { fg = checked })
    hi(0, '@markup.list.unchecked', { fg = unchecked })
    hi(0, '@markup.list.numbered', { fg = numbered })
  end
end

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
  local ts_map = {
    comments = { '@comment','@comment.documentation' },
    keywords = {
      '@keyword','@keyword.function','@keyword.operator','@keyword.directive','@keyword.storage',
      '@keyword.conditional','@keyword.debug','@keyword.exception','@keyword.import','@keyword.repeat','@keyword.return'
    },
    functions = { '@function','@function.macro','@method' },
    strings = { '@string','@character','@string.regex' },
    variables = { '@variable','@parameter','@field','@property' },
    types = { '@type','@type.builtin','@type.definition','@type.parameter','@type.qualifier' },
    operators = { '@operator','@punctuation.delimiter','@punctuation.bracket' },
    numbers = { '@number','@float','@number.integer','@number.hex','@number.octal','@number.binary' },
    booleans = { '@boolean' },
    constants = { '@constant','@constant.builtin','@variable.builtin','@constant.macro' },
    punctuation = { '@punctuation.delimiter','@punctuation.special' },
  }
  -- Apply style flags to Treesitter captures as well
  for key, groups in pairs(ts_map) do
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

  -- Replace default NvimLight*/NvimDark* palette leftovers with theme colors
  local function sanitize_nvim_light_colors(cfg)
    local ui = cfg and cfg.ui or {}
    local enable = (ui.sanitize_defaults ~= false)
    if not enable then return end
    local ok_api = (vim and vim.api and vim.api.nvim_set_hl and vim.api.nvim_get_hl and vim.fn and vim.fn.getcompletion)
    if not ok_api then return end
    local function probe(name)
      local g = 'NegProbe' .. name
      pcall(vim.api.nvim_set_hl, 0, g, { fg = name })
      local ok, t = pcall(vim.api.nvim_get_hl, 0, { name = g, link = false })
      local v = (ok and type(t) == 'table') and t.fg or nil
      pcall(vim.cmd, 'hi clear ' .. g)
      return v
    end
    local desired = {
      -- Light palette fallbacks
      NvimLightGreen   = p.diff_add_color,
      NvimLightRed     = p.diff_delete_color,
      NvimLightCyan    = p.preproc_light_color,
      NvimLightBlue    = p.include_color,
      NvimLightYellow  = p.warning_color,
      NvimLightMagenta = p.violet_color,
      NvimLightGrey    = p.comment_color,
      -- Dark palette fallbacks
      NvimDarkGreen    = p.diff_add_color,
      NvimDarkRed      = p.diff_delete_color,
      NvimDarkCyan     = p.preproc_light_color,
      NvimDarkBlue     = p.include_color,
      NvimDarkYellow   = p.warning_color,
      NvimDarkMagenta  = p.violet_color,
      NvimDarkGrey     = p.comment_color,
    }
    -- Allow user overrides of palette mapping
    if type(ui.sanitize_map) == 'table' then
      for k, v in pairs(ui.sanitize_map) do
        if type(k) == 'string' and type(v) == 'string' then desired[k] = v end
      end
    end
    local match_values = {}
    for k, hex in pairs(desired) do
      local v = probe(k)
      if type(v) == 'number' then match_values[v] = hex end
    end
    -- Exclusions (do not sanitize these groups by name)
    local exclude = { Search = true, CurSearch = true, IncSearch = true }
    if type(ui.sanitize_exclude) == 'table' then
      for _, n in ipairs(ui.sanitize_exclude) do if type(n) == 'string' then exclude[n] = true end end
    end
    -- Background alpha blend strength for bg replacements
    local bg_alpha = tonumber(ui.sanitize_bg_alpha or ui.sanitize_bg_strength) or 0.22
    local name_map = {
      ['@string']                 = { fg = p.string_color },
      ['@character']              = { fg = p.string_color },
      ['@character.special']      = { fg = p.string_color },
      ['@string.escape']          = { fg = p.literal2_color },
      ['@string.regexp']          = { fg = p.string_color },
      ['@string.special']         = { fg = p.string_color },
      ['@function']               = { fg = p.function_color },
      ['@function.builtin']       = { fg = p.function_color },
      ['@constructor']            = { fg = p.function_color },
      ['@lsp.type.function']      = { fg = p.function_color },
      ['@lsp.type.method']        = { fg = p.function_color },
      ['@tag']                    = { fg = p.tag_color },
      ['@tag.builtin']            = { fg = p.tag_color },
      ['@type.builtin']           = { fg = p.keyword3_color },
      ['@property']               = { fg = p.identifier_color },
      ['@lsp.type.property']      = { fg = p.identifier_color },
      ['@module.builtin']         = { fg = p.identifier_color },
      ['@variable.builtin']       = { fg = p.identifier_color },
      ['@variable.parameter.builtin'] = { fg = p.identifier_color },
      ['@constant.builtin']       = { fg = p.literal2_color },
      ['@attribute.builtin']      = { fg = p.identifier_color },
      ['@comment.error']          = { fg = p.diff_delete_color },
      ['@comment.warning']        = { fg = p.warning_color },
      ['@comment.note']           = { fg = p.identifier_color },
      ['@punctuation.special']    = { fg = p.delimiter_color },
      ['@diff.plus']              = { fg = p.diff_add_color },
      ['@diff.minus']             = { fg = p.diff_delete_color },
      ['@diff.delta']             = { fg = p.diff_change_color },
      DiagnosticError             = { fg = p.diff_delete_color },
      DiagnosticWarn              = { fg = p.warning_color },
      DiagnosticInfo              = { fg = p.preproc_light_color },
      DiagnosticHint              = { fg = p.identifier_color },
      DiagnosticOk                = { fg = p.diff_add_color },
    }
    local groups = vim.fn.getcompletion('', 'highlight') or {}
    for _, name in ipairs(groups) do
      if exclude[name] then goto continue end
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
      if ok and type(hl) == 'table' then
        local changed = false
        local spec = {}
        if hl.bold ~= nil then spec.bold = hl.bold end
        if hl.italic ~= nil then spec.italic = hl.italic end
        if hl.underline ~= nil then spec.underline = hl.underline end
        if hl.undercurl ~= nil then spec.undercurl = hl.undercurl end
        if hl.strikethrough ~= nil then spec.strikethrough = hl.strikethrough end
        if hl.reverse ~= nil then spec.reverse = hl.reverse end
        if hl.blend ~= nil then spec.blend = hl.blend end
        if hl.fg and match_values[hl.fg] then spec.fg = match_values[hl.fg]; changed = true end
        if hl.bg and match_values[hl.bg] then
          local hex = match_values[hl.bg]
          spec.bg = (U.alpha and U.alpha(hex, p.bg_default, bg_alpha)) or hex
          changed = true
        end
        if hl.sp and match_values[hl.sp] then spec.sp = match_values[hl.sp]; changed = true end
        -- Name-based fallbacks for common groups
        if name == 'Added'        then spec.fg = p.diff_add_color;    changed = true end
        if name == 'Removed'      then spec.fg = p.diff_delete_color; changed = true end
        if name == 'Changed'      then spec.fg = p.diff_change_color; changed = true end
        if name == 'diffAdded'    then spec.fg = p.diff_add_color;    changed = true end
        if name == 'diffRemoved'  then spec.fg = p.diff_delete_color; changed = true end
        if name == 'diffChanged'  then spec.fg = p.diff_change_color; changed = true end
        if name == 'DiffAdded'    then spec.fg = p.diff_add_color;    changed = true end
        if name == 'DiffRemoved'  then spec.fg = p.diff_delete_color; changed = true end
        if name == 'DiffChanged'  then spec.fg = p.diff_change_color; changed = true end
        -- Treesitter/LSP/common aliases
        local nm = name_map[name]
        if nm then for k, v in pairs(nm) do spec[k] = v end; changed = true end
        if changed then hi(0, name, spec) end
      end
      ::continue::
    end
  end

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

  -- Apply palette saturation before any highlight tables are required
  set_palette_saturation(cfg.saturation or 100)
  -- Ensure group modules are re-evaluated against the updated palette
  invalidate_group_modules()

  -- Idempotent apply: skip if no changes and no function overrides
  if not force_apply and M._applied_key and type(cfg.overrides) ~= 'function' then
    local key = U.config_signature(cfg)
    if vim.deep_equal(key, M._applied_key) then return end
  end

  -- Core groups
  apply(require('neg.groups.editor'))
  -- Legacy Vim syntax groups (when Treesitter is not active)
  safe_apply('neg.groups.legacy')
  -- Optional baseline UI enhancements
  if not (cfg.ui and cfg.ui.core_enhancements == false) then
    safe_apply('neg.groups.editor_extras')
  end
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
    -- phase 1 additions
    diffview = 'neg.groups.plugins.diffview',
    fidget = 'neg.groups.plugins.fidget',
    toggleterm = 'neg.groups.plugins.toggleterm',
    dashboard = 'neg.groups.plugins.dashboard',
    heirline = 'neg.groups.plugins.heirline',
    oil = 'neg.groups.plugins.oil',
    blink = 'neg.groups.plugins.blink',
    leap = 'neg.groups.plugins.leap',
    flash = 'neg.groups.plugins.flash',
    ufo = 'neg.groups.plugins.ufo',
    bqf = 'neg.groups.plugins.bqf',
    -- phase 2 additions
    glance = 'neg.groups.plugins.glance',
    barbecue = 'neg.groups.plugins.barbecue',
    illuminate = 'neg.groups.plugins.illuminate',
    hlslens = 'neg.groups.plugins.hlslens',
    virt_column = 'neg.groups.plugins.virt_column',
    dap_virtual_text = 'neg.groups.plugins.dap_virtual_text',
    mini_pick = 'neg.groups.plugins.mini_pick',
    snacks = 'neg.groups.plugins.snacks',
    fzf_lua = 'neg.groups.plugins.fzf_lua',
  }) do
    if cfg.plugins[key] ~= false then safe_apply(mod) end
  end

  -- Post-processing
  if not (cfg.treesitter and cfg.treesitter.extras == false) then safe_apply('neg.groups.treesitter_extras') end
  if cfg.transparent then apply_transparent(cfg.transparent) end
  if cfg.terminal_colors then apply_terminal_colors() end
  apply_styles(cfg.styles)
  apply_preset(cfg.preset, cfg)
  apply_markup_prefs(cfg)
  apply_operator_colors(cfg.operator_colors)
  apply_number_colors(cfg.number_colors)

  -- Apply order (as documented): accessibility → diagnostics virtual bg → alpha overlay → selection model → others → overrides
  apply_accessibility_opts(cfg)
  if cfg.diagnostics_virtual_bg then apply_diagnostics_virtual_bg(cfg) end
  apply_alpha_overlay(cfg)
  apply_selection_model(cfg)

  -- Other feature toggles
  apply_dim_inactive(cfg)
  apply_mode_accent(cfg)
  apply_focus_caret(cfg)
  apply_soft_borders(cfg)
  apply_auto_transparent_panels(cfg)
  apply_float_panel_bg(cfg)
  apply_diff_focus(cfg)
  apply_light_signs(cfg)
  apply_punct_family(cfg)
  apply_diag_pattern(cfg)
  apply_lexeme_cues(cfg)
  apply_thick_cursor(cfg)
  apply_outlines(cfg)
  apply_reading_mode(cfg)
  apply_search_visibility(cfg)
  apply_screenreader(cfg)
  apply_telescope_accents(cfg)
  apply_path_separator(cfg)

  -- User overrides last
  -- Sanitize any leftover default colors after everything is applied
  sanitize_nvim_light_colors(cfg)
  -- User overrides last
  apply_overrides(cfg.overrides)
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
    local allowed = { soft=true, hard=true, pro=true, writing=true, accessibility=true, focus=true, presentation=true, none=true }
    if not allowed[preset] then
      print("neg.nvim: unknown preset '" .. preset .. "'. Use: soft|hard|pro|writing|accessibility|focus|presentation|none")
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
      return { 'soft', 'hard', 'pro', 'writing', 'accessibility', 'focus', 'presentation', 'none' }
    end,
    desc = 'neg.nvim: Apply style preset (soft|hard|pro|writing|accessibility|focus|presentation|none)'
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
    complete = function()
      return { '0','0.05','0.1','0.15','0.2','0.25','0.3','0.4','0.5','0.6','0.75','1' }
    end,
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
    complete = function()
      return { '0','5','10','15','20','25','30','40','50','60','70','80','90','100' }
    end,
    desc = 'neg.nvim: Set diagnostics bg blend (0..100) when mode=blend'
  })

  vim.api.nvim_create_user_command('NegModeAccent', function(opts)
    local arg = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if arg == 'on' then
      newcfg.ui.mode_accent = true
    elseif arg == 'off' then
      newcfg.ui.mode_accent = false
    elseif arg == 'toggle' or arg == '' then
      newcfg.ui.mode_accent = not (cfg.ui and cfg.ui.mode_accent == true)
    else
      print("neg.nvim: unknown arg '" .. arg .. "'. Use: on|off|toggle")
      return
    end
    M.setup(newcfg)
  end, {
    nargs = '?',
    complete = function() return { 'on', 'off', 'toggle' } end,
    desc = 'neg.nvim: Toggle/Set mode-aware CursorLine/StatusLine accents (on|off|toggle)'
  })

  vim.api.nvim_create_user_command('NegSoftBorders', function(opts)
    local arg = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if arg == 'on' then
      newcfg.ui.soft_borders = true
    elseif arg == 'off' then
      newcfg.ui.soft_borders = false
    elseif arg == 'toggle' or arg == '' then
      newcfg.ui.soft_borders = not (cfg.ui and cfg.ui.soft_borders == true)
    else
      print("neg.nvim: unknown arg '" .. arg .. "'. Use: on|off|toggle")
      return
    end
    M.setup(newcfg)
  end, {
    nargs = '?',
    complete = function() return { 'on', 'off', 'toggle' } end,
    desc = 'neg.nvim: Toggle/Set soft borders (WinSeparator/FloatBorder) (on|off|toggle)'
  })

  vim.api.nvim_create_user_command('NegFloatBg', function(opts)
    local arg = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if arg == 'on' then
      newcfg.ui.float_panel_bg = true
    elseif arg == 'off' then
      newcfg.ui.float_panel_bg = false
    elseif arg == 'toggle' or arg == '' then
      newcfg.ui.float_panel_bg = not (cfg.ui and cfg.ui.float_panel_bg == true)
    else
      print("neg.nvim: unknown arg '" .. arg .. "'. Use: on|off|toggle")
      return
    end
    M.setup(newcfg)
  end, {
    nargs = '?',
    complete = function() return { 'on', 'off', 'toggle' } end,
    desc = 'neg.nvim: Toggle/Set float background model (Normal vs slightly lighter panel-like bg)'
  })

  vim.api.nvim_create_user_command('NegFocusCaret', function(opts)
    local arg = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if arg == 'on' then
      newcfg.ui.focus_caret = true
    elseif arg == 'off' then
      newcfg.ui.focus_caret = false
    elseif arg == 'toggle' or arg == '' then
      newcfg.ui.focus_caret = not (cfg.ui and cfg.ui.focus_caret == true)
    else
      print("neg.nvim: unknown arg '" .. arg .. "'. Use: on|off|toggle")
      return
    end
    M.setup(newcfg)
  end, {
    nargs = '?',
    complete = function() return { 'on', 'off', 'toggle' } end,
    desc = 'neg.nvim: Toggle/Set focus-caret (boost CursorLine contrast when overall contrast is low)'
  })

  vim.api.nvim_create_user_command('NegDimInactive', function(opts)
    local arg = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if arg == 'on' then
      newcfg.ui.dim_inactive = true
    elseif arg == 'off' then
      newcfg.ui.dim_inactive = false
    elseif arg == 'toggle' or arg == '' then
      newcfg.ui.dim_inactive = not (cfg.ui and cfg.ui.dim_inactive == true)
    else
      print("neg.nvim: unknown arg '" .. arg .. "'. Use: on|off|toggle")
      return
    end
    M.setup(newcfg)
  end, {
    nargs = '?',
    complete = function() return { 'on', 'off', 'toggle' } end,
    desc = 'neg.nvim: Toggle/Set dim inactive windows (on|off|toggle)'
  })

  vim.api.nvim_create_user_command('NegDiffFocus', function(opts)
    local arg = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if arg == 'on' then
      newcfg.ui.diff_focus = true
    elseif arg == 'off' then
      newcfg.ui.diff_focus = false
    elseif arg == 'toggle' or arg == '' then
      newcfg.ui.diff_focus = not (cfg.ui and cfg.ui.diff_focus ~= false)
    else
      print("neg.nvim: unknown arg '" .. arg .. "'. Use: on|off|toggle")
      return
    end
    M.setup(newcfg)
  end, {
    nargs = '?',
    complete = function() return { 'on', 'off', 'toggle' } end,
    desc = 'neg.nvim: Toggle/Set stronger Diff* backgrounds in :diff (on|off|toggle)'
  })

  vim.api.nvim_create_user_command('NegScreenreader', function(opts)
    local arg = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if arg == 'on' then
      newcfg.ui.screenreader_friendly = true
    elseif arg == 'off' then
      newcfg.ui.screenreader_friendly = false
    elseif arg == 'toggle' or arg == '' then
      newcfg.ui.screenreader_friendly = not (cfg.ui and cfg.ui.screenreader_friendly == true)
    else
      print("neg.nvim: unknown arg '" .. arg .. "'. Use: on|off|toggle")
      return
    end
    M.setup(newcfg)
  end, {
    nargs = '?',
    complete = function() return { 'on', 'off', 'toggle' } end,
    desc = 'neg.nvim: Toggle/Set screenreader-friendly mode (on|off|toggle)'
  })

  vim.api.nvim_create_user_command('NegContrast', function(opts)
    local raw = (opts.args or '')
    if raw == '' then
      print("neg.nvim: usage: :NegContrast {Group|@capture} [vs {Group|#rrggbb}] [--target AA|AAA] [apply] [--json] [--notify=off|on]")
      return
    end
    -- Parse "<group> [vs <bg>] [--target AA|AAA] [apply]"
    local tokens = {}
    for w in raw:gmatch('%S+') do tokens[#tokens+1] = w end
    local name = tokens[1]
    local bg_arg
    local target_label
    local apply_now = false
    local use_json, use_notify = false, true
    for i = 2, #tokens do
      local t = tokens[i]
      local tl = t:lower()
      if tl == 'vs' and tokens[i+1] then
        bg_arg = tokens[i+1]
      elseif tl == 'apply' then
        apply_now = true
      elseif tl == '--target' and tokens[i+1] then
        target_label = tostring(tokens[i+1]):upper()
      elseif tl:match('^%-%-target=') then
        target_label = tostring(t:sub(10)):upper()
      elseif tl == '--json' then
        use_json = true
      elseif tl:match('^%-%-notify=') or tl == '--notify' then
        local val = nil
        if tl == '--notify' and tokens[i+1] and tokens[i+1]:match('^(on|off)$') then val = tokens[i+1] end
        val = val or tl:match('^%-%-notify=(.+)$')
        if val then use_notify = (val == 'on') end
      end
    end
    local function get_hl(name_, follow)
      local function as_hex(v)
        if type(v) == 'number' then return string.format('#%06x', v) end
        if type(v) == 'string' then return v end
        return nil
      end
      if type(vim.api.nvim_get_hl) == 'function' then
        local ok, t = pcall(vim.api.nvim_get_hl, 0, { name = name_, link = follow and true or false })
        if ok and type(t) == 'table' then
          return { fg = as_hex(t.fg), bg = as_hex(t.bg), sp = as_hex(t.sp) }
        end
      end
      if type(vim.api.nvim_get_hl_by_name) == 'function' then
        local ok2, t2 = pcall(vim.api.nvim_get_hl_by_name, name_, true)
        if ok2 and type(t2) == 'table' then
          return { fg = as_hex(t2.foreground), bg = as_hex(t2.background), sp = as_hex(t2.special) }
        end
      end
      return {}
    end
    local function hex_to_rgb(hex)
      if type(hex) ~= 'string' or not hex:match('^#%x%x%x%x%x%x$') then return nil end
      return tonumber(hex:sub(2,3),16), tonumber(hex:sub(4,5),16), tonumber(hex:sub(6,7),16)
    end
    local function srgb_to_linear(c)
      c = c/255
      if c <= 0.03928 then return c/12.92 end
      return ((c + 0.055)/1.055)^2.4
    end
    local function rel_luminance(hex)
      local r, g, b = hex_to_rgb(hex)
      if not r then return nil end
      r, g, b = srgb_to_linear(r), srgb_to_linear(g), srgb_to_linear(b)
      return 0.2126*r + 0.7152*g + 0.0722*b
    end
    local function contrast_ratio(fg, bg)
      local L1 = rel_luminance(fg)
      local L2 = rel_luminance(bg)
      if not L1 or not L2 then return nil end
      if L1 < L2 then L1, L2 = L2, L1 end
      return (L1 + 0.05) / (L2 + 0.05)
    end
    local g = get_hl(name, true)
    local fg = g.fg
    local bg
    if type(bg_arg) == 'string' and bg_arg:match('^#%x%x%x%x%x%x$') then
      bg = bg_arg
    elseif type(bg_arg) == 'string' and bg_arg ~= '' then
      local gb = get_hl(bg_arg, true)
      bg = gb.bg or gb.fg -- fallback: if group has no bg, try its fg (rare)
      if (not bg) or bg == '' or bg == 'NONE' then
        local n = get_hl('Normal', true)
        bg = n.bg
      end
    else
      local gb = g
      bg = gb.bg
      if (not bg) or bg == '' or bg == 'NONE' then
        local n = get_hl('Normal', true)
        bg = n.bg
      end
    end
    if (not fg) or (not bg) then
      local err = "neg.nvim: can't resolve colors for '" .. name .. "' (fg=" .. tostring(fg) .. ", bg=" .. tostring(bg) .. ")"
      if use_json then
        local payload = vim.json_encode({ error = 'resolve_failed', group = name, fg = fg, bg = bg })
        if use_notify and vim.notify then vim.notify(payload) else print(payload) end
      else
        print(err)
      end
      return
    end
    local ratio = contrast_ratio(fg, bg)
    if not ratio then
      if use_json then
        local payload = vim.json_encode({ error = 'compute_failed', group = name })
        if use_notify and vim.notify then vim.notify(payload) else print(payload) end
      else
        print("neg.nvim: failed to compute contrast for '" .. name .. "'")
      end
      return
    end
    local grade
    if ratio >= 7.0 then grade = 'AAA'
    elseif ratio >= 4.5 then grade = 'AA'
    elseif ratio >= 3.0 then grade = 'AA (large)'
    else grade = 'low' end
    -- Suggest improvements when contrast is not AA
    local function clamp(x, a, b) if x < a then return a elseif x > b then return b else return x end end
    local function lighten(hex, percent)
      local r, g, b = hex_to_rgb(hex); if not r then return hex end
      local k = clamp(tonumber(percent) or 0, 0, 100) / 100
      r = r + (255 - r) * k; g = g + (255 - g) * k; b = b + (255 - b) * k
      return string.format('#%02x%02x%02x', r, g, b)
    end
    local function darken(hex, percent)
      local r, g, b = hex_to_rgb(hex); if not r then return hex end
      local k = 1 - clamp(tonumber(percent) or 0, 0, 100) / 100
      r = r * k; g = g * k; b = b * k
      return string.format('#%02x%02x%02x', r, g, b)
    end
    local function find_suggestion(target)
      local best, best_ratio, best_mode, best_pct
      for _, mode in ipairs({ 'lighten', 'darken' }) do
        for pct = 2, 60, 2 do
          local cand = (mode == 'lighten') and lighten(fg, pct) or darken(fg, pct)
          local r = contrast_ratio(cand, bg)
          if r and r >= target then
            best, best_ratio, best_mode, best_pct = cand, r, mode, pct
            break
          end
        end
        if best then break end
      end
      return best, best_ratio, best_mode, best_pct
    end
    local result = {
      group = name,
      bg_source = bg_arg or 'auto',
      fg = fg,
      bg = bg,
      contrast = tonumber(string.format('%.2f', ratio)),
      grade = grade,
      target = (target_label or 'AA'),
      meets = false,
    }
    local vs_str = bg_arg and (' vs ' .. bg_arg) or ''
    if not use_json then
      local msg = string.format("neg.nvim: %s%s — fg %s on bg %s → contrast %.2f (%s)", name, vs_str, fg, bg, ratio, grade)
      print(msg)
    end
    local target_ratio = 4.5
    if target_label == 'AAA' then target_ratio = 7.0
    elseif target_label == 'AA' or target_label == nil then target_ratio = 4.5
    end
    if ratio >= target_ratio then
      result.meets = true
      if use_json then
        local payload = vim.json_encode(result)
        if use_notify and vim.notify then vim.notify(payload) else print(payload) end
      else
        print(string.format("  · OK: meets target %s (%.1f)", target_label or 'AA', target_ratio))
      end
      return
    end
    local sug_fg, sug_r, sug_mode, sug_pct = find_suggestion(target_ratio)
    if sug_fg and sug_r then
      result.suggestion = { fg = sug_fg, contrast = tonumber(string.format('%.2f', sug_r)), mode = sug_mode, percent = sug_pct }
      if not use_json then
        print(string.format("  · suggestion (%s): set fg=%s (≈%.2f, %s %d%%)", target_label or 'AA', sug_fg, sug_r, sug_mode, sug_pct))
        local hi_line = string.format(":hi %s guifg=%s", name, sug_fg)
        print("    " .. hi_line)
      end
      if apply_now then
        local base = (U.get_hl_colors and U.get_hl_colors(name)) or {}
        local spec = { fg = sug_fg }
        if base.bg then spec.bg = base.bg end
        if base.sp then spec.sp = base.sp end
        hi(0, name, spec)
        if not use_json then print("    applied") end
      end
      if use_json then
        local payload = vim.json_encode(result)
        if use_notify and vim.notify then vim.notify(payload) else print(payload) end
      end
      return
    end
    -- If AAA target unreachable by fg tweak, try suggesting AA as fallback (no auto-apply)
    if target_ratio >= 7.0 then
      local aa_fg, aa_r, aa_mode, aa_pct = find_suggestion(4.5)
      if aa_fg and aa_r then
        result.suggestion = { fg = aa_fg, contrast = tonumber(string.format('%.2f', aa_r)), mode = aa_mode, percent = aa_pct, note = 'AA-fallback' }
        if not use_json then
          print(string.format("  · can't reach AAA by fg alone (<=60%%). Closest AA: fg=%s (≈%.2f, %s %d%%)", aa_fg, aa_r, aa_mode, aa_pct))
          print(string.format("    :hi %s guifg=%s", name, aa_fg))
        end
      else
        result.error = 'no_suggestion'
        if not use_json then print("  · no near fg-only solution found; consider adjusting background or use :NegHc soft|strong") end
      end
    else
      result.error = 'no_suggestion'
      if not use_json then print("  · no near fg-only solution found; consider adjusting background or use :NegHc soft|strong") end
    end
    if use_json then
      local payload = vim.json_encode(result)
      if use_notify and vim.notify then vim.notify(payload) else print(payload) end
    end
  end, {
    nargs = '+',
    complete = function(arglead, cmdline)
      local lead = tostring(arglead or '')
      local args = vim.split(cmdline or '', '%s+', { trimempty = true })
      local flags = { 'apply', '--target=AA', '--target=AAA', '--json', '--notify=off', '--notify=on' }
      if #args <= 2 then
        local groups = vim.fn.getcompletion(lead, 'highlight') or {}
        if lead == '' then
          local res = {}
          for i, v in ipairs(groups) do if i <= 50 then res[#res+1] = v end end
          return res
        end
        return groups
      end
      local line = table.concat(args, ' ')
      if not line:find('%svs%s') and lead ~= '' and lead:lower():find('^v') then return { 'vs' } end
      if lead == 'vs' then return { 'vs' } end
      local saw_vs = false
      for i = 1, #args do if args[i] == 'vs' then saw_vs = true break end end
      if saw_vs and (#args <= 4 or args[#args-1] == 'vs') then
        local groups = vim.fn.getcompletion(lead, 'highlight') or {}
        local out = {}
        if lead == '' or lead:sub(1,1) == '#' then out[#out+1] = '#' end
        for _, g in ipairs(groups) do if lead == '' or g:find(lead, 1, true) == 1 then out[#out+1] = g end end
        return out
      end
      if lead:sub(1,1) == '-' or lead == '' or lead == 'apply' then
        local res = {}
        for _, f in ipairs(flags) do if lead == '' or f:find(lead, 1, true) == 1 then res[#res+1] = f end end
        return res
      end
      return {}
    end,
    desc = 'neg.nvim: Show contrast ratio for a group/capture vs background; supports "vs Group|#hex"'
  })

  vim.api.nvim_create_user_command('NegTelescopeAccents', function(opts)
    local arg = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    local allowed = { on=true, off=true, toggle=true, soft=true, ['default']=true, strong=true }
    if arg == '' then arg = 'toggle' end
    if not allowed[arg] then
      print("neg.nvim: unknown arg '" .. arg .. "'. Use: on|off|toggle|soft|default|strong")
      return
    end
    if arg == 'on' then
      newcfg.ui.telescope_accents = 'default'
    elseif arg == 'off' then
      newcfg.ui.telescope_accents = false
    elseif arg == 'toggle' then
      local cur = cfg.ui and cfg.ui.telescope_accents
      if cur == false or cur == nil then newcfg.ui.telescope_accents = 'default' else newcfg.ui.telescope_accents = false end
    else
      newcfg.ui.telescope_accents = arg
    end
    M.setup(newcfg)
  end, {
    nargs = '?',
    complete = function() return { 'on','off','toggle','soft','default','strong' } end,
    desc = 'neg.nvim: Set Telescope accents (on/off/toggle or soft|default|strong)'
  })

  vim.api.nvim_create_user_command('NegPathSep', function(opts)
    local arg = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if arg == 'on' then
      newcfg.ui.path_separator_blue = true
    elseif arg == 'off' then
      newcfg.ui.path_separator_blue = false
    elseif arg == 'toggle' or arg == '' then
      newcfg.ui.path_separator_blue = not (cfg.ui and cfg.ui.path_separator_blue == true)
    else
      print("neg.nvim: unknown arg '" .. arg .. "'. Use: on|off|toggle")
      return
    end
    M.setup(newcfg)
  end, {
    nargs = '?',
    complete = function() return { 'on', 'off', 'toggle' } end,
    desc = 'neg.nvim: Toggle/Set blue path separators (Startify/Navic/WhichKey)'
  })

  vim.api.nvim_create_user_command('NegPathSepColor', function(opts)
    local arg = tostring(opts.args or '')
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if arg == '' or arg:lower() == 'default' or arg:lower() == 'clear' then
      newcfg.ui.path_separator_color = nil
    else
      newcfg.ui.path_separator_color = arg
    end
    M.setup(newcfg)
    if not (newcfg.ui.path_separator_blue) then
      print('neg.nvim: note — path separators tint is off; use :NegPathSep on')
    end
  end, {
    nargs = '?',
    complete = function(arglead)
      local out = { 'default', 'clear' }
      local ok, pal = pcall(require, 'neg.palette')
      if ok and type(pal) == 'table' then
        for k, v in pairs(pal) do
          if type(k) == 'string' and type(v) == 'string' and v:match('^#%x%x%x%x%x%x$') then
            out[#out+1] = k
          end
        end
      end
      local lead = tostring(arglead or '')
      if lead == '' then return out end
      local res = {}
      for _, v in ipairs(out) do if v:find(lead, 1, true) == 1 then res[#res+1] = v end end
      return res
    end,
    desc = 'neg.nvim: Set path separator color (#rrggbb or palette key); use "default" to clear'
  })

  vim.api.nvim_create_user_command('NegDiagSoft', function()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.diagnostics_virtual_bg = true
    newcfg.diagnostics_virtual_bg_mode = 'blend'
    newcfg.diagnostics_virtual_bg_blend = 20
    M.setup(newcfg)
  end, { desc = 'neg.nvim: Softer diagnostic virtual text backgrounds (blend ~20)' })

  vim.api.nvim_create_user_command('NegDiagStrong', function()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.diagnostics_virtual_bg = true
    newcfg.diagnostics_virtual_bg_mode = 'blend'
    newcfg.diagnostics_virtual_bg_blend = 10
    M.setup(newcfg)
  end, { desc = 'neg.nvim: Stronger diagnostic virtual text backgrounds (blend ~10)' })

  vim.api.nvim_create_user_command('NegLightSigns', function(opts)
    local arg = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if arg == 'on' then
      newcfg.ui.light_signs = true
    elseif arg == 'off' then
      newcfg.ui.light_signs = false
    elseif arg == 'toggle' or arg == '' then
      newcfg.ui.light_signs = not (cfg.ui and cfg.ui.light_signs == true)
    else
      print("neg.nvim: unknown arg '" .. arg .. "'. Use: on|off|toggle")
      return
    end
    M.setup(newcfg)
  end, {
    nargs = '?',
    complete = function() return { 'on', 'off', 'toggle' } end,
    desc = 'neg.nvim: Toggle/Set light signs (DiagnosticSign*/GitSigns*) (on|off|toggle)'
  })

  vim.api.nvim_create_user_command('NegPunctFamily', function(opts)
    local arg = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.treesitter = newcfg.treesitter or {}
    if arg == 'on' then
      newcfg.treesitter.punct_family = true
    elseif arg == 'off' then
      newcfg.treesitter.punct_family = false
    elseif arg == 'toggle' or arg == '' then
      newcfg.treesitter.punct_family = not (cfg.treesitter and cfg.treesitter.punct_family == true)
    else
      print("neg.nvim: unknown arg '" .. arg .. "'. Use: on|off|toggle")
      return
    end
    M.setup(newcfg)
  end, {
    nargs = '?',
    complete = function() return { 'on', 'off', 'toggle' } end,
    desc = 'neg.nvim: Toggle/Set punctuation family differentiation (on|off|toggle)'
  })

  vim.api.nvim_create_user_command('NegAccessibility', function(opts)
    local arg = (opts.args or ''):lower()
    local parts = {}
    for w in arg:gmatch("%S+") do parts[#parts+1] = w end
    local feature = parts[1]
    local state = (parts[2] or 'toggle')
    local features = { deuteranopia=true, achromatopsia=true }
    if not features[feature or ''] then
      print("neg.nvim: unknown feature '" .. tostring(feature) .. "'. Use: deuteranopia|achromatopsia [on|off|toggle]")
      return
    end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    newcfg.ui.accessibility = vim.tbl_deep_extend('force', { deuteranopia=false }, newcfg.ui.accessibility or {})
    local cur = newcfg.ui.accessibility[feature] == true
    if state == 'on' then newcfg.ui.accessibility[feature] = true
    elseif state == 'off' then newcfg.ui.accessibility[feature] = false
    elseif state == 'toggle' or state == '' then newcfg.ui.accessibility[feature] = not cur
    else
      print("neg.nvim: unknown arg '" .. state .. "'. Use: on|off|toggle")
      return
    end
    M.setup(newcfg)
  end, {
    nargs = '*',
    complete = function(_, line)
      local toks = {}
      for w in line:gmatch('%S+') do toks[#toks+1] = w end
      if #toks <= 2 then return { 'deuteranopia', 'achromatopsia' } end
      return { 'on', 'off', 'toggle' }
    end,
    desc = 'neg.nvim: Accessibility toggles: deuteranopia|achromatopsia [on|off|toggle]'
  })

  vim.api.nvim_create_user_command('NegDiagPattern', function(opts)
    local m = (opts.args or ''):lower()
    local allowed = { none=true, minimal=true, strong=true }
    if not allowed[m] then
      print("neg.nvim: unknown mode '" .. m .. "'. Use: none|minimal|strong")
      return
    end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    newcfg.ui.diag_pattern = m
    M.setup(newcfg)
  end, { nargs = 1, complete = function() return { 'none','minimal','strong' } end, desc = 'neg.nvim: Set diagnostics pattern preset' })

  vim.api.nvim_create_user_command('NegLexemeCues', function(opts)
    local m = (opts.args or ''):lower()
    local allowed = { off=true, minimal=true, strong=true }
    if not allowed[m] then
      print("neg.nvim: unknown mode '" .. m .. "'. Use: off|minimal|strong")
      return
    end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    newcfg.ui.lexeme_cues = m
    M.setup(newcfg)
  end, { nargs = 1, complete = function() return { 'off','minimal','strong' } end, desc = 'neg.nvim: Set lexeme cues strength' })

  vim.api.nvim_create_user_command('NegThickCursor', function(opts)
    local a = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if a == 'on' then newcfg.ui.thick_cursor = true
    elseif a == 'off' then newcfg.ui.thick_cursor = false
    else newcfg.ui.thick_cursor = not (cfg.ui and cfg.ui.thick_cursor == true) end
    M.setup(newcfg)
  end, { nargs = '?', complete = function() return { 'on','off','toggle' } end, desc = 'neg.nvim: Toggle/Set thick cursor mode' })

  vim.api.nvim_create_user_command('NegOutlines', function(opts)
    local a = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if a == 'on' then newcfg.ui.outlines = true
    elseif a == 'off' then newcfg.ui.outlines = false
    else newcfg.ui.outlines = not (cfg.ui and cfg.ui.outlines == true) end
    M.setup(newcfg)
  end, { nargs = '?', complete = function() return { 'on','off','toggle' } end, desc = 'neg.nvim: Toggle/Set UI outlines' })

  vim.api.nvim_create_user_command('NegReadingMode', function(opts)
    local a = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if a == 'on' then newcfg.ui.reading_mode = true
    elseif a == 'off' then newcfg.ui.reading_mode = false
    else newcfg.ui.reading_mode = not (cfg.ui and cfg.ui.reading_mode == true) end
    M.setup(newcfg)
  end, { nargs = '?', complete = function() return { 'on','off','toggle' } end, desc = 'neg.nvim: Toggle/Set reading mode' })

  vim.api.nvim_create_user_command('NegSearchVisibility', function(opts)
    local m = (opts.args or ''):lower()
    local allowed = { default=true, soft=true, strong=true }
    if not allowed[m] then
      print("neg.nvim: unknown mode '" .. m .. "'. Use: default|soft|strong")
      return
    end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    newcfg.ui.search_visibility = m
    M.setup(newcfg)
  end, { nargs = 1, complete = function() return { 'default','soft','strong' } end, desc = 'neg.nvim: Set search visibility preset' })

  vim.api.nvim_create_user_command('NegHc', function(opts)
    local m = (opts.args or ''):lower()
    local allowed = { off=true, soft=true, strong=true }
    if not allowed[m] then
      print("neg.nvim: unknown mode '" .. m .. "'. Use: off|soft|strong")
      return
    end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    newcfg.ui.accessibility = vim.tbl_deep_extend('force', { hc='off' }, newcfg.ui.accessibility or {})
    newcfg.ui.accessibility.hc = m
    M.setup(newcfg)
  end, { nargs = 1, complete = function() return { 'off','soft','strong' } end, desc = 'neg.nvim: Set high-contrast pack (achromatopsia extension)' })
  vim.api.nvim_create_user_command('NegNumberColors', function(opts)
    local mode = (opts.args or ''):lower()
    local allowed = {
      mono = true, ramp = true,
      ['ramp-soft'] = true, ['ramp:soft'] = true,
      ['ramp-balanced'] = true, ['ramp:balanced'] = true,
      ['ramp-strong'] = true, ['ramp:strong'] = true,
    }
    if not allowed[mode] then
      print("neg.nvim: unknown mode '" .. mode .. "'. Use: mono|ramp|ramp-soft|ramp-strong")
      return
    end
    if mode == 'ramp:soft' then mode = 'ramp-soft' end
    if mode == 'ramp:balanced' then mode = 'ramp' end
    if mode == 'ramp:strong' then mode = 'ramp-strong' end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.number_colors = mode
    M.setup(newcfg)
  end, {
    nargs = 1,
    complete = function() return { 'mono', 'ramp', 'ramp-soft', 'ramp-strong' } end,
    desc = 'neg.nvim: Set number colors (mono|ramp|ramp-soft|ramp-strong)'
  })

  vim.api.nvim_create_user_command('NegSaturation', function(opts)
    local v = tonumber(opts.args)
    if not v then
      print("neg.nvim: saturation must be a number in 0..100")
      return
    end
    if v < 0 then v = 0 end
    if v > 100 then v = 100 end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.saturation = v
    M.setup(newcfg)
  end, { nargs = 1, complete = function() return { '0','25','50','75','100' } end, desc = 'neg.nvim: Set global saturation (0..100); 100 = original palette' })

  vim.api.nvim_create_user_command('NegAlpha', function(opts)
    local v = tonumber(opts.args)
    if not v then
      print("neg.nvim: alpha must be a number in 0..30")
      return
    end
    if v < 0 then v = 0 end
    if v > 30 then v = 30 end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.alpha_overlay = v
    M.setup(newcfg)
  end, { nargs = 1, complete = function() return { '0','5','10','15','20','25','30' } end, desc = 'neg.nvim: Set global soft backgrounds alpha (0..30) for Search/Visual/VirtualText' })

  -- Quick scenarios: apply curated combos beyond presets
  -- Usage: :NegScenario {focus|presentation|screenreader|tui|gui|accessibility}
  vim.api.nvim_create_user_command('NegScenario', function(opts)
    local s = (opts.args or ''):lower()
    local allowed = { focus=true, presentation=true, screenreader=true, tui=true, gui=true, accessibility=true }
    if not allowed[s] then
      print("neg.nvim: unknown scenario '" .. s .. "'. Use: focus|presentation|screenreader|tui|gui|accessibility")
      return
    end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    if s == 'focus' then
      newcfg.preset = 'focus'
      newcfg.ui = vim.tbl_deep_extend('force', newcfg.ui or {}, { selection_model = 'kitty', telescope_accents = false })
    elseif s == 'presentation' then
      newcfg.preset = 'presentation'
      newcfg.number_colors = 'ramp-strong'
      newcfg.operator_colors = 'mono+'
      newcfg.ui = vim.tbl_deep_extend('force', newcfg.ui or {}, {
        mode_accent = false, focus_caret = false, soft_borders = true,
        search_visibility = 'strong', telescope_accents = false, diff_focus = false,
      })
    elseif s == 'screenreader' then
      newcfg.preset = nil
      newcfg.alpha_overlay = 0
      newcfg.ui = vim.tbl_deep_extend('force', newcfg.ui or {}, {
        screenreader_friendly = true, mode_accent = false, focus_caret = false,
        diff_focus = false, search_visibility = 'soft', selection_model = 'kitty',
        accessibility = vim.tbl_deep_extend('force', newcfg.ui and newcfg.ui.accessibility or {}, {
          achromatopsia = true, hc = 'soft'
        }),
      })
    elseif s == 'tui' then
      newcfg.alpha_overlay = 0
      newcfg.ui = vim.tbl_deep_extend('force', newcfg.ui or {}, {
        thick_cursor = true, soft_borders = false, float_panel_bg = false,
        diff_focus = true, light_signs = true, outlines = false,
        telescope_accents = false, selection_model = 'kitty',
      })
    elseif s == 'gui' then
      newcfg.saturation = 95
      newcfg.alpha_overlay = 6
      newcfg.ui = vim.tbl_deep_extend('force', newcfg.ui or {}, {
        soft_borders = true, float_panel_bg = true, telescope_accents = true,
        dim_inactive = false, outlines = false, selection_model = 'kitty', focus_caret = true,
      })
    elseif s == 'accessibility' then
      newcfg.preset = 'accessibility'
      newcfg.ui = vim.tbl_deep_extend('force', newcfg.ui or {}, {
        accessibility = vim.tbl_deep_extend('force', newcfg.ui and newcfg.ui.accessibility or {}, { achromatopsia = true, hc = 'soft' }),
      })
    end
    M.setup(newcfg)
  end, { nargs = 1, complete = function() return { 'focus','presentation','screenreader','tui','gui','accessibility' } end, desc = 'neg.nvim: Apply quick scenario: focus|presentation|screenreader|tui|gui|accessibility' })

  -- Scenario management: save/list/delete/export/import
  vim.api.nvim_create_user_command('NegScenarioSave', function(opts)
    local name = (opts.args or ''):lower()
    if name == '' then
      print("neg.nvim: usage: :NegScenarioSave {name}")
      return
    end
    local cfg = M._config or default_config
    M._scenarios[name] = pick_scenario_fields(cfg)
    print("neg.nvim: scenario saved: " .. name)
  end, {
    nargs = 1,
    complete = function(arglead)
      local builtins = { 'focus','presentation','screenreader','tui','gui','accessibility' }
      local names = {}
      for _, v in ipairs(builtins) do names[#names+1] = v end
      for k, _ in pairs(M._scenarios or {}) do names[#names+1] = k end
      table.sort(names)
      local lead = tostring(arglead or '')
      if lead == '' then return names end
      local res = {}
      for _, v in ipairs(names) do if v:find(lead, 1, true) == 1 then res[#res+1] = v end end
      return res
    end,
    desc = 'neg.nvim: Save current config to a named scenario (memory)'
  })

  vim.api.nvim_create_user_command('NegScenarioList', function()
    local builtins = { 'focus','presentation','screenreader','tui','gui','accessibility' }
    table.sort(builtins)
    local names = {}
    for k, _ in pairs(M._scenarios or {}) do names[#names+1] = k end
    table.sort(names)
    print('neg.nvim scenarios — built-in: ' .. table.concat(builtins, ', '))
    print('user: ' .. (#names > 0 and table.concat(names, ', ') or '—'))
  end, { desc = 'neg.nvim: List built-in and user scenarios' })

  vim.api.nvim_create_user_command('NegScenarioDelete', function(opts)
    local name = (opts.args or ''):lower()
    if name == '' then
      print("neg.nvim: usage: :NegScenarioDelete {name}")
      return
    end
    if M._scenarios and M._scenarios[name] then
      M._scenarios[name] = nil
      print('neg.nvim: scenario deleted: ' .. name)
    else
      print('neg.nvim: scenario not found: ' .. name)
    end
  end, {
    nargs = 1,
    complete = function(arglead)
      local names = {}
      for k, _ in pairs(M._scenarios or {}) do names[#names+1] = k end
      table.sort(names)
      local lead = tostring(arglead or '')
      if lead == '' then return names end
      local res = {}
      for _, v in ipairs(names) do if v:find(lead, 1, true) == 1 then res[#res+1] = v end end
      return res
    end,
    desc = 'neg.nvim: Delete saved user scenario (memory)'
  })

  vim.api.nvim_create_user_command('NegScenarioExport', function(opts)
    local raw = (opts.args or '')
    local tokens = {}
    for t in string.gmatch(raw, "[^%s]+") do tokens[#tokens+1] = t end
    local name = tokens[1] or 'current'
    local use_json, use_notify = true, false
    for i = 2, #tokens do
      local t = tokens[i]
      if t == '--json' then use_json = true
      elseif t:match('^%-%-notify=') or t == '--notify' then
        local val = nil
        if t == '--notify' and tokens[i+1] and tokens[i+1]:match('^(on|off)$') then val = tokens[i+1] end
        val = val or t:match('^%-%-notify=(.+)$')
        if val then use_notify = (val == 'on') end
      end
    end
    local obj
    if name == 'current' then
      obj = pick_scenario_fields(M._config or default_config)
    else
      name = name:lower()
      if M._scenarios and M._scenarios[name] then obj = deepcopy_tbl(M._scenarios[name]) end
    end
    if not obj then
      local payload = vim.json_encode({ error = 'not_found', name = name })
      if use_notify and vim.notify then vim.notify(payload) else print(payload) end
      return
    end
    local payload = vim.json_encode({ name = name, scenario = obj })
    if use_notify and vim.notify then vim.notify(payload) else print(payload) end
  end, {
    nargs = '*',
    complete = function(arglead)
      local out = { 'current', '--json', '--notify=off', '--notify=on' }
      for k, _ in pairs(M._scenarios or {}) do out[#out+1] = k end
      table.sort(out)
      local lead = tostring(arglead or '')
      if lead == '' then return out end
      local res = {}
      for _, v in ipairs(out) do if v:find(lead, 1, true) == 1 then res[#res+1] = v end end
      return res
    end,
    desc = 'neg.nvim: Export scenario JSON (name or "current")'
  })

  vim.api.nvim_create_user_command('NegScenarioImport', function(opts)
    local raw = (opts.args or '')
    if raw == '' then
      print("neg.nvim: usage: :NegScenarioImport {@/path|JSON} [--merge|--replace] [--notify=off|on]")
      return
    end
    local mode = 'merge'
    local use_notify = true
    -- Separate main blob from flags
    local blob, rest = raw:match('^(%S+)%s*(.*)$')
    for t in string.gmatch(rest or '', "[^%s]+") do
      if t == '--merge' then mode = 'merge'
      elseif t == '--replace' then mode = 'replace'
      elseif t:match('^%-%-notify=') or t == '--notify' then
        local val = nil
        if t == '--notify' then val = 'on' end
        val = val or t:match('^%-%-notify=(.+)$')
        if val then use_notify = (val == 'on') end
      end
    end
    local text
    if blob:sub(1,1) == '@' then
      local path = blob:sub(2)
      local ok, data = pcall(vim.fn.readfile, path)
      if not ok then print('neg.nvim: failed to read file: ' .. path); return end
      text = table.concat(data or {}, '\n')
    else
      text = blob
    end
    local decoded = nil
    local ok, obj = pcall(vim.json_decode, text)
    if ok and type(obj) == 'table' then
      -- Accept wrapped { name, scenario } or plain scenario
      if obj.scenario and type(obj.scenario) == 'table' then decoded = obj.scenario else decoded = obj end
    end
    if not decoded then
      local payload = vim.json_encode({ error = 'decode_failed' })
      if use_notify and vim.notify then vim.notify(payload) else print(payload) end
      return
    end
    apply_scenario_tbl(decoded, mode)
    if use_notify and vim.notify then vim.notify('neg.nvim: scenario imported (' .. mode .. ')') else print('neg.nvim: scenario imported (' .. mode .. ')') end
  end, {
    nargs = '+',
    complete = function(arglead, cmdline)
      local lead = tostring(arglead or '')
      local out = { '--merge', '--replace', '--notify=off', '--notify=on' }
      if lead:sub(1,1) == '@' then
        local pat = lead:sub(2)
        local files = vim.fn.getcompletion(pat, 'file') or {}
        local res = {}
        for _, f in ipairs(files) do res[#res+1] = '@' .. f end
        return res
      end
      local toks = {}
      for w in tostring(cmdline or ''):gmatch('%S+') do toks[#toks+1] = w end
      if #toks <= 2 then return out end
      local res = {}
      for _, v in ipairs(out) do if v:find(lead, 1, true) == 1 then res[#res+1] = v end end
      return res
    end,
    desc = 'neg.nvim: Import scenario from JSON string or file (@/path); merge or replace'
  })

  -- ScenarioWrite: persist all user scenarios to a JSON file
  -- Usage: :NegScenarioWrite [@/path] [--notify=off|on]
  vim.api.nvim_create_user_command('NegScenarioWrite', function(opts)
    local raw = (opts.args or '')
    local tokens = {}
    for t in string.gmatch(raw, "[^%s]+") do tokens[#tokens+1] = t end
    local dest = tokens[1]
    local use_notify = true
    for i = 2, #tokens do
      local t = tokens[i]
      if t:match('^%-%-notify=') or t == '--notify' then
        local val = nil
        if t == '--notify' and tokens[i+1] and tokens[i+1]:match('^(on|off)$') then val = tokens[i+1] end
        val = val or t:match('^%-%-notify=(.+)$')
        if val then use_notify = (val == 'on') end
      end
    end
    local path
    if dest and dest:sub(1,1) == '@' then path = dest:sub(2) end
    path = path or default_scenarios_path()
    local data = { scenarios = M._scenarios or {}, version = (M and M._config and '4.x') or '4.x' }
    local ok_json, payload = pcall(function() return vim.json_encode(data) end)
    if not ok_json then
      local msg = 'neg.nvim: failed to encode scenarios'
      if use_notify and vim.notify then vim.notify(msg) else print(msg) end
      return
    end
    -- ensure dir exists
    local dir = vim.fn.fnamemodify(path, ':h')
    pcall(vim.fn.mkdir, dir, 'p')
    local ok_write = pcall(vim.fn.writefile, { payload }, path)
    local msg = ok_write and ('neg.nvim: scenarios written to ' .. path) or ('neg.nvim: failed to write ' .. path)
    if use_notify and vim.notify then vim.notify(msg) else print(msg) end
  end, {
    nargs = '*',
    complete = function(arglead)
      local lead = tostring(arglead or '')
      local flags = { '--notify=off', '--notify=on' }
      if lead:sub(1,1) == '@' then
        local pat = lead:sub(2)
        local files = vim.fn.getcompletion(pat, 'file') or {}
        local res = {}
        for _, f in ipairs(files) do res[#res+1] = '@' .. f end
        return res
      end
      local res = {}
      for _, v in ipairs(flags) do if v:find(lead, 1, true) == 1 then res[#res+1] = v end end
      return res
    end,
    desc = 'neg.nvim: Write user scenarios to JSON (@path optional; defaults to stdpath(\'config\')/neg/scenarios.json)'
  })

  -- ScenarioRead: load scenarios from JSON file into memory (merge/replace)
  -- Usage: :NegScenarioRead [@/path] [--merge|--replace] [--notify=off|on]
  vim.api.nvim_create_user_command('NegScenarioRead', function(opts)
    local raw = (opts.args or '')
    local tokens = {}
    for t in string.gmatch(raw, "[^%s]+") do tokens[#tokens+1] = t end
    local src = tokens[1]
    local mode, use_notify = 'merge', true
    for i = 2, #tokens do
      local t = tokens[i]
      if t == '--merge' then mode = 'merge' end
      if t == '--replace' then mode = 'replace' end
      if t:match('^%-%-notify=') or t == '--notify' then
        local val = nil
        if t == '--notify' and tokens[i+1] and tokens[i+1]:match('^(on|off)$') then val = tokens[i+1] end
        val = val or t:match('^%-%-notify=(.+)$')
        if val then use_notify = (val == 'on') end
      end
    end
    local path
    if src and src:sub(1,1) == '@' then path = src:sub(2) end
    path = path or default_scenarios_path()
    local ok_read, lines = pcall(vim.fn.readfile, path)
    if not ok_read then
      local msg = 'neg.nvim: failed to read ' .. path
      if use_notify and vim.notify then vim.notify(msg) else print(msg) end
      return
    end
    local text = table.concat(lines or {}, '\n')
    local ok_json, obj = pcall(vim.json_decode, text)
    if not ok_json or type(obj) ~= 'table' then
      local msg = 'neg.nvim: failed to decode scenarios JSON'
      if use_notify and vim.notify then vim.notify(msg) else print(msg) end
      return
    end
    local incoming = obj.scenarios or obj
    if type(incoming) ~= 'table' then incoming = {} end
    if mode == 'replace' then
      M._scenarios = incoming
    else
      M._scenarios = M._scenarios or {}
      for k, v in pairs(incoming) do M._scenarios[k] = v end
    end
    local msg = ('neg.nvim: scenarios loaded (%s) from %s'):format(mode, path)
    if use_notify and vim.notify then vim.notify(msg) else print(msg) end
  end, {
    nargs = '*',
    complete = function(arglead)
      local lead = tostring(arglead or '')
      local out = { '--merge', '--replace', '--notify=off', '--notify=on' }
      if lead:sub(1,1) == '@' then
        local pat = lead:sub(2)
        local files = vim.fn.getcompletion(pat, 'file') or {}
        local res = {}
        for _, f in ipairs(files) do res[#res+1] = '@' .. f end
        return res
      end
      if lead == '' then return out end
      local res = {}
      for _, v in ipairs(out) do if v:find(lead, 1, true) == 1 then res[#res+1] = v end end
      return res
    end,
    desc = 'neg.nvim: Read scenarios from JSON (@path optional; merge or replace memory)'
  })

  vim.api.nvim_create_user_command('NegOperatorColors', function(opts)
    local mode = (opts.args or ''):lower()
    local allowed = { families = true, mono = true, ['mono+'] = true, ['mono_plus'] = true }
    if not allowed[mode] then
      print("neg.nvim: unknown mode '" .. mode .. "'. Use: families|mono|mono+")
      return
    end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    if mode == 'mono_plus' then mode = 'mono+' end
    newcfg.operator_colors = mode
  M.setup(newcfg)
  end, {
    nargs = 1,
    complete = function() return { 'families', 'mono', 'mono+' } end,
    desc = 'neg.nvim: Set operator colors mode (families|mono|mono+)'
  })

  vim.api.nvim_create_user_command('NegSelection', function(opts)
    local m = (opts.args or ''):lower()
    local allowed = { default = true, kitty = true }
    if not allowed[m] then
      print("neg.nvim: unknown selection model '" .. m .. "'. Use: default|kitty")
      return
    end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    newcfg.ui.selection_model = m
    M.setup(newcfg)
  end, { nargs = 1, complete = function() return { 'default','kitty' } end, desc = 'neg.nvim: Set selection model (default|kitty)' })

  -- Export highlights; supports section selection and JSON
  -- Usage: :NegExport [all|core|diff|diagnostics|syntax|hints] [--json] [--notify=off|on]
  -- Multiple sections can be comma-separated (e.g., core,diagnostics)
  vim.api.nvim_create_user_command('NegExport', function(opts)
    local function get_hl(name_, follow)
      local function as_hex(v)
        if type(v) == 'number' then return string.format('#%06x', v) end
        if type(v) == 'string' then return v end
        return nil
      end
      if type(vim.api.nvim_get_hl) == 'function' then
        local ok, t = pcall(vim.api.nvim_get_hl, 0, { name = name_, link = follow and true or false })
        if ok and type(t) == 'table' then
          return { fg = as_hex(t.fg), bg = as_hex(t.bg), sp = as_hex(t.sp) }
        end
      end
      if type(vim.api.nvim_get_hl_by_name) == 'function' then
        local ok2, t2 = pcall(vim.api.nvim_get_hl_by_name, name_, true)
        if ok2 and type(t2) == 'table' then
          return { fg = as_hex(t2.foreground), bg = as_hex(t2.background), sp = as_hex(t2.special) }
        end
      end
      return {}
    end
    local function fmt(name, t)
      local fg = t.fg or 'NONE'
      local bg = t.bg or 'NONE'
      local sp = t.sp or 'NONE'
      return string.format('%-28s fg=%-9s bg=%-9s sp=%-9s', name, fg, bg, sp)
    end
    local function header(title) print(('== %s =='):format(title)) end
    -- Parse args
    local args = (opts.args or '')
    local use_json, use_notify = false, true
    local sections = { core=true, diff=true, diagnostics=true, syntax=true, hints=true }
    if args and args ~= '' then
      local toks = {}
      for t in string.gmatch(args, "[^%s]+") do toks[#toks+1] = t end
      for _, t in ipairs(toks) do
        if t == '--json' then use_json = true
        elseif t:match('^%-%-notify=') or t == '--notify' then
          local val = nil
          if t == '--notify' then val = toks[_+1] end
          val = val or t:match('^%-%-notify=(.+)$')
          if val then use_notify = (val == 'on') end
        else
          local sel = t:lower()
          if sel == 'all' then sections = { core=true, diff=true, diagnostics=true, syntax=true, hints=true }
          else
            -- allow comma-separated
            local picked = {}
            for part in sel:gmatch("[^,]+") do picked[#picked+1] = part end
            sections = { core=false, diff=false, diagnostics=false, syntax=false, hints=false }
            for _, s in ipairs(picked) do if sections[s] ~= nil then sections[s] = true end end
          end
        end
      end
    end

    local cfg = M._config or default_config
    local summary_tbl = {
      saturation = cfg.saturation,
      alpha_overlay = cfg.alpha_overlay,
      operator_colors = cfg.operator_colors,
      number_colors = cfg.number_colors,
      ui = {
        mode_accent = cfg.ui and cfg.ui.mode_accent or false,
        soft_borders = cfg.ui and cfg.ui.soft_borders or false,
        dim_inactive = cfg.ui and cfg.ui.dim_inactive or false,
        diff_focus = cfg.ui and cfg.ui.diff_focus or false,
      },
    }

    local function collect(names)
      local arr = {}
      for _, g in ipairs(names) do
        local t = get_hl(g, true)
        arr[#arr+1] = { name = g, fg = t.fg or 'NONE', bg = t.bg or 'NONE', sp = t.sp or 'NONE' }
      end
      return arr
    end

    local out = { config = summary_tbl, sections = {} }

    if sections.core then
      out.sections.core = collect({ 'Normal','NormalNC','NormalFloat','StatusLine','StatusLineNC','Title','Underlined','WinBar','WinBarNC','VertSplit','WinSeparator','FloatBorder','LineNr','CursorLine','CursorLineNr','ColorColumn','CursorColumn','Visual','SignColumn','FoldColumn','NonText','Whitespace','EndOfBuffer','Search','CurSearch','IncSearch','Pmenu','PmenuSel','PmenuThumb','QuickFixLine','Substitute' })
    end
    if sections.diff then
      out.sections.diff = collect({ 'DiffAdd','DiffChange','DiffDelete','DiffText' })
    end
    if sections.diagnostics then
      out.sections.diagnostics = collect({ 'DiagnosticError','DiagnosticWarn','DiagnosticInfo','DiagnosticHint','DiagnosticOk','DiagnosticVirtualTextError','DiagnosticVirtualTextWarn','DiagnosticVirtualTextInfo','DiagnosticVirtualTextHint','DiagnosticVirtualTextOk' })
    end
    if sections.syntax then
      out.sections.syntax = collect({ '@comment','@keyword','@function','@method','@type','@type.builtin','@string','@number','@boolean','@operator','@constant','@variable','@property','@field','@namespace','@tag','@punctuation.bracket','@punctuation.delimiter','@punctuation.special','@markup.heading.1','@markup.link','@markup.math' })
    end
    -- Hints
    local function hex_to_rgb(hex)
      if type(hex) ~= 'string' or not hex:match('^#%x%x%x%x%x%x$') then return nil end
      return tonumber(hex:sub(2,3),16), tonumber(hex:sub(4,5),16), tonumber(hex:sub(6,7),16)
    end
    local function srgb_to_linear(c) c = c/255; if c <= 0.03928 then return c/12.92 end; return ((c + 0.055)/1.055)^2.4 end
    local function rel_luminance(hex)
      local r, g, b = hex_to_rgb(hex); if not r then return nil end
      r, g, b = srgb_to_linear(r), srgb_to_linear(g), srgb_to_linear(b)
      return 0.2126*r + 0.7152*g + 0.0722*b
    end
    local function contrast_ratio(fg, bg)
      local L1 = rel_luminance(fg); local L2 = rel_luminance(bg)
      if not L1 or not L2 then return nil end
      if L1 < L2 then L1, L2 = L2, L1 end
      return (L1 + 0.05) / (L2 + 0.05)
    end
    local hints = {}
    do
      local low = {}
      for _, g in ipairs({ 'DiffAdd','DiffChange','DiffDelete','DiffText' }) do
        local t = get_hl(g, true)
        local bg = t.bg
        local r = (bg and bg ~= 'NONE') and contrast_ratio('#ffffff', bg) or nil
        if (not bg) or bg == 'NONE' or (r and r < 1.20) then low[#low+1] = g end
      end
      if #low > 0 then hints[#hints+1] = 'diff tips: backgrounds for ' .. table.concat(low, ', ') .. ' may be too soft; try :NegDiffFocus on' end
      local s = get_hl('Search', true)
      if (not s.bg or s.bg == 'NONE') then hints[#hints+1] = 'search tips: try :NegAlpha 8 or :NegSearchVisibility soft|strong' end
    end
    if sections.hints then out.sections.hints = { messages = hints } end

    if use_json then
      local ok_json, enc = pcall(function() return vim.json_encode(out) end)
      local payload = ok_json and enc or ('{"error":"json_encode_failed"}')
      if use_notify then
        local ok_notify, _ = pcall(require, 'notify')
        if ok_notify and vim.notify then vim.notify(payload) else print(payload) end
      else
        print(payload)
      end
      return
    end

    -- Textual output
    print('neg.nvim export — current highlight colors')
    do
      local s = summary_tbl
      local summary = (
        'config: saturation=%s alpha_overlay=%s operator_colors=%s number_colors=%s\n' ..
        '        ui.mode_accent=%s ui.soft_borders=%s ui.dim_inactive=%s ui.diff_focus=%s'
      ):format(
        tostring(s.saturation), tostring(s.alpha_overlay), tostring(s.operator_colors), tostring(s.number_colors),
        tostring(s.ui.mode_accent), tostring(s.ui.soft_borders), tostring(s.ui.dim_inactive), tostring(s.ui.diff_focus)
      )
      print(summary)
    end
    if sections.core then
      header('Core UI')
      for _, e in ipairs(out.sections.core or {}) do print(fmt(e.name, { fg = e.fg, bg = e.bg, sp = e.sp })) end
    end
    if sections.diff then
      header('Diff')
      for _, e in ipairs(out.sections.diff or {}) do print(fmt(e.name, { fg = e.fg, bg = e.bg, sp = e.sp })) end
    end
    if sections.diagnostics then
      header('Diagnostics')
      for _, e in ipairs(out.sections.diagnostics or {}) do print(fmt(e.name, { fg = e.fg, bg = e.bg, sp = e.sp })) end
    end
    if sections.syntax then
      header('Syntax (TS)')
      for _, e in ipairs(out.sections.syntax or {}) do print(fmt(e.name, { fg = e.fg, bg = e.bg, sp = e.sp })) end
    end
    if sections.hints then
      header('Hints')
      for _, m in ipairs(hints) do print('· ' .. m) end
    end
  end, {
    nargs = '*',
    complete = function(arglead, cmdline)
      local sections = { 'all','core','diff','diagnostics','syntax','hints' }
      local flags = { '--json', '--notify=off', '--notify=on' }
      local lead = tostring(arglead or '')
      local toks = {}
      for w in tostring(cmdline or ''):gmatch('%S+') do toks[#toks+1] = w end
      local last = toks[#toks] or ''
      if lead:sub(1,1) == '-' or last:sub(1,1) == '-' then
        local res = {}
        for _, f in ipairs(flags) do if f:find(lead, 1, true) == 1 then res[#res+1] = f end end
        return res
      end
      local picked = {}
      for part in (last or ''):gmatch('[^,]+') do picked[part] = true end
      local base = {}
      for _, s in ipairs(sections) do if not picked[s] then base[#base+1] = s end end
      if lead == '' and last:find(',') then return base end
      local res = {}
      for _, s in ipairs(base) do if s:find(lead, 1, true) == 1 then res[#res+1] = s end end
      return (#res > 0) and res or sections
    end,
    desc = 'neg.nvim: Export highlights (supports sections + --json + --notify)'
  })

  -- List plugin integrations and their state
  -- Usage: :NegPlugins [enabled|disabled|all] [filter] [--json] [--notify=off|on]
  -- Example: :NegPlugins enabled | :NegPlugins disabled | :NegPlugins all neo --json
  vim.api.nvim_create_user_command('NegPlugins', function(opts)
    local cfg = M._config or default_config
    local plugs = cfg.plugins or {}
    local args = (opts.args or '')
    local state, filter = 'all', nil
    local use_json, use_notify = false, true
    local tokens = {}
    for t in string.gmatch(args, "[^%s]+") do tokens[#tokens+1] = t end
    local function take_state(tok)
      tok = (tok or ''):lower()
      if tok == 'enabled' or tok == 'disabled' or tok == 'all' then state = tok; return true end
      return false
    end
    local i = 1
    while i <= #tokens do
      local t = tokens[i]
      if t == '--json' then use_json = true; i = i + 1
      elseif t:match('^%-%-notify=') or t == '--notify' then
        local val = nil
        if t == '--notify' then
          if tokens[i+1] and tokens[i+1]:match('^(on|off)$') then val = tokens[i+1]; i = i + 1 end
        else
          val = t:match('^%-%-notify=(.+)$')
        end
        if val then use_notify = (val == 'on') end
        i = i + 1
      elseif take_state(t) and not filter then
        i = i + 1
      elseif not filter then
        filter = t:lower(); i = i + 1
      else
        i = i + 1
      end
    end
    local on, off = {}, {}
    for k, v in pairs(plugs) do
      local is_on = not (v == false)
      local name = tostring(k)
      local pass = (not filter) or name:lower():find(filter, 1, true) ~= nil
      if pass then
        if is_on then on[#on+1] = name else off[#off+1] = name end
      end
    end
    table.sort(on); table.sort(off)
    if use_json then
      local out = {
        state = state,
        filter = filter,
        enabled = on,
        disabled = off,
        enabled_count = #on,
        disabled_count = #off,
        total = (#on + #off),
      }
      local ok_json, enc = pcall(function() return vim.json_encode(out) end)
      local payload = ok_json and enc or ('{"error":"json_encode_failed"}')
      -- For JSON output, default to print unless explicitly forced via --notify=on
      if use_notify then
        local ok_notify, _ = pcall(require, 'notify')
        if ok_notify and vim.notify then vim.notify(payload) else print(payload) end
      else
        print(payload)
      end
    else
      local function join(tbl) return (#tbl > 0) and table.concat(tbl, ', ') or '—' end
      local lines = {}
      lines[#lines+1] = ('neg.nvim plugins — enabled: %d, disabled: %d, total: %d%s')
        :format(#on, #off, (#on + #off), (filter and (' (filter: ' .. filter .. ')') or ''))
      if state == 'all' or state == 'enabled' then lines[#lines+1] = 'enabled: ' .. join(on) end
      if state == 'all' or state == 'disabled' then lines[#lines+1] = 'disabled: ' .. join(off) end
      local ok_notify, _ = pcall(require, 'notify')
      local msg = table.concat(lines, '\n')
      if use_notify and ok_notify and vim.notify then vim.notify(msg) else print(msg) end
    end
  end, {
    nargs = '*',
    complete = function(arglead, cmdline)
      local lead = tostring(arglead or '')
      local args = vim.split(cmdline or '', '%s+', { trimempty = true })
      local flags = { '--json', '--notify=off', '--notify=on' }
      local states = { 'enabled', 'disabled', 'all' }
      local cfg = M._config or default_config
      local plugs = {}
      if cfg and cfg.plugins then for k, _ in pairs(cfg.plugins) do plugs[#plugs+1] = tostring(k) end end
      table.sort(plugs)
      if #args <= 2 then
        local pool = {}
        for _, v in ipairs(states) do pool[#pool+1] = v end
        for _, v in ipairs(flags) do pool[#pool+1] = v end
        local res = {}
        for _, v in ipairs(pool) do if v:find(lead, 1, true) == 1 then res[#res+1] = v end end
        return res
      end
      if lead:sub(1,1) == '-' then
        local res = {}
        for _, v in ipairs(flags) do if v:find(lead, 1, true) == 1 then res[#res+1] = v end end
        return res
      end
      local res = {}
      for _, v in ipairs(plugs) do if v:find(lead, 1, true) == 1 then res[#res+1] = v end end
      return (#res > 0) and res or plugs
    end,
    desc = 'neg.nvim: List plugin integrations and their state (filterable, --json, --notify=off|on)'
  })

  -- Suggest a ready 'plugins = { ... }' block based on installed lazy plugins
  -- Usage: :NegPluginsSuggest [--json] [--notify=off|on]
  vim.api.nvim_create_user_command('NegPluginsSuggest', function(opts)
    local args = (opts.args or '')
    local use_json, use_notify = false, true
    for t in string.gmatch(args, "[^%s]+") do
      if t == '--json' then use_json = true end
      if t:match('^%-%-notify=') then use_notify = (t:match('=on$') ~= nil) end
    end
    local data_dir = vim.fn.stdpath('data')
    local lazy_dir = data_dir .. '/lazy'
    local entries = vim.fn.glob(lazy_dir .. '/*', 0, 1) or {}
    local present = {}
    for _, pth in ipairs(entries) do
      local base = vim.fn.fnamemodify(pth, ':t')
      present[base] = true
    end
    local function has_any(patterns)
      for _, pat in ipairs(patterns) do if present[pat] then return true end end
      return false
    end
    local detectors = {
      telescope={'telescope.nvim'}, blink={'blink.cmp'}, diffview={'diffview.nvim'}, fidget={'fidget.nvim'},
      gitsigns={'gitsigns.nvim'}, harpoon={'harpoon'}, heirline={'heirline.nvim'}, leap={'leap.nvim'},
      noice={'noice.nvim'}, dap={'nvim-dap'}, dapui={'nvim-dap-ui'}, dap_virtual_text={'nvim-dap-virtual-text'},
      navbuddy={'nvim-navbuddy'}, navic={'nvim-navic'}, overseer={'overseer.nvim'}, trouble={'trouble.nvim'},
      toggleterm={'toggleterm.nvim'}, hlslens={'hlslens.nvim'}, virt_column={'virt-column.nvim'},
      rainbow={'rainbow-delimiters.nvim'}, cmp={'nvim-cmp'}, bufferline={'bufferline.nvim'}, alpha={'alpha-nvim'},
      startify={'vim-startify','startify'}, mini_statusline={'mini.statusline','mini.nvim'}, mini_tabline={'mini.tabline','mini.nvim'},
      todo_comments={'todo-comments.nvim'}, lspsaga={'lspsaga.nvim'}, nvim_tree={'nvim-tree.lua','nvim-tree'},
      neo_tree={'neo-tree.nvim'}, notify={'nvim-notify'}, treesitter_context={'treesitter-context','nvim-treesitter-context'},
      hop={'hop.nvim'}, ufo={'nvim-ufo'}, bqf={'nvim-bqf'}, flash={'flash.nvim'}, glance={'glance.nvim'},
      barbecue={'barbecue.nvim'}, illuminate={'vim-illuminate'}, oil={'oil.nvim'}, mini_pick={'mini.pick','mini.nvim'},
      snacks={'snacks.nvim'}, fzf_lua={'fzf-lua'}, obsidian={'obsidian.nvim'}, neotest={'neotest'}, which_key={'which-key.nvim'},
      indent={'indent-blankline.nvim','ibl','mini.indentscope','mini.nvim'}, headline={'headline.nvim'}, treesitter_playground={'treesitter-playground'},
    }
    local keys = {}
    for k, _ in pairs(detectors) do keys[#keys+1] = k end
    table.sort(keys)
    local result = { git = true }
    for _, k in ipairs(keys) do result[k] = has_any(detectors[k]) end
    if use_json then
      local obj = { plugins = result, lazy_dir = lazy_dir }
      local payload = vim.json_encode(obj)
      if use_notify and vim.notify then vim.notify(payload) else print(payload) end
      return
    end
    -- Render Lua block
    local lines = {}
    lines[#lines+1] = 'plugins = {'
    lines[#lines+1] = '  git = true,'
    for _, k in ipairs(keys) do
      lines[#lines+1] = string.format('  %s = %s,', k, tostring(result[k]))
    end
    lines[#lines+1] = '}'
    local msg = table.concat(lines, '\n')
    if use_notify and vim.notify then vim.notify(msg) else print(msg) end
  end, {
    nargs = '*',
    complete = function(arglead)
      local out = { '--json', '--notify=off', '--notify=on' }
      local lead = tostring(arglead or '')
      if lead == '' then return out end
      local res = {}
      for _, v in ipairs(out) do if v:find(lead, 1, true) == 1 then res[#res+1] = v end end
      return res
    end,
    desc = "neg.nvim: Suggest a 'plugins = { ... }' block from installed lazy plugins"
  })
  -- Debug: list groups that still use default NvimLight* palette
  vim.api.nvim_create_user_command('NegSanitizeScan', function()
    local function probe(name)
      local g = 'NegProbe' .. name
      pcall(vim.api.nvim_set_hl, 0, g, { fg = name })
      local ok, t = pcall(vim.api.nvim_get_hl, 0, { name = g, link = false })
      local v = (ok and type(t) == 'table') and t.fg or nil
      pcall(vim.cmd, 'hi clear ' .. g)
      return v
    end
    local targets = { 'NvimLightGreen','NvimLightRed','NvimLightCyan','NvimLightBlue','NvimLightYellow','NvimLightMagenta','NvimLightGrey','NvimDarkGreen','NvimDarkRed','NvimDarkCyan','NvimDarkBlue','NvimDarkYellow','NvimDarkMagenta','NvimDarkGrey' }
    local match_vals = {}
    for _, k in ipairs(targets) do
      local v = probe(k)
      if type(v) == 'number' then match_vals[v] = k end
    end
    local groups = vim.fn.getcompletion('', 'highlight') or {}
    local found = {}
    for _, name in ipairs(groups) do
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
      if ok and type(hl) == 'table' then
        for _, key in ipairs({ 'fg', 'bg', 'sp' }) do
          local val = hl[key]
          if val and match_vals[val] then
            table.insert(found, string.format('%s %s=%s', name, key, match_vals[val]))
            break
          end
        end
      end
    end
    if #found == 0 then
      print('neg.nvim: sanitize scan — no NvimLight*/NvimDark* leftovers found')
    else
      print(table.concat(found, '\n'))
    end
  end, { desc = 'neg.nvim: List highlight groups still using default NvimLight*/NvimDark* colors' })
end

return M
