---
title: "BOOL (0x060L)"
weight: 96
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL — Value, представляющий логические значения false и true."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Параметр | Значение |
|---|---|
| Имя | `BOOL` (документ спецификации BIND `BOOL`) |
| TAG ID | `0x060L` |
| Codec ID | `0x00000600` |
| Документ спецификации | `0x00000000/codecs/0x00000600/` (цель DECLARE `0600`) |
| Раздел | 3 `0011` (Value), смещение внутри раздела C = 0 |
| Kind | Value · семейство: NUMERIC |
| TAG WORD | `0000 0110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание индекса | false или true в фиксированном 1 WORD |
| На стороне Hugo | `value/numeric/bool.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD внутри документа — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | простое значение, 1 WORD |  | `0x0000` false, `0x0001` true |

BOOL — Value, представляющий логические значения false и true. Прямой код Value `0x060L`, семейство NUMERIC. Это тип, отличный от SIGNED-INTEGER и UNSIGNED-INTEGER, которые хранят числа 0 и 1.

## Раскладка {#레이아웃}

```
TAG WORD          0x0601 (0000 0110 0000 0001)  всего 2 WORD
Payload           1 WORD  Boolean Code
```

## Интерпретация и действительность {#해석과-유효성}

- Payload `0000` — false, `0001` — true.
- padding и descriptor нет.
- Payload — строго `0000` или `0001`. Любое другое 16-битное значение отвергается как invalid.
- Любое другое представление Length отвергается как invalid.

## Длина {#길이}

- Общая длина — ровно 2 WORD (TAG 1 WORD и Payload 1 WORD), используется прямая длина `LLLL=0001`. Length-расширяющего TAG, descriptor и padding нет.
- Если Payload не равен ровно 1 WORD, запись отвергается.

## Пример {#예시}

| Вся запись (TAG + Payload) | Payload | Вердикт |
|---|---|---|
| `0601 0000` | `0000` | false, канонично |
| `0601 0001` | `0001` | true, канонично |
| `0601 0002` | `0002` | invalid |
| `0601 FFFF` | `FFFF` | invalid |
| TAG с Length не `0001` + `0000` или `0001` | `0000` или `0001` | invalid |

## Статус формата {#형식-지위}

- Это представление, объединяющее 16-битное code word `0000`/`0001` с TAG GEUL, — собственный scalar profile GEUL.
- Само логическое значение универсально, но единого отраслевого стандарта, соответствующего этому представлению в 1 WORD, мы не заявляем.

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00000600/latest.geul`, прочитанный командой `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000060000000000
BODY
#1 DECLARE 0x0600
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 BIND #1 "BOOL"
#6 BIND #2 "code"
#7 BIND #3 "false"
#8 BIND #4 "true"
```
