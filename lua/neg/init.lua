-- Name:        neg
-- Version:     4.21
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
  preset = nil, -- one of: 'soft', 'hard', 'pro', 'writing', 'accessibility', 'focus', 'presentation'
    -- Operators coloring: 'families' (different subtle hues per family),
    -- 'mono' (single color), or 'mono+' (single color with a slightly stronger accent)
    operator_colors = 'families',
    -- Number coloring: 'mono' (single hue) or 'ramp' (subtle single‑hue variants for integer/hex/octal/binary)
    number_colors = 'ramp',
    -- UI options
    ui = {
      -- When true, define extra baseline UI groups missing in stock setup
      -- (Whitespace, EndOfBuffer, PmenuMatch*, FloatShadow*, Cursor*, VisualNOS, LineNrAbove/Below, Question)
      core_enhancements = true,
      -- Dim inactive windows (NormalNC/WinBarNC) and line numbers via winhighlight mapping
      dim_inactive = false,
      -- Mode-aware accents for CursorLine/StatusLine by Vim mode (Normal/Insert/Visual)
      mode_accent = false,
      -- Soft borders: lighten WinSeparator/FloatBorder to reduce visual noise
      soft_borders = false,
      -- Auto-tune float/panel backgrounds when terminal background is transparent
      auto_transparent_panels = true,
      -- Diff focus: stronger Diff* backgrounds when any window is in :diff mode
      diff_focus = true,
      -- Light signs: soften sign icons (DiagnosticSign*, GitSigns*) without changing their hue
      light_signs = false,
    },
    treesitter = {
      -- When true, apply subtle extra captures (math/environment, string.template,
      -- boolean true/false, nil/null, decorator/annotation, declaration/static/abstract links)
      extras = true,
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
  if mode ~= 'ramp' then return end
  local base = p.keyword1_color
  local ramp = {
    integer = base,                         -- baseline
    hex     = U.lighten(base, 6),           -- slightly lighter
    octal   = U.darken(base, 6),            -- slightly darker
    binary  = U.lighten(base, 3),           -- subtle lift
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
  apply_soft_borders(cfg)
  apply_auto_transparent_panels(cfg)
  apply_diff_focus(cfg)
  apply_light_signs(cfg)
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
  vim.api.nvim_create_user_command('NegNumberColors', function(opts)
    local mode = (opts.args or ''):lower()
    local allowed = { mono = true, ramp = true }
    if not allowed[mode] then
      print("neg.nvim: unknown mode '" .. mode .. "'. Use: mono|ramp")
      return
    end
    local cfg = M._config or default_config
    local newcfg = vim.deepcopy(cfg)
    newcfg.number_colors = mode
    M.setup(newcfg)
  end, {
    nargs = 1,
    complete = function() return { 'mono', 'ramp' } end,
    desc = 'neg.nvim: Set number colors mode (mono|ramp)'
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
end

return M
