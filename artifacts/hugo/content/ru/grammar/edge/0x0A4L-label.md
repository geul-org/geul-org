---
title: "LABEL (0x0A4L)"
weight: 164
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL — Edge-высказывание, связывающий с Subject через Object одно имя (label) объекта на конкретном языке."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `LABEL` (BIND документа спецификации `LABEL`) |
| TAG ID | `0x0A4L` |
| Codec ID | `0x00000A40` |
| Документ спецификации | `0x00000000/codecs/0x00000A40/` (цель DECLARE `0A40`) |
| Раздел | 5 `0101` (Edge-высказывание), смещение C внутри раздела = 4 |
| Kind | Edge · семейство: высказывание, группа: указание и имя |
| TAG WORD | `0000 1010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Связывает Subject с именем (label) на конкретном языке. Object — UTF8-LANGUAGE-TEXT |
| Сторона Hugo | `edge/label.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)). Edge Id у Edge не объявляется через FIELD.

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | запись | любая запись (кроме маркера места) |  |
| 2 | `object` | #3 | запись | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

LABEL — Edge-высказывание, связывающий с Subject через Object одно имя (label) объекта на конкретном языке. Codec `0x0A4L`. Это не Edge, выражающий лемму (lemma) общей лексикографии.

Имя и его язык хранятся в одном Object — [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). Поля простого значения нет.

## Раскладка {#레이아웃}

```
TAG WORD          0000 1010 0100 LLLL
[Length, расширяющий TAG]
Edge Id           запись LOCAL Reference
Subject           1 запись Reference
Object            1 Value UTF8-LANGUAGE-TEXT или запись LOCAL Reference
```

## Интерпретация и действительность {#해석과-유효성}

- Subject — ровно одна полная запись Reference. Граница находится по Length самого Subject; если это не Reference или запись неполна, она invalid.
- Object — ровно одна полная запись [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) (`0x078L`·`0x079L`). Правила языка и текста (допускаются оба языковых формата, сравнение одного языка) — по этому формату.
- В Object может стоять и LOCAL Reference. Тогда она должна разрешаться в UTF8-LANGUAGE-TEXT привязкой [REFERENCE-NODE](0x0A0L-reference-node.md) в том же документе. Если она не разрешается или разрешается в объект другого рода, это invalid.
- В документах спецификации geul.org это ограничение записывается через [CODEC](0x0BEL-codec.md) (Object = `0780`·`0790`·`0050`). Цель разрешения LOCAL через CODEC не выражается.
- Если Object не один из двух указанных форматов или запись неполна, это invalid. Текст без языка (UTF8-TEXT) LABEL быть не может. Машинное имя без языка записывается как [BIND](0x0A3L-bind.md). Имя, общее для нескольких языков, записывается с языком `mul`.
- LABEL с одним Subject и языком — не более одного. Другие имена записываются как [ALIAS](0x0A5L-alias.md).

## Длина {#길이}

```
всего = 1 + N_len + N_id + N_subject + N_object WORD
```

- Запись языка и число байтов текста в Object ведёт не Edge, а запись Object. Курсор после чтения последней записи должен точно совпасть с концом Edge.

## Пример (не нормативно) {#예시-비규범}

Код языка `0784` для `en` — номер в GEUL Language Registry v2 (документ спецификации `0x00000000/codecs/0x000007A0`, версия 2).

### LANGUAGE-SHORT-CODE {#language-short-code}

Edge Id `0007`, Subject Q22686 (`0141 589E`), Object `Donald Trump` (en).

- Object: язык `07A1 0784` (SHORT-CODE, 2 WORD) + 12 байт текста (чётное число, 6 WORD), поэтому `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), всего 9 WORD: `0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70`.
- Edge — TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. TAG — `0A4D`.

```
0A4D 0051 0007 0141 589E 0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70
```

### LANGUAGE-BCP47-CODE {#language-bcp47-code}

Edge Id `0008`, Subject Q155 (`0141 009B`), Object `Brasil` (pt-BR).

- Object: язык `0773 7074 2D42 5200` (BCP47 `pt-BR`, 4 WORD) + 6 байт текста (чётное число, 3 WORD), всего 8 WORD: `0787 0773 7074 2D42 5200 4272 6173 696C`.
- Edge — TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, `LLLL=1100`. TAG — `0A4C`.

```
0A4C 0051 0008 0141 009B 0787 0773 7074 2D42 5200 4272 6173 696C
```

## Связанные страницы {#관련-페이지}

- [Edge](_index.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md), [BIND](0x0A3L-bind.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md)
- [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000A40/latest.geul`, прочитанный через `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A4000000000
BODY
#1 DECLARE 0x0A40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "LABEL"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
