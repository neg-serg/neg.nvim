local p = require('neg.palette')

-- lspsaga.nvim (best-effort common groups)
-- Float-like aesthetics to match popups
local M = {
  SagaNormal = { bg = '#111d26', fg = p.default_color },
  SagaBorder = { link = 'FloatBorder' },
  SagaTitle  = { link = 'FloatTitle' },
  SagaShadow = { fg = p.dark_color },

  -- Finder
  SagaFinderTitle      = { link = 'FloatTitle' },
  SagaFinderSelection  = { bg = p.bg_cursorline, bold = true },
  SagaFinderFile       = { fg = p.include_color },
  SagaFinderIcon       = { fg = p.tag_color },

  -- Code Action
  SagaCodeActionTitle  = { link = 'FloatTitle' },
  SagaCodeActionText   = { fg = p.default_color },
  SagaCodeActionNumber = { fg = p.keyword3_color },

  -- Rename
  SagaRenameTitle      = { link = 'FloatTitle' },
  SagaRenameBorder     = { link = 'FloatBorder' },
  SagaRenameNormal     = { bg = '#111d26', fg = p.default_color },
  SagaRenameMatch      = { fg = p.search_color, bold = true },

  -- Hover/Signature
  SagaHoverTitle       = { link = 'FloatTitle' },
  SagaSignatureTitle   = { link = 'FloatTitle' },

  -- Diagnostics window
  SagaDiagnosticTitle   = { link = 'FloatTitle' },
  SagaDiagnosticBorder  = { link = 'FloatBorder' },
  SagaDiagnosticSource  = { fg = p.preproc_dark_color },
  SagaDiagnosticPos     = { fg = p.comment_color },
  SagaDiagnosticLineNr  = { fg = p.comment_color },
  SagaDiagnosticWord    = { fg = p.default_color },

  -- Outline
  SagaOutlineTitle     = { link = 'FloatTitle' },
  SagaOutlineNormal    = { bg = '#111d26', fg = p.default_color },
  SagaOutlineIndent    = { fg = p.comment_color },

  -- Winbar components
  SagaWinbarFile       = { fg = p.default_color, bold = true },
  SagaWinbarFolderName = { fg = p.include_color },
  SagaWinbarSeparator  = { fg = p.dark_color },
  SagaToggleIcon       = { fg = p.comment_color },

  -- Misc effects
  SagaBeacon           = { bg = p.highlight_color },
  SagaSpinner          = { fg = p.keyword3_color, italic = true },
}

return M
