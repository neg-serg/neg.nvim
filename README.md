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

## Plugins Coverage

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
