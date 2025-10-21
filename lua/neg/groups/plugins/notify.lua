local p = require('neg.palette')

local function sev(name, col)
  return {
    ["Notify"..name.."Border"]={fg=col},
    ["Notify"..name.."Icon"]={fg=col},
    ["Notify"..name.."Title"]={fg=col, bold=true},
  }
end

local M = {
  NotifyBackground={bg='#111d26', fg=p.default_color},
}

for _, s in ipairs({
  {"ERROR", p.diff_delete_color},
  {"WARN", p.warning_color},
  {"INFO", p.preproc_light_color},
  {"DEBUG", p.identifier_color},
  {"TRACE", p.comment_color},
}) do
  local name, col = s[1], s[2]
  local t = sev(name, col)
  for k, v in pairs(t) do M[k]=v end
end

return M
