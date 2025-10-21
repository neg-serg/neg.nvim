local p = require('neg.palette')

-- lspsaga.nvim (best-effort common groups)
-- Float-like aesthetics to match popups
return {
  SagaNormal = { bg = '#111d26', fg = p.default_color },
  SagaBorder = { link = 'FloatBorder' },
  SagaTitle  = { link = 'FloatTitle' },
  SagaShadow = { fg = p.dark_color },
}

