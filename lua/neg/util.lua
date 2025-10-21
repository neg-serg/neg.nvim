local M = {}

local hi = vim.api.nvim_set_hl

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
    p.bclr,   -- 0: black
    p.dred,   -- 1: red
    p.dadd,   -- 2: green
    p.dwarn,  -- 3: yellow
    p.incl,   -- 4: blue
    p.violet, -- 5: magenta
    p.lit2,   -- 6: cyan
    p.whit,   -- 7: white
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
      set_bg({ 'NormalFloat','Pmenu','FloatBorder','FloatTitle','WhichKeyFloat','WhichKeyBorder','DapUIFloatNormal' })
    end
    if cfg.sidebar then
      set_bg({ 'NvimTreeNormal','NvimTreeNormalNC','NeoTreeNormal','NeoTreeNormalNC','TroubleNormal' })
    end
    if cfg.statusline then
      set_bg({ 'StatusLine','StatusLineNC','WinBar','WinBarNC','TabLine','TabLineFill','TabLineSel' })
    end
  end
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
