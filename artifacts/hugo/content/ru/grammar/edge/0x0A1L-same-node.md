---
title: "SAME-NODE (0x0A1L)"
weight: 161
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE — ненаправленный Edge-высказывание о тождестве, объявляющий, что две Reference указывают на один и тот же референт."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `SAME-NODE` (BIND документа спецификации `SAME-NODE`) |
| TAG ID | `0x0A1L` |
| Codec ID | `0x00000A10` |
| Документ спецификации | `0x00000000/codecs/0x00000A10/` (цель DECLARE `0A10`) |
| Раздел | 5 `0101` (Edge-высказывание), смещение C внутри раздела = 1 |
| Kind | Edge · семейство: высказывание, группа: указание и имя |
| TAG WORD | `0000 1010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Тождество: две Reference указывают на один и тот же объект |
| Сторона Hugo | `edge/same-node.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)). Edge Id у Edge не объявляется через FIELD.

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | запись | любая запись (кроме маркера места) |  |
| 2 | `object` | #3 | запись | любая запись (кроме маркера места) |  |

SAME-NODE — ненаправленный Edge-высказывание о тождестве, объявляющий, что две Reference указывают на один и тот же референт. Codec `0x0A1L`.

Это не означает, что байтовое кодирование, Codec и ID двух записей Reference совпадают. В отличие от [REFERENCE-NODE](0x0A0L-reference-node.md) — направленной привязки `Reference → запись`, SAME-NODE выражает тождество (referential identity) двух Reference.

## Раскладка {#레이아웃}

```
TAG WORD          0000 1010 0001 LLLL
[Length, расширяющий TAG]
Edge Id           запись LOCAL Reference
Subject           1 запись Reference
Object            1 запись Reference
```

## Интерпретация и действительность {#해석과-유효성}

- Subject и Object сериализуются в этом порядке, и каждый должен быть ровно одной полной записью [Reference](../reference/_index.md). Граница находится по Length каждой записи.
- Если Subject или Object — Value, Edge или неполная запись, это invalid.
- Отношение SAME-NODE рефлексивно, симметрично и транзитивно. Порядок Subject/Object в wire служит для framing и не создаёт смыслового направления. Реализация должна уметь обходить это отношение в обе стороны.
- Разные ID [LOCAL](../reference/0x005L-local.md) — это лишь разные Reference, а не свидетельство того, что референты совпадают или различаются. Что две Reference указывают на один референт, выясняется через SAME-NODE.
- Интерпретация и вывод должны сохранять происхождение, момент времени, world и policy scope документа, содержащего этот Edge, и графа вердиктов. SAME-NODE не используется как основание для глобального слияния вне контекста.
- Даже при наличии SAME-NODE исходные записи Reference и родословная не стираются и не перезаписываются.
- Если для одной пары одновременно есть SAME-NODE и [DIFFERENT-NODE](0x0A2L-different-node.md), wire не становится invalid. Контекст каждого утверждения сохраняется, и они оцениваются как конфликт.
- Переменная разрешается связыванием Variable Reference с Identified Reference через SAME-NODE (Variable в [Reference](../reference/_index.md)).

## Длина {#길이}

```
всего = 1 + N_len + N_id + N_subject + N_object WORD
```

## Пример (не нормативно) {#예시-비규범}

Edge Id `0009`, Subject — LOCAL 1, Object — LOCAL 2.

- Edge — TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. TAG — `0000 1010 0001 0110` = `0A16`.

```
0A16 0051 0009 0051 0001 0051 0002
```

## Связанные страницы {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000A10/latest.geul`, прочитанный через `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A1000000000
BODY
#1 DECLARE 0x0A10
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SAME-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
