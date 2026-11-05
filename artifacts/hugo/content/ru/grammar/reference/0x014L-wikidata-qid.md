---
title: "WIKIDATA-QID (0x014L~0x018L)"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID — объявляющий Reference, указывающий на элемент (Item) Викиданных."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `WIKIDATA-QID` (группа 5Q; имена по кодам — в таблице членов ниже) |
| TAG ID | `0x014L~0x018L` |
| Раздел | 0 `0000` (сущность Reference), смещение внутри раздела C = 20~24 |
| Kind | Reference · классификация: объявление |
| Сторона Hugo | `reference/wikidata-qid.md` |

## Члены {#구성원}

Эта страница охватывает один комплект системы 5Q — пять кодов. Квантификация определяется смещением внутри раздела `C % 5` ([Reference](_index.md#quantifier)). Документ кодека — по одному на код. Поля у пяти документов кодека одинаковы, различаются только цель DECLARE и имя (BIND).

| TAG ID | Имя | Квантификация | Codec ID | Документ спецификации | TAG WORD |
|---|---|---|---|---|---|
| `0x014L` | `WIKIDATA-QID-IDENTIFIED` | Identified | `0x00000140` | `0x00000000/codecs/0x00000140/` | `0000 0001 0100 LLLL` |
| `0x015L` | `WIKIDATA-QID-GENERIC` | Generic | `0x00000150` | `0x00000000/codecs/0x00000150/` | `0000 0001 0101 LLLL` |
| `0x016L` | `WIKIDATA-QID-FREE-CHOICE` | Free-choice | `0x00000160` | `0x00000000/codecs/0x00000160/` | `0000 0001 0110 LLLL` |
| `0x017L` | `WIKIDATA-QID-UNIVERSAL` | Universal | `0x00000170` | `0x00000000/codecs/0x00000170/` | `0000 0001 0111 LLLL` |
| `0x018L` | `WIKIDATA-QID-VARIABLE` | Variable | `0x00000180` | `0x00000000/codecs/0x00000180/` | `0000 0001 1000 LLLL` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемая форма (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `qid` | #2 | остаток, простое значение (`0xFFFF`) |  |  |

WIKIDATA-QID — объявляющий Reference, указывающий на элемент (Item) Викиданных. Числовую часть Q-идентификатора без `Q` записывают как целое число без знака.

## Раскладка {#레이아웃}

```
TAG WORD          0000 0001 0100 LLLL      Codec 0x014L~0x018L (Identified 0x014L)
[расширяющий TAG Length]
QID               unsigned big-endian наименьшей ширины
```

- QID записывают наименьшей шириной. `Q1`–`Q65535` занимают всего 2 WORD, выше — 3 WORD.
- Данные Викиданных — CC0.
- Для Variable это анонимная переменная того вида, на который указывает этот элемент ([Reference](_index.md) Variable).

## Пример {#예시}

| Элемент | WORD sequence |
|---|---|
| `Q5` (human) | `0141 0005` |
| `Q76` (Barack Obama) | `0141 004C` |
| `Q884` (South Korea) | `0141 0374` |
| `Q317521` (Elon Musk) | `0142 0004 D851` |
| `Q30461` (president), Variable | `0181 76FD` |

## Связанные страницы {#관련-페이지}

- [Reference](_index.md), [WIKIDATA-PID](0x019L-wikidata-pid.md), [TRIPLE](../edge/0x0AAL-triple.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000140/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000014000000000
BODY
#1 DECLARE 0x0140
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-QID-IDENTIFIED"
#4 BIND #2 "qid"
```

Выше — документ кодека `WIKIDATA-QID-IDENTIFIED` (`0x014L`). У остальных членов (`WIKIDATA-QID-GENERIC`, `WIKIDATA-QID-FREE-CHOICE`, `WIKIDATA-QID-UNIVERSAL`, `WIKIDATA-QID-VARIABLE`) в документе кодека различаются только Codec ID в DOC-ID, цель DECLARE и имя, привязанное в `#1` (BIND).
