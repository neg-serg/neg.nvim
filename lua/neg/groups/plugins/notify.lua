local p = require('neg.palette')

local function sev(name, col)
  return {
    ["Notify"..name.."Border"]={fg=col},
    ["Notify"..name.."Icon"]={fg=col},
    ["Notify"..name.."Title"]={fg=col, bold=true},
  }
end

local M = {
  NotifyBackground={bg='#111d26', fg=p.norm},
}

for _, s in ipairs({
  {"ERROR", p.dred},
  {"WARN", p.dwarn},
  {"INFO", p.lbgn},
  {"DEBUG", p.iden},
  {"TRACE", p.comm},
}) do
  local name, col = s[1], s[2]
  local t = sev(name, col)
  for k, v in pairs(t) do M[k]=v end
end

return M

