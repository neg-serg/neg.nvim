<!-- This file mirrors lua/neg/README.ru.md to expose a root-level Russian guide. -->
<!-- Source of truth is the root file; the in-tree copy is for runtime packaging. -->

# neg (русская документация)

Современная цветовая схема для Neovim с модульной структурой, расширенной поддержкой Tree‑sitter и удобными опциями для UX.

- Установка и подробности на английском: см. `README.md`
- Эта страница — краткий русскоязычный гид по ключевым опциям и быстрым командам (включая новые возможности).

## Быстрый старт

```lua
require('neg').setup({
  preset = nil,          -- 'soft' | 'hard' | 'pro' | 'writing' | 'accessibility' | 'focus' | 'presentation'
  operator_colors = 'families',      -- 'families' | 'mono' | 'mono+'
  number_colors   = 'ramp',          -- 'mono' | 'ramp' | 'ramp-soft' | 'ramp-strong'
  treesitter = {
    extras = true,                   -- доп. тонкие капчеры (math/environment, template, true/false, nil/null, decorator/annotation ...)
    punct_family = false,            -- различать скобки (parenthesis/brace) от bracket
  },
  ui = {
    core_enhancements = true,        -- базовые полезные группы UI (Whitespace, EndOfBuffer, PmenuMatch*, FloatShadow*, Cursor*, ...)
    dim_inactive = false,            -- приглушать неактивные окна и номера строк
    mode_accent = true,              -- акценты CursorLine/StatusLine по режимам (Normal/Insert/Visual)
    soft_borders = false,            -- мягкие границы: WinSeparator/FloatBorder ближе к фону
    auto_transparent_panels = true,  -- легкая подложка для float/panel в прозрачном терминале
    diff_focus = true,               -- более явные фоны Diff* в режиме :diff
    light_signs = false,             -- смягчить иконки SignColumn (DiagnosticSign*/GitSigns*) без смены оттенков
    diag_pattern = 'none',           -- паттерны для диагностик: 'none' | 'minimal' | 'strong'
    lexeme_cues = 'off',            -- подсказки для лексем: 'off' | 'minimal' | 'strong'
    thick_cursor = false,           -- усиленный курсор/строка для TUI
    outlines = false,               -- рамки активных/неактивных окон через winhighlight
    reading_mode = false,           -- почти монохромный режим чтения
    search_visibility = 'default',  -- видимость поиска: 'default' | 'soft' | 'strong'
    screenreader_friendly = false,  -- уменьшить динамику акцентов для скринридера
    accessibility = {
      deuteranopia = false,        -- дружественный режим для дальтонизма: «добавления» более сине‑голубые
      strong_undercurl = false,    -- более заметные подчеркивания (undercurl/underline) у диагностик
      strong_tui_cursor = false,   -- более заметный курсор/выделение в TUI
      achromatopsia = false,       -- монохром/высокий контраст; минимальная зависимость от оттенков
      hc = 'off',                  -- контраст для achromatopsia: 'off' | 'soft' | 'strong'
    },
  },
})
vim.cmd.colorscheme('neg')
```

## Пресеты

- soft — дефолт: деликатные акценты, курсив комментариев
- hard — сильнее акценты; ключевые категории жирные, Title жирный
- pro — без курсива (комменты, inlay hints, CodeLens, markup)
- writing — акценты для Markdown/markup (заголовки/strong/italic)
- accessibility — повышенный контраст, без мягких фонов диагностик, сильнее линии/номера
- focus — приглушает неактивные окна и смягчает границы (включает dim_inactive + soft_borders)
- presentation — ярче акценты, заметнее CursorLine/CursorLineNr, выразительнее поиск/заголовки

## Ключевые опции

- Операторы `operator_colors`:
  - 'families' (по умолчанию): разные семействам операторов (assignment/comparison/…)
  - 'mono': один оттенок для всех
  - 'mono+': один оттенок с чуть более сильным акцентом

- Числа `number_colors`:
  - 'mono': единый цвет
  - 'ramp' | 'ramp-soft' | 'ramp-strong': мягкие одноцветные вариации для integer/hex/octal/binary (мягче/сбаланс./сильнее)

- Tree‑sitter:
  - `treesitter.extras = true` — включает «тонкие» капчеры: `@markup.math`, `@markup.environment(.name)`, `@string.template`, `@boolean.true/.false`, `@nil/@null`, LSP types (`decorator`, `annotation`) и распространённые typemods (declaration/static/abstract/readonly)
  - `treesitter.punct_family = false` — различать `parenthesis/brace` от `bracket` (чуть светлее/темнее)

- UI:
  - `ui.core_enhancements` — базовые недостающие группы UI (Whitespace, EndOfBuffer, FloatShadow*, Cursor*, PmenuMatch*, VisualNOS, Question, LineNrAbove/Below)
  - `ui.dim_inactive` — приглушать неактивные окна и номера строк
  - `ui.mode_accent` — акценты CursorLine/StatusLine в Normal/Insert/Visual (включено по умолчанию)
  - `ui.soft_borders` — мягкие границы (WinSeparator/FloatBorder)
  - `ui.auto_transparent_panels` — подложка float/Pmenu при прозрачном терминале
  - `ui.diff_focus` — усилить фоны Diff* в :diff
  - `ui.light_signs` — сделать SignColumn менее шумным (смягчить яркость без смены оттенков)
  - `ui.diag_pattern` — паттерны для диагностик: 'none' | 'minimal' | 'strong'
  - `ui.lexeme_cues` — подсказки для лексем: 'off' | 'minimal' | 'strong'
  - `ui.thick_cursor` — усиленный курсор/строка для TUI
  - `ui.outlines` — рамки активных/неактивных окон через winhighlight
  - `ui.reading_mode` — почти монохромный режим чтения
  - `ui.search_visibility` — видимость поиска: 'default' | 'soft' | 'strong'
  - `ui.screenreader_friendly` — уменьшить динамику акцентов для скринридера
  - `ui.accessibility.*` — независимые тумблеры доступности (см. выше)

## Быстрые команды

- Общие
  - `:NegPreset {soft|hard|pro|writing|accessibility|focus|presentation|none}`
  - Прозрачность: `:NegToggleTransparent`, `:NegToggleTransparentZone {float|sidebar|statusline}`

- Операторы/числа
  - `:NegOperatorColors {families|mono|mono+}`
  - `:NegNumberColors {mono|ramp|ramp-soft|ramp-strong}`

- Диагностика
  - `:NegDiagBgMode {blend|alpha|lighten|darken|off|on}`
  - `:NegDiagBgBlend {0..100}` и `:NegDiagBgStrength {0..1}`
  - Быстрые пресеты: `:NegDiagSoft` (мягче), `:NegDiagStrong` (сильнее)

- UI/UX переключатели
  - `:NegModeAccent {on|off|toggle}` — режимные акценты CursorLine/StatusLine
  - `:NegSoftBorders {on|off|toggle}` — мягкие границы
  - `:NegLightSigns {on|off|toggle}` — лёгкие знаки в SignColumn
  - `:NegPunctFamily {on|off|toggle}` — различение семейства скобок
  - `:NegAccessibility {deuteranopia|strong_undercurl|strong_tui_cursor|achromatopsia} {on|off|toggle}`
  - `:NegDiagPattern {none|minimal|strong}` — паттерны для диагностик
  - `:NegLexemeCues {off|minimal|strong}` — визуальные подсказки для функций/типов
  - `:NegThickCursor {on|off|toggle}` — «толстый» курсор/строка
  - `:NegOutlines {on|off|toggle}` — рамки активных окон/панелей
  - `:NegReadingMode {on|off|toggle}` — режим чтения (почти монохром)
  - `:NegSearchVisibility {default|soft|strong}` — видимость поиска/текущего совпадения
  - `:NegHc {off|soft|strong}` — контраст для achromatopsia

## Рекомендованные сочетания

- «Спокойный интерфейс» (меньше шума):

```lua
require('neg').setup({
  preset = 'soft',
  operator_colors = 'families',
  number_colors = 'ramp-soft',
  ui = {
    soft_borders = true,
    light_signs = true,
    dim_inactive = true,
  },
})
```

- «Фокус на активном окне»:

```lua
require('neg').setup({
  preset = 'focus',          -- включает dim_inactive + soft_borders
  operator_colors = 'mono+', -- чуть сильнее акцент операторов
  treesitter = { punct_family = true },
})
```

- «Презентация/демо»:

```lua
require('neg').setup({
  preset = 'presentation',
  operator_colors = 'mono+',
  number_colors = 'ramp-strong',
})
-- Для более выразительных диагностик:
-- :NegDiagStrong
```

