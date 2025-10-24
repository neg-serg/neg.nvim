# neg.nvim — Обзор изменений (линейка 4.x)

Этот документ в свободной форме объединяет и объясняет изменения 4.x по темам. Он дополняет постатейный CHANGELOG, помогая увидеть замысел и сценарии использования.

## Ядро UI и редактора

- Базовые группы (ui.core_enhancements = true по умолчанию): Whitespace, EndOfBuffer, LineNrAbove/Below (0.10+), Question, VisualNOS, FloatShadow/FloatShadowThrough, PmenuMatch/MatchSel, Cursor/lCursor/CursorIM.
- Diff всегда в core (не зависит от git‑плагинов): DiffAdd/Change/Delete/Text перенесены в модуль редактора, чтобы режим diff оставался читаемым даже без плагинов.
- Акценты по режимам (ui.mode_accent = true): мягко меняют CursorLine/StatusLine; сочетаются с focus_caret.
- Focus caret (ui.focus_caret = true): слегка усиливает CursorLine при низком общем контрасте (ориентация на AA).
- Приглушение неактивных (ui.dim_inactive): мьютит NormalNC/WinBarNC и LineNr через winhighlight.
- Мягкие границы (ui.soft_borders): более светлые WinSeparator/FloatBorder для спокойных рамок.
- Рамки/контуры (ui.outlines): поканальная подсветка WinSeparator для лучшей локализации фокуса.
- «Толстый» курсор (ui.thick_cursor): усиливает CursorLine/CursorLineNr без агрессивных цветов.
- Фон флоатов (ui.float_panel_bg): по умолчанию совпадает с Normal; опционально — чуть «панельный» светлее.
- Нейтральные флоаты по умолчанию (NormalFloat → link Normal): прежняя голубизна/серость полностью убрана.
- Видимость поиска: предустановки для Search/CurSearch без «заливки» экрана.

## Диагностика и Diff

- Фон виртуального текста: режимы blend/alpha/lighten/darken и сила; быстрые пресеты :NegDiagSoft / :NegDiagStrong.
- Паттерны диагностик (ui.diag_pattern): none|minimal|strong — underline/undercurl по степени.
- Screenreader‑friendly: стабилизирует акценты и гасит усиление diff для более спокойного озвучивания.
- Diff focus (ui.diff_focus): делает фоны Diff* заметнее, когда есть :diff (по умолчанию вкл., тумблер).

## Tree‑sitter и LSP

- Дополнения (treesitter.extras = true по умолчанию):
  - Markup: @markup.math, @markup.environment, @markup.environment.name, @markup.link.text
  - Строки: @string.template, @string.documentation
  - Логические/нулевые: @boolean.true/@boolean.false, @nil/@null
  - Семейства пунктуации: @punctuation.parenthesis/@punctuation.brace (опционально)
  - Типы: @type.enum/@type.union/@type.interface
  - Константы: @constant.builtin.boolean/@constant.builtin.numeric
- Операторы:
  - Разводка по семействам; рантайм‑пресет :NegOperatorColors {families|mono|mono+}. По умолчанию ‘families’ (сдержанное разнообразие); ‘mono+’ — единый цвет с лёгким акцентом.
- LSP семантика:
  - @lsp.type.decorator → @function.macro, @lsp.type.annotation → @attribute
  - Типмоды добавлены аккуратно: declaration/abstract/static/readonly для распространённых сущностей, включая @lsp.typemod.enumMember.static → @constant.

## Числа и палитра

- Рамп чисел: тонкие монохромные варианты для integer/hex/octal/binary с пресетами ramp|ramp‑soft|ramp‑strong; :NegNumberColors.
- Современные имена палитры: говорящие алиасы (include_color, diff_add_color, bg_panel и т.д.) + удобные вспомогательные (border_color, selection_bg/fg).
- Слайдер насыщенности :NegSaturation {0..100} — быстро к нейтрали/выразительности.
- Общий альфа‑уровень :NegAlpha {0..30} — мягкая подложка для Search/CurSearch/Visual и DiagnosticVirtualText.

## Telescope, kitty и разделители путей

- Нейтральный Telescope: совпадения — только underline; выбор — из Visual; все панели линкованы к Normal (без тонированных флоатов).
- Опциональные акценты (ui.telescope_accents, :NegTelescopeAccents): аккуратный «поп» для желающих.
- Модель выделения как у kitty: ui.selection_model = 'kitty' (теперь по умолчанию) применяет kitty‑цвета к Visual/VisualNOS; :NegSelection переключает 'default'↔'kitty'.
- Разделители путей:
  - ui.path_separator_blue (тумблер) и ui.path_separator_color — «zsh‑подобный» голубой для разделителей.
  - Охват: TelescopePathSeparator, StartifySlash, NavicSeparator, WhichKeySeparator (учитываются тумблеры плагинов).

## Доступность и профили

- Пресеты: accessibility, focus, presentation (наряду с soft/hard/pro/writing).
- Поддержка ахроматопсии: флаг achromatopsia + пакет контраста ui.accessibility.hc ('off'|'soft'|'strong').
- Deuteranopia: мягкий сдвиг оттенков для различимости добавлений/предупреждений.
  
- Режим чтения: почти монохромная подсветка с ясной структурой.
- Подсказки лексем: подчёркивание функций и акцент типов (off|minimal|strong).

## Инструменты рантайма

- :NegContrast {Group|@capture} [vs Group|#hex] [--target AA|AAA] [apply]
  - Печатает контраст (WCAG); можно задать цель AA/AAA, получить подсказку :hi и даже применить.
- :NegExport — выгружает core/diff/diagnostics/syntax с быстрыми подсказками.
- Богатый набор тумблеров на каждый день: ModeAccent, FocusCaret, DimInactive, DiffFocus, SoftBorders, FloatBg, LightSigns, PunctFamily, TelescopeAccents, Selection, ReadingMode, Outlines, ThickCursor, SearchVisibility, Screenreader, Hc.

## Документация и качество

- README на английском и русском синхронизированы.
- Разделы «Таблица пресетов», «Быстрые переключатели», «Быстрые примеры» и «Известные взаимодействия» помогают быстро понять поведение и приоритеты.
- «Порядок применения» задокументирован; валидатор проверяет ключи/линки и при желании контраст.

## Важные дефолты

- ui.core_enhancements = true, treesitter.extras = true, ui.mode_accent = true, ui.diff_focus = true, selection_model = 'kitty'.
- ui.soft_borders = false, ui.float_panel_bg = false, ui.telescope_accents = false, ui.path_separator_blue = false.
- number_colors = 'ramp', operator_colors = 'families'.

## Подсказки миграции

- Если нужен отдельный фон флоатов — включите ui.float_panel_bg или переопределите NormalFloat.
- Если предпочитаете «тематическое» выделение, а не kitty — :NegSelection default или ui.selection_model = 'default'.
- Если плагин перекрашивает Telescope позже — используйте :NegReload или свои overrides.

## Подход

Линейка 4.x про ясность, сдержанные дефолты, опциональные акценты за тумблерами и сильный набор инструментов доступности. Переопределения пользователя остаются «последним словом» в пайплайне, известные взаимодействия описаны.
