---
title: "DESCRIPTION (0x0A6L)"
weight: 166
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION — Edge-высказывание, связывающий с Subject через Object одно описание объекта на конкретном языке."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `DESCRIPTION` (BIND документа спецификации `DESCRIPTION`) |
| TAG ID | `0x0A6L` |
| Codec ID | `0x00000A60` |
| Документ спецификации | `0x00000000/codecs/0x00000A60/` (цель DECLARE `0A60`) |
| Раздел | 5 `0101` (Edge-высказывание), смещение C внутри раздела = 6 |
| Kind | Edge · семейство: высказывание, группа: указание и имя |
| TAG WORD | `0000 1010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Связывает Subject с описанием (description) на конкретном языке. Раскладка та же, что у LABEL |
| Сторона Hugo | `edge/description.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)). Edge Id у Edge не объявляется через FIELD.

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | запись | любая запись (кроме маркера места) |  |
| 2 | `object` | #3 | запись | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

DESCRIPTION — Edge-высказывание, связывающий с Subject через Object одно описание объекта на конкретном языке. Codec `0x0A6L`.

Описание — короткая фраза, отличающая объект от других (description в Wikidata, например «столица и крупнейший город Германии»). Это не определение объекта и не утверждение. Предложение об объекте записывается как [TRIPLE](0x0AAL-triple.md). Раскладка та же, что у [LABEL](0x0A4L-label.md). Описание и его язык хранятся в одном Object — [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). Поля простого значения нет.

## Раскладка {#레이아웃}

```
TAG WORD          0000 1010 0110 LLLL
[Length, расширяющий TAG]
Edge Id           запись LOCAL Reference
Subject           1 запись Reference
Object            1 Value UTF8-LANGUAGE-TEXT или запись LOCAL Reference
```

## Интерпретация и действительность {#해석과-유효성}

- Правила для Subject и Object те же, что у [LABEL](0x0A4L-label.md). Subject — ровно одна полная запись Reference. Object — либо ровно одна полная запись UTF8-LANGUAGE-TEXT (`0x078L`·`0x079L`), либо LOCAL Reference, разрешающаяся в UTF8-LANGUAGE-TEXT привязкой [REFERENCE-NODE](0x0A0L-reference-node.md) в том же документе.
- Текст без языка (UTF8-TEXT) DESCRIPTION быть не может. Описание одно на язык, поэтому это правило действует только при наличии языка. Описание, общее для нескольких языков, записывается с языком `mul`.
- DESCRIPTION с одним Subject и языком — не более одного.
- Описание служит для отличия от другого объекта с тем же именем. Желательно, чтобы пара LABEL и DESCRIPTION на одном языке не совпадала у двух объектов, но спецификация этого не проверяет (Wikidata тоже лишь рекомендует, но не принуждает).
- Документы спецификации geul.org ограничивают Object через [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, как у LABEL).

## Длина {#길이}

```
всего = 1 + N_len + N_id + N_subject + N_object WORD
```

- Запись языка и число байтов текста в Object ведёт запись Object. Курсор после чтения последней записи должен точно совпасть с концом Edge.
- Описание длиннее метки, поэтому и Object, и Edge легко превышают 15 WORD. Тогда используется расширение Length ([запись](../record.md)).

## Пример (не нормативно) {#예시-비규범}

Edge Id `0009`, Subject Q64 (`0141 0040`), Object `capital and largest city of Germany` (en). Язык — пример формата LANGUAGE-BCP47-CODE (для `en` есть номер реестра `0x0784`, поэтому можно использовать и SHORT-CODE).

- Object: язык `0761 656E` (BCP47 `en`, 2 WORD) + 35 байт текста (нечётное число, 18 WORD), поэтому `0x079L`, TAG 1 + расширяющий TAG 1 + 20 = 22 WORD, `079E 0016 …`.
- Edge — TAG 1 + расширяющий TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD, поэтому `LLLL=1110`, TAG `0A6E`, расширяющий TAG `001C`.

```
0A6E 001C 0051 0009 0141 0040
079E 0016 0761 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Соответствие Wikidata {#위키데이터-대응}

- `descriptions` элемента (по одному на язык) → по одному DESCRIPTION на язык. Код языка переносится по той же таблице соответствия кодов языков, что и для LABEL.

## Открытые проблемы {#열린-문제}

- Есть ли случаи, в которых стоит допустить описание в виде UTF8-TEXT без языка (сейчас не допускается).

## Связанные страницы {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [CODEC](0x0BEL-codec.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000A60/latest.geul`, прочитанный через `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A6000000000
BODY
#1 DECLARE 0x0A60
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DESCRIPTION"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
