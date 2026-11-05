---
title: "REFERENCE-NODE (0x0A0L)"
weight: 160
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE — направленный Edge-высказывание, который связывает одну Reference с одной записью Object, определяя или привязывая то, чем является эта Reference."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `REFERENCE-NODE` (BIND документа спецификации `REFERENCE-NODE`) |
| TAG ID | `0x0A0L` |
| Codec ID | `0x00000A00` |
| Документ спецификации | `0x00000000/codecs/0x00000A00/` (цель DECLARE `0A00`) |
| Раздел | 5 `0101` (Edge-высказывание), смещение C внутри раздела = 0 |
| Kind | Edge · семейство: высказывание, группа: указание и имя |
| TAG WORD | `0000 1010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Направленная привязка: Subject (Reference) указывает на Object |
| Сторона Hugo | `edge/reference-node.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)). Edge Id у Edge не объявляется через FIELD.

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | запись | любая запись (кроме маркера места) |  |
| 2 | `object` | #3 | запись | `000F` весь раздел 0 (шаблон, Reference), `020F` весь раздел 1 (шаблон, Reference), `040F` весь раздел 2 (шаблон, Reference), `060F` весь раздел 3 (шаблон, Value), `080F` весь раздел 4 (шаблон, Value) |  |

REFERENCE-NODE — направленный Edge-высказывание, который связывает одну Reference с одной записью Object, определяя или привязывая то, чем является эта Reference. Codec `0x0A0L`.

Subject указывает на Object. Эта привязка не является [SAME-NODE](0x0A1L-same-node.md), утверждающим смысловое тождество, и не означает, что байты двух записей совпадают.

## Раскладка {#레이아웃}

```
TAG WORD          0000 1010 0000 LLLL
[Length, расширяющий TAG]
Edge Id           запись LOCAL Reference
Subject           1 запись Reference
Object            1 запись Reference или Value
```

## Интерпретация и действительность {#해석과-유효성}

- Subject должен быть ровно одной полной записью [Reference](../reference/_index.md). Граница находится по Length самого Subject; если это не Reference или запись неполна, она invalid.
- Object должен быть ровно одной полной записью Reference или Value. Граница находится по Length самого Object; если это Edge или Meta либо запись неполна, она invalid.
- Если Object — Reference, цепочка Reference, по которой идут привязками REFERENCE-NODE, не должна быть циклической, а LOCAL должен в итоге разрешиться. Цикл разрешения и висячий LOCAL — invalid.
- Если в одном документе один LOCAL ID привязан к взаимно противоречащим Object, это invalid. Область LOCAL, ID, минимальная ширина и правила слияния — по [LOCAL](../reference/0x005L-local.md).
- Не каждая Reference обязана быть привязана через REFERENCE-NODE.
- Типичное применение — `LOCAL → UTF8-LANGUAGE-TEXT`. Если в Object у [LABEL](0x0A4L-label.md) стоит LOCAL, текст разрешается этой привязкой в том же документе.

Направление, в котором Subject указывает на Object, нельзя трактовать наоборот. Смысл и подробные правила SAME и DIFFERENT задаёт каждый из этих форматов отдельно.

## Длина {#길이}

```
всего = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` — число WORD расширяющего TAG Length, `N_id` — число WORD записи Edge Id LOCAL, `N_subject` и `N_object` — полное число WORD каждой записи. Курсор после чтения Subject и Object должен точно совпасть с концом Edge.

## Пример (не нормативно) {#예시-비규범}

Edge Id `0008`, Subject — LOCAL 1, Object — [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) для `Donald Trump` (en).

- Edge Id — `0051 0008`, 2 WORD.
- Subject — `0051 0001`, 2 WORD.
- Object: язык `0761 656E` (BCP47 `en`) + 12 байт текста (чётное число), поэтому `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), всего 9 WORD. TAG — `0788`.
- Edge — TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. TAG — `0A0D`.

```
0A0D 0051 0008 0051 0001 0788 0761 656E 446F 6E61 6C64 2054 7275 6D70
```

## Связанные страницы {#관련-페이지}

- [Edge](_index.md), [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [LABEL](0x0A4L-label.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000A00/latest.geul`, прочитанный через `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A0000000000
BODY
#1 DECLARE 0x0A00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "REFERENCE-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x000F
#9 CODEC #3 0x020F
#10 CODEC #3 0x040F
#8 CODEC #3 0x060F
#11 CODEC #3 0x080F
```
