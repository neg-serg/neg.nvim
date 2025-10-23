# neg (полная русская документация)

Полноценная, современная цветовая схема для Neovim, частично основанная на miromiro Джейсона У. Райана:
https://www.vim.org/scripts/script.php?script_id=3815

Подсветка организована по модулям (ядро UI, диагностика, LSP/Tree‑sitter, интеграции с плагинами). Есть чистый API настройки, переключатели интеграций и простой валидатор, который запускается локально и в CI.

См. историю изменений в CHANGELOG.md и тематический обзор в RELEASE_NOTES.ru.md (English: RELEASE_NOTES.md).

## Возможности

- Модульные группы подсветки: базовые UI, синтаксис, диагностика, LSP, Tree‑sitter
- Интеграции с популярными плагинами (можно отключать): telescope, cmp, gitsigns, indent‑blankline/ibl,
  mini.indentscope, which‑key, neo‑tree, nvim‑tree, dap, dap‑ui, trouble,
  notify, treesitter‑context, hop, rainbow‑delimiters, obsidian,
  diffview, fidget, toggleterm, dashboard‑nvim, heirline, oil.nvim,
  blink.cmp, leap.nvim, flash.nvim, nvim‑ufo, nvim‑bqf, fzf‑lua и др.
- Опции конфигурации: прозрачные фоны, ANSI‑цвета терминала, расширенные стилевые категории
  (keywords/functions/types/operators/numbers/booleans/constants/punctuation)
- Диагностика с опциональным фоном виртуального текста (blend/alpha/lighten/darken)
- Overrides таблицей или функцией (получает палитру)
- Валидатор и workflow GitHub Actions

## Установка

lazy.nvim

```lua
{
  'neg-serg/neg.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('neg').setup({
      -- Выбор пресета (необязательно): 'soft' | 'hard' | 'pro' | 'writing' | 'accessibility' | 'focus' | 'presentation'
      preset = nil,
      -- Операторы: 'families' | 'mono' | 'mono+'
      operator_colors = 'families',
      -- Прозрачность: boolean или таблица зон
      transparent = { float = false, sidebar = false, statusline = false },
      terminal_colors = true,
      diagnostics_virtual_bg = false,
      diagnostics_virtual_bg_blend = 15,
      styles = {
        comments = 'italic',
        keywords = 'none', functions = 'none', strings = 'none', variables = 'none',
        types = 'none', operators = 'none', numbers = 'none', booleans = 'none',
        constants = 'none', punctuation = 'none',
      },
      plugins = {
        cmp = true, telescope = true, git = true, gitsigns = true,
        noice = true, obsidian = true, rainbow = true, headline = true,
        indent = true, which_key = true, nvim_tree = false, neo_tree = true,
        dap = true, dapui = true, trouble = true, notify = true,
        treesitter_context = true, hop = true,
        -- phase 1 additions
        diffview = true, fidget = true, toggleterm = true, dashboard = true,
        heirline = true, oil = true, blink = true, leap = true, flash = true,
        ufo = true, bqf = true,
      },
      overrides = function(colors)
        return { NormalFloat = { bg = 'NONE' }, CursorLine = { underline = true } }
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

## Опции (полный список с дефолтами)

```lua
require('neg').setup({
  saturation = 100,                    -- глобальный масштаб насыщенности 0..100 (100 = исходная палитра, 0 = монохром)
  alpha_overlay = 0,                  -- глобальный альфа‑уровень мягких фонов 0..30 (Search/CurSearch/Visual и DiagnosticVirtualText)
  transparent = false,                  -- boolean или { float, sidebar, statusline }
  terminal_colors = true,               -- задать 16 ANSI цветов терминала
  preset = nil,                         -- 'soft' | 'hard' | 'pro' | 'writing' | 'accessibility' | 'focus' | 'presentation' | nil

  operator_colors = 'families',         -- 'families' (семейства операторов) | 'mono' | 'mono+' (чуть сильнее акцент)
  number_colors = 'ramp',               -- 'mono' или 'ramp'‑пресеты: 'ramp' (balanced, по умолчанию) | 'ramp-soft' | 'ramp-strong'

  treesitter = {
    extras = true,                      -- доп. капчеры: math/environment/name, template, true/false, nil/null, decorator/annotation и типмоды
    punct_family = false,               -- различать families скобок (parenthesis/brace) от bracket
  },

  ui = {
    core_enhancements = true,           -- Whitespace, EndOfBuffer, PmenuMatch*, FloatShadow*, Cursor*, VisualNOS, Question, LineNrAbove/Below
    dim_inactive = false,               -- приглушать неактивные окна (NormalNC/WinBarNC) и LineNr по winhighlight
    mode_accent = true,                 -- акцентировать CursorLine/StatusLine по режимам
    focus_caret = true,                 -- усилить видимость CursorLine при низком общем контрасте
    soft_borders = false,               -- смягчить WinSeparator/FloatBorder
    float_panel_bg = false,             -- слегка осветлённый «панельный» фон для NormalFloat (по умолчанию выкл.)
    auto_transparent_panels = true,     -- мягкая подложка для float/panel при прозрачном терминале
    diff_focus = true,                  -- усилить фоны Diff* при :diff
    light_signs = false,                -- смягчить иконки SignColumn (DiagnosticSign*/GitSigns*)

    -- Пакет доступности/UX‑улучшений
    diag_pattern = 'none',              -- 'none' | 'minimal' | 'strong' (паттерны для Diagnostic*)
    lexeme_cues = 'off',                -- 'off' | 'minimal' | 'strong' (подсказки для функций/типов)
    thick_cursor = false,               -- «толстый» курсор/строка
    outlines = false,                   -- рамки активных/неактивных окон
    reading_mode = false,               -- режим чтения (почти монохром)
    search_visibility = 'default',      -- 'default' | 'soft' | 'strong'
    screenreader_friendly = false,      -- минимизировать динамические акценты/цветные фоны
    telescope_accents = false,          -- усиленные акценты для Telescope (совпадения/выделение/границы)
    path_separator_blue = false,        -- голубые разделители путей (Startify/Navic/WhichKey)
    path_separator_color = nil,         -- необязательный '#rrggbb' или ключ палитры при включенном path_separator_blue
    selection_model = 'kitty',          -- 'default' (тема) или 'kitty' (как выделение в kitty)

    accessibility = {
      deuteranopia = false,             -- сдвиг «добавлений» в синеву, варны остаются различимыми
      strong_undercurl = false,         -- более заметные undercurl (с underline‑fallback)
      -- удалено: strong_tui_cursor
      achromatopsia = false,            -- монохром/высокий контраст (минимум зависимости от цвета); повышает читаемость Folded/ColorColumn
      hc = 'off',                       -- high‑contrast для achromatopsia: 'off' | 'soft' | 'strong'
    },
  },

  styles = {
    comments = 'italic', keywords = 'none', functions = 'none', strings = 'none',
    variables = 'none', types = 'none', operators = 'none', numbers = 'none',
    booleans = 'none', constants = 'none', punctuation = 'none',
  },

  plugins = {  -- поставить false чтобы отключить интеграцию
    cmp = true, telescope = true, git = true, gitsigns = true,
    bufferline = true, noice = true, obsidian = true, rainbow = true,
    headline = true, indent = true, which_key = true, nvim_tree = false,
    neo_tree = true, dap = true, dapui = true, trouble = true, notify = true,
    treesitter_context = true, hop = true,
    -- дополнительные
    alpha = true, mini_statusline = true, mini_tabline = true,
    todo_comments = true, navic = true, lspsaga = true, navbuddy = true,
    neotest = true, harpoon = true, treesitter_playground = true, startify = true,
    overseer = true,
  },
})
```

### Порядок применения

Когда включено несколько пост‑процессингов, neg.nvim применяет их в предсказуемой последовательности, чтобы избежать конфликтов:

- Сначала опции доступности (deuteranopia/achromatopsia), затем пакет повышенного контраста `hc`
- Затем фоны виртуального текста диагностик (если включены)
- Далее глобальный альфа‑оверлей мягких фонов (`alpha_overlay` для Search/CurSearch/Visual/VirtualText)
- Затем модель выделения (дефолтная темы или kitty)
- В самом конце пользовательские переопределения (`overrides` как таблица или функция)

## Пресеты

- soft — по умолчанию: деликатные акценты, курсив комментариев
- hard — более контрастные акценты; ключевые категории жирные; Title жирный
- pro — без курсива (комменты, inlay hints, CodeLens, markup)
- writing — акценты для Markdown/markup (жирные заголовки/strong, курсив)
- accessibility — повышенный контраст, без мягкого фона диагностик, сильнее линии/номера
- focus — приглушает неактивные окна (включает dim_inactive) и смягчает границы (soft_borders)
- presentation — ярче акценты, более заметные CursorLine/CursorLineNr и поиск/Title

Использование:

```lua
require('neg').setup({ preset = 'hard' })
-- или в рантайме:
-- :NegPreset hard
-- :NegPreset none  -- сброс пресета
```

### Таблица пресетов

| Пресет | Цель | Изменения | Примечания |
| --- | --- | --- | --- |
| soft | Сдержанный базовый вид | Дефолты; курсив комментариев | Базовая палитра |
| hard | Выше контраст акцентов | Жирные keywords/functions/types/constants/booleans/numbers; Title жирный | Хорошо для презентаций кода |
| pro | Без курсива | Отключает курсив у комментариев, inlay hints, CodeLens, markup italics | Можно сочетать с `lexeme_cues=minimal` |
| writing | Акценты для разметки | Жирные заголовки/strong; курсив для emphasis; Title жирный | Для Markdown/прозы |
| accessibility | Более высокий контраст UI | Отключает фон виртуальных диагностик; сильнее LineNr/границы; более явные CursorLine/ColorColumn/Visual; без курсива комментариев | Комбинируйте с `ui.accessibility.*` и `:NegHc` |
| focus | Меньше шума, фокус на окне | Включает `ui.dim_inactive=true`, `ui.soft_borders=true` | Удобно при множестве сплитов |
| presentation | Ярче акценты | Более видимые CursorLine/CursorLineNr; сильнее Title и поиск | Для демо/докладов |
| none | Без пресета | Нет доп. изменений | Используйте явные опции |

#### Быстрые примеры (пресет + 1–2 тумблера)

```lua
-- Focus + мягкие границы
require('neg').setup({ preset = 'focus', ui = { soft_borders = true } })

-- Presentation + нейтральный Telescope (без усиленных акцентов)
require('neg').setup({ preset = 'presentation', ui = { telescope_accents = false } })

-- Accessibility + мягкий high‑contrast
require('neg').setup({ preset = 'accessibility', ui = { accessibility = { achromatopsia = true, hc = 'soft' } } })

-- Pro (без курсива) + моно операторы
require('neg').setup({ preset = 'pro', operator_colors = 'mono' })
```

## Команды

- :NegToggleTransparent — переключить прозрачность и применить тему
- :NegToggleTransparentZone {float|sidebar|statusline} — прозрачность по зоне
- :NegPreset {soft|hard|pro|writing|accessibility|focus|presentation|none} — применить пресет
- :NegReload — повторно применить подсветки с текущей конфигурацией
- :NegInfo — краткая сводка опций (включая фон диагностик)
- :NegDiagBgMode {blend|alpha|lighten|darken|off|on} — режим фона виртуального текста
- :NegDiagBgStrength {0..1} — сила для alpha/lighten/darken
- :NegDiagBgBlend {0..100} — blend‑значение при mode=blend
- :NegDiagSoft / :NegDiagStrong — быстрые пресеты мягче/сильнее
- :NegOperatorColors {families|mono|mono+} — режим окраски операторов
- :NegNumberColors {mono|ramp|ramp-soft|ramp-strong} — пресеты ramp для чисел
- :NegSaturation {0..100} — глобальная насыщенность (100 = исходная палитра, 0 = монохром)
- :NegAlpha {0..30} — общий альфа‑уровень мягких фонов (Search/CurSearch/Visual/VirtualText)
- :NegModeAccent {on|off|toggle} — акценты по режимам (CursorLine/StatusLine)
- :NegSoftBorders {on|off|toggle} — мягкие границы (WinSeparator/FloatBorder)
- :NegFloatBg {on|off|toggle} — модель фона флоатов (Normal vs слегка осветлённый «панельный»)
- :NegFocusCaret {on|off|toggle} — повысить контраст CursorLine при низком общем контрасте
- :NegLightSigns {on|off|toggle} — «легкие» знаки в SignColumn
- :NegSelection {default|kitty} — модель подсветки выделения (тема/kitty)
- :NegDimInactive {on|off|toggle} — приглушить неактивные окна
- :NegDiffFocus {on|off|toggle} — усилить фоны Diff* при :diff
- :NegPunctFamily {on|off|toggle} — различение семейства скобок
- :NegTelescopeAccents {on|off|toggle} — усиленные акценты для Telescope (совпадения/выделение/границы)
- :NegPathSep {on|off|toggle} — голубой цвет разделителей путей (Startify/Navic/WhichKey)
- :NegPathSepColor {#rrggbb|palette_key|default} — задать/сбросить цвет разделителей (используется при включенном голубом)
- :NegAccessibility {deuteranopia|strong_undercurl|achromatopsia} {on|off|toggle}
- :NegDiagPattern {none|minimal|strong} — паттерны для Diagnostic*
- :NegLexemeCues {off|minimal|strong} — подсказки для функций/типов
- :NegThickCursor {on|off|toggle} — «толстый» курсор/строка
- :NegOutlines {on|off|toggle} — рамки активных/неактивных окон
- :NegReadingMode {on|off|toggle} — режим чтения
- :NegSearchVisibility {default|soft|strong} — видимость поиска/текущего совпадения
- :NegHc {off|soft|strong} — пресеты контраста (achromatopsia)
- :NegScreenreader {on|off|toggle} — режим, дружелюбный к скринридеру
- :NegContrast {Group|@capture} [vs {Group|#rrggbb}] [--target AA|AAA] [apply] [--json] [--notify=off|on] — посчитать контраст; есть JSON‑вывод и apply
- :NegExport [all|core|diff|diagnostics|syntax|hints] [--json] [--notify=off|on] — экспорт подсветок (выбор секций; доступен JSON)
- :NegScenario {focus|presentation|screenreader|tui|gui|accessibility} — быстро применить готовый набор тумблеров
- :NegScenarioSave {name} — сохранить текущую конфигурацию как именованный сценарий (в памяти сессии)
- :NegScenarioList — показать встроенные и пользовательские сценарии
- :NegScenarioDelete {name} — удалить сохранённый пользовательский сценарий
- :NegScenarioExport {name|current} [--json] [--notify=off|on] — экспорт сценария в JSON ({ name, scenario })
- :NegScenarioImport {@/path|JSON} [--merge|--replace] [--notify=off|on] — импорт сценария из JSON‑строки или файла
- :NegScenarioWrite [@/path] [--notify=off|on] — записать пользовательские сценарии в файл (по умолчанию stdpath('config')/neg/scenarios.json)
- :NegScenarioRead [@/path] [--merge|--replace] [--notify=off|on] — прочитать сценарии из файла в память
- :NegPlugins [enabled|disabled|all] [filter] [--json] [--notify=off|on] — распечатать интеграции (фильтр по состоянию/подстроке; JSON-вывод и управление notify)

### Флаги плагинов — Сводка

По умолчанию все перечисленные интеграции включены (если не указано иное). Отключайте через `plugins.<ключ> = false` в setup.

- Поисковые пикеры: `telescope`, `fzf_lua`, `mini_pick`, `snacks` (вкл)
- Автодополнение: `cmp`, `blink` (вкл)
- Git и Diff: `git`, `gitsigns`, `diffview` (вкл)
- Файлы и дашборды: `neo_tree` (вкл), `nvim_tree` (выкл), `oil` (вкл), `startify` (вкл), `alpha` (вкл), `dashboard` (вкл)
- Статус/табы/винбар: `bufferline`, `mini_statusline`, `mini_tabline`, `heirline`, `barbecue`, `navic`, `navbuddy` (вкл)
- LSP/UI: `lspsaga`, `noice`, `notify`, `treesitter_context`, `treesitter_playground`, `glance`, `illuminate`, `hlslens` (вкл)
- Навигация/переходы: `hop`, `leap`, `flash`, `harpoon`, `rainbow` (вкл)
- Диагностика/задачи: `trouble`, `todo_comments`, `overseer` (вкл)
- Отладка: `dap`, `dapui`, `dap_virtual_text`, `bqf` (вкл)
- Структура/отступы: `indent`, `virt_column`, `ufo` (вкл)
- Заметки/тесты: `obsidian`, `neotest`, `which_key`, `toggleterm` (вкл)

### Быстрые переключатели

| Команда | Действие | По умолчанию |
| --- | --- | --- |
| `:NegModeAccent {on|off|toggle}` | Акценты по режимам (CursorLine/StatusLine) | вкл |
| `:NegFocusCaret {on|off|toggle}` | Усилить видимость CursorLine при низком контрасте | вкл |
| `:NegDimInactive {on|off|toggle}` | Приглушать неактивные окна (NormalNC/WinBarNC, LineNr) | выкл |
| `:NegDiffFocus {on|off|toggle}` | Более явные фоны Diff* при `:diff` | вкл |
| `:NegSoftBorders {on|off|toggle}` | Мягкие границы (WinSeparator/FloatBorder) | выкл |
| `:NegFloatBg {on|off|toggle}` | Слегка «панельный» фон флоатов | выкл |
| `:NegLightSigns {on|off|toggle}` | «Лёгкие» значки SignColumn (DiagnosticSign*/GitSigns*) | выкл |
| `:NegTelescopeAccents {on|off|toggle}` | Усиленные акценты Telescope (совпадения/выделение) | выкл |
| `:NegPathSep {on|off|toggle}` | Голубые разделители путей (Startify/Navic/WhichKey) | выкл |
| `:NegPathSepColor {#hex|key|default}` | Задать/сбросить цвет разделителей | — |
| `:NegSelection {default|kitty}` | Модель выделения (тема/kitty) | kitty |
| `:NegPunctFamily {on|off|toggle}` | Различать семейства скобок | выкл |
| `:NegReadingMode {on|off|toggle}` | Режим чтения (почти монохром) | выкл |
| `:NegOutlines {on|off|toggle}` | Рамки активных/неактивных окон | выкл |
| `:NegThickCursor {on|off|toggle}` | Более «толстая» строка курсора | выкл |
| `:NegSearchVisibility {default|soft|strong}` | Видимость поиска/текущего совпадения | default |
| `:NegScreenreader {on|off|toggle}` | Режим, дружелюбный к скринридеру | выкл |
| `:NegAccessibility {deuteranopia|strong_undercurl|achromatopsia}` | Флаги доступности | все выкл |
| `:NegHc {off|soft|strong}` | Пакет высокого контраста (achromatopsia) | off |
| `:NegDiagPattern {none|minimal|strong}` | Паттерны Diagnostic* | none |
| `:NegDiagSoft` / `:NegDiagStrong` | Быстрые пресеты фонов виртуального текста | выкл |

### Модель выделения (kitty)

По умолчанию выделение соответствует kitty. Чтобы вернуть выделение темы:

- Опция: `ui.selection_model = 'default'`
- Команда: `:NegSelection default`

Используются цвета палитры:

- `selection_bg = '#0d1824'`
- `selection_fg = '#367bbf'`

Примечания:

- Для точного совпадения лучше держать `alpha_overlay = 0` (альфа‑оверлей смягчает фон).
- Можно переопределить `selection_bg/fg` через `overrides`.

Примеры быстрых overrides:

```lua
-- Свои цвета "как в kitty"
require('neg').setup({
  ui = { selection_model = 'kitty' },
  overrides = {
    Visual    = { bg = '#101a28', fg = '#62a0ff', bold = false, underline = false },
    VisualNOS = { bg = '#101a28', fg = '#62a0ff' },
  },
})

-- Или на базе палитры
require('neg').setup({
  ui = { selection_model = 'kitty' },
  overrides = function(colors)
    return {
      Visual = { bg = colors.selection_bg, fg = '#5fb0ff' },
    }
  end,
})
```

### Модель фона флоатов

По умолчанию `NormalFloat` совпадает с фоном `Normal` (без оттенков). Если нужен чуть более светлый “панельный” фон:

- Опция: `ui.float_panel_bg = true`
- Команда: `:NegFloatBg on`

Фон берётся из `palette.bg_panel` (на основе базового фона). Переключение — `:NegFloatBg toggle`.

Примеры быстрых overrides:

```lua
-- Чуть темнее граница и свой фон флоатов
require('neg').setup({
  ui = { float_panel_bg = true },
  overrides = {
    NormalFloat = { bg = '#0f131a' },
    FloatBorder = { fg = '#1a1f29' },
  },
})

-- Или отталкиваясь от палитры
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

## Известные взаимодействия

- CursorLine (mode_accent, focus_caret, thick_cursor)
  - Порядок: акценты по режиму → caret‑фокус → «толстый» курсор. Thick cursor усиливает CursorLine после акцентов; screenreader может затем стабилизировать.
  - Совет: для стабильной картинки (без динамики) отключите `ui.mode_accent` и `ui.focus_caret` или включите `:NegScreenreader on`.
- WinSeparator/FloatBorder (soft_borders, outlines)
  - Soft borders осветляет `WinSeparator`/`FloatBorder` глобально; outlines переназначает `WinSeparator` поканально на активный/неактивный.
  - Итог: outlines имеет приоритет для `WinSeparator`; soft borders продолжает влиять на `FloatBorder`.
 - Dim inactive и outlines
  - `ui.dim_inactive` переназначает только `LineNr` (и базовые NormalNC/WinBarNC) по окну и не изменяет `WinSeparator`; приоритет для разделителей остаётся за outlines.
- Фоны Diff (diff_focus, screenreader)
  - Diff focus усиливает `Diff*` в `:diff`; screenreader снимает это усиление для более спокойного вывода.
- Telescope + границы
  - Границы Telescope ссылаются на `WinSeparator`: при включенных outlines Telescope наследует активный/неактивный оттенок; при soft borders (без outlines) остаётся мягкое осветление.
- Выделение, альфа‑оверлей, фон виртуальных диагностик
  - Порядок применения (см. «Порядок применения»): фон диагностик → alpha overlay → модель выделения. Если Visual слишком мягкий — уменьшите `alpha_overlay` или используйте `:NegSearchVisibility`.

### Сценарии (рецепты)

- Спокойная презентация (ярче, но без шума)

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

- Высокий контраст (achromatopsia, strong)

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
-- Коротко в рантайме:
-- :NegAccessibility achromatopsia on | :NegHc strong | :NegDiagPattern strong
```

- Минимум динамики (стабильная картинка)

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

#### Рецепты под среды (терминал / GUI / презентация / скринридер)

- Терминал (TUI)

  - Когда: работа в терминале без прозрачности; нужно чёткое выделение (kitty) и спокойные значки.
  - Что меняется: выключаем альфа‑оверлей мягких фонов, включаем «толстый» курсор и light_signs, оставляем нейтральные границы и diff_focus.

```lua
-- Совет: включите truecolor в Neovim: :set termguicolors
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

- GUI (Neovide/Goneovim и т.п.)

  - Когда: GUI‑фронтенды; хочется мягких границ и «панельных» флоатов, лёгкие акценты.
  - Что меняется: мягкие границы + панельный фон флоатов, лёгкий alpha overlay, опциональные акценты Telescope.

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

- Яркая презентация

  - Когда: демо/проектор, где акценты должны читаться издалека.
  - Что меняется: пресет presentation, сильнее числа/поиск, отключаем динамические акценты.

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

- Дружелюбно к скринридеру

  - Когда: пользователи скринридера или тем, кому важна стабильная картинка.
  - Что меняется: стабилизируем акценты, achromatopsia + мягкий high‑contrast, сильные undercurl, без diff focus.

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

- Терминал + kitty + голубые разделители путей (как в zsh)

  - Когда: TUI с kitty‑выделением и голубыми разделителями путей как в zsh.
  - Что меняется: kitty‑выделение + голубые разделители (цвет задаётся явно или ключом палитры).

```lua
require('neg').setup({
  ui = {
    selection_model = 'kitty',
    path_separator_blue = true,
    -- необязательный цвет (hex или ключ палитры):
    -- path_separator_color = 'include_color', -- или '#22aaff'
  },
})
-- В рантайме: :NegPathSep on | :NegPathSepColor include_color
```

## Overrides

Можно переопределять любые группы:

```lua
require('neg').setup({
  overrides = {
    Normal = { fg = '#c0c0c0' },
    NormalFloat = { bg = 'NONE' },
  }
})
```

или передать функцию, получающую палитру:

```lua
require('neg').setup({
  overrides = function(c)
    return { DiagnosticUnderlineWarn = { undercurl = true, sp = c.warning_color } }
  end
})
```

### Частые рецепты

- Без курсива везде (альтернатива preset='pro'):

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

- Прозрачные float/sidebars (альтернатива transparent={ ... }):

```lua
require('neg').setup({
  overrides = {
    NormalFloat = { bg = 'NONE' }, Pmenu = { bg = 'NONE' }, FloatBorder = { bg = 'NONE' },
    NvimTreeNormal = { bg = 'NONE' }, NeoTreeNormal = { bg = 'NONE' }, TroubleNormal = { bg = 'NONE' },
  }
})
```

- Более мягкий/заметный фон виртуального текста по уровням:

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

## Покрытие плагинов (кратко)

- telescope.nvim — рамки, выбор, совпадения; учитывает прозрачные float‑зоны
- nvim‑cmp — `CmpItemKind*` (расширенные виды), документы/границы; прозрачные float‑зоны
- gitsigns/gitgutter/diff — знаки/дифф‑группы
- indent‑blankline/ibl / mini.indentscope — символы/контекст/скоупы
- which‑key — группы/бордеры/флоат
- neo‑tree / nvim‑tree — основные группы, курсорлайны, статусы; float‑зоны
- bufferline — *BufferLine*
- lualine — тема `theme = 'neg'`
- dap / dap‑ui — маркеры отладки + UI
- trouble / notify / treesitter‑context / hop / rainbow‑delimiters / obsidian / alpha / startify / todo‑comments / lspsaga / overseer / navic / navbuddy / treesitter‑playground — покрытие основных групп

Подробные списки см. в английском README (раздел Detailed Plugin Coverage).

## Troubleshooting

- Тема выглядит «смешанной»/частично применённой
  - Убедитесь, что включена только одна тема; уберите лишние `colorscheme`.
  - Для lazy.nvim — `priority = 1000` и `lazy = false`.
  - Выполните `:colorscheme neg` после загрузки UI‑плагинов, если кто‑то поздно перезаписывает группы.
- Прозрачность не работает
  - Терминал должен поддерживать прозрачность. Опция `transparent` задаёт bg = `NONE`, а не изменяет фон терминала.
  - Для отдельных зон используйте `transparent = { float = true, sidebar = true, statusline = true }` или `:NegToggleTransparentZone`.
  - Проверьте `overrides` — они применяются последними. Используйте `:NegInfo`.
- Переопределение связанной группы не действует
  - Если группа `link`‑связана, её атрибуты игнорируются. Укажите любые атрибуты, чтобы разбить связь.
  - Пример: `NormalFloat = { bg = 'NONE' }`.
- Цвета выглядят «неправильно»
  - Включите `:set termguicolors` и оставьте `terminal_colors = true` (или настройте в overrides).
- Несовпадение Tree‑sitter/LSP подсветки
  - Проверьте `:Inspect` на токене. Капчеры в 0.9/0.10 могут отличаться.
  - Тема мапит современные капчеры; обновите Neovim/парсеры.
- Диагностика слишком сильная/слабая
  - `diagnostics_virtual_bg = false` или настройте `diagnostics_virtual_bg_blend`.
  - Либо переопределите по уровню.
- Курсив не виден
  - Шрифт терминала может не поддерживать курсив. Попробуйте GUI или другой шрифт.
- Светлый фон?
  - Тема тёмная. `set background=light` сейчас не поддерживается.

## FAQ

- Как использовать с `:colorscheme`?
  - Плагин кладёт `colors/neg.lua`. Вызовите `:colorscheme neg` после `require('neg').setup(...)`.
- Как отключить интеграцию для конкретного плагина?
  - Поставьте `false` в таблице `plugins`.
- Можно ли кастомизировать палитру?
  - Используйте `overrides` для групп и `require('neg.palette')` при необходимости.
- Как переключать пресеты/прозрачность на лету?
  - `:NegPreset ...` и `:NegToggleTransparent`/`:NegToggleTransparentZone`.
- Группа плагина не покрыта — что делать?
  - Добавьте `overrides` для этой группы. PR‑ы приветствуются.

## Валидатор и CI

- Локально: `./scripts/validate.sh`
- Строгий режим: `NEG_VALIDATE_STRICT=1 ./scripts/validate.sh`
- GitHub Actions: `.github/workflows/validate.yml`
- Проверка контраста (необязательно): `NEG_VALIDATE_CONTRAST=1 NEG_VALIDATE_CONTRAST_MIN=3.0 ./scripts/validate.sh`
  - Предупреждает, если контраст (fg vs bg) ниже порога.
  - Включайте при настройке цветов; строгий режим упадёт на предупреждениях.
- Подробная сводка: `NEG_VALIDATE_VERBOSE=1 ./scripts/validate.sh`

- Листинг покрытия (необязательно):
  - `NEG_VALIDATE_LIST=1` — вывести все определённые группы `DEF: <name>`
  - `NEG_VALIDATE_LIST_FILTER='^CmpItem'` — отфильтровать по Lua‑шаблону
  - `NEG_VALIDATE_LIST_LIMIT=200` — ограничить количество
- Статистика по модулям и дубликаты:
  - `NEG_VALIDATE_MODULE_STATS=1` — количество групп на модуль
  - `NEG_VALIDATE_DUP_SOURCES=1` — показать дубликаты источников

## Примеры (скриншоты)

См. раздел Demo shots в README.md (англ.).

## Рекомендованные сочетания

- «Спокойный интерфейс» (меньше шума):

```lua
require('neg').setup({
  preset = 'soft', operator_colors = 'families', number_colors = 'ramp-soft',
  ui = { soft_borders = true, light_signs = true, dim_inactive = true },
})
```

- «Фокус на активном окне»:

```lua
require('neg').setup({
  preset = 'focus',              -- включает dim_inactive + soft_borders
  operator_colors = 'mono+',
  treesitter = { punct_family = true },
})
```

- «Презентация/демо»:

```lua
require('neg').setup({
  preset = 'presentation', operator_colors = 'mono+', number_colors = 'ramp-strong',
})
-- для более выразительной диагностики: :NegDiagStrong
```
