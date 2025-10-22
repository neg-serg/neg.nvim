# Changelog

All notable changes to this project are documented here.

## [4.04] - 2025-10-22
- Command: add `:NegOperatorColors {families|mono}` to switch operator coloring at runtime.
- Meta: bump version.

## [4.05] - 2025-10-22
- Style/harmony: tune links — URLs now use `include_color` with underline to stay readable without shouting.
- Numbers: add optional subtle single‑hue ramp via `number_colors = 'ramp'` (default stays `mono`).
- Command: add `:NegNumberColors {mono|ramp}` to toggle number ramp at runtime.
- Meta: bump version.

## [4.06] - 2025-10-22
- Numbers: change default `number_colors` to `ramp` (was `mono`).
- Meta: bump version.

## [4.07] - 2025-10-22
- UI: add option `ui.core_enhancements = true` (default) to define extra baseline UI groups (Whitespace, EndOfBuffer, PmenuMatch*, FloatShadow*, Cursor*, VisualNOS, LineNrAbove/Below, Question). Set to `false` to skip applying them.
- Internal: moved these groups to `neg.groups.editor_extras` and apply conditionally.
- Validator: include `neg.groups.editor_extras` in module scan.
- Meta: bump version.

## [4.03] - 2025-10-22
- LSP typemods: add safe links for declaration/static/readonly across common types —
  `@lsp.typemod.class.declaration`/`@lsp.typemod.type.declaration` → `@type`,
  `@lsp.typemod.property.declaration` → `@property`, `@lsp.typemod.enumMember.declaration` → `@constant`,
  `@lsp.typemod.function.static` → `@function`, `@lsp.typemod.enumMember.readonly` → `@constant`.
- Meta: bump version.

## [4.02] - 2025-10-22
- LSP tokens: add `@lsp.type.decorator` → `@function.macro`, `@lsp.type.annotation` → `@attribute`.
- LSP typemods: add a few common links without new colors — `@lsp.typemod.function.declaration` → `@function`, `@lsp.typemod.method.declaration` → `@method`, `@lsp.typemod.property.static` → `@property`, `@lsp.typemod.type.abstract`/`@lsp.typemod.class.abstract` → `@type`.
- Meta: bump version.

## [4.01] - 2025-10-22
- Config: add `operator_colors = 'families' | 'mono'` (default: `families`) to toggle per‑family vs single operator color.
- Treesitter: per‑family operator hues (assignment/comparison/arithmetic/logical/bitwise/etc.).
- Treesitter: boolean/nil/null/string template links — `@boolean.true`/`@boolean.false` → `@boolean`, `@nil`/`@null` → `@constant.builtin`, `@string.template` → `@string`.
- Palette: new convenience aliases (`bg_float`, `bg_panel`, `border_color`, `success_color`, `error_color`, `info_color`, `hint_color`, `accent_primary`, `accent_secondary`, `accent_tertiary`).
- UI: `NormalFloat` now uses `bg_float`.
- Docs: README updated for operator colors and palette additions.

## [4.00] - 2025-10-22
- Major release marking the removal of legacy Vim 'syntax' groups (breaking change introduced in 3.82). Theme now relies on Tree‑sitter captures and Neovim UI groups.
- Includes 3.83 enhancements: configurable markup (headings/list styles), extended Treesitter coverage (math/environment, logic, operator families, string templates, boolean/nil/null links), and core UI tweaks (Whitespace, EndOfBuffer, LineNrAbove/Below, Question, VisualNOS, Float shadows, Pmenu match highlights, cursor groups), plus moving Diff* groups to core editor.
- New option: `operator_colors = 'families' | 'mono'` to choose between subtle per-family operator hues or a single unified operator color (default: `families`).
 - Palette: add convenience aliases — `bg_float`, `bg_panel`, `border_color`,
   `success_color`, `error_color`, `info_color`, `hint_color`,
   `accent_primary`, `accent_secondary`, `accent_tertiary`. `NormalFloat` now uses `bg_float`.
- No additional breaking changes beyond the 3.82 deprecation.

## [3.83] - 2025-10-22
- Markup: configurable headings and list styles via `setup({ markup = ... })`.
- Markup: cohesive single‑hue ramp for headings by default (derived from `include_color`), overrideable per level (`h1..h6`).
- Styles: apply style flags to more Treesitter captures; preserves existing fg/bg/sp while adding style bits.
- Treesitter: extended capture coverage (numbers: integer/hex/octal/binary; constants.macro; types.parameter/qualifier; characters.special; markup: headings/link/raw.inline/list variants).
 - Treesitter: add markup captures `@markup.math` (now uses `literal2_color`), `@markup.environment`, `@markup.environment.name` with neutral palette.
- Docs: README updated with new `markup` options and examples.
- Meta: bump version and header in `init.lua`.
 - Core UI (editor):
   - Base: add `Whitespace` (subdued from `comment_color`), `EndOfBuffer` (hide tildes via `bg_default`), `LineNrAbove`/`LineNrBelow` (link to `LineNr`), `Question` (muted blue‑green), `VisualNOS` (like `Visual` but without bold).
   - Neovim 0.10+: add `FloatShadow`/`FloatShadowThrough` with soft shading close to `bg_default`.
   - Pmenu: add `PmenuMatch`/`PmenuMatchSel` (underline matches; use search hue without over‑saturation).
   - Cursor: define `Cursor`, `lCursor`, `CursorIM` consistent with `TermCursor` (reverse).
 - Diff: move `DiffAdd`/`DiffChange`/`DiffDelete`/`DiffText` from git plugin module into core editor module so diffs stay readable even when `plugins.git` is disabled.
 - Treesitter (logic/strings/operators):
   - Link `@boolean.true`/`@boolean.false` → `@boolean`.
   - Link `@nil`/`@null` → `@constant.builtin`.
   - Add `@string.template` → `@string` (punctuation already covered by `@punctuation.special`).
   - Add comprehensive operator subcaptures → `@operator` (uniform color; ready for future per‑family tweaks):
     `assignment{,.compound,.augmented}`, `comparison{,.equality,.relational}`,
     `arithmetic{,.add,.sub,.mul,.div,.mod,.pow}`, `logical{,.and,.or,.not,.xor}`,
     `bitwise{,.and,.or,.xor,.shift,.not,.left_shift,.right_shift}`,
     `ternary`, `unary`, `increment`, `decrement`, `range`, `spread`, `pipe`, `arrow`, `coalesce`.
   - Per‑family hues: assignment (keyword4), comparison (keyword3), arithmetic (keyword1), logical (keyword2), bitwise/range/spread/pipe (delimiter), ternary/coalesce (keyword3), unary (keyword4), increment/decrement/arrow (keyword1).

## [3.82] - 2025-10-22
- Breaking: fully removed legacy Vim 'syntax' highlight groups. Theme now relies exclusively on Treesitter `@` captures and Neovim UI groups.
- Removed module `neg.groups.syntax` and dropped its application from setup.
- Styles: `apply_styles` now targets only Treesitter captures (e.g. `@comment`, `@keyword`, `@function`, etc.); classic groups like `String`, `Function`, etc. are no longer styled.
- Links migrated to captures:
  - `DiffAdded` → `@string`, `DiffRemoved` → `@constant`
  - `Conceal` → `@operator`
  - `FlashLabel` (noice) → `@comment.todo`
- UI: removed `Todo` group; use `@comment.todo` instead.
- Validator: removed `neg.groups.syntax` from module lists.
- Validator: drop legacy Vim `syntax` groups from builtin target list; only UI/core groups are recognized as built-in.
- Treesitter: removed legacy `@text.*` alias links; use `@markup.*` and `@comment.*` captures.
- Treesitter: extended coverage for additional captures:
  - numbers: `@number.{integer,hex,octal,binary}`
  - constants/macros: `@constant.macro`
  - types: `@type.{parameter,qualifier}`
  - attributes/modules: `@attribute.builtin`, `@module.builtin`
  - characters: `@character.special`
  - markup: `@markup.heading.{1..6}`, `@markup.link`, `@markup.raw.inline`, `@markup.list{,.checked,.unchecked,.numbered}`
  - strings/comments: `@string.special.path`, `@comment.documentation`
- Styles: style flags now apply to the new captures above.
- Migration tip: if you still depend on legacy Vim syntax groups, define them in your config or link them to the corresponding `@` captures.


## [3.78] - 2025-10-22
- Validator: add coverage listing (`NEG_VALIDATE_LIST` + `NEG_VALIDATE_LIST_FILTER` + `NEG_VALIDATE_LIST_LIMIT`), per‑module stats (`NEG_VALIDATE_MODULE_STATS`), and duplicate source reporting (`NEG_VALIDATE_DUP_SOURCES`).
- Docs: README “Validator & CI” section updated to document the new options.
- Meta: bump version and Last Change header in `init.lua`.


## [3.74] - 2025-10-21
- Plugins: new integrations
  - neotest (status and UI groups)
  - harpoon (float Normal/Border)
  - alpha-nvim (header/footer/buttons/shortcut)
  - mini.statusline + mini.tabline
  - todo-comments (severity backgrounds)
  - nvim-navic (text/separator)
  - treesitter-playground (focus/lang/query/help)
- Docs: README plugin lists updated.







## [3.77] - 2025-10-21
- Plugins: navbuddy (float + preview windows, cursorline, scope).
- noice: cmdline/popup/popupmenu variants (+ borders).
- cmp: extended CmpItemKind* coloring for many kinds.
- Transparent floats: added Navbuddy* float/preview groups.
- Docs: README updated for navbuddy, noice variants, cmp kinds.

## [3.76] - 2025-10-21
- lspsaga: add detailed component groups (Finder, Code Action, Rename, Hover/Signature titles, Diagnostics, Outline, Winbar, Beacon/Spinner).
- Transparent floats: include SagaNormal/SagaBorder and OverseerNormal/OverseerBorder.
- Docs: README expanded lspsaga coverage.

## [3.75] - 2025-10-21
- Plugins: more integrations
  - lspsaga.nvim (SagaNormal/Border/Title)
  - overseer.nvim (Normal/Border/Title + statuses: Pending/Running/Success/Failed/Canceled/Error)
  - startify: detailed groups (Number/Path/Slash/Bracket/File/Var/Special/Header/Footer/Section/Select)
- nvim-navic: icon groups for many symbol kinds (NavicIcons*)
- Options: added toggles for startify/overseer/lspsaga in README, wired in code.

## [3.73] - 2025-10-21
- Validator: optional contrast ratio checks (enable with `NEG_VALIDATE_CONTRAST=1` and set `NEG_VALIDATE_CONTRAST_MIN`, default off).
- Validator: verbose summary line when `NEG_VALIDATE_VERBOSE=1`.
- Validator: extended module coverage to include more plugin integrations (bufferline, gitsigns, hop, indent, neo-tree, notify, nvim-tree, treesitter-context, trouble, which-key, dap/dap-ui).
- Docs: README documents new validator options.

## [3.72] - 2025-10-21
- Transparent zones: add more popular plugin groups
  - Float: Mason (`MasonNormal`, `MasonBorder`), lazy.nvim (`LazyNormal`, `LazyBorder`), Neo-tree float (`NeoTreeFloatNormal`, `NeoTreeFloatBorder`), `LspInfoBorder`.
  - Sidebar: symbols-outline (`SymbolsOutlineNormal`), aerial.nvim (`AerialNormal`).
- Docs: README “Detailed Plugin Coverage” mentions the new transparent float/sidebar coverage.

## [3.71] - 2025-10-21
- Cleanup: removed stray positional `nil` values in editor highlight tables (`StatusLine*`, `TabLine*`, `Cursor*`, `ColorColumn`).
- Transparent zones: extended `transparent.float` to cover more plugin groups (Telescope, cmp docs, Noice popups, Dressing, FzfLua).

## [3.70] - 2025-10-21
- Migration: Start gradual code migration to descriptive palette names.
  - Lualine theme: replace `clin`/`comm` with `bg_cursorline`/`comment_color`.
  - Docs: update README override examples from `fg_*` to descriptive aliases.

## [3.69] - 2025-10-21
- Docs: Added README migration cheat sheet (old → new palette names). Recommend descriptive aliases; keep `fg_*` and short names as compatibility aliases.

## [3.68] - 2025-10-21
- Palette: Completed migration to descriptive non-prefixed palette names internally; minimized `fg_*` usage in code while keeping aliases for backward compatibility.

## [3.67] - 2025-10-21
- Docs: README color utility recipes using `neg.util` (alpha/lighten/darken).

## [3.66] - 2025-10-21
- Commands: `:NegInfo` now shows diagnostics virtual background settings (enabled, mode, strength, blend).

## [3.65] - 2025-10-21
- Palette: Added descriptive aliases (e.g., `fg_default`, `bg_default`, `fg_keyword_*`, etc.) and refactored internal usage.
- Docs: Updated examples to use new color names.

## [3.64] - 2025-10-21
- Commands: Added `:NegDiagBgMode`, `:NegDiagBgStrength`, `:NegDiagBgBlend` to control diagnostics virtual text background at runtime.
- Docs: Documented the new commands.

## [3.63] - 2025-10-21
- Palette utils: Added `lighten`, `darken`, and `alpha` in `neg.util`.
- Diagnostics: Advanced `diagnostics_virtual_bg` modes (`blend`|`alpha`|`lighten`|`darken`) with `strength`.
- Docs: Extended Options section with the new fields.

## [3.62] - 2025-10-21
- Internal: incremental changes toward advanced diagnostics backgrounds.

## [3.61] - 2025-10-21
- LSP: Expanded `@lsp.typemod.*` mappings (declaration/definition/reference/readonly/static/async).

## [3.60] - 2025-10-21
- Plugins: Added bufferline highlight groups.
- Lualine: Provided `lualine.themes.neg` theme.

## [3.59] - 2025-10-21
- Refactor: Extracted helpers to `neg.util` (flags, transparency, terminal colors, overrides, config signature).
- Core: Idempotent setup — skip reapply on unchanged config; support `setup({ force = true })`.

## [3.58] - 2025-10-21
- Docs: Added Detailed Plugin Coverage section.

## [3.57] - 2025-10-21
- Docs: Added Troubleshooting and FAQ sections.

## [3.56] - 2025-10-21
- Docs: Added Common override recipes section.

## [3.55] - 2025-10-21
- Docs: Added Options section with defaults and descriptions.

## [3.54] - 2025-10-21
- Docs: Added Presets section (soft/hard/pro/writing) with examples.

## [3.53] - 2025-10-21
- Commands: Added `:NegPreset {soft|hard|pro|writing|none}`.
- Docs: Documented the command.

## [3.52] - 2025-10-21
- Commands: Added `:NegToggleTransparentZone {float|sidebar|statusline}`.
- Docs: Documented the command and zoned transparency usage.

## [3.51] - 2025-10-21
- Transparent: Zoned transparency via `transparent.{float,sidebar,statusline}` (boolean still supported).

## [3.50] - 2025-10-21
- Presets: Added style presets (`soft`, `hard`, `pro`, `writing`) selectable via `preset` or `:NegPreset`.

## [3.49] - 2025-10-21
- Docs: README now links to CHANGELOG; created release tag `v3.48`.

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
## [4.08] - 2025-10-22
- Treesitter: add option `treesitter.extras = true` (default) to enable subtle extra captures (math/environment, string.template, boolean true/false, nil/null, decorator/annotation, declaration/static/abstract links). Moved these into `neg.groups.treesitter_extras` and apply conditionally.
- Validator: include `neg.groups.treesitter_extras` in module scan.
- Meta: bump version.
