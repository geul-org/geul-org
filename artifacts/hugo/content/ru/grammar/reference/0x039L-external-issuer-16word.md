---
title: "EXTERNAL-ISSUER-16WORD (0x039L~0x03DL)"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER — указывающе-объявляющий Reference, цитирующий LOCAL ID документа, опубликованного Issuer, одной записью без IMPORT."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER — указывающе-объявляющий Reference, цитирующий LOCAL ID документа, опубликованного Issuer, одной записью без IMPORT.

| Пункт | Значение |
|---|---|
| Имя | `EXTERNAL-ISSUER-16WORD` (группа 5Q; имена по кодам — в таблице членов ниже) |
| TAG ID | `0x039L~0x03DL` |
| Раздел | 1 `0001` (Reference EXTERNAL), смещение внутри раздела C = 25~29 |
| Kind | Reference · классификация: указание-объявление |
| Сторона Hugo | `reference/external-issuer.md` (эта страница охватывает также [EXTERNAL-ISSUER-2WORD](0x02FL-external-issuer-2word.md) и [EXTERNAL-ISSUER-4WORD](0x034L-external-issuer-4word.md)) |

## Члены {#구성원}

Эта страница охватывает один комплект системы 5Q — пять кодов. Квантификация определяется смещением внутри раздела `C % 5` ([Reference](_index.md#quantifier)). Документ кодека — по одному на код. Поля у пяти документов кодека одинаковы, различаются только цель DECLARE и имя (BIND).

| TAG ID | Имя | Квантификация | Codec ID | Документ спецификации | TAG WORD |
|---|---|---|---|---|---|
| `0x039L` | `EXTERNAL-ISSUER-16WORD-IDENTIFIED` | Identified | `0x00000390` | `0x00000000/codecs/0x00000390/` | `0000 0011 1001 LLLL` |
| `0x03AL` | `EXTERNAL-ISSUER-16WORD-GENERIC` | Generic | `0x000003A0` | `0x00000000/codecs/0x000003A0/` | `0000 0011 1010 LLLL` |
| `0x03BL` | `EXTERNAL-ISSUER-16WORD-FREE-CHOICE` | Free-choice | `0x000003B0` | `0x00000000/codecs/0x000003B0/` | `0000 0011 1011 LLLL` |
| `0x03CL` | `EXTERNAL-ISSUER-16WORD-UNIVERSAL` | Universal | `0x000003C0` | `0x00000000/codecs/0x000003C0/` | `0000 0011 1100 LLLL` |
| `0x03DL` | `EXTERNAL-ISSUER-16WORD-VARIABLE` | Variable | `0x000003D0` | `0x00000000/codecs/0x000003D0/` | `0000 0011 1101 LLLL` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемая форма (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | простое значение 16 WORD |  |  |
| 2 | `doc` | #3 | простое значение 4 WORD |  |  |
| 3 | `target-id` | #4 | остаток, простое значение (`0xFFFF`) |  |  |

EXTERNAL-ISSUER — указывающе-объявляющий Reference, цитирующий LOCAL ID документа, опубликованного Issuer, без IMPORT. Смысл завершён одной записью, и он следует последней версии.

## Раскладка {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x02FL~0x03DL (раздел 1)
[расширяющий TAG Length]
Issuer            ширина, заданная Codec (2/4/16 WORD)
ID документа      4 WORD
ID цели           всё остальное. LOCAL ID этого документа, наименьшей ширины
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Имя | Ширина Issuer |
|---|---|---|
| `0x02FL~0x033L` | EXTERNAL-ISSUER-2WORD | 2 WORD (регистрация в geul.org, подтверждение домена) |
| `0x034L~0x038L` | EXTERNAL-ISSUER-4WORD | 4 WORD (регистрация в geul.org, без подтверждения) |
| `0x039L~0x03DL` | EXTERNAL-ISSUER-16WORD | 16 WORD (вычисляется из открытого ключа) |

- Ширина определяется номером системы: если система − 9 (то есть `C / 5 − 3` от смещения внутри раздела `C`) равна 0, 1, 2, то ширина 2, 4, 16 WORD. Квантификация — `C % 5`.
- Issuer ID — целое значение. Равные значения — один и тот же Issuer. Issuer записывают наименьшей шириной, в которую помещается значение, и выбирают Codec этой ширины (4 WORD — только при `2^32` и выше, 16 WORD — только при `2^64` и выше). Запись более широкой формой — invalid ([Issuer](../issuer.md)).
- Регистрацию и управление Issuer ведёт geul.org.
- Версию не записывают, следуют последней версии. Чтобы зафиксировать версию, используют [IMPORT-DOC](../meta/0x1E4L-import-doc.md) и [EXTERNAL-POINTER](0x020L-external-pointer-1word.md).
- Местоположение находят по правилу адресов публикации ([адреса публикации и список версий](../publishing.md)).
- Один и тот же LOCAL ID этого документа — одна и та же цель, независимо от того, записан ли он как LOCAL внутри документа, как EXTERNAL-ISSUER в другом документе (или как EXTERNAL-POINTER после IMPORT).
- Указывает только на LOCAL документа. На сам документ указывают через [DOC-POINTER](0x041L-doc-pointer.md), на сам Issuer — через [ISSUER-POINTER](0x040L-issuer-pointer.md). Поэтому ID цели не равен `0`. Документ с ID `0` — индексный документ определений терминов Issuer.

## Действительность {#유효성}

- Если ширина Issuer не соответствует Codec или значение помещается в более узкую ширину, это invalid.
- Если ID цели равен `0`, это invalid. ID цели `0` (сам документ) обслуживает DOC-POINTER.
- Ведущий WORD `0x0000` в ID цели запрещён.

## Пример {#예시}

| Цель | WORD sequence |
|---|---|
| Issuer `0x00000002`, документ `0x…0002`, LOCAL 7 | `02F7 0000 0002 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, документ `0x…0002`, LOCAL 7 | `02F7 0001 2345 0000 0000 0000 0002 0007` |

## Связанные страницы {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Issuer и публикация](../issuer.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000390/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000039000000000
BODY
#1 DECLARE 0x0390
#2 FIELD #1 0x0010
#3 FIELD #1 0x0004
#4 FIELD #1 rest
#5 BIND #1 "EXTERNAL-ISSUER-16WORD-IDENTIFIED"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "target-id"
```

Выше — документ кодека `EXTERNAL-ISSUER-16WORD-IDENTIFIED` (`0x039L`). У остальных членов (`EXTERNAL-ISSUER-16WORD-GENERIC`, `EXTERNAL-ISSUER-16WORD-FREE-CHOICE`, `EXTERNAL-ISSUER-16WORD-UNIVERSAL`, `EXTERNAL-ISSUER-16WORD-VARIABLE`) в документе кодека различаются только Codec ID в DOC-ID, цель DECLARE и имя, привязанное в `#1` (BIND).
