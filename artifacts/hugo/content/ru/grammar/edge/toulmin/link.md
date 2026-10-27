---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK — раскладка для записи отношений между узлами TOULMIN (атака, вытеснение, выполнение, связь вердикта, определение, имя). Состоит из REF src и dst, WORD флагов, необязательного порога уверенности и SPAN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK — раскладка для записи отношений между узлами графа TOULMIN. Вид отношения задаёт Codec (или номер формата ISSUER GEUL).

## Codec

| Codec | Имя | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | правило → правило. Постепенно снижает вердикт |
| `0x69` | SUPERSEDES | `X supersedes Y` | правило → правило. Если Active, исключает цель из агрегации |
| `0x70` | RUN | `run c when n` | правило → дело |
| `0x71` | DO | `do fn when n` | правило → FuncRef |
| `0x72` | DO-ONCE | `do fn once when n` | правило → FuncRef |
| `0x73` | UNDO | `undo fn when n` | правило → FuncRef |
| `0x74` | CHECKING | `checking c` | правило → дело. Вердикт без побочных эффектов |
| ISSUER `0x0000`/`0xC020` | REQUIRES | `f is required` | дело → поле |
| ISSUER `0x0000`/`0xC021` | MEANS | `means` в Definitions | элемент определения → значение или тип |
| ISSUER `0x0000`/`0xC022` | HAS | `has` в Definitions | элемент определения → поле |
| ISSUER `0x0000`/`0xC023` | RUNS | `run c` точки входа | точка входа → дело (выполнение) |
| ISSUER `0x0000`/`0xC024` | EVALUATES | `check c` точки входа | точка входа → дело (вердикт) |
| ISSUER `0x0000`/`0xC025` | TRIGGERS | `run c` триггера | триггер → дело |
| ISSUER `0x0000`/`0xC026` | UNTIL | `every … until c` | триггер → дело |
| ISSUER `0x0000`/`0xC027` | SAME-AS | | узел → глобальный идентификатор |
| ISSUER `0x0000`/`0xC028` | IMPORTED-FROM | `see a from path` | алиас → путь (TEXT) |
| ISSUER `0x0000`/`0xC029` | LABEL | имя в обратных кавычках | узел → TEXT. Запись имени |

## Раскладка

```
ID               запись LOCAL Reference (Edge Id)
src              REF
dst              REF. Для DO·DO-ONCE·UNDO — FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED
[F_GATE]         оператор 1 WORD (старшие 2 бита) + UNSIGNED-DECIMAL Value (проценты)
SPAN             ширина, заданная SOURCE × 2
```

| flag | Смысл |
|---|---|
| b0 F_ONCE | Выполняется только один раз (`once` у UNDO) |
| b1 F_GATE | Есть поле порога уверенности |
| b2 F_STRIKE | Отношение зачёркнуто |
| b3 F_ORDERED | Принадлежит нумерованному списку `1.` |

| Оператор порога | Смысл |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

## Интерпретация и допустимость

- REF — это Edge Id записи этого документа (общие поля в [TOULMIN](/ru/grammar/edge/toulmin/#общие-поля)).
- Форму dst задаёт Codec. Для DO·DO-ONCE·UNDO это FuncRef (REF(ALIAS, 0 если нет) + VerbCode 1 WORD, [NODE](/ru/grammar/edge/toulmin/node/#поля)), для LABEL·IMPORTED-FROM — REF записи TEXT, в остальных случаях — REF узла.
- `do … once` выражается Codec DO-ONCE. В flags у DO-ONCE F_ONCE не используется (если он установлен, запись отклоняется). `once` у UNDO записывается через F_ONCE.
- Оператор порога — старшие 2 бита WORD оператора, остальные 14 бит равны 0. Проценты — это UNSIGNED-DECIMAL Value с `E=0`, значение 0~100.
- Биты b4~b15 в flags зарезервированы и должны быть равны 0. Иначе запись отклоняется.
- Цепочка `A > B > C` у SUPERSEDES записывается по одной записи SUPERSEDES на пару.

## Связанные страницы

- [TOULMIN](/ru/grammar/edge/toulmin/), [NODE](/ru/grammar/edge/toulmin/node/), [SOURCE и разделы](/ru/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/ru/grammar/value/decimal/unsigned-decimal/)
