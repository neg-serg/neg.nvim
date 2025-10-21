local p = require('neg.palette')

local function sev(name, col)
  return {
    ["Notify"..name.."Border"]={fg=col},
    ["Notify"..name.."Icon"]={fg=col},
    ["Notify"..name.."Title"]={fg=col, bold=true},
  }
end

local M = {
  NotifyBackground={bg='#111d26', fg=p.fg_default},
}

for _, s in ipairs({
  {"ERROR", p.fg_diff_delete},
  {"WARN", p.fg_warning},
  {"INFO", p.fg_preproc_light},
  {"DEBUG", p.fg_identifier},
  {"TRACE", p.fg_comment},
}) do
  local name, col = s[1], s[2]
  local t = sev(name, col)
  for k, v in pairs(t) do M[k]=v end
end

return M
