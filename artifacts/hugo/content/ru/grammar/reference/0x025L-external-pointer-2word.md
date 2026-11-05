---
title: "EXTERNAL-POINTER-2WORD (0x025L~0x029L)"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER — указывающий Reference, указывающий на LOCAL ID документа, подключённого через IMPORT-DOC в HEAD."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER — указывающий Reference, указывающий на LOCAL ID документа, подключённого через IMPORT-DOC в HEAD.

| Пункт | Значение |
|---|---|
| Имя | `EXTERNAL-POINTER-2WORD` (группа 5Q; имена по кодам — в таблице членов ниже) |
| TAG ID | `0x025L~0x029L` |
| Раздел | 1 `0001` (Reference EXTERNAL), смещение внутри раздела C = 5~9 |
| Kind | Reference · классификация: указание |
| Сторона Hugo | `reference/external-pointer.md` (эта страница охватывает также [EXTERNAL-POINTER-1WORD](0x020L-external-pointer-1word.md) и [EXTERNAL-POINTER-4WORD](0x02AL-external-pointer-4word.md)) |

## Члены {#구성원}

Эта страница охватывает один комплект системы 5Q — пять кодов. Квантификация определяется смещением внутри раздела `C % 5` ([Reference](_index.md#quantifier)). Документ кодека — по одному на код. Поля у пяти документов кодека одинаковы, различаются только цель DECLARE и имя (BIND).

| TAG ID | Имя | Квантификация | Codec ID | Документ спецификации | TAG WORD |
|---|---|---|---|---|---|
| `0x025L` | `EXTERNAL-POINTER-2WORD-IDENTIFIED` | Identified | `0x00000250` | `0x00000000/codecs/0x00000250/` | `0000 0010 0101 LLLL` |
| `0x026L` | `EXTERNAL-POINTER-2WORD-GENERIC` | Generic | `0x00000260` | `0x00000000/codecs/0x00000260/` | `0000 0010 0110 LLLL` |
| `0x027L` | `EXTERNAL-POINTER-2WORD-FREE-CHOICE` | Free-choice | `0x00000270` | `0x00000000/codecs/0x00000270/` | `0000 0010 0111 LLLL` |
| `0x028L` | `EXTERNAL-POINTER-2WORD-UNIVERSAL` | Universal | `0x00000280` | `0x00000000/codecs/0x00000280/` | `0000 0010 1000 LLLL` |
| `0x029L` | `EXTERNAL-POINTER-2WORD-VARIABLE` | Variable | `0x00000290` | `0x00000000/codecs/0x00000290/` | `0000 0010 1001 LLLL` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемая форма (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `import-id` | #2 | простое значение 2 WORD |  |  |
| 2 | `target-id` | #3 | остаток, простое значение (`0xFFFF`) |  |  |

EXTERNAL-POINTER — указывающий Reference, указывающий на LOCAL ID документа, подключённого через [IMPORT-DOC](../meta/0x1E4L-import-doc.md) в HEAD.

## Раскладка {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x020L~0x02EL (раздел 1)
[расширяющий TAG Length]
IMPORT ID         ширина, заданная Codec (1/2/4 WORD)
ID цели           всё остальное. LOCAL ID подключённого документа, наименьшей ширины
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Имя | Ширина IMPORT ID |
|---|---|---|
| `0x020L~0x024L` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `0x025L~0x029L` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `0x02AL~0x02EL` | EXTERNAL-POINTER-4WORD | 4 WORD |

- Ширина определяется номером системы: если система − 6 (то есть `C / 5` от смещения внутри раздела `C`) равна 0, 1, 2, то ширина 1, 2, 4 WORD. Квантификация — `C % 5`.

- Используют самый узкий Codec, в который помещается значение IMPORT ID.
- IMPORT ID — значение, назначенное `IMPORT-DOC` этого документа. В EXTERNAL-POINTER Issuer не записывают. Issuer и ID документа берут из этого `IMPORT-DOC`. Версию тоже определяет этот `IMPORT-DOC` (фиксированная или последняя).
- Один и тот же LOCAL ID подключённого документа — одна и та же цель, независимо от того, записан ли он как LOCAL внутри того документа или как EXTERNAL-POINTER здесь.
- Для Variable это LOCAL-переменная подключённого документа.

## Действительность {#유효성}

- Если в этом документе нет `IMPORT-DOC`, назначившего данный IMPORT ID, это invalid.
- Если IMPORT ID помещается в более узкий Codec, а использован более широкий, это отвергается как non-minimal.
- Если ID цели равен `0`, это invalid. На сам подключённый документ указывают через [DOC-POINTER](0x041L-doc-pointer.md).
- Ведущий WORD `0x0000` в ID цели запрещён.

## Пример {#예시}

| Цель | WORD sequence |
|---|---|
| LOCAL 5 для IMPORT ID 1 | `0202 0001 0005` |
| LOCAL 65536 для IMPORT ID 1 | `0203 0001 0001 0000` |
| LOCAL 5 для IMPORT ID 70000 | `0253 0001 1170 0005` |

## Связанные страницы {#관련-페이지}

- [Reference](_index.md), [LOCAL](0x005L-local.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [DOC-POINTER](0x041L-doc-pointer.md)
- [IMPORT-DOC](../meta/0x1E4L-import-doc.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000250/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000025000000000
BODY
#1 DECLARE 0x0250
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "EXTERNAL-POINTER-2WORD-IDENTIFIED"
#5 BIND #2 "import-id"
#6 BIND #3 "target-id"
```

Выше — документ кодека `EXTERNAL-POINTER-2WORD-IDENTIFIED` (`0x025L`). У остальных членов (`EXTERNAL-POINTER-2WORD-GENERIC`, `EXTERNAL-POINTER-2WORD-FREE-CHOICE`, `EXTERNAL-POINTER-2WORD-UNIVERSAL`, `EXTERNAL-POINTER-2WORD-VARIABLE`) в документе кодека различаются только Codec ID в DOC-ID, цель DECLARE и имя, привязанное в `#1` (BIND).
