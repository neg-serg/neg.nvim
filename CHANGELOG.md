# Changelog

All notable changes to this project are documented here.

## [4.04]
Release date: 2025-10-23 02:02:37 +0300
- Command: add `:NegOperatorColors {families|mono}` to switch operator coloring at runtime.
- Meta: bump version.

## [4.05]
Release date: 2025-10-23 02:03:52 +0300
- Style/harmony: tune links — URLs now use `include_color` with underline to stay readable without shouting.
- Numbers: add optional subtle single‑hue ramp via `number_colors = 'ramp'` (default stays `mono`).
- Command: add `:NegNumberColors {mono|ramp}` to toggle number ramp at runtime.
- Meta: bump version.

## [4.06]
Release date: 2025-10-23 02:05:06 +0300
- Numbers: change default `number_colors` to `ramp` (was `mono`).
- Meta: bump version.

## [4.07]
Release date: 2025-10-23 02:07:08 +0300
- UI: add option `ui.core_enhancements = true` (default) to define extra baseline UI groups (Whitespace, EndOfBuffer, PmenuMatch*, FloatShadow*, Cursor*, VisualNOS, LineNrAbove/Below, Question). Set to `false` to skip applying them.
- Internal: moved these groups to `neg.groups.editor_extras` and apply conditionally.
- Validator: include `neg.groups.editor_extras` in module scan.
- Meta: bump version.

## [4.03]
Release date: 2025-10-22
- LSP typemods: add safe links for declaration/static/readonly across common types —
  `@lsp.typemod.class.declaration`/`@lsp.typemod.type.declaration` → `@type`,
  `@lsp.typemod.property.declaration` → `@property`, `@lsp.typemod.enumMember.declaration` → `@constant`,
  `@lsp.typemod.function.static` → `@function`, `@lsp.typemod.enumMember.readonly` → `@constant`.
- Meta: bump version.

## [4.02]
Release date: 2025-10-22
- LSP tokens: add `@lsp.type.decorator` → `@function.macro`, `@lsp.type.annotation` → `@attribute`.
- LSP typemods: add a few common links without new colors — `@lsp.typemod.function.declaration` → `@function`, `@lsp.typemod.method.declaration` → `@method`, `@lsp.typemod.property.static` → `@property`, `@lsp.typemod.type.abstract`/`@lsp.typemod.class.abstract` → `@type`.
- Meta: bump version.

## [4.01]
Release date: 2025-10-22
- Config: add `operator_colors = 'families' | 'mono'` (default: `families`) to toggle per‑family vs single operator color.
- Treesitter: per‑family operator hues (assignment/comparison/arithmetic/logical/bitwise/etc.).
- Treesitter: boolean/nil/null/string template links — `@boolean.true`/`@boolean.false` → `@boolean`, `@nil`/`@null` → `@constant.builtin`, `@string.template` → `@string`.
- Palette: new convenience aliases (`bg_float`, `bg_panel`, `border_color`, `success_color`, `error_color`, `info_color`, `hint_color`, `accent_primary`, `accent_secondary`, `accent_tertiary`).
- UI: `NormalFloat` now uses `bg_float`.
- Docs: README updated for operator colors and palette additions.

## [4.00]
Release date: 2025-10-22
- Major release marking the removal of legacy Vim 'syntax' groups (breaking change introduced in 3.82). Theme now relies on Tree‑sitter captures and Neovim UI groups.
- Includes 3.83 enhancements: configurable markup (headings/list styles), extended Treesitter coverage (math/environment, logic, operator families, string templates, boolean/nil/null links), and core UI tweaks (Whitespace, EndOfBuffer, LineNrAbove/Below, Question, VisualNOS, Float shadows, Pmenu match highlights, cursor groups), plus moving Diff* groups to core editor.
- New option: `operator_colors = 'families' | 'mono'` to choose between subtle per-family operator hues or a single unified operator color (default: `families`).
 - Palette: add convenience aliases — `bg_float`, `bg_panel`, `border_color`,
   `success_color`, `error_color`, `info_color`, `hint_color`,
   `accent_primary`, `accent_secondary`, `accent_tertiary`. `NormalFloat` now uses `bg_float`.
- No additional breaking changes beyond the 3.82 deprecation.

## [3.83]
Release date: 2025-10-22
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

## [3.82]
Release date: 2025-10-22
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


## [3.78]
Release date: 2025-10-22
- Validator: add coverage listing (`NEG_VALIDATE_LIST` + `NEG_VALIDATE_LIST_FILTER` + `NEG_VALIDATE_LIST_LIMIT`), per‑module stats (`NEG_VALIDATE_MODULE_STATS`), and duplicate source reporting (`NEG_VALIDATE_DUP_SOURCES`).
- Docs: README “Validator & CI” section updated to document the new options.
- Meta: bump version and Last Change header in `init.lua`.


## [3.74]
Release date: 2025-10-21
- Plugins: new integrations
  - neotest (status and UI groups)
  - harpoon (float Normal/Border)
  - alpha-nvim (header/footer/buttons/shortcut)
  - mini.statusline + mini.tabline
  - todo-comments (severity backgrounds)
  - nvim-navic (text/separator)
  - treesitter-playground (focus/lang/query/help)
- Docs: README plugin lists updated.







## [3.77]
Release date: 2025-10-21
- Plugins: navbuddy (float + preview windows, cursorline, scope).
- noice: cmdline/popup/popupmenu variants (+ borders).
- cmp: extended CmpItemKind* coloring for many kinds.
- Transparent floats: added Navbuddy* float/preview groups.
- Docs: README updated for navbuddy, noice variants, cmp kinds.

## [3.76]
Release date: 2025-10-21
- lspsaga: add detailed component groups (Finder, Code Action, Rename, Hover/Signature titles, Diagnostics, Outline, Winbar, Beacon/Spinner).
- Transparent floats: include SagaNormal/SagaBorder and OverseerNormal/OverseerBorder.
- Docs: README expanded lspsaga coverage.

## [3.75]
Release date: 2025-10-21
- Plugins: more integrations
  - lspsaga.nvim (SagaNormal/Border/Title)
  - overseer.nvim (Normal/Border/Title + statuses: Pending/Running/Success/Failed/Canceled/Error)
  - startify: detailed groups (Number/Path/Slash/Bracket/File/Var/Special/Header/Footer/Section/Select)
- nvim-navic: icon groups for many symbol kinds (NavicIcons*)
- Options: added toggles for startify/overseer/lspsaga in README, wired in code.

## [3.73]
Release date: 2025-10-21
- Validator: optional contrast ratio checks (enable with `NEG_VALIDATE_CONTRAST=1` and set `NEG_VALIDATE_CONTRAST_MIN`, default off).
- Validator: verbose summary line when `NEG_VALIDATE_VERBOSE=1`.
- Validator: extended module coverage to include more plugin integrations (bufferline, gitsigns, hop, indent, neo-tree, notify, nvim-tree, treesitter-context, trouble, which-key, dap/dap-ui).
- Docs: README documents new validator options.

## [3.72]
Release date: 2025-10-21
- Transparent zones: add more popular plugin groups
  - Float: Mason (`MasonNormal`, `MasonBorder`), lazy.nvim (`LazyNormal`, `LazyBorder`), Neo-tree float (`NeoTreeFloatNormal`, `NeoTreeFloatBorder`), `LspInfoBorder`.
  - Sidebar: symbols-outline (`SymbolsOutlineNormal`), aerial.nvim (`AerialNormal`).
- Docs: README “Detailed Plugin Coverage” mentions the new transparent float/sidebar coverage.

## [3.71]
Release date: 2025-10-21
- Cleanup: removed stray positional `nil` values in editor highlight tables (`StatusLine*`, `TabLine*`, `Cursor*`, `ColorColumn`).
- Transparent zones: extended `transparent.float` to cover more plugin groups (Telescope, cmp docs, Noice popups, Dressing, FzfLua).

## [3.70]
Release date: 2025-10-21
- Migration: Start gradual code migration to descriptive palette names.
  - Lualine theme: replace `clin`/`comm` with `bg_cursorline`/`comment_color`.
  - Docs: update README override examples from `fg_*` to descriptive aliases.

## [3.69]
Release date: 2025-10-21
- Docs: Added README migration cheat sheet (old → new palette names). Recommend descriptive aliases; keep `fg_*` and short names as compatibility aliases.

## [3.68]
Release date: 2025-10-21
- Palette: Completed migration to descriptive non-prefixed palette names internally; minimized `fg_*` usage in code while keeping aliases for backward compatibility.

## [3.67]
Release date: 2025-10-21
- Docs: README color utility recipes using `neg.util` (alpha/lighten/darken).

## [3.66]
Release date: 2025-10-21
- Commands: `:NegInfo` now shows diagnostics virtual background settings (enabled, mode, strength, blend).

## [3.65]
Release date: 2025-10-21
- Palette: Added descriptive aliases (e.g., `fg_default`, `bg_default`, `fg_keyword_*`, etc.) and refactored internal usage.
- Docs: Updated examples to use new color names.

## [3.64]
Release date: 2025-10-21
- Commands: Added `:NegDiagBgMode`, `:NegDiagBgStrength`, `:NegDiagBgBlend` to control diagnostics virtual text background at runtime.
- Docs: Documented the new commands.

## [3.63]
Release date: 2025-10-21
- Palette utils: Added `lighten`, `darken`, and `alpha` in `neg.util`.
- Diagnostics: Advanced `diagnostics_virtual_bg` modes (`blend`|`alpha`|`lighten`|`darken`) with `strength`.
- Docs: Extended Options section with the new fields.

## [3.62]
Release date: 2025-10-21
- Internal: incremental changes toward advanced diagnostics backgrounds.

## [3.61]
Release date: 2025-10-21
- LSP: Expanded `@lsp.typemod.*` mappings (declaration/definition/reference/readonly/static/async).

## [3.60]
Release date: 2025-10-21
- Plugins: Added bufferline highlight groups.
- Lualine: Provided `lualine.themes.neg` theme.

## [3.59]
Release date: 2025-10-21
- Refactor: Extracted helpers to `neg.util` (flags, transparency, terminal colors, overrides, config signature).
- Core: Idempotent setup — skip reapply on unchanged config; support `setup({ force = true })`.

## [3.58]
Release date: 2025-10-21
- Docs: Added Detailed Plugin Coverage section.

## [3.57]
Release date: 2025-10-21
- Docs: Added Troubleshooting and FAQ sections.

## [3.56]
Release date: 2025-10-21
- Docs: Added Common override recipes section.

## [3.55]
Release date: 2025-10-21
- Docs: Added Options section with defaults and descriptions.

## [3.54]
Release date: 2025-10-21
- Docs: Added Presets section (soft/hard/pro/writing) with examples.

## [3.53]
Release date: 2025-10-21
- Commands: Added `:NegPreset {soft|hard|pro|writing|none}`.
- Docs: Documented the command.

## [3.52]
Release date: 2025-10-21
- Commands: Added `:NegToggleTransparentZone {float|sidebar|statusline}`.
- Docs: Documented the command and zoned transparency usage.

## [3.51]
Release date: 2025-10-21
- Transparent: Zoned transparency via `transparent.{float,sidebar,statusline}` (boolean still supported).

## [3.50]
Release date: 2025-10-21
- Presets: Added style presets (`soft`, `hard`, `pro`, `writing`) selectable via `preset` or `:NegPreset`.

## [3.49]
Release date: 2025-10-21
- Docs: README now links to CHANGELOG; created release tag `v3.48`.

## [3.47]
Release date: 2025-10-21
- Docs: README switched fully to English (commands, overrides, sections).

## [3.46]
Release date: 2025-10-21
- Docs: Expanded README (install via lazy.nvim and vim-plug, options, plugins, commands, overrides, validator section).

## [3.45]
Release date: 2025-10-21
- Plugins: Added which-key, nvim-tree, neo-tree, nvim-dap, dap-ui, trouble.nvim, nvim-notify, treesitter-context, hop.nvim.
- Styles: Expanded categories (types, operators, numbers, booleans, constants, punctuation).
- Diagnostics: Optional virtual text background with blend.
- Commands: :NegToggleTransparent, :NegReload, :NegInfo.

## [3.44]
Release date: 2025-10-21
- Terminal: Set 16 ANSI terminal colors from the palette (configurable via `terminal_colors`).

## [3.43]
Release date: 2025-10-21
- Plugins: Added gitsigns and indent guides (indent-blankline/ibl, mini.indentscope).

## [3.42]
Release date: 2025-10-21
- LSP: Added `LspInlayHint`, `LspCodeLens`, and `LspReference{Text,Read,Write}` highlights.

## [3.41]
Release date: 2025-10-21
- Editor: Added builtin UI groups: NormalFloat, FloatTitle, WinBar/WinBarNC, QuickFixLine, Substitute, MsgArea, MsgSeparator, TermCursor/TermCursorNC.
- Noice: Removed duplicate `Cursor` definition from plugin module.

## [3.40]
Release date: 2025-10-21
- Groups: Added plugin group modules (cmp, git, headline, noice, rainbow, telescope) and Treesitter module.

## [3.39]
Release date: 2025-10-21
- Groups: Split diagnostics into `neg.groups.diagnostics` and wire in setup.

## [3.38]
Release date: 2025-10-21
- Palette: Added `dwarn` (warning yellow/orange) and applied to diagnostics.

## [3.37]
Release date: 2025-10-21
- Validate: Fixed warnings by replacing `bg=''` with `nil`, removing `standout`, and avoiding `link` mixed with attrs.

## [3.36]
Release date: 2025-10-21
- CI: Strict mode — fail on warnings (`NEG_VALIDATE_STRICT=1`).

## [3.35]
Release date: 2025-10-21
- CI: Added GitHub Actions workflow to run validator.

## [3.34]
Release date: 2025-10-21
- Tooling: Added validator (`lua/neg/validate.lua`) and `scripts/validate.sh`.

## [3.33]
Release date: 2025-10-21
- Setup: New options (transparent, styles, plugins, overrides). Preserve user config when applying `:colorscheme neg`.

## [3.32]
Release date: 2025-10-21
- Fix: Correct `VertSplit` link usage.

## [3.31]
Release date: 2025-10-21
- Fix: Correct `VertSplit` link usage.

## [3.30]
Release date: 2025-10-21
- Groups: Moved diagnostics into a dedicated module.

## [3.29]
Release date: 2025-10-21
- Colors: Added `colors/neg.lua` entrypoint for `:colorscheme neg`.

## [3.28]
Release date: 2025-10-21
- Refactor: Split monolithic init into modules (syntax, editor, treesitter, plugins, diagnostics).

## [3.27]
Release date: 2025-10-21
- Cleanup: Removed legacy ALE highlight groups.

## [3.26]
Release date: 2025-10-21
- Diagnostics: Introduced dedicated warning color and wired across warn groups.

## [3.25]
Release date: 2025-10-21
- Diagnostics: Added VirtualText*, Underline* (undercurl + sp), Sign*, Floating*, Deprecated.

## [3.24]
Release date: 2025-10-21
- Treesitter: Modernized capture mappings and added LSP semantic token links.

## [3.23]
- Previous version prior to the refactor documented above.
## [4.08] - 2025-10-23 02:09:49 +0300
- Treesitter: add option `treesitter.extras = true` (default) to enable subtle extra captures (math/environment, string.template, boolean true/false, nil/null, decorator/annotation, declaration/static/abstract links). Moved these into `neg.groups.treesitter_extras` and apply conditionally.
- Validator: include `neg.groups.treesitter_extras` in module scan.
- Meta: bump version.

## [4.09]
Release date: 2025-10-23 02:13:25 +0300
- Treesitter extras: add more subtle captures/links:
  - Markup: `@markup.link.text` → `@markup.link.label`
  - Punctuation families: `@punctuation.parenthesis`/`@punctuation.brace` → `@punctuation.bracket`
  - Types: `@type.enum`/`@type.union`/`@type.interface` → `@type`
  - Strings: `@string.documentation` (italic, comment tone)
  - Constants: `@constant.builtin.{boolean,numeric}` → `@boolean`/`@number`
  - LSP typemod: `@lsp.typemod.enumMember.static` → `@constant`
- Meta: bump version.
## [4.10]
Release date: 2025-10-23 02:16:15 +0300
- Preset: add `accessibility` profile with higher contrast, minimal italics, stronger separators and line numbers; disables soft diagnostic virtual backgrounds.
- Docs: README updated (presets list and examples).
- Meta: bump version.

## [4.11]
Release date: 2025-10-23 02:17:41 +0300
- Preset: add `focus` profile — dims inactive windows (stronger NormalNC/WinBarNC) and softens separators (`VertSplit`/`WinSeparator`) to reduce visual noise.
- Docs: README updated (presets list and examples).
- Meta: bump version.

## [4.12]
Release date: 2025-10-23 02:18:52 +0300
- Preset: add `presentation` profile — brighter accents with more visible `CursorLine`/`CursorLineNr`, and slightly emphasized search/title for demos and talks.
- Docs: README updated (presets list and examples).
- Meta: bump version.
## [4.13]
Release date: 2025-10-23 02:20:50 +0300
- UI: add `ui.dim_inactive` (default false) — dims non‑current windows via `NormalNC`/`WinBarNC` and maps `LineNr` to a dim variant using window‑local `winhighlight` (on `WinEnter/WinLeave`).
- Docs: README updated (UI options).
- Meta: bump version.
## [4.14]
Release date: 2025-10-23 02:22:00 +0300
- UI: add `ui.mode_accent` (default false) — mode-aware accents for `CursorLine` and `StatusLine` based on Vim mode (Normal/Insert/Visual). Implemented via `ModeChanged`/`WinEnter` autocmds with palette-derived hues.
- Docs: README updated (UI options).
- Meta: bump version.
## [4.15]
Release date: 2025-10-23 02:22:54 +0300
- Command: add `:NegModeAccent {on|off|toggle}` to switch mode-aware accents at runtime.
- Docs: README updated (commands).
- Meta: bump version.
## [4.16]
Release date: 2025-10-23 02:23:57 +0300
- UI: add `ui.soft_borders` (default false) — lighter `WinSeparator`/`FloatBorder` for softer boundaries.
- Command: `:NegSoftBorders {on|off|toggle}` to switch at runtime.
- Docs: README updated (UI options + Commands).
- Meta: bump version.
## [4.17]
Release date: 2025-10-23 02:25:52 +0300
- UI: auto-tune float/panel backgrounds for transparent terminals — when `Normal` bg is transparent and float transparency is off, set subtle backdrops for `NormalFloat`/`Pmenu`.
- Option: `ui.auto_transparent_panels = true` (default) controls this behavior.
- Docs: README updated (UI options).
- Meta: bump version.
## [4.18]
Release date: 2025-10-23 02:27:22 +0300
- UI: add `ui.diff_focus` (default true) — strengthens `DiffAdd`/`DiffChange`/`DiffDelete`/`DiffText` backgrounds when any window is in `:diff` mode; restores baseline otherwise.
- Implementation: global highlights toggled via autocmds; previous colors preserved and restored when leaving diff.
- Docs: README updated (UI options).
- Meta: bump version.
## [4.19]
Release date: 2025-10-23 02:28:36 +0300
- UI: add `ui.light_signs` (default false) — softens sign icons (`DiagnosticSign*`, `GitSigns*`) by blending their hue with background to reduce noise while keeping semantics.
- Command: `:NegLightSigns {on|off|toggle}` to switch at runtime.
- Docs: README updated (UI options + Commands).
- Meta: bump version.
## [4.20]
Release date: 2025-10-23 02:29:45 +0300
- Diagnostics: add quick commands `:NegDiagSoft` and `:NegDiagStrong` to set softer/stronger virtual text backgrounds (blend ≈ 20 / 10) without tweaking individual settings.
- Docs: README updated (Commands).
- Meta: bump version.
## [4.21]
Release date: 2025-10-23 02:31:05 +0300
- Treesitter operators: add `operator_colors = 'mono+'` preset — keeps single operator hue but with a slightly stronger accent; available via `:NegOperatorColors mono+`.
- Docs: README updated (Options, command help).
- Meta: bump version.
## [4.22]
Release date: 2025-10-23 02:32:34 +0300
- Treesitter punctuation: add `treesitter.punct_family` (default false) to differentiate `@punctuation.parenthesis`/`@punctuation.brace` from `@punctuation.bracket` with subtle hues.
- Command: `:NegPunctFamily {on|off|toggle}` to switch at runtime.
- Docs: README updated (Options + Commands).
- Meta: bump version.
## [4.23]
Release date: 2025-10-23 02:33:46 +0300
- Numbers ramp: add presets — `ramp-soft` (very subtle), `ramp` (balanced, default), `ramp-strong` (higher contrast). Usable via `number_colors` option and `:NegNumberColors` command.
- Docs: README updated (options + command).
- Meta: bump version.
## [4.24]
Release date: 2025-10-23 02:35:12 +0300
- Accessibility options:
  - `ui.accessibility.deuteranopia` — shifts additions (ok/plus) toward blue for red/green deficiency; warnings remain orange.
  - `ui.accessibility.strong_undercurl` — makes diagnostic undercurls more visible (adds underline fallback).
  - Command: `:NegAccessibility {deuteranopia|strong_undercurl} {on|off|toggle}`.
- Docs: README updated (UI options + Commands).
- Meta: bump version.
## [4.25]
Release date: 2025-10-23 02:36:12 +0300
- UI: enable `ui.mode_accent` by default to provide mode-aware accents for `CursorLine`/`StatusLine` (Normal/Insert/Visual). Command `:NegModeAccent {on|off|toggle}` remains available to control it at runtime.
- Docs: README updated (default changed to true).
- Meta: bump version.
## [4.26]
Release date: 2025-10-23 02:38:15 +0300
- Preset: 'focus' now enables `ui.dim_inactive` and `ui.soft_borders` by default (as part of the profile) to reduce visual noise and emphasize the active window.
- Meta: bump version.
## [4.27]
Release date: 2025-10-23 02:44:25 +0300
- Docs: add Russian quick guide `README.ru.md` covering new options and runtime commands; link from main README.
- Meta: bump version.
## [4.28]
Release date: 2025-10-23 02:46:21 +0300
- Accessibility: add `ui.accessibility.achromatopsia` (monochrome/high-contrast assist). Reduces reliance on hue by normalizing syntax colors, uses style cues (bold/underline), grayscale diagnostics and neutral diff backgrounds.
- Command: `:NegAccessibility achromatopsia {on|off|toggle}`.
- Docs: README/README.ru updated (options + command).
- Meta: bump version.
## [4.29]
Release date: 2025-10-23 02:49:53 +0300
- Accessibility pack extensions:
  - High-contrast presets for achromatopsia: `:NegHc {off|soft|strong}`; tune `Visual`/`ColorColumn`/`StatusLine`/`NormalFloat`/`Pmenu`.
  - Pattern-first diagnostics: `ui.diag_pattern = 'none'|'minimal'|'strong'` + `:NegDiagPattern` command.
  - Lexeme cues: underline for functions; underline+bold for types (`ui.lexeme_cues`, `:NegLexemeCues`).
  - Thick cursor: `ui.thick_cursor`/`:NegThickCursor` — более заметная текущая строка и курсор.
  - UI outlines: `ui.outlines`/`:NegOutlines` — рамки активных окон через winhighlight.
  - Reading mode: `ui.reading_mode`/`:NegReadingMode` — почти монохромный синтаксис.
  - Search visibility: `ui.search_visibility`/`:NegSearchVisibility` — мягкий/сильный пресет.
  - Screenreader friendly: `ui.screenreader_friendly` — снижает динамические акценты.
- Docs: README/README.ru updated (options + commands).
- Meta: bump version.

## [4.30]
Release date: 2025-10-23 03:19:51 +0300
- Telescope: neutral defaults restored (no strong blue). Enhanced accents moved behind new option `ui.telescope_accents = false` by default.
- Command: add `:NegTelescopeAccents {on|off|toggle}` to control enhanced Telescope accents at runtime.
- Docs: README/README.ru updated (options + commands). Clarified accessibility high‑contrast `ui.accessibility.hc` option in English README.
- Meta: bump version and update `Last Change` header in `lua/neg/init.lua`.

## [4.31]
Release date: 2025-10-23 03:27:24 +0300
- Commands: add quick toggles for core UX features:
  - `:NegDimInactive {on|off|toggle}` — dim inactive windows.
  - `:NegDiffFocus {on|off|toggle}` — stronger Diff* backgrounds in :diff.
  - `:NegScreenreader {on|off|toggle}` — screenreader‑friendly mode.
- Docs: README/README.ru — Commands section updated.
- Meta: bump version.

## [4.32]
Release date: 2025-10-23 03:29:33 +0300
- Command: add `:NegContrast {Group|@capture}` — prints contrast ratio (WCAG) for the group's foreground vs background (resolves effective colors; falls back to Normal bg).
- Docs: README/README.ru updated with the new command.
- Meta: bump version and header.

## [4.33]
Release date: 2025-10-23 03:32:10 +0300
- :NegContrast: add actionable suggestions when contrast is below AA:
  - Prints a nearest suggested foreground to reach AA / AA (large) and the operation (lighten/darken, approx. %).
  - Tips to try `:NegHc soft|strong` or `:NegPreset accessibility|presentation`, and a minimal overrides snippet.
- Meta: bump version.

## [4.34]
Release date: 2025-10-23 03:33:25 +0300
- :NegContrast: add optional background argument: `:NegContrast Group [vs {Group|#rrggbb}]`.
- :NegContrast: print a ready `:hi {Group} guifg=#rrggbb` line for the suggested AA/AA-large foreground.
- Docs: README/README.ru updated with new usage.
- Meta: bump version.

## [4.35]
Release date: 2025-10-23 03:35:00 +0300
- :NegContrast: switched to printing a ready `:hi {Group} guifg=#rrggbb` line only (removed Lua overrides snippet in output).
- Meta: bump version.
## [4.36]
Release date: 2025-10-23 03:34:58 +0300
- Accessibility: remove `ui.accessibility.strong_tui_cursor` option and its behavior; feature is no longer supported.
- :NegAccessibility: update accepted features to `deuteranopia|strong_undercurl|achromatopsia`.
- Docs: README/README.ru updated accordingly.
- Meta: bump version and header.

## [4.37]
Release date: 2025-10-23 03:37:50 +0300
- :NegContrast: add `--target AA|AAA` to compute suggestions against a chosen WCAG threshold; default is AA.
- :NegContrast: support `apply` to instantly set the suggested foreground via `:hi {Group} guifg=...`.
- Docs: README/README.ru updated with new flags.
- Meta: bump version and header.

## [4.38]
Release date: 2025-10-23 03:40:03 +0300
- Global saturation: add `saturation = 100` option and runtime command `:NegSaturation {0..100}` to scale palette saturation via HSL (100 = original, 0 = grayscale).
- Implementation: transforms the palette in-place from a pristine base before (re)applying highlights; idempotent and reversible.
- Docs: README/README.ru updated (options + commands).
- Meta: bump version and header.

## [4.39]
Release date: 2025-10-23 03:43:20 +0300
- Global alpha overlay: add `alpha_overlay = 0` option and `:NegAlpha {0..30}` command to control soft backgrounds for Search/CurSearch/Visual and DiagnosticVirtualText*. Values map to alpha blend (0..0.30) and proportional darken for Visual.
- Order of application: applied after diagnostics virtual bg and before user overrides to stay predictable.
- Docs: README/README.ru updated (options + commands).
- Meta: bump version and header.

## [4.40]
Release date: 2025-10-23 03:45:55 +0300
- Command: add `:NegExport` — prints current highlight colors (core UI, diff, diagnostics, syntax) in a compact report with quick tips (diff/search).
- Docs: README/README.ru document the command.
- Meta: bump header.

## [4.41]
Release date: 2025-10-23 03:47:13 +0300
- Focus caret: new `ui.focus_caret = true` (default on) and `:NegFocusCaret {on|off|toggle}` — slightly boosts `CursorLine` contrast when overall contrast is below AA (~4.5:1), with an autocmd that coexists with mode accents.
- Docs: README/README.ru updated (options + commands).
- Meta: bump version and header.

## [4.42]
Release date: 2025-10-23 03:48:40 +0300
- Accessibility (achromatopsia): softly increase visibility of structure zones — `Folded` and `ColorColumn` now get slightly stronger backgrounds to stay readable without color cues.
- Docs: README/README.ru note the behavior under `ui.accessibility.achromatopsia`.
- Meta: bump version and header.

## [4.43]
Release date: 2025-10-23 03:50:20 +0300
- Telescope: fully neutralize prompt/results/preview backgrounds by linking `Telescope*Normal` (Prompt/Results/Preview/Normal) to `Normal` (no bluish float tint). Matching stays underline-only by default.
- Rationale: previous blue tint came from `NormalFloat` (bg_float) affecting Telescope windows; explicit links remove that hue.
