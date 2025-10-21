local M = {}

local hi = vim.api.nvim_set_hl

local function clamp(x, a, b)
  if x < a then return a end
  if x > b then return b end
  return x
end

local function hex_to_rgb(hex)
  if type(hex) ~= 'string' or not hex:match('^#%x%x%x%x%x%x$') then return nil end
  local r = tonumber(hex:sub(2,3), 16)
  local g = tonumber(hex:sub(4,5), 16)
  local b = tonumber(hex:sub(6,7), 16)
  return r, g, b
end

local function rgb_to_hex(r, g, b)
  return string.format('#%02x%02x%02x', clamp(math.floor(r + 0.5), 0, 255), clamp(math.floor(g + 0.5), 0, 255), clamp(math.floor(b + 0.5), 0, 255))
end

function M.flags_from(v)
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

function M.apply_terminal_colors(p)
  local colors = {
    p.bg_default,   -- 0: black
    p.diff_delete_color,   -- 1: red
    p.diff_add_color,   -- 2: green
    p.warning_color,  -- 3: yellow
    p.include_color,   -- 4: blue
    p.violet_color, -- 5: magenta
    p.literal2_color,   -- 6: cyan
    p.white_color,   -- 7: white
  }
  for i = 0, 7 do
    vim.g['terminal_color_'..i] = colors[i+1]
    vim.g['terminal_color_'..(i+8)] = colors[i+1]
  end
end

function M.apply_transparent(cfg)
  local function set_bg(groups)
    for _, g in ipairs(groups) do hi(0, g, { bg='NONE' }) end
  end
  if cfg == true then
    set_bg({
      'Normal','NormalNC','NormalFloat','SignColumn','FoldColumn',
      'StatusLine','StatusLineNC','TabLine','TabLineFill','TabLineSel',
      'Pmenu','FloatBorder','FloatTitle','WinSeparator'
    })
    return
  end
  if type(cfg) == 'table' then
    if cfg.float then
      set_bg({
        'NormalFloat','Pmenu','FloatBorder','FloatTitle',
        -- Common plugin floats
        'WhichKeyFloat','WhichKeyBorder','DapUIFloatNormal',
        'CmpDocumentation','CmpDocumentationBorder',
        'TelescopeNormal','TelescopePreviewNormal','TelescopePromptNormal','TelescopeResultsNormal',
        'TelescopeBorder','TelescopePreviewBorder','TelescopePromptBorder','TelescopeResultsBorder',
        'NoicePopup','NoicePopupmenu','NoiceCmdlinePopup',
        'DressingInput','DressingInputBorder','DressingSelect','DressingSelectBorder',
        'FzfLuaNormal','FzfLuaBorder',
        'LazyNormal','LazyBorder',
        'MasonNormal','MasonBorder',
        'NeoTreeFloatNormal','NeoTreeFloatBorder',
        'LspInfoBorder',
        -- Additional plugin floats
        'SagaNormal','SagaBorder',
        'OverseerNormal','OverseerBorder',
        'NavbuddyNormal','NavbuddyBorder','NavbuddyFloatNormal','NavbuddyFloatBorder','NavbuddyPreviewNormal','NavbuddyPreviewBorder'
      })
    end
    if cfg.sidebar then
      set_bg({
        'NvimTreeNormal','NvimTreeNormalNC',
        'NeoTreeNormal','NeoTreeNormalNC',
        'TroubleNormal',
        'SymbolsOutlineNormal',
        'AerialNormal'
      })
    end
    if cfg.statusline then
      set_bg({ 'StatusLine','StatusLineNC','WinBar','WinBarNC','TabLine','TabLineFill','TabLineSel' })
    end
  end
end

-- Color utilities
function M.lighten(hex, percent)
  local r, g, b = hex_to_rgb(hex)
  if not r then return hex end
  local k = clamp(tonumber(percent) or 0, 0, 100) / 100
  r = r + (255 - r) * k
  g = g + (255 - g) * k
  b = b + (255 - b) * k
  return rgb_to_hex(r, g, b)
end

function M.darken(hex, percent)
  local r, g, b = hex_to_rgb(hex)
  if not r then return hex end
  local k = 1 - clamp(tonumber(percent) or 0, 0, 100) / 100
  r = r * k
  g = g * k
  b = b * k
  return rgb_to_hex(r, g, b)
end

function M.alpha(fg, bg, a)
  local r1, g1, b1 = hex_to_rgb(fg)
  local r2, g2, b2 = hex_to_rgb(bg)
  if not r1 or not r2 then return fg end
  local k = clamp(tonumber(a) or 0.15, 0, 1)
  local r = r1 * k + r2 * (1 - k)
  local g = g1 * k + g2 * (1 - k)
  local b = b1 * k + b2 * (1 - k)
  return rgb_to_hex(r, g, b)
end

function M.apply_overrides(overrides, p)
  if not overrides then return end
  local tbl = overrides
  if type(overrides) == 'function' then
    local ok, res = pcall(overrides, p)
    if ok and type(res) == 'table' then tbl = res else return end
  end
  if type(tbl) == 'table' then
    for name, style in pairs(tbl) do hi(0, name, style) end
  end
end

local function sig_copy(v)
  local t = type(v)
  if t == 'table' then
    local out = {}
    for k, val in pairs(v) do out[k] = sig_copy(val) end
    return out
  elseif t == 'function' then
    return 'fn'
  end
  return v
end

function M.config_signature(cfg)
  local copy = sig_copy(cfg)
  if type(copy) == 'table' then
    copy.force = nil
  end
  return copy
end

return M
