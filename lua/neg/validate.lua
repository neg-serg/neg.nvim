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
  String=true, Constant=true, Identifier=true, Statement=true, Keyword=true,
  Function=true, Conditional=true, Repeat=true, Label=true, Operator=true,
  PreProc=true, Include=true, Define=true, Macro=true, PreCondit=true,
  Type=true, StorageClass=true, Structure=true, Typedef=true, Special=true,
  SpecialChar=true, SpecialComment=true, Underlined=true, Ignore=true,
  Delimiter=true, Todo=true, FloatBorder=true, WinSeparator=true,
}

local function load_tables()
  local mods = {
    'neg.groups.syntax',
    'neg.groups.editor',
    'neg.groups.diagnostics',
    'neg.groups.treesitter',
    'neg.groups.plugins.cmp',
    'neg.groups.plugins.telescope',
    'neg.groups.plugins.git',
    'neg.groups.plugins.noice',
    'neg.groups.plugins.obsidian',
    'neg.groups.plugins.rainbow',
    'neg.groups.plugins.headline',
  }
  local tables = {}
  for _, m in ipairs(mods) do
    local ok, t = pcall(require, m)
    if ok and type(t) == 'table' then tables[#tables+1] = t end
  end
  return tables
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

local function validate()
  local tables = load_tables()
  local defined, duplicates = collect_defined(tables)

  local errors, warnings = {}, {}

  -- Warn duplicate group definitions
  for name in pairs(duplicates) do
    warnings[#warnings+1] = ("duplicate group: %s is defined in multiple modules"):format(name)
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

  for _, tbl in ipairs(tables) do
    for name, style in pairs(tbl) do
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
        end
      end
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
  local errs = M.run()
  local code = type(errs) == 'table' and errs[1] or errs
  if vim and vim.cmd then
    if code > 0 then vim.cmd('cquit 1') else vim.cmd('qall') end
  else
    os.exit(code)
  end
end

return M

