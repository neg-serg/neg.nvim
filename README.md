# neg

[Русская версия README](README.ru.md)

Modern Neovim colorscheme partially based on Jason W Ryan's miromiro:
https://www.vim.org/scripts/script.php?script_id=3815

Highlights are organized by modules (core, LSP/Tree‑sitter, plugins) with a
clean setup API, plugin toggles, and a simple validator used in CI.

## Features

- Modular highlight groups: core UI, syntax, diagnostics, LSP, Tree‑sitter
- Plugin integrations (toggleable): telescope, cmp, gitsigns, indent‑blankline/ibl,
  mini.indentscope, which‑key, neo‑tree, nvim‑tree, dap, dap‑ui, trouble,
  notify, treesitter‑context, hop, rainbow‑delimiters, obsidian,
  diffview, fidget, toggleterm, dashboard‑nvim, heirline, oil.nvim,
  blink.cmp, leap.nvim, flash.nvim, nvim‑ufo, nvim‑bqf,
  glance.nvim, barbecue.nvim, vim‑illuminate, hlslens.nvim, virt‑column.nvim,
  nvim‑dap‑virtual‑text, mini.pick, snacks.nvim, fzf‑lua
- Setup options: transparent backgrounds, terminal ANSI colors, extended style
  categories (keywords/functions/types/operators/numbers/booleans/constants/punctuation)
- Diagnostics with optional virtual text background (blend)
- Overrides via table or function (receives palette)
- Validator script and GitHub Actions workflow

See the full history in CHANGELOG.md and the thematic overview in RELEASE_NOTES.md (Russian: RELEASE_NOTES.ru.md).

## Installation

lazy.nvim

```lua
{
  'neg-serg/neg.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('neg').setup({
      -- Pick a preset (optional): 'soft' | 'hard' | 'pro' | 'writing' | 'accessibility' | 'focus' | 'presentation'
      preset = nil,
      -- Operators coloring (default: families): 'families' | 'mono'
      operator_colors = 'families',
      -- Transparency: boolean for global, or table for zones
      -- transparent = true,
      transparent = { float = false, sidebar = false, statusline = false },
      terminal_colors = true,
      diagnostics_virtual_bg = false,
      diagnostics_virtual_bg_blend = 15,
      styles = {
        comments = 'italic',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none',
        types = 'none',
        operators = 'none',
        numbers = 'none',
        booleans = 'none',
        constants = 'none',
        punctuation = 'none',
      },
      plugins = {
        cmp = true,
        telescope = true,
        git = true,
        gitsigns = true,
        noice = true,
        obsidian = true,
        rainbow = true,
        headline = true,
        indent = true,
        which_key = true,
        nvim_tree = false,
        neo_tree = true,
        dap = true,
        dapui = true,
        trouble = true,
        notify = true,
        treesitter_context = true,
        hop = true,
      },
      overrides = function(colors)
        return {
          NormalFloat = { bg = 'NONE' },
          CursorLine = { underline = true },
        }
      end,
    })
    vim.cmd.colorscheme('neg')
  end,
}
```

vim‑plug

```vim
Plug 'neg-serg/neg.nvim'
lua << EOF
require('neg').setup({})
EOF
colorscheme neg
```

## Options

All options are optional. Defaults are shown below.

```lua
require('neg').setup({
  saturation = 100,                    -- global saturation scale 0..100 (100 = original, 0 = grayscale)
  alpha_overlay = 0,                  -- global soft backgrounds alpha 0..30 (Search/CurSearch/Visual & DiagnosticVirtualText)
  transparent = false,                  -- boolean or { float, sidebar, statusline }
  -- transparent = { float = false, sidebar = false, statusline = false },
  terminal_colors = true,              -- set 16 ANSI terminal colors
  preset = nil,                        -- 'soft' | 'hard' | 'pro' | 'writing' | 'accessibility' | 'focus' | 'presentation' | nil
  operator_colors = 'families',        -- 'families' for subtle per-family hues, 'mono' for single operator color, or 'mono+' for a slightly stronger single accent
  number_colors = 'ramp',              -- numbers coloring: 'mono' or ramp presets 'ramp' (balanced, default) | 'ramp-soft' | 'ramp-strong'
  ui = {
    core_enhancements = true,          -- define extra baseline UI groups (Whitespace, EndOfBuffer, PmenuMatch*, FloatShadow*, Cursor*, ...)
    dim_inactive = false,              -- dim NormalNC/WinBarNC and LineNr in inactive windows (window-local winhighlight mapping)
    mode_accent = true,                -- change CursorLine/StatusLine accents by mode (Normal/Insert/Visual)
    focus_caret = true,                -- boost CursorLine visibility if overall contrast is low
    soft_borders = false,              -- lighten WinSeparator/FloatBorder to reduce visual noise
    float_panel_bg = false,            -- use slightly lighter panel-like background for NormalFloat (off by default)
    auto_transparent_panels = true,    -- when terminal background is transparent and float transparency is off, give floats/panels a subtle backdrop
    diff_focus = true,                 -- stronger Diff* backgrounds when any window is in :diff mode
    light_signs = false,               -- soften sign icons (DiagnosticSign*, GitSigns*) without changing hue
    diag_pattern = 'none',             -- diagnostics pattern preset: 'none' | 'minimal' | 'strong'
    lexeme_cues = 'off',              -- functions underline; types underline+bold (off|minimal|strong)
    thick_cursor = false,             -- thicker CursorLine/CursorLineNr for TUI
    outlines = false,                 -- active/inactive window outlines via winhighlight
    reading_mode = false,             -- near-monochrome syntax with clearer structure
    search_visibility = 'default',    -- 'default' | 'soft' | 'strong'
    screenreader_friendly = false,    -- minimize dynamic accents and colored backgrounds
    telescope_accents = false,        -- enhanced accents for Telescope (matching/selection/borders)
    path_separator_blue = false,      -- blue path separators (Startify/Navic/WhichKey)
    path_separator_color = nil,       -- optional '#rrggbb' or palette key when path_separator_blue = true
    selection_model = 'kitty',        -- 'default' (theme) or 'kitty' (match kitty selection colors)
    accessibility = {                  -- independent toggles
      deuteranopia = false,            -- shift additions to blue‑ish hue; keep warnings distinct
      strong_undercurl = false,        -- stronger/more visible diagnostic undercurls
      -- removed: strong_tui_cursor
      achromatopsia = false,           -- monochrome/high-contrast assist; reduce reliance on hue; boosts Folded/ColorColumn visibility
      hc = 'off',                      -- high‑contrast pack for achromatopsia: 'off' | 'soft' | 'strong'
    },
  },
  treesitter = {
    extras = true,                     -- apply subtle extra captures (math/environment, string.template, boolean true/false, nil/null, decorator/annotation, declaration/static/abstract links)
    punct_family = false,              -- differentiate punctuation families (parenthesis/brace vs bracket) with subtle hues
  },

  styles = {
    comments = 'italic',               -- 'italic' | 'bold' | 'underline' | 'undercurl' | 'none' | combos
    keywords = 'none',
    functions = 'none',
    strings = 'none',
    variables = 'none',
    types = 'none',
    operators = 'none',
    numbers = 'none',
    booleans = 'none',
    constants = 'none',
    punctuation = 'none',
  },

  plugins = {                          -- set to false to disable integration
    cmp = true,
    telescope = true,
    git = true,
    gitsigns = true,
    bufferline = true,
    noice = true,
    obsidian = true,
    rainbow = true,
    headline = true,
    indent = true,                     -- indent-blankline/ibl + mini.indentscope
    which_key = true,
    nvim_tree = false,                 -- disabled by default if using neo-tree
    neo_tree = true,
    dap = true,
    dapui = true,
    trouble = true,
    notify = true,
    treesitter_context = true,
    hop = true,
    -- phase 1 additions
    diffview = true,
    fidget = true,
    toggleterm = true,
    dashboard = true,
    heirline = true,
    oil = true,
    blink = true,
    leap = true,
    flash = true,
    ufo = true,
    bqf = true,
    -- phase 2 additions
    glance = true,
    barbecue = true,
    illuminate = true,
    hlslens = true,
    virt_column = true,
    dap_virtual_text = true,
    mini_pick = true,
    snacks = true,
    -- additional supported plugins
    alpha = true,
    mini_statusline = true,
    mini_tabline = true,
    todo_comments = true,
    navic = true,
    lspsaga = true,
    neotest = true,
    harpoon = true,
    treesitter_playground = true,
    startify = true,
    overseer = true,
  },

  overrides = nil,                     -- table or function(colors) -> table

  diagnostics_virtual_bg = false,      -- virtual text with soft background
  diagnostics_virtual_bg_blend = 15,   -- used when mode = 'blend' (0..100; larger = more transparent)
  diagnostics_virtual_bg_mode = 'blend',   -- 'blend' | 'alpha' | 'lighten' | 'darken'
  diagnostics_virtual_bg_strength = 0.15,  -- strength for alpha/lighten/darken (0..1)
})
```

### Apply Order

When multiple post‑processing features are enabled, neg.nvim applies them in a predictable order to avoid clashes:

- Accessibility tweaks first (deuteranopia/achromatopsia, then high‑contrast pack `hc`)
- Diagnostics virtual backgrounds (if enabled)
- Global soft backgrounds alpha (`alpha_overlay` for Search/CurSearch/Visual/VirtualText)
- Selection model (theme default vs kitty)
- User overrides last (`overrides` table or function)

## Migration: Palette Names (old → new)

The palette now exposes descriptive aliases without the `fg_` prefix. Old short names remain for compatibility, but new names are recommended for overrides and custom recipes.

- Base/backgrounds
  - `norm` → `default_color`
  - `bclr` → `bg_default`
  - `dark` → `dark_color`
  - `drk2` → `dark_secondary_color`
  - `whit` → `white_color`
  - `culc` → `bg_cursorcolumn`
  - `comm` → `comment_color`

- Syntax/categories
  - `lit1` → `literal1_color`
  - `lit2` → `literal2_color`
  - `lit3` → `literal3_color`
  - `ops1` → `keyword1_color`
  - `ops2` → `keyword2_color`
  - `ops3` → `keyword3_color`
  - `ops4` → `keyword4_color`
  - `otag` → `tag_color`
  - `lstr` → `string_color`
  - `incl` → `include_color`
  - `dlim` → `delimiter_color`
  - `blod` → `red_blood_color`
  - `violet` → `violet_color`
  - `high` → `highlight_color`
  - `darkhigh` → `highlight_dark_color`
  - `var` → `variable_color`
  - `func` → `function_color`

- Diff/diagnostics
  - `dadd` → `diff_add_color`
  - `dchg` → `diff_change_color`
  - `dred` → `diff_delete_color`
  - `dwarn` → `warning_color`

- UI and misc
  - `visu` → `bg_visual`
  - `clin` → `bg_cursorline`
  - `pmen` → `pmenu_color`
  - `csel` → `search_color`
  - `cmpdef` → `cmp_default_color`
  - `iden` → `identifier_color`
  - `lbgn` → `preproc_light_color`
  - `dbng` → `preproc_dark_color`
  - `dnorm` → `bg_selection_dim`

- Shades/rainbow
  - `col1..col24` → `shade_01..shade_24`
  - `br1..br7` → `rainbow_1..rainbow_7`

Prefix note: `fg_*` aliases (e.g. `fg_warning`, `fg_diff_delete`) remain for backward compatibility and map 1:1 to the new names (e.g. `warning_color`, `diff_delete_color`). Prefer the descriptive names going forward.

### Palette Additions

Convenience aliases exposed for overrides and UI tuning:

- Float/panels: `bg_float`, `bg_panel`, `border_color`
- Severities: `success_color`, `error_color`, `info_color`, `hint_color`
- Accents: `accent_primary`, `accent_secondary`, `accent_tertiary`

## Presets

Built-in style presets you can use via `preset` option or `:NegPreset`:

- soft: default, subtle accents, italic comments
- hard: higher contrast accents; makes keywords/functions/types/constants/booleans/numbers bold, `Title` bold
- pro: no italics anywhere (disables italics for comments, inlay hints, code lens, and markup italics)
- writing: Markdown-first; bold headings/strong, italic emphasis
- accessibility: higher contrast, minimal italics, stronger lines/separators and line numbers; disables soft diagnostic virtual backgrounds
- focus: dim inactive windows (stronger NormalNC/WinBarNC), soften separators/borders for less visual noise
 - presentation: brighter accents with more visible `CursorLine`/`CursorLineNr` and emphasized search/title

Usage examples:

```lua
require('neg').setup({ preset = 'hard' })
-- or on the fly:
-- :NegPreset hard
-- :NegPreset none  -- clear preset
```

### Preset Map

| Preset | Aim | Changes | Notes |
| --- | --- | --- | --- |
| soft | Subtle defaults | Keep defaults; italic comments | Baseline look |
| hard | Higher contrast accents | Makes keywords/functions/types/constants/booleans/numbers bold; Title bold | Good for code presentations |
| pro | No italics | Disables italics for comments, inlay hints, code lens, markup italics | Pair with `lexeme_cues=minimal` if desired |
| writing | Emphasize markup | Bold headings/strong; italic emphasis; Title bold | For Markdown/prose |
| accessibility | Higher UI contrast | Disables diagnostic virtual BG; stronger LineNr/Separators; clearer CursorLine/ColorColumn/Visual; no italic comments | Combine with `ui.accessibility.*` and `:NegHc` |
| focus | Reduce noise, focus current window | Sets `ui.dim_inactive=true`, `ui.soft_borders=true` | Good for many splits |
| presentation | Brighter accents | Stronger CursorLine/CursorLineNr; Title and Search emphasized | For demos and talks |
| none | No preset | No extra changes | Use explicit options only |

#### Quick Examples (preset + 1–2 toggles)

```lua
-- Focus with soft borders
require('neg').setup({ preset = 'focus', ui = { soft_borders = true } })

-- Presentation with neutral Telescope (no extra accents)
require('neg').setup({ preset = 'presentation', ui = { telescope_accents = false } })

-- Accessibility with soft high‑contrast pack
require('neg').setup({ preset = 'accessibility', ui = { accessibility = { achromatopsia = true, hc = 'soft' } } })

-- Pro (no italics) with mono operators
require('neg').setup({ preset = 'pro', operator_colors = 'mono' })
```

## Commands

- :NegToggleTransparent — toggle transparency and re‑apply the theme
- :NegToggleTransparentZone {float|sidebar|statusline} — toggle transparency for a specific zone
- :NegPreset {soft|hard|pro|writing|accessibility|focus|presentation|none} — apply a style preset (or clear with 'none')
- :NegReload — re‑apply highlights using the current config
- :NegInfo — show a short summary of current options, including diagnostics virtual background (enabled/mode/strength/blend)
- :NegDiagBgMode {blend|alpha|lighten|darken|off|on} — set diagnostics virtual text background mode (or turn off/on)
- :NegDiagBgStrength {0..1} — set strength for alpha/lighten/darken modes
- :NegDiagBgBlend {0..100} — set blend value when mode = 'blend'
- :NegDiagSoft — quick softer virtual text background (blend ≈ 20)
- :NegDiagStrong — quick stronger virtual text background (blend ≈ 10)
- :NegOperatorColors {families|mono|mono+} — switch operator coloring mode at runtime
- :NegNumberColors {mono|ramp|ramp-soft|ramp-strong} — switch number coloring mode/preset
- :NegSaturation {0..100} — set global saturation (100 = original, 0 = grayscale)
- :NegAlpha {0..30} — set global soft backgrounds alpha (Search/CurSearch/Visual/VirtualText)
- :NegModeAccent {on|off|toggle} — enable/disable or toggle mode-aware accents for CursorLine/StatusLine
- :NegSoftBorders {on|off|toggle} — enable/disable or toggle soft borders (WinSeparator/FloatBorder)
- :NegFloatBg {on|off|toggle} — float background model (Normal vs slightly lighter panel-like bg)
- :NegFocusCaret {on|off|toggle} — boost CursorLine contrast when overall contrast is low
- :NegLightSigns {on|off|toggle} — enable/disable or toggle light sign icons (DiagnosticSign*/GitSigns*)
- :NegSelection {default|kitty} — set selection model (kitty by default)
- :NegDimInactive {on|off|toggle} — dim inactive windows
- :NegDiffFocus {on|off|toggle} — stronger Diff* backgrounds in :diff
- :NegPunctFamily {on|off|toggle} — enable/disable or toggle punctuation family differentiation
- :NegTelescopeAccents {on|off|toggle} — toggle enhanced Telescope accents (matching/selection/borders)
- :NegPathSep {on|off|toggle} — toggle blue path separators (Telescope/Startify/Navic/WhichKey)
- :NegPathSepColor {#rrggbb|palette_key|default} — set/reset path separator color (used when blue is on)
- :NegAccessibility {feature} {on|off|toggle} — toggle accessibility features (deuteranopia|strong_undercurl|achromatopsia)
- :NegDiagPattern {none|minimal|strong} — set diagnostics pattern preset
- :NegLexemeCues {off|minimal|strong} — set lexeme cues
- :NegThickCursor {on|off|toggle} — thicker CursorLine/CursorLineNr
- :NegOutlines {on|off|toggle} — window outlines
- :NegScreenreader {on|off|toggle} — screenreader-friendly mode
- :NegReadingMode {on|off|toggle} — near-monochrome reading mode
- :NegSearchVisibility {default|soft|strong} — search/cursearch visibility
- :NegHc {off|soft|strong} — high-contrast pack presets
- :NegContrast {Group|@capture} [vs {Group|#rrggbb}] [--target AA|AAA] [apply] — print contrast ratio; accepts explicit bg, can target AA/AAA and print/apply a suggested :hi
- :NegExport — export current core/diagnostics/syntax colors with quick tips
- :NegPlugins — print enabled/disabled plugin integrations from current config

### Plugin Flags — Quick Summary

Defaults: all listed integrations are enabled unless noted. Toggle by setting `plugins.<key> = false` in setup.

- Pickers: `telescope`, `fzf_lua`, `mini_pick`, `snacks` (on)
- Completion: `cmp`, `blink` (on)
- Git & Diff: `git`, `gitsigns`, `diffview` (on)
- Files & Dashboards: `neo_tree` (on), `nvim_tree` (off), `oil` (on), `startify` (on), `alpha` (on), `dashboard` (on)
- Status/Tab/Winbar: `bufferline`, `mini_statusline`, `mini_tabline`, `heirline`, `barbecue`, `navic`, `navbuddy` (on)
- LSP/UI: `lspsaga`, `noice`, `notify`, `treesitter_context`, `treesitter_playground`, `glance`, `illuminate`, `hlslens` (on)
- Navigation/Motion: `hop`, `leap`, `flash`, `harpoon`, `rainbow` (on)
- Diagnostics/Tasks: `trouble`, `todo_comments`, `overseer` (on)
- Debug: `dap`, `dapui`, `dap_virtual_text`, `bqf` (on)
- Structure/Indent: `indent`, `virt_column`, `ufo` (on)
- Notes/Testing: `obsidian`, `neotest`, `which_key`, `toggleterm` (on)

### Quick Toggles

| Command | Effect | Default |
| --- | --- | --- |
| `:NegModeAccent {on|off|toggle}` | Mode‑aware CursorLine/StatusLine accents | on |
| `:NegFocusCaret {on|off|toggle}` | Boost CursorLine when overall contrast is low | on |
| `:NegDimInactive {on|off|toggle}` | Dim inactive windows (NormalNC/WinBarNC, LineNr) | off |
| `:NegDiffFocus {on|off|toggle}` | Stronger Diff* backgrounds in `:diff` | on |
| `:NegSoftBorders {on|off|toggle}` | Lighten WinSeparator/FloatBorder | off |
| `:NegFloatBg {on|off|toggle}` | Slightly lighter float “panel” background | off |
| `:NegLightSigns {on|off|toggle}` | Softer sign icons (DiagnosticSign*/GitSigns*) | off |
| `:NegTelescopeAccents {on|off|toggle}` | Enhanced Telescope matching/selection accents | off |
| `:NegPathSep {on|off|toggle}` | Blue path separators (Startify/Navic/WhichKey) | off |
| `:NegPathSepColor {#hex|key|default}` | Set/reset path separator color | — |
| `:NegSelection {default|kitty}` | Selection model (theme vs kitty) | kitty |
| `:NegPunctFamily {on|off|toggle}` | Differentiate punctuation families | off |
| `:NegReadingMode {on|off|toggle}` | Near‑monochrome reading mode | off |
| `:NegOutlines {on|off|toggle}` | Neutral outlines for active/inactive windows | off |
| `:NegThickCursor {on|off|toggle}` | Thicker CursorLine/CursorLineNr | off |
| `:NegSearchVisibility {default|soft|strong}` | Tune Search/CurSearch visibility | default |
| `:NegScreenreader {on|off|toggle}` | Reduce dynamic accents and colored backgrounds | off |
| `:NegAccessibility {deuteranopia|strong_undercurl|achromatopsia}` | Toggle accessibility features | all off |
| `:NegHc {off|soft|strong}` | High‑contrast pack (achromatopsia) | off |
| `:NegDiagPattern {none|minimal|strong}` | Diagnostics pattern presets | none |
| `:NegDiagSoft` / `:NegDiagStrong` | Quick soft/strong DiagnosticVirtualText bg | off |

### Selection model (kitty-style)

By default, selection matches kitty. To use the theme selection instead:

- Option: `ui.selection_model = 'default'`
- Command: `:NegSelection default`

Colors used (from palette):

- `selection_bg = '#0d1824'`
- `selection_fg = '#367bbf'`

Notes:

- Keep `alpha_overlay = 0` for an exact kitty match (alpha overlay softens backgrounds).
- You can override `selection_bg/fg` via `overrides` if you prefer different shades.

Quick overrides examples:

```lua
-- Custom kitty-like selection colors
require('neg').setup({
  ui = { selection_model = 'kitty' },
  overrides = {
    Visual    = { bg = '#101a28', fg = '#62a0ff', bold = false, underline = false },
    VisualNOS = { bg = '#101a28', fg = '#62a0ff' },
  },
})

-- Or compute from palette
require('neg').setup({
  ui = { selection_model = 'kitty' },
  overrides = function(colors)
    return {
      Visual = { bg = colors.selection_bg, fg = '#5fb0ff' },
    }
  end,
})
```

### Float background model

Floats default to the exact same background as `Normal` (no tint). If you prefer a slightly lighter panel‑like background:

- Option: `ui.float_panel_bg = true`
- Command: `:NegFloatBg on`

This sets `NormalFloat` bg to `palette.bg_panel` (derived from base bg). Toggle with `:NegFloatBg toggle`.

Quick overrides examples:

```lua
-- Slightly darker panel border and custom float bg
require('neg').setup({
  ui = { float_panel_bg = true },
  overrides = {
    NormalFloat = { bg = '#0f131a' },
    FloatBorder = { fg = '#1a1f29' },
  },
})

-- Or base on palette values
require('neg').setup({
  ui = { float_panel_bg = true },
  overrides = function(colors)
    return {
      NormalFloat = { bg = colors.bg_panel },
      FloatBorder = { fg = colors.border_color },
    }
  end,
})
```

## Known Interactions

- CursorLine (mode_accent, focus_caret, thick_cursor)
  - Order: mode accents → focus caret → thick cursor. Thick cursor makes CursorLine stronger after accents; screenreader may later stabilize it.
  - Tip: for fully stable visuals (no dynamic changes), disable `ui.mode_accent` and `ui.focus_caret`, or enable `:NegScreenreader on`.
- WinSeparator/FloatBorder (soft_borders, outlines)
  - Soft borders lightens `WinSeparator`/`FloatBorder` globally; outlines remap `WinSeparator` per‑window to active/inactive variants.
  - Outcome: outlines take precedence for `WinSeparator`; soft borders still affect `FloatBorder`.
 - Dim inactive vs outlines
   - `ui.dim_inactive` maps only `LineNr` (and base NormalNC/WinBarNC) per window and does not override `WinSeparator` mappings; outlines keep precedence for separators.
- Diff backgrounds (diff_focus, screenreader)
  - Diff focus strengthens `Diff*` bgs in `:diff`; screenreader clears that strengthening for calmer output.
- Telescope + borders
  - Telescope borders link to `WinSeparator`: with outlines on, Telescope adopts active/inactive border tint per window; with soft borders on (no outlines) borders stay softly lightened.
- Selection, alpha overlay, diagnostics virtual bg
  - Apply order (see “Apply Order”): diagnostics virtual bg → alpha overlay → selection model. If your Visual looks too soft, reduce `alpha_overlay` or use `:NegSearchVisibility`.

### Scenario Recipes

- Calm presentation (brighter but not noisy)

```lua
require('neg').setup({
  preset = 'presentation',
  number_colors = 'ramp-soft',
  ui = {
    soft_borders = true,
    diff_focus = false,
    search_visibility = 'soft',
    telescope_accents = false,
  },
})
```

- High contrast (achromatopsia, strong)

```lua
require('neg').setup({
  preset = 'accessibility',
  alpha_overlay = 0,
  ui = {
    mode_accent = false,
    focus_caret = false,
    soft_borders = false,
    diag_pattern = 'strong',
    accessibility = {
      achromatopsia = true,
      strong_undercurl = true,
      hc = 'strong',
    },
  },
})
-- Runtime shorthand:
-- :NegAccessibility achromatopsia on | :NegHc strong | :NegDiagPattern strong
```

- Minimum dynamics (stable visuals)

```lua
require('neg').setup({
  alpha_overlay = 0,
  operator_colors = 'mono',
  number_colors = 'mono',
  ui = {
    mode_accent = false,
    focus_caret = false,
    diff_focus = false,
    outlines = false,
    screenreader_friendly = true,
  },
})
```

#### Environment Recipes (terminal / GUI / presentation / screenreader)

- Terminal (TUI)

  - When: terminal usage without transparency; want crisp selection (kitty) and calmer signs.
  - Changes: disables alpha overlay, enables thicker cursor and light signs, keeps neutral borders and diff focus.

```lua
-- Tip: ensure Neovim uses truecolor: :set termguicolors
require('neg').setup({
  alpha_overlay = 0,
  ui = {
    thick_cursor = true,
    soft_borders = false,
    float_panel_bg = false,
    diff_focus = true,
    light_signs = true,
    outlines = false,
    telescope_accents = false,
    selection_model = 'kitty',
  },
})
```

- GUI (Neovide/Goneovim, etc.)

  - When: GUI frontends; prefer soft borders and panel floats with mild accents.
  - Changes: soft borders + panel float bg, light alpha overlay, optional Telescope accents.

```lua
require('neg').setup({
  saturation = 95,
  alpha_overlay = 6,
  ui = {
    soft_borders = true,
    float_panel_bg = true,
    telescope_accents = true,
    dim_inactive = false,
    outlines = false,
    selection_model = 'kitty',
    focus_caret = true,
  },
})
```

- Bright presentation

  - When: live demos/projectors where accents need to read from a distance.
  - Changes: presentation preset, stronger numbers and search, disables dynamic accents.

```lua
require('neg').setup({
  preset = 'presentation',
  number_colors = 'ramp-strong',
  operator_colors = 'mono+',
  ui = {
    mode_accent = false,
    focus_caret = false,
    soft_borders = true,
    search_visibility = 'strong',
    telescope_accents = false,
    diff_focus = false,
  },
})
```

- Screenreader‑friendly

  - When: screenreader users or anyone preferring very stable visuals.
  - Changes: stabilizes accents, achromatopsia + soft high‑contrast, strong undercurls, no diff focus.

```lua
require('neg').setup({
  alpha_overlay = 0,
  ui = {
    screenreader_friendly = true,
    mode_accent = false,
    focus_caret = false,
    diff_focus = false,
    search_visibility = 'soft',
    selection_model = 'kitty',
    accessibility = {
      strong_undercurl = true,
      achromatopsia = true,
      hc = 'soft',
    },
  },
})
```

- Terminal + kitty + blue path separators (zsh‑like)

  - When: TUI with kitty‑style selection and blue path separators like zsh.
  - Changes: kitty selection + blue path separators (configurable color or palette key).

```lua
require('neg').setup({
  ui = {
    selection_model = 'kitty',
    path_separator_blue = true,
    -- optional custom color (hex or palette key):
    -- path_separator_color = 'include_color', -- or '#22aaff'
  },
})
-- Runtime: :NegPathSep on | :NegPathSepColor include_color
```

## Overrides

You can override any highlight groups:

```lua
require('neg').setup({
  overrides = {
    Normal = { fg = '#c0c0c0' },
    NormalFloat = { bg = 'NONE' },
  }
})
```

or provide a function that receives the palette:

```lua
require('neg').setup({
  overrides = function(c)
    return { DiagnosticUnderlineWarn = { undercurl = true, sp = c.warning_color } }
  end
})
```

### Common override recipes

- No italics anywhere (alternative to `preset = 'pro'`):

```lua
require('neg').setup({
  overrides = function()
    return {
      Comment = { italic = false },
      LspInlayHint = { italic = false },
      LspCodeLens = { italic = false },
      ['@markup.italic'] = { italic = false },
    }
  end,
})
```

- Transparent floats and sidebars (alternative to `transparent = { ... }`):

```lua
require('neg').setup({
  overrides = {
    NormalFloat = { bg = 'NONE' },
    Pmenu = { bg = 'NONE' },
    FloatBorder = { bg = 'NONE' },
    NvimTreeNormal = { bg = 'NONE' },
    NeoTreeNormal = { bg = 'NONE' },
    TroubleNormal = { bg = 'NONE' },
  }
})
```

- Softer/more visible virtual text background (per severity):

```lua
require('neg').setup({
  overrides = function(c)
    return {
      DiagnosticVirtualTextError = { bg = c.diff_delete_color, blend = 12 },
      DiagnosticVirtualTextWarn  = { bg = c.warning_color, blend = 12 },
      DiagnosticVirtualTextInfo  = { bg = c.preproc_light_color, blend = 12 },
      DiagnosticVirtualTextHint  = { bg = c.identifier_color, blend = 12 },
    }
  end,
})
```

- Stronger line numbers and separators:

```lua
require('neg').setup({
  overrides = {
    CursorLineNr = { bold = true },
    WinSeparator = { fg = '#1c2430' },
  }
})
```

- LSP inlay hints color tweak:

```lua
require('neg').setup({
  overrides = function(c)
    return { LspInlayHint = { fg = c.comment_color } }
  end,
})
```

- gitsigns color tweak:

```lua
require('neg').setup({
  overrides = function()
    return {
      GitSignsAdd = { fg = '#2ecc71' },
      GitSignsChange = { fg = '#3498db' },
      GitSignsDelete = { fg = '#e74c3c' },
    }
  end,
})
```

## Plugins Coverage

### Color utility recipes (alpha/lighten/darken)

You can use the color helpers from `neg.util` to derive colors on the fly in your overrides. This is helpful for subtle backgrounds, undercurls or tuned floats.

- Subtle diagnostic backgrounds via alpha blending on top of your theme background:

```lua
local U = require('neg.util')
require('neg').setup({
  overrides = function(c)
    return {
      DiagnosticVirtualTextError = { bg = U.alpha(c.diff_delete_color, c.bg_default, 0.16) },
      DiagnosticVirtualTextWarn  = { bg = U.alpha(c.warning_color,      c.bg_default, 0.14) },
      DiagnosticVirtualTextInfo  = { bg = U.alpha(c.preproc_light_color, c.bg_default, 0.12) },
      DiagnosticVirtualTextHint  = { bg = U.alpha(c.identifier_color,   c.bg_default, 0.12) },
    }
  end,
})
```

- Lighten/darken for selection or floats:

```lua
local U = require('neg.util')
require('neg').setup({
  overrides = function(c)
    return {
      Visual = { bg = U.darken(c.bg_default, 6) },     -- darker selection
      NormalFloat = { bg = U.lighten('#111d26', 8) },  -- soften float background
    }
  end,
})
```

- Fine‑tuned undercurl hues (slightly darker than the base):

```lua
local U = require('neg.util')
require('neg').setup({
  overrides = function(c)
    return {
      DiagnosticUnderlineError = { undercurl = true, sp = U.darken(c.diff_delete_color, 8) },
      DiagnosticUnderlineWarn  = { undercurl = true, sp = U.darken(c.warning_color, 6) },
    }
  end,
})
```

- telescope.nvim, nvim-cmp
- gitsigns.nvim, gitgutter (basic), diff, diffview.nvim
- indent‑blankline/ibl, mini.indentscope
- mini.statusline, mini.tabline
- which‑key.nvim
- neo‑tree, nvim‑tree
- bufferline.nvim
- lualine.nvim (theme = 'neg')
- nvim‑dap, dap‑ui, nvim‑dap‑virtual‑text
- trouble.nvim
- nvim‑notify
- treesitter‑context
- hop.nvim, rainbow‑delimiters
- obsidian.nvim
- alpha‑nvim
- startify, dashboard‑nvim
- todo‑comments.nvim
- lspsaga.nvim
- overseer.nvim
- neotest
- harpoon
- nvim‑navic
- treesitter‑playground
- heirline.nvim (theme via palette)
- oil.nvim
- blink.cmp
- leap.nvim, flash.nvim
- nvim‑ufo
- nvim‑bqf

### Detailed Plugin Coverage

 - telescope.nvim
  - Groups: `TelescopeMatching`, `TelescopeSelection`, `TelescopeBorder`, `TelescopePreviewBorder`, `TelescopePromptBorder`, `TelescopeResultsBorder`
  - Transparent float zone also covers: `TelescopeNormal`, `TelescopePreviewNormal`, `TelescopePromptNormal`, `TelescopeResultsNormal`, and the corresponding `*Border`
- mason.nvim
  - Transparent float zone also covers: `MasonNormal`, `MasonBorder`
- lazy.nvim
  - Transparent float zone also covers: `LazyNormal`, `LazyBorder`
- nvim-cmp
  - Groups: `CmpItemKind*` (extended kinds: Text/Class/Module/Field/Constructor/Enum/Unit/Value/EnumMember/Constant/Struct/Event/Operator/TypeParameter/Snippet/Color/File/Reference/Folder)
  - Transparent float zone also covers: `CmpDocumentation`, `CmpDocumentationBorder`
- gitsigns.nvim
  - Groups: `GitSignsAdd`, `GitSignsAddNr`, `GitSignsAddLn`, `GitSignsChange`, `GitSignsChangeNr`, `GitSignsChangeLn`, `GitSignsDelete`, `GitSignsDeleteNr`, `GitSignsDeleteLn`, `GitSignsTopdelete`, `GitSignsChangedelete`, `GitSignsUntracked`, `GitSignsCurrentLineBlame`
- gitgutter/diff
  - Groups: `GitGutterAdd`, `GitGutterChangeDelete`, `GitGutterChange`, `GitGutterDelete`, `DiffAdd`, `DiffChange`, `DiffDelete`, `DiffText`, `DiffAdded`, `DiffRemoved`, `diffAdded`, `diffChanged`, `diffRemoved`, `diffLine`, `diffNewFile`, `diffOldFile`, `diffOldLine`
- indent‑blankline/ibl/mini.indentscope
  - Groups: `IndentBlanklineChar`, `IndentBlanklineSpaceChar`, `IndentBlanklineSpaceCharBlankline`, `IndentBlanklineContextChar`, `IndentBlanklineContextStart`, `IblIndent`, `IblWhitespace`, `IblScope`, `MiniIndentscopeSymbol`, `MiniIndentscopePrefix`
- which‑key.nvim
  - Groups: `WhichKey`, `WhichKeyGroup`, `WhichKeyDesc`, `WhichKeySeparator`, `WhichKeyFloat`, `WhichKeyBorder`, `WhichKeyValue`
- neo‑tree
  - Groups: `NeoTreeNormal`, `NeoTreeNormalNC`, `NeoTreeRootName`, `NeoTreeDirectoryIcon`, `NeoTreeDirectoryName`, `NeoTreeCursorLine`, `NeoTreeGitAdded`, `NeoTreeGitModified`, `NeoTreeGitDeleted`, `NeoTreeDimText`
  - Transparent float zone also covers: `NeoTreeFloatNormal`, `NeoTreeFloatBorder`
- nvim‑tree
  - Groups: `NvimTreeNormal`, `NvimTreeNormalNC`, `NvimTreeFolderIcon`, `NvimTreeFolderName`, `NvimTreeOpenedFolderName`, `NvimTreeRootFolder`, `NvimTreeIndentMarker`, `NvimTreeCursorLine`, `NvimTreeGitDirty`, `NvimTreeGitNew`, `NvimTreeGitDeleted`
- symbols-outline.nvim
  - Transparent sidebar zone also covers: `SymbolsOutlineNormal`
- aerial.nvim
  - Transparent sidebar zone also covers: `AerialNormal`
- nvim‑dap
  - Groups: `DebugBreakpoint`, `DebugBreakpointCondition`, `DebugBreakpointRejected`, `DebugStopped`, `DebugLogPoint`, `DebugPC`
- dap‑ui
  - Groups: `DapUIFloatNormal`, `DapUIFloatBorder`, `DapUIVariable`, `DapUIDecoration`, `DapUIScope`, `DapUIType`, `DapUIValue`, `DapUILineNumber`, `DapUIBreakpointsPath`, `DapUIBreakpointsLine`, `DapUIBreakpointsCurrentLine`, `DapUIBreakpointsDisabledLine`, `DapUIPlayPause`, `DapUIRestart`, `DapUIStop`, `DapUIUnavailable`, `DapUIWinSelect`
- trouble.nvim
  - Groups: `TroubleNormal`, `TroubleText`, `TroubleCount`, `TroubleFoldIcon`, `TroubleLocation`, `TroubleFilename`, `TroubleIndent`, `TroubleSignError`, `TroubleSignWarning`, `TroubleSignInformation`, `TroubleSignHint`
- nvim‑notify
  - Groups: `NotifyBackground`, plus `Notify{ERROR|WARN|INFO|DEBUG|TRACE}{Border|Icon|Title}`
- treesitter‑context
  - Groups: `TreesitterContext`, `TreesitterContextLineNumber`, `TreesitterContextSeparator`
- hop.nvim
  - Groups: `HopNextKey`, `HopNextKey1`, `HopNextKey2`, `HopUnmatched`
- rainbow‑delimiters
  - Groups: `RainbowDelimiterRed`, `RainbowDelimiterYellow`, `RainbowDelimiterBlue`, `RainbowDelimiterOrange`, `RainbowDelimiterGreen`, `RainbowDelimiterViolet`, `RainbowDelimiterCyan`
- obsidian.nvim
- alpha‑nvim
- startify / startify
- todo‑comments.nvim
- lspsaga.nvim
- overseer.nvim
- lspsaga.nvim
- overseer.nvim
- neotest
- harpoon
- nvim‑navic
- navbuddy
- treesitter‑playground
  - Groups: `ObsidianExtLinkIcon`, `ObsidianRefText`, `ObsidianBullet`, `ObsidianImportant`, `ObsidianTilde`, `ObsidianRightArrow`, `ObsidianDone`, `ObsidianTodo`, `ObsidianHighlightText`, `ObsidianBlockID`, `ObsidianTag`
- headline.nvim
  - Groups: `Headline1`, `Headline2`, `CodeBlock`, `Dash`
- noice.nvim
  - Groups: `NoiceCursor`, `NoiceCmdLine`, popup/cmdline menu (`NoiceCmdlinePopup`, `NoiceCmdlinePopupBorder`, `NoicePopup`, `NoicePopupBorder`, `NoicePopupmenu`, `NoicePopupmenuBorder`); transparent float zone also covers `NoicePopup`, `NoicePopupmenu`, `NoiceCmdlinePopup`
- dressing.nvim
  - Transparent float zone also covers: `DressingInput`, `DressingInputBorder`, `DressingSelect`, `DressingSelectBorder`
- fzf-lua
  - Groups: `FzfLuaNormal`, `FzfLuaBorder`, `FzfLuaTitle`, `FzfLuaCursorLine`, `FzfLuaMatch`
  - Transparent float zone also covers: preview (`FzfLuaPreviewNormal`, `FzfLuaPreviewBorder`, `FzfLuaPreviewTitle`)


## Troubleshooting

- Theme looks mixed or not applied sometimes
  - Ensure only one colorscheme is active. If using multiple themes, remove extra `colorscheme` calls.
  - With lazy.nvim, set a high `priority` (e.g. 1000) and `lazy = false` for this plugin.
  - Run `:colorscheme neg` after your UI plugins load if something overrides highlights late.
- Transparency seems not applied
  - Terminal must support transparency (or set GUI background). `transparent` sets highlight backgrounds to `NONE`, it does not change the terminal background.
  - For specific areas, use `transparent = { float = true, sidebar = true, statusline = true }` or the command `:NegToggleTransparentZone`.
  - Check your overrides — they have the last word. Use `:NegInfo` to inspect active options.
- Overriding a linked group has no effect
  - When a group `link`s to another, its own attrs are ignored. Provide attributes in your `overrides` to break the link (Neovim will clear the link when attrs are set).
  - Example: `NormalFloat = { bg = 'NONE' }` will override any previous link.
- Colors look off
  - Add `:set termguicolors` to your config and keep `terminal_colors = true` (or tune them in overrides).
- Treesitter/LSP highlight mismatch
  - Use `:Inspect` on a token to see active captures. Some captures differ between Neovim 0.9/0.10 and parsers.
  - This colorscheme links common modern captures; update Neovim/parsers if something is missing.
- Diagnostics are too strong/too soft
  - Disable colored virtual backgrounds with `diagnostics_virtual_bg = false` or tune `diagnostics_virtual_bg_blend`.
  - Or override individual severities.
- Italics not visible
  - Your terminal font might not support italics. Try a GUI (Neovide) or a font that supports italics.
- Light background?
  - This is a dark theme. `set background=light` is not supported at the moment.

## FAQ

- How do I use it with `:colorscheme`?
  - The plugin provides `colors/neg.lua`. Use `:colorscheme neg` after `require('neg').setup(...)`.
- How do I disable a specific plugin integration?
  - Set its flag to `false` under `plugins`.
- Can I customize the palette?
  - Use `overrides` for highlight groups and `require('neg.palette')` if you need palette colors. Direct palette overrides are not exposed yet.
- How do I toggle presets/transparency on the fly?
  - Use `:NegPreset soft|hard|pro|writing|none` and `:NegToggleTransparent`/`:NegToggleTransparentZone {float|sidebar|statusline}`.
- A plugin's group is not covered — what do I do?
  - Add an `overrides` entry for that group. PRs to add more integrations are welcome.

## Validator & CI

- Locally: `./scripts/validate.sh`
- Strict mode (treat WARN as errors): `NEG_VALIDATE_STRICT=1 ./scripts/validate.sh`
- GitHub Actions: `.github/workflows/validate.yml`
- Optional contrast check: `NEG_VALIDATE_CONTRAST=1 NEG_VALIDATE_CONTRAST_MIN=3.0 ./scripts/validate.sh`
  - Reports warnings if contrast ratio (fg vs bg) is below the threshold.
  - Tip: enable only when tuning colors; strict mode will fail on warnings.
- Verbose summary: `NEG_VALIDATE_VERBOSE=1 ./scripts/validate.sh` prints a short coverage line.

- Coverage listing (optional):
  - `NEG_VALIDATE_LIST=1` — print all defined groups as `DEF: <name>` lines
  - `NEG_VALIDATE_LIST_FILTER='^CmpItem'` — filter names by Lua pattern
  - `NEG_VALIDATE_LIST_LIMIT=200` — limit number of printed names
- Module stats & duplicates:
  - `NEG_VALIDATE_MODULE_STATS=1` — per‑module group counts
  - `NEG_VALIDATE_DUP_SOURCES=1` — show duplicate group sources (module names)


## Demo shots

## Python
![shot1](https://i.imgur.com/vge1c3X.png)
![shot2](https://i.imgur.com/6mFaXPX.png)

## sh
![shot3](https://i.imgur.com/wvX0Q0o.png)

## Zsh
![shot4](https://i.imgur.com/ImCHl7I.png)

## C
![shot5](https://i.imgur.com/oF275OQ.png)

## Rust
![shot6](https://i.imgur.com/cacYu8g.png)
- bufferline.nvim
  - Groups: `BufferLine*` (fill, background, selected/visible buffers, tabs, separators, modified/duplicate markers, indicators, close buttons)
- lualine.nvim
  - Theme: `require('lualine').setup({ options = { theme = 'neg' } })`
