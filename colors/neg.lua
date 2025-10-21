-- neg colorscheme entrypoint for :colorscheme neg

vim.cmd('hi clear')
if vim.fn.exists('syntax_on') == 1 then
  vim.cmd('syntax reset')
end

vim.g.colors_name = 'neg'

local ok, theme = pcall(require, 'neg')
if ok and type(theme) == 'table' and type(theme.setup) == 'function' then
  -- Reuse existing config if user called require('neg').setup({...}) earlier
  theme.setup(theme._config or {})
end
