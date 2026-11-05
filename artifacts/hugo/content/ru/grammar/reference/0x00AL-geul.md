---
title: "GEUL (0x00AL~0x00EL)"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL — объявляющий Reference, указывающий на сущности, которые geul.org выдаёт под CC0."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `GEUL` (группа 5Q; имена по кодам — в таблице членов ниже) |
| TAG ID | `0x00AL~0x00EL` |
| Раздел | 0 `0000` (сущность Reference), смещение внутри раздела C = 10~14 |
| Kind | Reference · классификация: объявление |
| Сторона Hugo | `reference/geul.md` |

## Члены {#구성원}

Эта страница охватывает один комплект системы 5Q — пять кодов. Квантификация определяется смещением внутри раздела `C % 5` ([Reference](_index.md#quantifier)). Документ кодека — по одному на код. Поля у пяти документов кодека одинаковы, различаются только цель DECLARE и имя (BIND).

| TAG ID | Имя | Квантификация | Codec ID | Документ спецификации | TAG WORD |
|---|---|---|---|---|---|
| `0x00AL` | `GEUL-IDENTIFIED` | Identified | `0x000000A0` | `0x00000000/codecs/0x000000A0/` | `0000 0000 1010 LLLL` |
| `0x00BL` | `GEUL-GENERIC` | Generic | `0x000000B0` | `0x00000000/codecs/0x000000B0/` | `0000 0000 1011 LLLL` |
| `0x00CL` | `GEUL-FREE-CHOICE` | Free-choice | `0x000000C0` | `0x00000000/codecs/0x000000C0/` | `0000 0000 1100 LLLL` |
| `0x00DL` | `GEUL-UNIVERSAL` | Universal | `0x000000D0` | `0x00000000/codecs/0x000000D0/` | `0000 0000 1101 LLLL` |
| `0x00EL` | `GEUL-VARIABLE` | Variable | `0x000000E0` | `0x00000000/codecs/0x000000E0/` | `0000 0000 1110 LLLL` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемая форма (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `geul-id` | #2 | остаток, простое значение (`0xFFFF`) |  |  |

GEUL — объявляющий Reference, указывающий на сущности, которые geul.org выдаёт под CC0. Это последовательный ID, номер которого не несёт смысла. Идентификатор, чьи биты несут смысл, обслуживает отдельный Codec [GEUL-SIDX](0x00FL-geul-sidx.md) (`0x00FL~0x013L`).

## Раскладка {#레이아웃}

```
TAG WORD          0000 0000 1010 LLLL      Codec 0x00AL~0x00EL (Identified 0x00AL)
[расширяющий TAG Length]
GEUL ID           unsigned big-endian наименьшей ширины
```

- Малые номера назначают часто встречающимся сущностям. ID, помещающийся в 1 WORD, занимает всего 2 WORD.
- Назначение ID и реестр ведёт geul.org. В реестр включают только то, что происходит из источников CC0.
- Для Variable это анонимная переменная данного вида ([Reference](_index.md) Variable).

## Пример {#예시}

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `00A1 0001` |
| 1, Variable | `00E1 0001` |
| 70000, Generic | `00B2 0001 1170` |

## Открытые проблемы {#열린-문제}

- Правило назначения GEUL ID и формат публикации реестра.

## Связанные страницы {#관련-페이지}

- [Reference](_index.md), [GEUL-SIDX](0x00FL-geul-sidx.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x000000A0/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000A000000000
BODY
#1 DECLARE 0x00A0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-IDENTIFIED"
#4 BIND #2 "geul-id"
```

Выше — документ кодека `GEUL-IDENTIFIED` (`0x00AL`). У остальных членов (`GEUL-GENERIC`, `GEUL-FREE-CHOICE`, `GEUL-UNIVERSAL`, `GEUL-VARIABLE`) в документе кодека различаются только Codec ID в DOC-ID, цель DECLARE и имя, привязанное в `#1` (BIND).
