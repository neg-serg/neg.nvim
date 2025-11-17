local OptionSchema = {}
OptionSchema.__index = OptionSchema

local bool_map = {
  on = true,
  off = false,
  ['true'] = true,
  ['false'] = false,
  yes = true,
  no = false,
  ['1'] = true,
  ['0'] = false,
  enable = true,
  disable = false,
}

local function clamp(v, minv, maxv)
  if minv and v < minv then return minv end
  if maxv and v > maxv then return maxv end
  return v
end

local function split_path(id)
  local tokens = {}
  for part in string.gmatch(id, '[^%.:]+') do
    tokens[#tokens + 1] = part
  end
  return tokens
end

local function deepcopy(tbl) return vim.deepcopy(tbl) end

local function get_from_path(tbl, path)
  local cur = tbl
  for i = 1, #path do
    if type(cur) ~= 'table' then return nil end
    cur = cur[path[i]]
    if cur == nil then return nil end
  end
  return cur
end

local function ensure_path(tbl, path)
  local cur = tbl
  for i = 1, (#path - 1) do
    local key = path[i]
    if type(cur[key]) ~= 'table' then cur[key] = {} end
    cur = cur[key]
  end
  return cur, path[#path]
end

local function set_on_path(tbl, path, value)
  local parent, leaf = ensure_path(tbl, path)
  parent[leaf] = value
end

local function normalize_bool(value)
  if type(value) == 'boolean' then return value end
  if type(value) == 'number' then return value ~= 0 end
  if type(value) == 'string' then
    local val = bool_map[value:lower()]
    if val ~= nil then return val end
  end
  return nil
end

function OptionSchema.new(ctx)
  local self = setmetatable({
    default_config = ctx and ctx.default_config or {},
    palette = ctx and ctx.palette or {},
    nodes = {},
  }, OptionSchema)
  self:_register()
  return self
end

function OptionSchema:add(id, meta)
  meta = meta or {}
  meta.id = id:lower()
  meta.config_path = meta.config_path or split_path(meta.id)
  self.nodes[meta.id] = meta
end

function OptionSchema:get(id)
  if not id then return nil end
  return self.nodes[id:lower()]
end

function OptionSchema:list(prefix)
  local out = {}
  prefix = prefix and prefix:lower() or ''
  for key, _ in pairs(self.nodes) do
    if prefix == '' or key:find('^' .. vim.pesc(prefix)) then
      out[#out + 1] = key
    end
  end
  table.sort(out)
  return out
end

local function palette_keys(palette)
  local out = {}
  for k, v in pairs(palette or {}) do
    if type(k) == 'string' and type(v) == 'string' and v:match('^#%x%x%x%x%x%x$') then
      out[#out + 1] = k
    end
  end
  table.sort(out)
  return out
end

function OptionSchema:default_value(meta, cfg)
  if meta.get then return meta.get(cfg) end
  return get_from_path(cfg, meta.config_path)
end

local function parse_number(raw, meta)
  local num = tonumber(raw)
  if num == nil then return nil, 'not-a-number' end
  if meta and meta.min ~= nil then num = math.max(num, meta.min) end
  if meta and meta.max ~= nil then num = math.min(num, meta.max) end
  return num
end

function OptionSchema:normalize_value(meta, raw, cfg)
  if meta.coerce then
    local val, err = meta.coerce(raw, cfg)
    if err ~= nil then return val, err end
    return val
  end
  if meta.type == 'toggle' then
    local val = normalize_bool(raw)
    if val == nil then return nil, 'invalid-bool' end
    return val
  elseif meta.type == 'enum' then
    raw = tostring(raw or ''):lower()
    if meta.aliases and meta.aliases[raw] then raw = meta.aliases[raw] end
    for _, v in ipairs(meta.values or {}) do
      if raw == v then return raw end
    end
    return nil, 'invalid-enum'
  elseif meta.type == 'number' or meta.type == 'integer' then
    local val, err = parse_number(raw, meta)
    if not val then return nil, err end
    if meta.round or meta.type == 'integer' then val = math.floor(val + 0.5) end
    return val
  elseif meta.type == 'float' then
    local val, err = parse_number(raw, meta)
    if not val then return nil, err end
    return val
  elseif meta.type == 'color' then
    local text = tostring(raw or '')
    if text == '' or text == 'default' or text == 'clear' then return nil end
    if text:match('^#%x%x%x%x%x%x$') then return text end
    return text
  else
    return raw
  end
end

function OptionSchema:set_value(meta, cfg, value)
  if meta.set then
    meta.set(cfg, value)
    return
  end
  set_on_path(cfg, meta.config_path, value)
end

local function truthy(v)
  if type(v) == 'table' then
    for _, key in ipairs({ 'float', 'sidebar', 'statusline' }) do
      if v[key] == true then return true end
    end
    return false
  end
  return v == true
end

function OptionSchema:toggle_value(meta, cfg)
  if meta.toggle then
    return meta.toggle(cfg)
  end
  local cur = self:default_value(meta, cfg)
  local bool = normalize_bool(cur)
  if bool == nil then bool = truthy(cur) end
  return not bool
end

function OptionSchema:complete_values(meta, prefix)
  if meta.complete then return meta.complete(prefix) end
  prefix = prefix and prefix:lower() or ''
  if meta.type == 'toggle' then
    local values = { 'on', 'off', 'toggle' }
    local out = {}
    for _, v in ipairs(values) do
      if prefix == '' or v:find('^' .. vim.pesc(prefix)) then out[#out + 1] = v end
    end
    return out
  elseif meta.type == 'enum' then
    local out = {}
    for _, v in ipairs(meta.values or {}) do
      if prefix == '' or v:find('^' .. vim.pesc(prefix)) then out[#out + 1] = v end
    end
    return out
  elseif meta.type == 'color' then
    local base = { 'default', 'clear' }
    local out = {}
    for _, v in ipairs(base) do
      if prefix == '' or v:find('^' .. vim.pesc(prefix)) then out[#out + 1] = v end
    end
    for _, v in ipairs(palette_keys(self.palette)) do
      if prefix == '' or v:find('^' .. vim.pesc(prefix)) then out[#out + 1] = v end
    end
    return out
  end
  return {}
end

function OptionSchema:_register()
  local function opt(id, meta)
    self:add(id, meta)
  end

  -- Core toggles
  opt('transparent', {
    type = 'toggle',
    description = 'Toggle global transparency',
    set = function(cfg, value)
      cfg.transparent = value
    end,
    toggle = function(cfg)
      local cur = cfg.transparent
      return not truthy(cur)
    end,
  })

  local function ensure_transparent_table(cfg)
    local t = cfg.transparent
    if type(t) ~= 'table' then
      local fill = false
      if t == true then fill = true end
      t = { float = fill, sidebar = fill, statusline = fill }
    else
      t = deepcopy(t)
      for _, key in ipairs({ 'float', 'sidebar', 'statusline' }) do
        if t[key] == nil then t[key] = false end
      end
    end
    cfg.transparent = t
    return t
  end

  for _, zone in ipairs({ 'float', 'sidebar', 'statusline' }) do
    opt('transparent.' .. zone, {
      type = 'toggle',
      description = 'Toggle transparency for specific zone',
      set = function(cfg, value)
        local tbl = ensure_transparent_table(cfg)
        tbl[zone] = value
      end,
      get = function(cfg)
        local t = cfg.transparent
        if type(t) == 'table' then return t[zone] end
        return truthy(t)
      end,
      toggle = function(cfg)
        local tbl = ensure_transparent_table(cfg)
        tbl[zone] = not (tbl[zone] == true)
        return tbl[zone]
      end,
    })
  end

  opt('preset', {
    type = 'enum',
    values = { 'soft', 'hard', 'pro', 'writing', 'accessibility', 'focus', 'presentation', 'none' },
    description = 'Apply built-in preset',
    coerce = function(raw)
      raw = tostring(raw or ''):lower()
      if raw == 'none' or raw == '' then return nil end
      return raw
    end,
  })

  opt('saturation', {
    type = 'integer',
    min = 0,
    max = 100,
    description = 'Global palette saturation 0..100',
  })

  opt('alpha', {
    type = 'integer',
    config_path = { 'alpha_overlay' },
    min = 0,
    max = 30,
    description = 'Soft background alpha for Search/Visual/Diagnostics',
  })

  opt('operator_colors', {
    type = 'enum',
    values = { 'families', 'mono', 'mono+' },
    aliases = { ['mono_plus'] = 'mono+' },
    description = 'Operator highlighting mode',
  })

  opt('number_colors', {
    type = 'enum',
    values = { 'mono', 'ramp', 'ramp-soft', 'ramp-strong' },
    aliases = {
      ['ramp:soft'] = 'ramp-soft',
      ['ramp:strong'] = 'ramp-strong',
      ['ramp:balanced'] = 'ramp',
    },
    description = 'Number highlighting mode',
  })

  opt('diagnostics.enabled', {
    type = 'toggle',
    config_path = { 'diagnostics_virtual_bg' },
    description = 'Enable diagnostic virtual backgrounds',
  })

  opt('diagnostics.mode', {
    type = 'enum',
    values = { 'blend', 'alpha', 'lighten', 'darken', 'on', 'off' },
    description = 'Diagnostics background blend mode',
    set = function(cfg, value)
      if value == 'off' then
        cfg.diagnostics_virtual_bg = false
        return
      end
      cfg.diagnostics_virtual_bg = true
      if value ~= 'on' then
        cfg.diagnostics_virtual_bg_mode = value
      end
    end,
  })

  opt('diagnostics.strength', {
    type = 'float',
    min = 0,
    max = 1,
    config_path = { 'diagnostics_virtual_bg_strength' },
    description = 'Diagnostic virtual background alpha 0..1',
  })

  opt('diagnostics.blend', {
    type = 'integer',
    min = 0,
    max = 100,
    config_path = { 'diagnostics_virtual_bg_blend' },
    description = 'Diagnostic virtual bg blend (only for mode=blend)',
  })

  local ui_toggles = {
    { 'ui.mode_accent', 'Mode aware accents' },
    { 'ui.soft_borders', 'Soft win/float borders' },
    { 'ui.float_bg', 'Float panel background', { path = { 'ui', 'float_panel_bg' } } },
    { 'ui.focus_caret', 'Focus caret boosting' },
    { 'ui.dim_inactive', 'Dim inactive windows' },
    { 'ui.diff_focus', 'Stronger diff focus backgrounds' },
    { 'ui.screenreader', 'Screenreader-friendly mode', { path = { 'ui', 'screenreader_friendly' } } },
    { 'ui.light_signs', 'Lighten diagnostic/gitsign icons' },
    { 'ui.thick_cursor', 'Thick cursor in TUI' },
    { 'ui.outlines', 'UI outlines' },
    { 'ui.reading_mode', 'Reading mode' },
  }
  for _, item in ipairs(ui_toggles) do
    local id, desc, extra = item[1], item[2], item[3]
    opt(id, {
      type = 'toggle',
      description = desc,
      config_path = (extra and extra.path) or split_path(id),
    })
  end

  opt('ui.telescope_accents', {
    type = 'enum',
    values = { 'off', 'default', 'soft', 'strong' },
    description = 'Telescope accent strength',
    coerce = function(raw)
      raw = tostring(raw or ''):lower()
      if raw == 'on' then return 'default' end
      if raw == 'toggle' or raw == '' then return nil, 'toggle' end
      if raw == 'off' then return 'off' end
      return raw
    end,
    toggle = function(cfg)
      local cur = cfg.ui and cfg.ui.telescope_accents
      if cur == false or cur == nil then return 'default' end
      return false
    end,
  })

  opt('ui.path_separator_blue', {
    type = 'toggle',
    config_path = { 'ui', 'path_separator_blue' },
    description = 'Tint separators blue',
  })

  opt('ui.path_separator_color', {
    type = 'color',
    config_path = { 'ui', 'path_separator_color' },
    description = 'Custom path separator color',
  })

  opt('ui.selection_model', {
    type = 'enum',
    values = { 'default', 'kitty' },
    config_path = { 'ui', 'selection_model' },
    description = 'Selection color model',
  })

  opt('ui.search_visibility', {
    type = 'enum',
    values = { 'default', 'soft', 'strong' },
    config_path = { 'ui', 'search_visibility' },
    description = 'Search highlight visibility',
  })

  opt('ui.lexeme_cues', {
    type = 'enum',
    values = { 'off', 'minimal', 'strong' },
    config_path = { 'ui', 'lexeme_cues' },
    description = 'Lexeme cues intensity',
  })

  opt('ui.diag_pattern', {
    type = 'enum',
    values = { 'none', 'minimal', 'strong' },
    config_path = { 'ui', 'diag_pattern' },
    description = 'Diagnostic background pattern presets',
  })

  opt('treesitter.punct_family', {
    type = 'toggle',
    config_path = { 'treesitter', 'punct_family' },
    description = 'Differentiate punctuation families',
  })

  opt('ui.accessibility.deuteranopia', {
    type = 'toggle',
    description = 'Accessibility: deuteranopia assist',
    set = function(cfg, value)
      cfg.ui = cfg.ui or {}
      cfg.ui.accessibility = cfg.ui.accessibility or {}
      cfg.ui.accessibility.deuteranopia = value
    end,
    get = function(cfg) return cfg.ui and cfg.ui.accessibility and cfg.ui.accessibility.deuteranopia end,
  })

  opt('ui.accessibility.achromatopsia', {
    type = 'toggle',
    description = 'Accessibility: achromatopsia assist',
    set = function(cfg, value)
      cfg.ui = cfg.ui or {}
      cfg.ui.accessibility = cfg.ui.accessibility or {}
      cfg.ui.accessibility.achromatopsia = value
    end,
    get = function(cfg) return cfg.ui and cfg.ui.accessibility and cfg.ui.accessibility.achromatopsia end,
  })

  opt('ui.accessibility.hc', {
    type = 'enum',
    values = { 'off', 'soft', 'strong' },
    description = 'High contrast pack',
    set = function(cfg, value)
      cfg.ui = cfg.ui or {}
      cfg.ui.accessibility = cfg.ui.accessibility or {}
      cfg.ui.accessibility.hc = value
    end,
    get = function(cfg) return cfg.ui and cfg.ui.accessibility and cfg.ui.accessibility.hc end,
  })

  -- Plugin toggles
  local defaults = self.default_config and self.default_config.plugins or {}
  local keys = {}
  for k, _ in pairs(defaults) do keys[#keys + 1] = k end
  table.sort(keys)
  for _, name in ipairs(keys) do
    opt('plugins.' .. name, {
      type = 'toggle',
      description = 'Enable ' .. name .. ' integration',
      config_path = { 'plugins', name },
    })
  end
end

return OptionSchema
