---
title: "WIKIDATA-PID (0x019L~0x01DL)"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID — объявляющий Reference, указывающий на свойство (Property) Викиданных."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `WIKIDATA-PID` (группа 5Q; имена по кодам — в таблице членов ниже) |
| TAG ID | `0x019L~0x01DL` |
| Раздел | 0 `0000` (сущность Reference), смещение внутри раздела C = 25~29 |
| Kind | Reference · классификация: объявление |
| Сторона Hugo | `reference/wikidata-pid.md` |

## Члены {#구성원}

Эта страница охватывает один комплект системы 5Q — пять кодов. Квантификация определяется смещением внутри раздела `C % 5` ([Reference](_index.md#quantifier)). Документ кодека — по одному на код. Поля у пяти документов кодека одинаковы, различаются только цель DECLARE и имя (BIND).

| TAG ID | Имя | Квантификация | Codec ID | Документ спецификации | TAG WORD |
|---|---|---|---|---|---|
| `0x019L` | `WIKIDATA-PID-IDENTIFIED` | Identified | `0x00000190` | `0x00000000/codecs/0x00000190/` | `0000 0001 1001 LLLL` |
| `0x01AL` | `WIKIDATA-PID-GENERIC` | Generic | `0x000001A0` | `0x00000000/codecs/0x000001A0/` | `0000 0001 1010 LLLL` |
| `0x01BL` | `WIKIDATA-PID-FREE-CHOICE` | Free-choice | `0x000001B0` | `0x00000000/codecs/0x000001B0/` | `0000 0001 1011 LLLL` |
| `0x01CL` | `WIKIDATA-PID-UNIVERSAL` | Universal | `0x000001C0` | `0x00000000/codecs/0x000001C0/` | `0000 0001 1100 LLLL` |
| `0x01DL` | `WIKIDATA-PID-VARIABLE` | Variable | `0x000001D0` | `0x00000000/codecs/0x000001D0/` | `0000 0001 1101 LLLL` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемая форма (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `pid` | #2 | остаток, простое значение (`0xFFFF`) |  |  |

WIKIDATA-PID — объявляющий Reference, указывающий на свойство (Property) Викиданных. Числовую часть P-идентификатора без `P` записывают как целое число без знака.

## Раскладка {#레이아웃}

```
TAG WORD          0000 0001 1001 LLLL      Codec 0x019L~0x01DL (Identified 0x019L)
[расширяющий TAG Length]
PID               unsigned big-endian наименьшей ширины
```

- PID записывают наименьшей шириной. Нынешние номера свойств помещаются в 1 WORD, то есть занимают всего 2 WORD; при превышении 65535 запись естественно вырастает до 3 WORD.
- Используется главным образом на месте Predicate в [TRIPLE](../edge/0x0AAL-triple.md) и Property в [QUALIFIER](../edge/0x0ABL-qualifier.md).

## Пример {#예시}

| Свойство | WORD sequence |
|---|---|
| `P31` (instance of) | `0191 001F` |
| `P279` (subclass of) | `0191 0117` |
| `P569` (date of birth) | `0191 0239` |

## Связанные страницы {#관련-페이지}

- [Reference](_index.md), [WIKIDATA-QID](0x014L-wikidata-qid.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000190/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000019000000000
BODY
#1 DECLARE 0x0190
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-PID-IDENTIFIED"
#4 BIND #2 "pid"
```

Выше — документ кодека `WIKIDATA-PID-IDENTIFIED` (`0x019L`). У остальных членов (`WIKIDATA-PID-GENERIC`, `WIKIDATA-PID-FREE-CHOICE`, `WIKIDATA-PID-UNIVERSAL`, `WIKIDATA-PID-VARIABLE`) в документе кодека различаются только Codec ID в DOC-ID, цель DECLARE и имя, привязанное в `#1` (BIND).
