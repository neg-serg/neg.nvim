local M = {}

-- Allowable style keys for nvim_set_hl
local allowed_keys = {
  fg=true, bg=true, sp=true,
  bold=true, italic=true, underline=true, undercurl=true,
  strikethrough=true, reverse=true, nocombine=true,
  link=true, blend=true,
  -- discouraged but seen in legacy configs
  standout=true,
}

-- Common builtin highlight targets present in Neovim
local builtin_targets = {
  -- UI/core groups only; legacy Vim 'syntax' groups removed
  Normal=true, NormalNC=true, NormalFloat=true,
  SignColumn=true, FoldColumn=true, LineNr=true,
  CursorLine=true, CursorColumn=true, CursorLineNr=true,
  ColorColumn=true, Title=true, Visual=true,
  Error=true, ErrorMsg=true, WarningMsg=true, ModeMsg=true,
  MoreMsg=true, Question=true, StatusLine=true, StatusLineNC=true,
  WildMenu=true, Pmenu=true, PmenuSbar=true, PmenuSel=true, PmenuThumb=true,
  VertSplit=true, Folded=true, SpecialKey=true, NonText=true,
  SpellBad=true, SpellCap=true, SpellLocal=true, SpellRare=true,
  TabLine=true, TabLineFill=true, TabLineSel=true,
  Underlined=true, FloatBorder=true, WinSeparator=true,
}

local function load_tables()
  local mods = {
    -- core
    'neg.groups.editor',
    'neg.groups.editor_extras',
    'neg.groups.diagnostics',
    'neg.groups.treesitter',
    'neg.groups.treesitter_extras',
    -- plugins (extended)
    'neg.groups.plugins.bufferline',
    'neg.groups.plugins.cmp',
    'neg.groups.plugins.alpha',
    'neg.groups.plugins.startify',
    'neg.groups.plugins.dap',
    'neg.groups.plugins.dapui',
    'neg.groups.plugins.overseer',
    'neg.groups.plugins.harpoon',
    'neg.groups.plugins.git',
    'neg.groups.plugins.gitsigns',
    'neg.groups.plugins.headline',
    'neg.groups.plugins.hop',
    'neg.groups.plugins.indent',
    'neg.groups.plugins.mini_statusline',
    'neg.groups.plugins.mini_tabline',
    'neg.groups.plugins.navic',
    'neg.groups.plugins.navbuddy',
    'neg.groups.plugins.lspsaga',
    'neg.groups.plugins.neo_tree',
    'neg.groups.plugins.noice',
    'neg.groups.plugins.notify',
    'neg.groups.plugins.nvim_tree',
    'neg.groups.plugins.obsidian',
    'neg.groups.plugins.rainbow',
    'neg.groups.plugins.todo_comments',
    'neg.groups.plugins.telescope',
    'neg.groups.plugins.treesitter_playground',
    'neg.groups.plugins.treesitter_context',
    'neg.groups.plugins.trouble',
    'neg.groups.plugins.which_key',
    -- phase 1 additions
    'neg.groups.plugins.diffview',
    'neg.groups.plugins.fidget',
    'neg.groups.plugins.toggleterm',
    'neg.groups.plugins.dashboard',
    'neg.groups.plugins.heirline',
    'neg.groups.plugins.oil',
    'neg.groups.plugins.blink',
    'neg.groups.plugins.leap',
    'neg.groups.plugins.flash',
    'neg.groups.plugins.ufo',
    'neg.groups.plugins.bqf',
  }
  local tables = {}
  for _, m in ipairs(mods) do
    local ok, t = pcall(require, m)
    if ok and type(t) == 'table' then tables[#tables+1] = t end
  end
  return tables
end

local function load_modules()
  local mods = {
    -- core
    'neg.groups.editor',
    'neg.groups.editor_extras',
    'neg.groups.diagnostics',
    'neg.groups.treesitter',
    'neg.groups.treesitter_extras',
    -- plugins (extended)
    'neg.groups.plugins.bufferline',
    'neg.groups.plugins.cmp',
    'neg.groups.plugins.alpha',
    'neg.groups.plugins.startify',
    'neg.groups.plugins.dap',
    'neg.groups.plugins.dapui',
    'neg.groups.plugins.overseer',
    'neg.groups.plugins.harpoon',
    'neg.groups.plugins.git',
    'neg.groups.plugins.gitsigns',
    'neg.groups.plugins.headline',
    'neg.groups.plugins.hop',
    'neg.groups.plugins.indent',
    'neg.groups.plugins.mini_statusline',
    'neg.groups.plugins.mini_tabline',
    'neg.groups.plugins.navic',
    'neg.groups.plugins.navbuddy',
    'neg.groups.plugins.lspsaga',
    'neg.groups.plugins.neo_tree',
    'neg.groups.plugins.noice',
    'neg.groups.plugins.notify',
    'neg.groups.plugins.nvim_tree',
    'neg.groups.plugins.obsidian',
    'neg.groups.plugins.rainbow',
    'neg.groups.plugins.todo_comments',
    'neg.groups.plugins.telescope',
    'neg.groups.plugins.treesitter_playground',
    'neg.groups.plugins.treesitter_context',
    'neg.groups.plugins.trouble',
    'neg.groups.plugins.which_key',
    -- phase 1 additions
    'neg.groups.plugins.diffview',
    'neg.groups.plugins.fidget',
    'neg.groups.plugins.toggleterm',
    'neg.groups.plugins.dashboard',
    'neg.groups.plugins.heirline',
    'neg.groups.plugins.oil',
    'neg.groups.plugins.blink',
    'neg.groups.plugins.leap',
    'neg.groups.plugins.flash',
    'neg.groups.plugins.ufo',
    'neg.groups.plugins.bqf',
  }
  local modules = {}
  for _, m in ipairs(mods) do
    local ok, t = pcall(require, m)
    if ok and type(t) == 'table' then
      modules[#modules+1] = { name = m, table = t }
    end
  end
  return modules
end

local function collect_defined_with_sources(modules)
  local defined = {}
  local dup_sources = {}
  for _, mod in ipairs(modules) do
    for name, _ in pairs(mod.table) do
      if defined[name] then
        dup_sources[name] = dup_sources[name] or {}
        dup_sources[name][#dup_sources[name]+1] = mod.name
      else
        defined[name] = true
        dup_sources[name] = { mod.name }
      end
    end
  end
  local duplicates = {}
  for name, mods in pairs(dup_sources) do
    if #mods > 1 then duplicates[name] = mods end
  end
  return defined, duplicates
end

local function collect_defined(tables)
  local defined = {}
  local duplicates = {}
  for _, tbl in ipairs(tables) do
    for name, _ in pairs(tbl) do
      if defined[name] then duplicates[name] = true end
      defined[name] = true
    end
  end
  return defined, duplicates
end

local function keycount(t)
  local n = 0
  for _ in pairs(t) do n = n + 1 end
  return n
end

-- Helpers for optional contrast checks
local function getenv_bool(name)
  local v = (vim and vim.env and vim.env[name]) or os.getenv(name)
  if not v then return false end
  v = tostring(v):lower()
  return v == '1' or v == 'true' or v == 'yes' or v == 'on'
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

local function validate()
  local tables = load_tables()
  local modules = load_modules()
  local defined, duplicates = collect_defined_with_sources(modules)

  local errors, warnings = {}, {}

  local contrast_on = getenv_bool('NEG_VALIDATE_CONTRAST')
  local verbose_on = getenv_bool('NEG_VALIDATE_VERBOSE')
  local min_ratio = tonumber((vim and vim.env and vim.env.NEG_VALIDATE_CONTRAST_MIN) or os.getenv('NEG_VALIDATE_CONTRAST_MIN')) or 0

  -- configuration for reporting
  local list_on = getenv_bool('NEG_VALIDATE_LIST')
  local module_stats_on = getenv_bool('NEG_VALIDATE_MODULE_STATS')
  local dup_sources_on = getenv_bool('NEG_VALIDATE_DUP_SOURCES') or verbose_on
  local list_filter = (vim and vim.env and vim.env.NEG_VALIDATE_LIST_FILTER) or os.getenv('NEG_VALIDATE_LIST_FILTER')
  local list_limit = tonumber((vim and vim.env and vim.env.NEG_VALIDATE_LIST_LIMIT) or os.getenv('NEG_VALIDATE_LIST_LIMIT')) or 0

  -- Warn duplicate group definitions
  for name, mods in pairs(duplicates) do
    if dup_sources_on then
      warnings[#warnings+1] = ("duplicate group: %s in %s"):format(name, table.concat(mods, ", "))
    else
      warnings[#warnings+1] = ("duplicate group: %s is defined in multiple modules"):format(name)
    end
  end

  local function add_err(msg)
    errors[#errors+1] = msg
  end
  local function add_warn(msg)
    warnings[#warnings+1] = msg
  end

  local function is_capture(s)
    return type(s) == 'string' and s:sub(1,1) == '@'
  end

  local missing_link_targets = 0
  local total = 0
  for _, tbl in ipairs(tables) do
    for name, style in pairs(tbl) do
      total = total + 1
      if type(style) ~= 'table' then
        add_err(('%s: value must be table, got %s'):format(name, type(style)))
      else
        local has_link = style.link ~= nil
        -- Unknown keys / array part
        for k, v in pairs(style) do
          if type(k) ~= 'string' then
            add_warn(('%s: unexpected array value (%s)'):format(name, tostring(v)))
          elseif not allowed_keys[k] then
            add_err(('%s: unknown key %q'):format(name, k))
          end
        end
        -- Discourage standout
        if style.standout ~= nil then
          add_warn(('%s: "standout" is discouraged; prefer bold/reverse'):format(name))
        end
        if has_link then
          if type(style.link) ~= 'string' or style.link == '' then
            add_err(('%s: link must be non-empty string'):format(name))
          end
          -- Do not mix link with other attrs
          if keycount(style) > (style.blend and 2 or 1) then
            -- allow blend with link (nvim supports it), otherwise warn
            add_warn(('%s: link combined with other attrs; only link is used'):format(name))
          end
          local target = style.link
          if target == name then
            add_err(('%s: link to itself'):format(name))
          else
            if not defined[target] and not builtin_targets[target] and not is_capture(target) then
              add_warn(('%s: link target %q not found (may be builtin or capture)'):format(name, target))
              missing_link_targets = missing_link_targets + 1
            end
          end
        else
          -- Validate value types
          local function check_color(field)
            local v = style[field]
            if v ~= nil then
              if v == '' then
                add_warn(('%s: %s is empty string; prefer nil or "NONE"'):format(name, field))
              elseif type(v) ~= 'string' then
                add_err(('%s: %s must be string (hex or "NONE"), got %s'):format(name, field, type(v)))
              else
                local s = v
                if s ~= 'NONE' then
                  if not s:match('^#%x%x%x%x%x%x$') then
                    add_err(('%s: %s has invalid color %q (expect #RRGGBB or "NONE")'):format(name, field, s))
                  end
                end
              end
            end
          end
          check_color('fg'); check_color('bg'); check_color('sp')

          if style.blend ~= nil and type(style.blend) ~= 'number' then
            add_err(('%s: blend must be number'):format(name))
          end
          for _, key in ipairs({'bold','italic','underline','undercurl','strikethrough','reverse','nocombine'}) do
            local v = style[key]
            if v ~= nil and type(v) ~= 'boolean' then
              add_err(('%s: %s must be boolean, got %s'):format(name, key, type(v)))
            end
          end
          -- Simple contrast sanity: if both fg and bg present and equal → warn
          if style.fg and style.bg and style.fg ~= 'NONE' and style.bg ~= 'NONE' then
            if style.fg == style.bg then
              add_warn(('%s: fg equals bg (%s); low contrast'):format(name, style.fg))
            elseif contrast_on and min_ratio > 0 then
              local ratio = contrast_ratio(style.fg, style.bg)
              if ratio and ratio < min_ratio then
                add_warn(('%s: low contrast %.2f (fg %s on bg %s)'):format(name, ratio, style.fg, style.bg))
              end
            end
          end
        end
      end
    end
  end

  if verbose_on then
    print(('INFO: groups defined: %d; duplicates: %d; modules loaded: %d; scanned entries: %d; missing link targets: %d')
      :format(keycount(defined), keycount(duplicates), #modules, total, missing_link_targets))
  end

  if module_stats_on then
    print('INFO: module group counts:')
    for _, mod in ipairs(modules) do
      local c = 0
      for _ in pairs(mod.table) do c = c + 1 end
      print((' - %s: %d'):format(mod.name, c))
    end
  end

  if list_on then
    local list = {}
    for name in pairs(defined) do
      if not list_filter or tostring(name):match(list_filter) then
        list[#list+1] = name
      end
    end
    table.sort(list)
    local n = 0
    for _, name in ipairs(list) do
      print(('DEF: %s'):format(name))
      n = n + 1
      if list_limit > 0 and n >= list_limit then break end
    end
  end

  return errors, warnings
end

function M.run()
  local errors, warnings = validate()
  local function echo(list, kind)
    for _, m in ipairs(list) do
      print(('%s: %s'):format(kind, m))
    end
  end
  if #warnings > 0 then echo(warnings, 'WARN') end
  if #errors > 0 then echo(errors, 'ERROR') end
  return #errors, #warnings
end

function M.exit()
  local errors, warnings = M.run()
  local strict = (vim and vim.env and vim.env.NEG_VALIDATE_STRICT) or os.getenv('NEG_VALIDATE_STRICT')
  local s = tostring(strict or ''):lower()
  local strict_on = (s == '1' or s == 'true' or s == 'yes')
  local code = errors
  if strict_on and warnings > 0 then code = errors + warnings end
  if vim and vim.cmd then
    if code > 0 then vim.cmd('cquit 1') else vim.cmd('qall') end
  else
    os.exit(code)
  end
end

return M
