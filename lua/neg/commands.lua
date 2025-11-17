local OptionSchema = require('neg.options')

local Commander = {}
Commander.__index = Commander

local SUBCOMMANDS = {
  'set',
  'toggle',
  'info',
  'list',
  'preset',
  'scenario',
  'plugins',
  'export',
  'import',
  'reload',
}

local function clone(tbl) return vim.deepcopy(tbl) end

local function is_empty(str) return not str or str == '' end

local function notify(level, msg)
  if type(vim.notify) == 'function' then
    vim.notify(msg, level, { title = 'neg.nvim' })
  else
    print(msg)
  end
end

local function join_words(words, start_idx)
  local out = {}
  for i = start_idx or 1, #words do out[#out + 1] = words[i] end
  return table.concat(out, ' ')
end

local function parse_cmdline(cmdline)
  local tokens = vim.split(cmdline or '', '%s+', { trimempty = true })
  if (cmdline or ''):match('%s$') then tokens[#tokens + 1] = '' end
  return tokens
end

local function bool_to_text(v)
  if v == nil then return 'nil' end
  return v and 'on' or 'off'
end

local function file_complete(prefix)
  local lead = tostring(prefix or '')
  local mode = 'file'
  local path = lead
  if lead:sub(1, 1) == '@' then
    mode = 'file'
    path = lead:sub(2)
  end
  local matches = vim.fn.getcompletion(path, mode) or {}
  local out = {}
  for _, f in ipairs(matches) do
    if lead:sub(1, 1) == '@' then
      out[#out + 1] = '@' .. f
    else
      out[#out + 1] = f
    end
  end
  return out
end

function Commander.new(ctx)
  assert(ctx and ctx.get_config and ctx.apply_config, 'commander context missing')
  local self = setmetatable({
    ctx = ctx,
    schema = OptionSchema.new({ default_config = ctx.default_config or {}, palette = ctx.palette or {} }),
  }, Commander)
  self:define_quick_scenarios()
  return self
end

function Commander:register()
  vim.api.nvim_create_user_command('Neg', function(opts)
    self:run(opts)
  end, {
    nargs = '*',
    desc = 'neg.nvim: unified control center',
    complete = function(arglead, cmdline, cursorpos)
      return self:complete(arglead, cmdline, cursorpos)
    end,
  })
  self:register_legacy_aliases()
end

function Commander:tokens(str)
  return vim.split(str or '', '%s+', { trimempty = true })
end

function Commander:get_config()
  return self.ctx.get_config()
end

function Commander:apply_config(cfg)
  self.ctx.apply_config(cfg)
end

function Commander:scenarios()
  local store = self.ctx.get_scenarios
  if type(store) == 'function' then return store() end
  return store
end

function Commander:default_scenarios_path()
  local fn = self.ctx.default_scenarios_path
  if type(fn) == 'function' then return fn() end
  return fn
end

function Commander:print(msg)
  notify(vim.log.levels.INFO, msg)
end

function Commander:warn(msg)
  notify(vim.log.levels.WARN, msg)
end

function Commander:error(msg)
  notify(vim.log.levels.ERROR, msg)
end

function Commander:announce(path, value)
  if type(value) == 'boolean' then value = bool_to_text(value) end
  self:print(string.format("neg.nvim: %s → %s", path, tostring(value)))
end

function Commander:apply_option(action, path, raw_value)
  local meta = self.schema:get(path)
  if not meta then return nil, string.format("unknown option '%s'", path) end
  local cfg = self:get_config()
  local newcfg = clone(cfg)
  local value, err
  if action == 'toggle' and (raw_value and raw_value ~= '') then
    action = 'set'
  end
  if action == 'toggle' then
    value, err = self.schema:toggle_value(meta, newcfg)
    if err then return nil, err end
    self.schema:set_value(meta, newcfg, value)
  else
    value, err = self.schema:normalize_value(meta, raw_value, cfg)
    if err then
      if err == 'toggle' then
        return nil, 'toggle keyword is not valid for set; use :Neg toggle ...'
      end
      return nil, err
    end
    self.schema:set_value(meta, newcfg, value)
  end
  return newcfg, value, meta
end

function Commander:run(opts)
  local args = self:tokens(opts.args or '')
  local sub = args[1]
  if not sub or sub == '' then
    self:print('neg.nvim: use :Neg {set|toggle|scenario|plugins|info|list|export|import|preset}')
    return
  end
  if sub == 'set' then
    self:handle_set(args)
  elseif sub == 'toggle' then
    self:handle_toggle(args)
  elseif sub == 'info' then
    self:handle_info(args)
  elseif sub == 'list' then
    self:handle_list(args)
  elseif sub == 'preset' then
    local value = args[2]
    if not value or value == '' then
      self:warn('neg.nvim: usage: :Neg preset {soft|hard|...}')
      return
    end
    self:handle_set({ 'set', 'preset', value })
  elseif sub == 'scenario' then
    self:handle_scenario(args)
  elseif sub == 'plugins' then
    self:handle_plugins(args)
  elseif sub == 'export' then
    self:handle_export(args)
  elseif sub == 'import' then
    self:handle_import(args)
  elseif sub == 'reload' then
    self:apply_config(self:get_config())
  else
    self:warn(string.format("neg.nvim: unknown subcommand '%s'", sub))
  end
end

function Commander:handle_set(args)
  local path = args[2]
  local value = args[3]
  if not path or value == nil then
    self:warn('neg.nvim: usage: :Neg set {option.path} {value}')
    return
  end
  local newcfg, result, meta = self:apply_option('set', path, value)
  if not newcfg then
    self:warn('neg.nvim: ' .. tostring(result))
    return
  end
  self:apply_config(newcfg)
  self:announce(meta.id, result)
end

function Commander:handle_toggle(args)
  local path = args[2]
  local value = args[3]
  if not path then
    self:warn('neg.nvim: usage: :Neg toggle {option.path} [on|off]')
    return
  end
  local action = value and value ~= '' and 'set' or 'toggle'
  local newcfg, result = self:apply_option(action, path, value)
  if not newcfg then
    self:warn('neg.nvim: ' .. tostring(result))
    return
  end
  self:apply_config(newcfg)
  self:announce(path, result)
end

function Commander:handle_info(args)
  local path = args[2]
  if not path or path == '' then
    pcall(vim.cmd, 'NegInfo')
    return
  end
  local meta = self.schema:get(path)
  if not meta then
    self:warn("neg.nvim: unknown option '" .. path .. "'")
    return
  end
  local value = self.schema:default_value(meta, self:get_config())
  if type(value) == 'table' then value = vim.inspect(value) end
  self:print(string.format('neg.nvim: %s = %s', meta.id, tostring(value)))
end

function Commander:handle_list(args)
  local target = args[2] or 'options'
  if target == 'options' then
    local prefix = args[3]
    local list = self.schema:list(prefix)
    self:print('neg.nvim options: ' .. table.concat(list, ', '))
  elseif target == 'scenarios' then
    local names = {}
    for _, name in ipairs(self:scenario_names(true)) do
      names[#names + 1] = name
    end
    self:print('neg.nvim scenarios: ' .. table.concat(names, ', '))
  elseif target == 'plugins' then
    local plugs = {}
    for path, meta in pairs(self.schema.nodes) do
      if path:match('^plugins%.') then plugs[#plugs + 1] = path end
    end
    table.sort(plugs)
    self:print('neg.nvim plugins: ' .. table.concat(plugs, ', '))
  else
    self:warn("neg.nvim: list target must be options|scenarios|plugins")
  end
end

function Commander:handle_plugins(args)
  local action = args[2] or 'list'
  if action == 'set' or action == 'toggle' then
    local name = args[3]
    if not name then
      self:warn(string.format('neg.nvim: usage: :Neg plugins %s {name} [on|off]', action))
      return
    end
    local option_path = 'plugins.' .. name
    local arg = args[4]
    local act = (action == 'toggle' and not arg) and 'toggle' or 'set'
    local newcfg, result = self:apply_option(act, option_path, arg)
    if not newcfg then
      self:warn('neg.nvim: ' .. tostring(result))
      return
    end
    self:apply_config(newcfg)
    self:announce(option_path, result)
  elseif action == 'list' then
    local rest = join_words(args, 3)
    pcall(vim.cmd, 'NegPlugins ' .. rest)
  elseif action == 'detect' then
    local rest = join_words(args, 3)
    pcall(vim.cmd, 'NegPluginsSuggest ' .. rest)
  else
    self:warn("neg.nvim: plugins actions: set|toggle|list|detect")
  end
end

function Commander:handle_export(args)
  local dest = args[2]
  local notify = true
  for i = 3, #args do
    local token = args[i]
    if token == '--notify=off' then notify = false end
    if token == '--notify=on' then notify = true end
  end
  local path
  if dest and dest:sub(1, 1) == '@' then path = dest:sub(2) end
  path = path or self:default_scenarios_path()
  local ok = self:write_scenarios_file(path)
  if ok then
    if notify then self:print('neg.nvim: scenarios written to ' .. path) end
  else
    self:warn('neg.nvim: failed to write ' .. path)
  end
end

function Commander:handle_import(args)
  local src = args[2]
  local mode = 'merge'
  local notify = true
  for i = 3, #args do
    local token = args[i]
    if token == '--replace' then mode = 'replace' end
    if token == '--merge' then mode = 'merge' end
    if token == '--notify=off' then notify = false end
    if token == '--notify=on' then notify = true end
  end
  local path
  if src and src:sub(1, 1) == '@' then path = src:sub(2) end
  path = path or self:default_scenarios_path()
  local ok, count = self:read_scenarios_file(path, mode)
  if not ok then
    self:warn('neg.nvim: failed to read ' .. path)
    return
  end
  if notify then
    self:print(string.format('neg.nvim: loaded %d scenarios (%s) from %s', count, mode, path))
  end
end

function Commander:scenario_names(include_builtins)
  local names = {}
  if include_builtins then
    for _, name in ipairs({ 'focus', 'presentation', 'screenreader', 'tui', 'gui', 'accessibility' }) do
      names[#names + 1] = name
    end
  end
  local store = self:scenarios()
  for k, _ in pairs(store) do names[#names + 1] = k end
  table.sort(names)
  return names
end

function Commander:handle_scenario(args)
  local action = args[2]
  if not action then
    self:warn('neg.nvim: scenario actions: apply|save|list|delete|dump|load')
    return
  end
  if action == 'list' then
    self:handle_list({ nil, 'scenarios' })
    return
  end
  if action == 'apply' then
    local name = args[3]
    local mode = 'merge'
    for i = 4, #args do
      if args[i] == '--replace' then mode = 'replace' end
      if args[i] == '--merge' then mode = 'merge' end
    end
    if not name then
      self:warn('neg.nvim: usage: :Neg scenario apply {name}')
      return
    end
    name = name:lower()
    if self:apply_quick_scenario(name) then return end
    local store = self:scenarios()
    local scenario = store[name]
    if not scenario then
      self:warn("neg.nvim: scenario '" .. name .. "' not found")
      return
    end
    self.ctx.apply_scenario_tbl(clone(scenario), mode)
    self:print('neg.nvim: scenario ' .. name .. ' applied (' .. mode .. ')')
  elseif action == 'save' then
    local name = args[3]
    if not name then
      self:warn('neg.nvim: usage: :Neg scenario save {name}')
      return
    end
    self:save_scenario(name)
  elseif action == 'delete' then
    local name = args[3]
    if not name then
      self:warn('neg.nvim: usage: :Neg scenario delete {name}')
      return
    end
    local store = self:scenarios()
    if store[name] then
      store[name] = nil
      self:print('neg.nvim: scenario deleted: ' .. name)
    else
      self:warn("neg.nvim: scenario '" .. name .. "' not found")
    end
  elseif action == 'dump' then
    local name = args[3] or 'current'
    self:dump_scenario(name, args)
  elseif action == 'load' then
    self:load_scenario_blob(args)
  else
    self:warn('neg.nvim: scenario actions: apply|save|list|delete|dump|load')
  end
end

function Commander:save_scenario(name)
  name = name:lower()
  local cfg = self:get_config()
  local store = self:scenarios()
  store[name] = self.ctx.pick_scenario_fields(cfg)
  self:print('neg.nvim: scenario saved: ' .. name)
end

function Commander:dump_scenario(name, args)
  name = name:lower()
  local use_notify = false
  for i = 4, #args do
    if args[i] == '--notify=on' then use_notify = true end
  end
  local obj
  if name == 'current' then
    obj = self.ctx.pick_scenario_fields(self:get_config())
  else
    obj = self:scenarios()[name]
  end
  if not obj then
    local payload = vim.json_encode({ error = 'not_found', name = name })
    if use_notify then notify(vim.log.levels.INFO, payload) else print(payload) end
    return
  end
  local payload = vim.json_encode({ name = name, scenario = obj })
  if use_notify then notify(vim.log.levels.INFO, payload) else print(payload) end
end

function Commander:load_scenario_blob(args)
  local blob = args[3]
  if not blob then
    self:warn('neg.nvim: usage: :Neg scenario load {@/path|JSON} [--merge|--replace]')
    return
  end
  local mode = 'merge'
  for i = 4, #args do
    if args[i] == '--replace' then mode = 'replace' end
    if args[i] == '--merge' then mode = 'merge' end
  end
  local payload
  if blob:sub(1, 1) == '@' then
    local path = blob:sub(2)
    local ok, data = pcall(vim.fn.readfile, path)
    if not ok then
      self:warn('neg.nvim: failed to read ' .. path)
      return
    end
    payload = table.concat(data or {}, '\n')
  else
    payload = blob
  end
  local ok, decoded = pcall(vim.json_decode, payload)
  if not ok or type(decoded) ~= 'table' then
    self:warn('neg.nvim: failed to decode scenario JSON')
    return
  end
  local scenario = decoded.scenario or decoded
  if type(scenario) ~= 'table' then
    self:warn('neg.nvim: invalid scenario payload')
    return
  end
  self.ctx.apply_scenario_tbl(scenario, mode)
  self:print('neg.nvim: scenario loaded (' .. mode .. ')')
end

function Commander:apply_quick_scenario(name)
  name = (name or ''):lower()
  local fn = self.quick_scenarios and self.quick_scenarios[name]
  if not fn then return false end
  local cfg = fn(clone(self:get_config()))
  self:apply_config(cfg)
  self:print('neg.nvim: applied scenario ' .. name)
  return true
end

function Commander:define_quick_scenarios()
  if self.quick_scenarios then return end
  local function extend_ui(cfg, extra)
    cfg.ui = vim.tbl_deep_extend('force', cfg.ui or {}, extra)
  end
  self.quick_scenarios = {
    focus = function(cfg)
      cfg.preset = 'focus'
      extend_ui(cfg, { selection_model = 'kitty', telescope_accents = false })
      return cfg
    end,
    presentation = function(cfg)
      cfg.preset = 'presentation'
      cfg.number_colors = 'ramp-strong'
      cfg.operator_colors = 'mono+'
      extend_ui(cfg, {
        mode_accent = false,
        focus_caret = false,
        soft_borders = true,
        search_visibility = 'strong',
        telescope_accents = false,
        diff_focus = false,
      })
      return cfg
    end,
    screenreader = function(cfg)
      cfg.preset = nil
      cfg.alpha_overlay = 0
      extend_ui(cfg, {
        screenreader_friendly = true,
        mode_accent = false,
        focus_caret = false,
        diff_focus = false,
        search_visibility = 'soft',
        selection_model = 'kitty',
        accessibility = vim.tbl_deep_extend('force', cfg.ui and cfg.ui.accessibility or {}, {
          achromatopsia = true,
          hc = 'soft',
        }),
      })
      return cfg
    end,
    tui = function(cfg)
      cfg.alpha_overlay = 0
      extend_ui(cfg, {
        thick_cursor = true,
        soft_borders = false,
        float_panel_bg = false,
        diff_focus = true,
        light_signs = true,
        outlines = false,
        telescope_accents = false,
        selection_model = 'kitty',
      })
      return cfg
    end,
    gui = function(cfg)
      cfg.saturation = 95
      cfg.alpha_overlay = 6
      extend_ui(cfg, {
        soft_borders = true,
        float_panel_bg = true,
        telescope_accents = true,
        dim_inactive = false,
        outlines = false,
        selection_model = 'kitty',
        focus_caret = true,
      })
      return cfg
    end,
    accessibility = function(cfg)
      cfg.preset = 'accessibility'
      extend_ui(cfg, {
        accessibility = vim.tbl_deep_extend('force', cfg.ui and cfg.ui.accessibility or {}, {
          achromatopsia = true,
          hc = 'soft',
        }),
      })
      return cfg
    end,
  }
end

function Commander:write_scenarios_file(path)
  local data = { scenarios = self:scenarios(), version = '4.x' }
  local ok, payload = pcall(vim.json_encode, data)
  if not ok then return false end
  local dir = vim.fn.fnamemodify(path, ':h')
  pcall(vim.fn.mkdir, dir, 'p')
  local success = pcall(vim.fn.writefile, { payload }, path)
  return success
end

function Commander:read_scenarios_file(path, mode)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then return false end
  local text = table.concat(lines or {}, '\n')
  local ok_json, obj = pcall(vim.json_decode, text)
  if not ok_json or type(obj) ~= 'table' then return false end
  local incoming = obj.scenarios or obj
  if type(incoming) ~= 'table' then incoming = {} end
  local store = self:scenarios()
  if mode == 'replace' then
    for k in pairs(store) do store[k] = nil end
  end
  local count = 0
  for k, v in pairs(incoming) do
    store[k] = v
    count = count + 1
  end
  return true, count
end

function Commander:complete(arglead, cmdline, cursorpos)
  local tokens = parse_cmdline(cmdline)
  if tokens[1] and tokens[1]:lower() == 'neg' then table.remove(tokens, 1) end
  local sub = tokens[1] or ''
  if #tokens == 0 or sub == '' then
    local res = {}
    local lead = arglead or ''
    for _, cmd in ipairs(SUBCOMMANDS) do
      if cmd:find('^' .. vim.pesc(lead)) then res[#res + 1] = cmd end
    end
    return res
  end
  if #tokens == 1 then
    local out = {}
    for _, v in ipairs(SUBCOMMANDS) do
      if v:find('^' .. vim.pesc(sub)) then out[#out + 1] = v end
    end
    return out
  end
  if sub == 'set' or sub == 'toggle' or sub == 'info' then
    if #tokens == 2 then
      return self.schema:list(arglead)
    elseif sub == 'set' and #tokens == 3 then
      local meta = self.schema:get(tokens[2])
      if not meta then return {} end
      return self.schema:complete_values(meta, arglead)
    end
    return {}
  elseif sub == 'list' then
    local options = { 'options', 'scenarios', 'plugins' }
    if #tokens == 2 then
      local out = {}
      for _, opt in ipairs(options) do
        if opt:find('^' .. vim.pesc(arglead or '')) then out[#out + 1] = opt end
      end
      return out
    end
    if tokens[2] == 'options' and #tokens == 3 then
      return self.schema:list(arglead)
    end
    return {}
  elseif sub == 'preset' then
    local meta = self.schema:get('preset')
    return self.schema:complete_values(meta, arglead)
  elseif sub == 'scenario' then
    local actions = { 'apply', 'save', 'list', 'delete', 'dump', 'load' }
    if #tokens == 2 then
      local out = {}
      for _, act in ipairs(actions) do
        if act:find('^' .. vim.pesc(arglead or '')) then out[#out + 1] = act end
      end
      return out
    end
    local action = tokens[2]
    if action == 'apply' or action == 'save' or action == 'delete' then
      return self:scenario_names(true)
    elseif action == 'dump' then
      local out = { 'current' }
      vim.list_extend(out, self:scenario_names(true))
      return out
    elseif action == 'load' then
      if arglead and arglead:sub(1, 1) == '@' then
        return file_complete(arglead)
      end
    end
    return {}
  elseif sub == 'plugins' then
    local actions = { 'set', 'toggle', 'list', 'detect' }
    if #tokens == 2 then
      local out = {}
      for _, act in ipairs(actions) do
        if act:find('^' .. vim.pesc(arglead or '')) then out[#out + 1] = act end
      end
      return out
    end
    local action = tokens[2]
    if (action == 'set' or action == 'toggle') and #tokens == 3 then
      local res = {}
      for key in pairs(self.schema.nodes) do
        if key:match('^plugins%.') then
          res[#res + 1] = key:sub(9)
        end
      end
      table.sort(res)
      return res
    elseif action == 'set' and #tokens == 4 then
      local meta = self.schema:get('plugins.' .. tokens[3])
      if meta then return self.schema:complete_values(meta, arglead) end
    end
  elseif sub == 'export' or sub == 'import' then
    return file_complete(arglead)
  end
  return {}
end

function Commander:create_alias(name, handler, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, handler, opts)
end

function Commander:alias_toggle(name, path)
  self:create_alias(name, function(command_opts)
    local arg = command_opts.args or ''
    local normalized = arg:lower()
    local action = (normalized ~= '' and normalized ~= 'toggle') and 'set' or 'toggle'
    local newcfg, result = self:apply_option(action, path, arg ~= '' and arg or nil)
    if not newcfg then
      self:warn('neg.nvim: ' .. tostring(result))
      return
    end
    self:apply_config(newcfg)
  end, {
    nargs = '?',
    complete = function(arglead)
      local choices = { 'on', 'off', 'toggle' }
      local res = {}
      local lead = arglead or ''
      for _, c in ipairs(choices) do
        if c:find('^' .. vim.pesc(lead)) then res[#res + 1] = c end
      end
      return res
    end,
  })
end

function Commander:alias_set(name, path)
  local meta = self.schema:get(path)
  local function compl(arglead)
    if not meta then return {} end
    return self.schema:complete_values(meta, arglead)
  end
  self:create_alias(name, function(command_opts)
    local arg = command_opts.args or ''
    if arg == '' then
      self:warn('neg.nvim: value required')
      return
    end
    local newcfg, result = self:apply_option('set', path, arg)
    if not newcfg then
      self:warn('neg.nvim: ' .. tostring(result))
      return
    end
    self:apply_config(newcfg)
  end, {
    nargs = 1,
    complete = meta and compl or nil,
  })
end

function Commander:alias_zone(name)
  local zones = { 'float', 'sidebar', 'statusline' }
  self:create_alias(name, function(opts)
    local zone = (opts.args or ''):lower()
    if zone == '' then
      self:warn('neg.nvim: usage: :NegToggleTransparentZone {float|sidebar|statusline}')
      return
    end
    local option = 'transparent.' .. zone
    if not self.schema:get(option) then
      self:warn("neg.nvim: unknown zone '" .. zone .. "'")
      return
    end
    local newcfg, result = self:apply_option('toggle', option)
    if not newcfg then
      self:warn('neg.nvim: ' .. tostring(result))
      return
    end
    self:apply_config(newcfg)
  end, {
    nargs = 1,
    complete = function()
      return zones
    end,
  })
end

function Commander:alias_diag_preset(name, blend)
  self:create_alias(name, function()
    local cfg = clone(self:get_config())
    cfg.diagnostics_virtual_bg = true
    cfg.diagnostics_virtual_bg_mode = 'blend'
    cfg.diagnostics_virtual_bg_blend = blend
    self:apply_config(cfg)
    self:announce('diagnostics.mode', 'blend')
  end, { nargs = 0 })
end

function Commander:register_legacy_aliases()
  self:alias_toggle('NegToggleTransparent', 'transparent')
  self:alias_zone('NegToggleTransparentZone')
  self:create_alias('NegReload', function() self:apply_config(self:get_config()) end, {})
  self:create_alias('NegPreset', function(opts)
    if opts.args == '' then
      self:warn('neg.nvim: usage: :NegPreset {soft|hard|...}')
      return
    end
    self:run({ args = 'set preset ' .. opts.args })
  end, {
    nargs = 1,
    complete = function(arglead) return self.schema:complete_values(self.schema:get('preset'), arglead) end,
  })
  local toggles = {
    { 'NegModeAccent', 'ui.mode_accent' },
    { 'NegSoftBorders', 'ui.soft_borders' },
    { 'NegFloatBg', 'ui.float_bg' },
    { 'NegFocusCaret', 'ui.focus_caret' },
    { 'NegDimInactive', 'ui.dim_inactive' },
    { 'NegDiffFocus', 'ui.diff_focus' },
    { 'NegScreenreader', 'ui.screenreader' },
    { 'NegLightSigns', 'ui.light_signs' },
    { 'NegPunctFamily', 'treesitter.punct_family' },
    { 'NegThickCursor', 'ui.thick_cursor' },
    { 'NegOutlines', 'ui.outlines' },
    { 'NegReadingMode', 'ui.reading_mode' },
    { 'NegPathSep', 'ui.path_separator_blue' },
  }
  for _, entry in ipairs(toggles) do
    self:alias_toggle(entry[1], entry[2])
  end
  self:alias_set('NegDiagBgMode', 'diagnostics.mode')
  self:alias_set('NegDiagBgStrength', 'diagnostics.strength')
  self:alias_set('NegDiagBgBlend', 'diagnostics.blend')
  self:alias_diag_preset('NegDiagSoft', 20)
  self:alias_diag_preset('NegDiagStrong', 10)
  self:create_alias('NegTelescopeAccents', function(opts)
    local arg = (opts.args or 'toggle'):lower()
    local action = (arg == '' or arg == 'toggle') and 'toggle' or 'set'
    local value = (action == 'toggle') and nil or opts.args
    local newcfg, result = self:apply_option(action, 'ui.telescope_accents', value)
    if not newcfg then
      self:warn('neg.nvim: ' .. tostring(result))
      return
    end
    self:apply_config(newcfg)
  end, {
    nargs = '?',
    complete = function() return { 'on', 'off', 'toggle', 'soft', 'default', 'strong' } end,
  })
  self:create_alias('NegPathSepColor', function(opts)
    local value = opts.args
    if value == '' then value = 'default' end
    self:run({ args = 'set ui.path_separator_color ' .. value })
  end, {
    nargs = '?',
    complete = function(arglead) return self.schema:complete_values(self.schema:get('ui.path_separator_color'), arglead) end,
  })
  self:alias_set('NegDiagPattern', 'ui.diag_pattern')
  self:alias_set('NegLexemeCues', 'ui.lexeme_cues')
  self:alias_set('NegSearchVisibility', 'ui.search_visibility')
  self:alias_set('NegHc', 'ui.accessibility.hc')
  self:alias_set('NegNumberColors', 'number_colors')
  self:alias_set('NegOperatorColors', 'operator_colors')
  self:alias_set('NegSelection', 'ui.selection_model')
  self:alias_set('NegSaturation', 'saturation')
  self:alias_set('NegAlpha', 'alpha')
  self:create_alias('NegAccessibility', function(opts)
    local tokens = self:tokens(opts.args or '')
    local feature = (tokens[1] or ''):lower()
    local state = (tokens[2] or 'toggle')
    if feature ~= 'deuteranopia' and feature ~= 'achromatopsia' then
      self:warn("neg.nvim: usage: :NegAccessibility {deuteranopia|achromatopsia} [on|off|toggle]")
      return
    end
    local path = 'ui.accessibility.' .. feature
    local action = (state ~= '' and state ~= 'toggle') and 'set' or 'toggle'
    local newcfg, result = self:apply_option(action, path, state ~= 'toggle' and state or nil)
    if not newcfg then
      self:warn('neg.nvim: ' .. tostring(result))
      return
    end
    self:apply_config(newcfg)
  end, {
    nargs = '*',
    complete = function(arglead)
      local base = { 'deuteranopia', 'achromatopsia', 'on', 'off', 'toggle' }
      local res = {}
      for _, v in ipairs(base) do if v:find('^' .. vim.pesc(arglead or '')) then res[#res + 1] = v end end
      return res
    end,
  })
  self:create_alias('NegScenario', function(opts)
    local name = (opts.args or ''):lower()
    if name == '' then
      self:warn('neg.nvim: usage: :NegScenario {focus|...}')
      return
    end
    if not self:apply_quick_scenario(name) then
      self:warn("neg.nvim: unknown scenario '" .. name .. "'")
    end
  end, {
    nargs = 1,
    complete = function() return { 'focus', 'presentation', 'screenreader', 'tui', 'gui', 'accessibility' } end,
  })
  self:create_alias('NegScenarioSave', function(opts)
    if opts.args == '' then self:warn('neg.nvim: usage: :NegScenarioSave {name}') return end
    self:run({ args = 'scenario save ' .. opts.args })
  end, { nargs = 1 })
  self:create_alias('NegScenarioList', function() self:run({ args = 'scenario list' }) end, { nargs = 0 })
  self:create_alias('NegScenarioDelete', function(opts)
    if opts.args == '' then self:warn('neg.nvim: usage: :NegScenarioDelete {name}') return end
    self:run({ args = 'scenario delete ' .. opts.args })
  end, { nargs = 1 })
  self:create_alias('NegScenarioExport', function(opts)
    local target = (opts.args ~= '' and opts.args) or 'current'
    self:run({ args = 'scenario dump ' .. target })
  end, {
    nargs = '?',
    complete = function(arglead)
      local out = { 'current' }
      vim.list_extend(out, self:scenario_names(true))
      return out
    end,
  })
  self:create_alias('NegScenarioImport', function(opts)
    if opts.args == '' then self:warn('neg.nvim: usage: :NegScenarioImport {@path|JSON} ...') return end
    self:run({ args = 'scenario load ' .. opts.args })
  end, {
    nargs = '+',
    complete = function(arglead)
      if arglead and arglead:sub(1, 1) == '@' then return file_complete(arglead) end
      return {}
    end,
  })
  self:create_alias('NegScenarioWrite', function(opts)
    self:run({ args = 'export ' .. (opts.args or '') })
  end, {
    nargs = '?',
    complete = function(arglead)
      if arglead and arglead:sub(1, 1) == '@' then return file_complete(arglead) end
      return {}
    end,
  })
  self:create_alias('NegScenarioRead', function(opts)
    self:run({ args = 'import ' .. (opts.args or '') })
  end, {
    nargs = '?',
    complete = function(arglead)
      if arglead and arglead:sub(1, 1) == '@' then return file_complete(arglead) end
      return {}
    end,
  })
end

return Commander
