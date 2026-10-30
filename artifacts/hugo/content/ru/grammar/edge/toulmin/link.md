---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK — раскладка для записи отношений между узлами TOULMIN (атака, вытеснение, выполнение, связь вердикта, определение, имя). Состоит из REF src и dst, WORD флагов, необязательного порога уверенности, необязательной интенсивности атаки и SPAN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK — раскладка для записи отношений между узлами графа TOULMIN. Вид отношения задаёт Codec (или номер формата ISSUER GEUL).

## Codec

| Codec | Имя | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | правило → правило. Постепенно снижает вердикт с интенсивностью атаки |
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
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         оператор 1 WORD (старшие 2 бита) + UNSIGNED-DECIMAL Value (проценты)
[F_FORCE]        SIGNED-DECIMAL Value. Интенсивность атаки (0~1). Только ATTACKS
SPAN             ширина, заданная SOURCE × 2
```

| flag | Смысл |
|---|---|
| b0 F_ONCE | Выполняется только один раз (`once` у UNDO) |
| b1 F_GATE | Есть поле порога уверенности |
| b2 F_STRIKE | Отношение зачёркнуто |
| b3 F_ORDERED | Принадлежит нумерованному списку `1.` |
| b4 F_FORCE | Есть поле интенсивности атаки. Только ATTACKS |

| Оператор порога | Смысл |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- Условные поля идут в порядке флагов (F_GATE, F_FORCE). Поле с выключенным флагом места не занимает.

## Интенсивность атаки

Интенсивность атаки (Force) показывает, насколько сильно одно ребро ATTACKS атакует цель. Диапазон 0~1; без F_FORCE она равна 1.

- При вынесении вердикта вклад `(v+1)/2` значения вердикта v атакующего умножается на интенсивность F. Атака-опровержение (COUNTER) входит в член знаменателя как `F·(v+1)/2`, атака-исключение (EXCEPT) — в порог `Π(1 − F·(v+1)/2)`. При F = 0 атака не влияет на вердикт.
- Значение следует числовым правилам [TOULMIN](/ru/grammar/edge/toulmin/#числа). Кодировщик удаляет конечные нули коэффициента (0.5 — это `C=5, E=−1`, 1.0 — `C=1, E=0`). Декодер принимает до 4 знаков после запятой.
- Поверхность без указания интенсивности (`don't X when Y`, по-корейски `` `Y` 면 `X` 는 무효다``) выключает F_FORCE.
- Поверхность с указанием интенсивности (по-корейски `` `Y` 면 `X` 를 0.5의 세기로 공격한다``) включает F_FORCE и несёт значение. Даже если написано 1, как в `1.0의 세기로`, F_FORCE включается и несёт 1. Так исходная поверхность возвращается без изменений.
- Интенсивность атаки — ось, отличная от силы узла (Strict, Defeasible, Defeater). Сила принадлежит узлу, интенсивность атаки — ребру ATTACKS.

### Пример

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``. Edge Id 5, атакующий Y — Edge Id 3, цель X — Edge Id 2, ширина SPAN 1 WORD.

```
16E8                  TAG WORD: Edge, всего 14 WORD, Codec 0x68 (ATTACKS)
0088 0005             ID      LOCAL 5
0088 0003             src     LOCAL 3 (Y, атакующий)
0088 0002             dst     LOCAL 2 (X, цель)
0010                  flags   F_FORCE
0990 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    начальный байт 0x40, число байтов 0x1A
```

У того же ребра без интенсивности flags равны `0000`, а поля F_FORCE нет. Его TAG WORD — `14E8` (всего 10 WORD).

## Интерпретация и допустимость

- REF — это Edge Id записи этого документа (общие поля в [TOULMIN](/ru/grammar/edge/toulmin/#общие-поля)).
- Форму dst задаёт Codec. Для DO·DO-ONCE·UNDO это FuncRef (REF(ALIAS, 0 если нет) + VerbCode 1 WORD, [NODE](/ru/grammar/edge/toulmin/node/#поля)), для LABEL·IMPORTED-FROM — REF записи TEXT, в остальных случаях — REF узла.
- `do … once` выражается Codec DO-ONCE. В flags у DO-ONCE F_ONCE не используется (если он установлен, запись отклоняется). `once` у UNDO записывается через F_ONCE.
- Оператор порога — старшие 2 бита WORD оператора, остальные 14 бит равны 0. Проценты — это UNSIGNED-DECIMAL Value с `E=0`, значение 0~100.
- Биты b5~b15 в flags зарезервированы и должны быть равны 0. Иначе запись отклоняется.
- F_FORCE используется только в ATTACKS. Если он включён в другом Codec (SUPERSEDES, связи выполнения и вердикта, отношения формата ISSUER), запись отклоняется.
- Если интенсивность атаки не является Value SIGNED-DECIMAL, лежит вне 0~1 или не записывается точно с 4 знаками после запятой, запись отклоняется.
- Цепочка `A > B > C` у SUPERSEDES записывается по одной записи SUPERSEDES на пару.

## Связанные страницы

- [TOULMIN](/ru/grammar/edge/toulmin/), [NODE](/ru/grammar/edge/toulmin/node/), [SOURCE и разделы](/ru/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/ru/grammar/value/decimal/unsigned-decimal/), [SIGNED-DECIMAL](/ru/grammar/value/decimal/signed-decimal/)
