# neg.nvim — Release Highlights (4.x series)

This document summarizes the changes across the 4.x line in a thematic, free‑form way. It complements the per‑version CHANGELOG by grouping features and decisions into topics to make the intent and usage clearer.

## New in 4.67

- Default‑palette sanitizer: remaps any leftover `NvimLight*`/`NvimDark*` highlights to the theme palette. Toggle with `ui.sanitize_defaults`.
- Tooling: `:NegSanitizeScan` prints groups still using default palette (if any) after apply.
- Legacy syntax coverage: add core Vim groups (String/Character/Number/Boolean/etc.) so non‑Tree‑sitter setups use palette colors.
- Colors: strings retuned to a cool, subdued steel‑blue `#6e879f` for better readability.
- Fix: Lua completion typo (`||` → `or`) that could prevent theme loading in rare paths.

## Core UI & Editor

- Baseline UI groups filled in (ui.core_enhancements = true by default): Whitespace, EndOfBuffer, LineNrAbove/Below (0.10+), Question, VisualNOS, FloatShadow/FloatShadowThrough, PmenuMatch/MatchSel, Cursor/lCursor/CursorIM.
- Diff always available in core (not gated by git plugins): DiffAdd/Change/Delete/Text live in the editor module so diff mode remains readable even with plugins disabled.
- Mode‑aware accents (ui.mode_accent = true): gentle CursorLine/StatusLine tint per Vim mode; pairs with focus_caret below.
- Focus caret (ui.focus_caret = true): boosts CursorLine a bit when overall contrast is low (AA‑aware heuristic).
- Dim inactive (ui.dim_inactive): mutes NormalNC/WinBarNC and LineNr via winhighlight mapping.
- Soft borders (ui.soft_borders): lighter WinSeparator/FloatBorder for calmer frames.
- Outlines (ui.outlines): optional per‑window WinSeparator accent for clearer focus separation.
- Thick cursor (ui.thick_cursor): stronger CursorLine/CursorLineNr without resorting to flashy colors.
- Float background model (ui.float_panel_bg): default floats match Normal exactly; optional “panel” background provides a slightly lighter float backdrop.
- Neutral floats by default (NormalFloat → link Normal): removes prior blue/gray tint completely.
- Search visibility presets: tune Search/CurSearch emphasis without flooding the view.

## Diagnostics & Diff

- Virtual text background: controllable modes (blend/alpha/lighten/darken) and strength; quick helpers :NegDiagSoft and :NegDiagStrong.
- Diagnostic patterns (ui.diag_pattern): none|minimal|strong for underline/undercurl emphasis.
- Screenreader‑friendly mode: stabilizes dynamic accents and suppresses strong diff focus backgrounds for calmer speech output.
- Diff focus (ui.diff_focus): stronger Diff* backgrounds when any window is in :diff (toggleable, defaults on).

## Tree‑sitter & LSP

- Extras (treesitter.extras = true by default):
  - Markup: @markup.math, @markup.environment, @markup.environment.name, @markup.link.text
  - Strings: @string.template, @string.documentation
  - Booleans & nulls: @boolean.true/@boolean.false, @nil/@null
  - Punctuation families: @punctuation.parenthesis/@punctuation.brace (optional separation)
  - Types: @type.enum/@type.union/@type.interface
  - Constants: @constant.builtin.boolean/@constant.builtin.numeric
- Operators:
  - Operator families available; runtime preset: :NegOperatorColors {families|mono|mono+}. ‘families’ is default for subtle variety; ‘mono+’ is a single‑hue with a mild accent.
- LSP semantic tokens:
  - @lsp.type.decorator → @function.macro, @lsp.type.annotation → @attribute
  - Typemods added prudently: declarations/abstract/static/readonly for common kinds, incl. @lsp.typemod.enumMember.static → @constant.

## Numbers & Palette

- Numbers ramp: subtle single‑hue variants for integer/hex/octal/binary with presets ramp|ramp‑soft|ramp‑strong; runtime :NegNumberColors.
- Palette modernization: descriptive names (e.g. include_color, diff_add_color, bg_panel), plus helpers like border_color and selection_bg/fg.
- Global saturation slider :NegSaturation {0..100} for quick neutral↔vivid tuning.
- Global alpha overlay :NegAlpha {0..30} for soft fill on Search/CurSearch/Visual and DiagnosticVirtualText.

## Telescope, Kitty & Path Separators

- Neutral Telescope defaults: matching is underline‑only; selection links to Visual; all Telescope panes link to Normal to avoid tinted floats.
- Optional accents (ui.telescope_accents, :NegTelescopeAccents): tasteful match/selection accents for those who want extra pop.
- Selection model integrates kitty: ui.selection_model = 'kitty' (now default) applies kitty‑style selection colors to Visual/VisualNOS; :NegSelection switches between 'default' and 'kitty'.
- Path separators:
  - ui.path_separator_blue (toggle) and ui.path_separator_color let you tint path separators in a zsh‑like blue.
  - Scope: TelescopePathSeparator, StartifySlash, NavicSeparator, WhichKeySeparator (respects plugin toggles).

## Accessibility & Profiles

- Presets: accessibility, focus, presentation (plus soft/hard/pro/writing).
- Achromatopsia support: achromatopsia flag plus high‑contrast pack ui.accessibility.hc ('off'|'soft'|'strong').
- Deuteranopia option: gentle hue shift to keep additions/warnings distinct.
  
- Reading mode: near‑monochrome syntax with clearer structure and low noise.
- Lexeme cues: underline functions and emphasize types (off|minimal|strong).

## Runtime Tools

- :NegContrast {Group|@capture} [vs Group|#hex] [--target AA|AAA] [apply]
  - Prints WCAG contrast; can target AA/AAA, suggests a :hi; optionally applies.
- :NegExport — dumps core/diff/diagnostics/syntax colors and quick tips.
- Rich set of toggles for day‑to‑day UX: ModeAccent, FocusCaret, DimInactive, DiffFocus, SoftBorders, FloatBg, LightSigns, PunctFamily, TelescopeAccents, Selection, ReadingMode, Outlines, ThickCursor, SearchVisibility, Screenreader, Hc.

## Documentation & Quality

- English + Russian READMEs stay in sync.
- “Preset Map”, “Quick Toggles”, “Quick Examples”, and “Known Interactions” sections help you navigate runtime behavior and precedence.
- Apply order is documented to prevent surprises; validator checks keys, links, and can optionally check contrast.

## Defaults you should know

- ui.core_enhancements = true, treesitter.extras = true, ui.mode_accent = true, ui.diff_focus = true, selection_model = 'kitty'.
- ui.soft_borders = false, ui.float_panel_bg = false, ui.telescope_accents = false, ui.path_separator_blue = false.
- number_colors = 'ramp', operator_colors = 'families'.

## Migration hints

- If you relied on distinct float background, enable ui.float_panel_bg or override NormalFloat.
- If you preferred theme selection (not kitty), run :NegSelection default or set ui.selection_model = 'default'.
- If a plugin recolors Telescope after theme application, use :NegReload or your own overrides to re‑assert choices.

## Credits and approach

The 4.x line focuses on clarity, gentle defaults, optional accents behind toggles, and strong accessibility tooling. We keep user overrides last in the pipeline and document known interactions so your preferences win consistently.
