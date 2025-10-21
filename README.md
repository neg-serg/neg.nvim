# neg

Modern Neovim colorscheme partially based on Jason W Ryan's miromiro:
https://www.vim.org/scripts/script.php?script_id=3815

Highlights are organized by modules (core, LSP/Tree‑sitter, plugins) with a
clean setup API, plugin toggles, and a simple validator used in CI.

## Features

- Modular highlight groups: core UI, syntax, diagnostics, LSP, Tree‑sitter
- Plugin integrations (toggleable): telescope, cmp, gitsigns, indent‑blankline/ibl,
  mini.indentscope, which‑key, neo‑tree, nvim‑tree, dap, dap‑ui, trouble,
  notify, treesitter‑context, hop, rainbow‑delimiters, obsidian
- Setup options: transparent backgrounds, terminal ANSI colors, extended style
  categories (keywords/functions/types/operators/numbers/booleans/constants/punctuation)
- Diagnostics with optional virtual text background (blend)
- Overrides via table or function (receives palette)
- Validator script and GitHub Actions workflow

See the full history in CHANGELOG.md.

## Installation

lazy.nvim

```lua
{
  'neg-serg/neg.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('neg').setup({
      -- Pick a preset (optional): 'soft' | 'hard' | 'pro' | 'writing'
      preset = nil,
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
  transparent = false,                  -- boolean or { float, sidebar, statusline }
  -- transparent = { float = false, sidebar = false, statusline = false },
  terminal_colors = true,              -- set 16 ANSI terminal colors
  preset = nil,                        -- 'soft' | 'hard' | 'pro' | 'writing' | nil

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
  },

  overrides = nil,                     -- table or function(colors) -> table

  diagnostics_virtual_bg = false,      -- virtual text with soft background
  diagnostics_virtual_bg_blend = 15,   -- 0..100 (larger = more transparent)
})
```

## Presets

Built-in style presets you can use via `preset` option or `:NegPreset`:

- soft: default, subtle accents, italic comments
- hard: higher contrast accents; makes keywords/functions/types/constants/booleans/numbers bold, `Title` bold
- pro: no italics anywhere (disables italics for comments, inlay hints, code lens, and markup italics)
- writing: Markdown-first; bold headings/strong, italic emphasis

Usage examples:

```lua
require('neg').setup({ preset = 'hard' })
-- or on the fly:
-- :NegPreset hard
-- :NegPreset none  -- clear preset
```

## Commands

- :NegToggleTransparent — toggle transparency and re‑apply the theme
- :NegToggleTransparentZone {float|sidebar|statusline} — toggle transparency for a specific zone
- :NegPreset {soft|hard|pro|writing|none} — apply a style preset (or clear with 'none')
- :NegReload — re‑apply highlights using the current config
- :NegInfo — show a short summary of current options

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
    return { DiagnosticUnderlineWarn = { undercurl = true, sp = c.dwarn } }
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
      DiagnosticVirtualTextError = { bg = c.dred, blend = 12 },
      DiagnosticVirtualTextWarn  = { bg = c.dwarn, blend = 12 },
      DiagnosticVirtualTextInfo  = { bg = c.lbgn, blend = 12 },
      DiagnosticVirtualTextHint  = { bg = c.iden, blend = 12 },
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
    return { LspInlayHint = { fg = c.comm } }
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

- telescope.nvim, nvim-cmp
- telescope.nvim, nvim-cmp
- gitsigns.nvim, gitgutter (basic), diff
- indent‑blankline/ibl, mini.indentscope
- which‑key.nvim
- neo‑tree, nvim‑tree
- nvim‑dap, dap‑ui
- trouble.nvim
- nvim‑notify
- treesitter‑context
- hop.nvim, rainbow‑delimiters
- obsidian.nvim

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
