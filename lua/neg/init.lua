-- Name:        neg
-- Version:     4.50
-- Last Change: 23-10-2025
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
        strong_undercurl = false,  -- stronger/more visible diagnostic undercurls
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
      -- Enhanced accents for Telescope (matching/selection/borders); off by default
      telescope_accents = false,
      -- Path separator tint (Telescope only): when true, color path separators in a kitty-like blue
      path_separator_blue = false,
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
  -- Stronger undercurls for diagnostics
  if acc.strong_undercurl then
    local map = {
      { 'DiagnosticUnderlineError', p.diff_delete_color },
      { 'DiagnosticUnderlineWarn',  p.warning_color },
      { 'DiagnosticUnderlineInfo',  p.preproc_light_color },
      { 'DiagnosticUnderlineHint',  p.identifier_color },
      { 'DiagnosticUnderlineOk',    p.diff_add_color },
    }
    for _, entry in ipairs(map) do
      local name, col = entry[1], entry[2]
      hi(0, name, { undercurl = true, underline = true, sp = col })
    end
  end
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
  if not (ui and ui.telescope_accents) then
    -- Enforce neutral defaults even if other plugins recolor later
    hi(0, 'TelescopeMatching', { underline = true })
    hi(0, 'TelescopeSelection', { link = 'Visual' })
    return
  end
  -- Accented matching/selection/borders for Telescope
  -- Keep tasteful: emphasize matches and selection; borders follow soft_borders if enabled
  local match_fg = p.search_color or p.include_color or p.keyword3_color
  hi(0, 'TelescopeMatching', { fg = match_fg, italic = true, underline = false })
  -- Selection: use CursorLine but ensure fg remains readable
  local cl = (U.get_hl_colors and U.get_hl_colors('CursorLine')) or {}
  local sel = { }
  if cl.bg then sel.bg = cl.bg end
  hi(0, 'TelescopeSelection', sel)
  -- Borders: if soft_borders already set WinSeparator, leave links; nothing to do here
end

-- Optional blue path separators (TelescopePathSeparator)
local function apply_path_separator(cfg)
  local ui = cfg and cfg.ui or {}
  if ui and ui.path_separator_blue then
    local col = p.include_color or p.keyword3_color
    hi(0, 'TelescopePathSeparator', { fg = col })
  else
    hi(0, 'TelescopePathSeparator', { link = 'Normal' })
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

  -- Idempotent apply: skip if no changes and no function overrides
  if not force_apply and M._applied_key and type(cfg.overrides) ~= 'function' then
    local key = U.config_signature(cfg)
    if vim.deep_equal(key, M._applied_key) then return end
  end

  -- Core groups
  apply(require('neg.groups.editor'))
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
  apply_dim_inactive(cfg)
  apply_mode_accent(cfg)
  apply_focus_caret(cfg)
  apply_soft_borders(cfg)
  apply_auto_transparent_panels(cfg)
  apply_float_panel_bg(cfg)
  apply_diff_focus(cfg)
  apply_light_signs(cfg)
  apply_punct_family(cfg)
  apply_accessibility_opts(cfg)
  apply_diag_pattern(cfg)
  apply_lexeme_cues(cfg)
  apply_thick_cursor(cfg)
  apply_outlines(cfg)
  apply_reading_mode(cfg)
  apply_search_visibility(cfg)
  apply_screenreader(cfg)
  apply_telescope_accents(cfg)
  apply_path_separator(cfg)
  if cfg.diagnostics_virtual_bg then apply_diagnostics_virtual_bg(cfg) end
  apply_selection_model(cfg)
  apply_alpha_overlay(cfg)
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
      print("neg.nvim: usage: :NegContrast {Group|@capture} [vs {Group|#rrggbb}]")
      return
    end
    -- Parse "<group> [vs <bg>] [--target AA|AAA] [apply]"
    local tokens = {}
    for w in raw:gmatch('%S+') do tokens[#tokens+1] = w end
    local name = tokens[1]
    local bg_arg
    local target_label
    local apply_now = false
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
      print("neg.nvim: can't resolve colors for '" .. name .. "' (fg=" .. tostring(fg) .. ", bg=" .. tostring(bg) .. ")")
      return
    end
    local ratio = contrast_ratio(fg, bg)
    if not ratio then
      print("neg.nvim: failed to compute contrast for '" .. name .. "'")
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
    local vs_str = bg_arg and (' vs ' .. bg_arg) or ''
    local msg = string.format("neg.nvim: %s%s — fg %s on bg %s → contrast %.2f (%s)", name, vs_str, fg, bg, ratio, grade)
    print(msg)
    local target_ratio = 4.5
    if target_label == 'AAA' then target_ratio = 7.0
    elseif target_label == 'AA' or target_label == nil then target_ratio = 4.5
    end
    if ratio >= target_ratio then
      print(string.format("  · OK: meets target %s (%.1f)", target_label or 'AA', target_ratio))
      return
    end
    local sug_fg, sug_r, sug_mode, sug_pct = find_suggestion(target_ratio)
    if sug_fg and sug_r then
      print(string.format("  · suggestion (%s): set fg=%s (≈%.2f, %s %d%%)", target_label or 'AA', sug_fg, sug_r, sug_mode, sug_pct))
      local hi_line = string.format(":hi %s guifg=%s", name, sug_fg)
      print("    " .. hi_line)
      if apply_now then
        local base = (U.get_hl_colors and U.get_hl_colors(name)) or {}
        local spec = { fg = sug_fg }
        if base.bg then spec.bg = base.bg end
        if base.sp then spec.sp = base.sp end
        hi(0, name, spec)
        print("    applied")
      end
      return
    end
    -- If AAA target unreachable by fg tweak, try suggesting AA as fallback (no auto-apply)
    if target_ratio >= 7.0 then
      local aa_fg, aa_r, aa_mode, aa_pct = find_suggestion(4.5)
      if aa_fg and aa_r then
        print(string.format("  · can't reach AAA by fg alone (<=60%%). Closest AA: fg=%s (≈%.2f, %s %d%%)", aa_fg, aa_r, aa_mode, aa_pct))
        print(string.format("    :hi %s guifg=%s", name, aa_fg))
      else
        print("  · no near fg-only solution found; consider adjusting background or use :NegHc soft|strong")
      end
    else
      print("  · no near fg-only solution found; consider adjusting background or use :NegHc soft|strong")
    end
  end, { nargs = '+', desc = 'neg.nvim: Show contrast ratio for a group/capture vs background; supports "vs Group|#hex"' })

  vim.api.nvim_create_user_command('NegTelescopeAccents', function(opts)
    local arg = (opts.args or ''):lower()
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    if arg == 'on' then
      newcfg.ui.telescope_accents = true
    elseif arg == 'off' then
      newcfg.ui.telescope_accents = false
    elseif arg == 'toggle' or arg == '' then
      newcfg.ui.telescope_accents = not (cfg.ui and cfg.ui.telescope_accents == true)
    else
      print("neg.nvim: unknown arg '" .. arg .. "'. Use: on|off|toggle")
      return
    end
    M.setup(newcfg)
  end, {
    nargs = '?',
    complete = function() return { 'on', 'off', 'toggle' } end,
    desc = 'neg.nvim: Toggle/Set enhanced Telescope accents (matching/selection/borders)'
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
    desc = 'neg.nvim: Toggle/Set blue path separators (TelescopePathSeparator)'
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
    local features = { deuteranopia=true, strong_undercurl=true, achromatopsia=true }
    if not features[feature or ''] then
      print("neg.nvim: unknown feature '" .. tostring(feature) .. "'. Use: deuteranopia|strong_undercurl|achromatopsia [on|off|toggle]")
      return
    end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.ui = newcfg.ui or {}
    newcfg.ui.accessibility = vim.tbl_deep_extend('force', { deuteranopia=false, strong_undercurl=false }, newcfg.ui.accessibility or {})
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
      if #toks <= 2 then return { 'deuteranopia', 'strong_undercurl', 'achromatopsia' } end
      return { 'on', 'off', 'toggle' }
    end,
    desc = 'neg.nvim: Accessibility toggles: deuteranopia|strong_undercurl|achromatopsia [on|off|toggle]'
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

  vim.api.nvim_create_user_command('NegExport', function()
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
    -- Summary
    print('neg.nvim export — current highlight colors')
    do
      local cfg = M._config or default_config
      local summary = (
        'config: saturation=%s alpha_overlay=%s operator_colors=%s number_colors=%s\n' ..
        '        ui.mode_accent=%s ui.soft_borders=%s ui.dim_inactive=%s ui.diff_focus=%s'
      ):format(
        tostring(cfg.saturation), tostring(cfg.alpha_overlay), tostring(cfg.operator_colors), tostring(cfg.number_colors),
        tostring(cfg.ui and cfg.ui.mode_accent), tostring(cfg.ui and cfg.ui.soft_borders), tostring(cfg.ui and cfg.ui.dim_inactive), tostring(cfg.ui and cfg.ui.diff_focus)
      )
      print(summary)
    end
    -- Core UI
    header('Core UI')
    for _, g in ipairs({ 'Normal','NormalNC','NormalFloat','StatusLine','StatusLineNC','Title','Underlined','WinBar','WinBarNC','VertSplit','WinSeparator','FloatBorder','LineNr','CursorLine','CursorLineNr','ColorColumn','CursorColumn','Visual','SignColumn','FoldColumn','NonText','Whitespace','EndOfBuffer','Search','CurSearch','IncSearch','Pmenu','PmenuSel','PmenuThumb','QuickFixLine','Substitute' }) do
      print(fmt(g, get_hl(g, true)))
    end
    -- Diff
    header('Diff')
    for _, g in ipairs({ 'DiffAdd','DiffChange','DiffDelete','DiffText' }) do print(fmt(g, get_hl(g, true))) end
    -- Diagnostics
    header('Diagnostics')
    for _, g in ipairs({ 'DiagnosticError','DiagnosticWarn','DiagnosticInfo','DiagnosticHint','DiagnosticOk','DiagnosticVirtualTextError','DiagnosticVirtualTextWarn','DiagnosticVirtualTextInfo','DiagnosticVirtualTextHint','DiagnosticVirtualTextOk' }) do
      print(fmt(g, get_hl(g, true)))
    end
    -- Syntax (Treesitter)
    header('Syntax (TS)')
    for _, g in ipairs({ '@comment','@keyword','@function','@method','@type','@type.builtin','@string','@number','@boolean','@operator','@constant','@variable','@property','@field','@namespace','@tag','@punctuation.bracket','@punctuation.delimiter','@punctuation.special','@markup.heading.1','@markup.link','@markup.math' }) do
      print(fmt(g, get_hl(g, true)))
    end
    -- Diff hints
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
    do
      header('Hints')
      local low = {}
      for _, g in ipairs({ 'DiffAdd','DiffChange','DiffDelete','DiffText' }) do
        local t = get_hl(g, true)
        local bg = t.bg
        local r = (bg and bg ~= 'NONE') and contrast_ratio('#ffffff', bg) or nil
        if (not bg) or bg == 'NONE' or (r and r < 1.20) then low[#low+1] = g end
      end
      if #low > 0 then
        print('· diff tips: backgrounds for ' .. table.concat(low, ', ') .. ' may be too soft; try :NegDiffFocus on')
      end
      local s = get_hl('Search', true)
      if (not s.bg or s.bg == 'NONE') then print('· search tips: try :NegAlpha 8 or :NegSearchVisibility soft|strong') end
    end
  end, { desc = 'neg.nvim: Export current highlight colors (core, diff, diagnostics, syntax) with quick hints' })
end

return M
