local term = require("neg.term")

local M = {}

function M.colorscheme()
    vim.o.background = "dark"
    vim.termguicolors = true
    vim.g.colors_name = "neg"
    term.setup()
end

return M
