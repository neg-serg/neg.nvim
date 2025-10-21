# Changelog

All notable changes to this project are documented here.

## [3.47] - 2025-10-21
- Docs: README switched fully to English (commands, overrides, sections).

## [3.46] - 2025-10-21
- Docs: Expanded README (install via lazy.nvim and vim-plug, options, plugins, commands, overrides, validator section).

## [3.45] - 2025-10-21
- Plugins: Added which-key, nvim-tree, neo-tree, nvim-dap, dap-ui, trouble.nvim, nvim-notify, treesitter-context, hop.nvim.
- Styles: Expanded categories (types, operators, numbers, booleans, constants, punctuation).
- Diagnostics: Optional virtual text background with blend.
- Commands: :NegToggleTransparent, :NegReload, :NegInfo.

## [3.44] - 2025-10-21
- Terminal: Set 16 ANSI terminal colors from the palette (configurable via `terminal_colors`).

## [3.43] - 2025-10-21
- Plugins: Added gitsigns and indent guides (indent-blankline/ibl, mini.indentscope).

## [3.42] - 2025-10-21
- LSP: Added `LspInlayHint`, `LspCodeLens`, and `LspReference{Text,Read,Write}` highlights.

## [3.41] - 2025-10-21
- Editor: Added builtin UI groups: NormalFloat, FloatTitle, WinBar/WinBarNC, QuickFixLine, Substitute, MsgArea, MsgSeparator, TermCursor/TermCursorNC.
- Noice: Removed duplicate `Cursor` definition from plugin module.

## [3.40] - 2025-10-21
- Groups: Added plugin group modules (cmp, git, headline, noice, rainbow, telescope) and Treesitter module.

## [3.39] - 2025-10-21
- Groups: Split diagnostics into `neg.groups.diagnostics` and wire in setup.

## [3.38] - 2025-10-21
- Palette: Added `dwarn` (warning yellow/orange) and applied to diagnostics.

## [3.37] - 2025-10-21
- Validate: Fixed warnings by replacing `bg=''` with `nil`, removing `standout`, and avoiding `link` mixed with attrs.

## [3.36] - 2025-10-21
- CI: Strict mode — fail on warnings (`NEG_VALIDATE_STRICT=1`).

## [3.35] - 2025-10-21
- CI: Added GitHub Actions workflow to run validator.

## [3.34] - 2025-10-21
- Tooling: Added validator (`lua/neg/validate.lua`) and `scripts/validate.sh`.

## [3.33] - 2025-10-21
- Setup: New options (transparent, styles, plugins, overrides). Preserve user config when applying `:colorscheme neg`.

## [3.32] - 2025-10-21
- Fix: Correct `VertSplit` link usage.

## [3.31] - 2025-10-21
- Fix: Correct `VertSplit` link usage.

## [3.30] - 2025-10-21
- Groups: Moved diagnostics into a dedicated module.

## [3.29] - 2025-10-21
- Colors: Added `colors/neg.lua` entrypoint for `:colorscheme neg`.

## [3.28] - 2025-10-21
- Refactor: Split monolithic init into modules (syntax, editor, treesitter, plugins, diagnostics).

## [3.27] - 2025-10-21
- Cleanup: Removed legacy ALE highlight groups.

## [3.26] - 2025-10-21
- Diagnostics: Introduced dedicated warning color and wired across warn groups.

## [3.25] - 2025-10-21
- Diagnostics: Added VirtualText*, Underline* (undercurl + sp), Sign*, Floating*, Deprecated.

## [3.24] - 2025-10-21
- Treesitter: Modernized capture mappings and added LSP semantic token links.

## [3.23]
- Previous version prior to the refactor documented above.

