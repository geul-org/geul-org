---
title: "ALIAS (0x0A5L)"
weight: 165
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS — Edge-высказывание, связывающий с Subject через Object одно другое имя (псевдоним) объекта."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `ALIAS` (BIND документа спецификации `ALIAS`) |
| TAG ID | `0x0A5L` |
| Codec ID | `0x00000A50` |
| Документ спецификации | `0x00000000/codecs/0x00000A50/` (цель DECLARE `0A50`) |
| Раздел | 5 `0101` (Edge-высказывание), смещение C внутри раздела = 5 |
| Kind | Edge · семейство: высказывание, группа: указание и имя |
| TAG WORD | `0000 1010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Связывает Subject с другим именем (псевдонимом). Раскладка та же, что у LABEL |
| Сторона Hugo | `edge/alias.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)). Edge Id у Edge не объявляется через FIELD.

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | запись | любая запись (кроме маркера места) |  |
| 2 | `object` | #3 | запись | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

ALIAS — Edge-высказывание, связывающий с Subject через Object одно другое имя (псевдоним) объекта. Codec `0x0A5L`.

[LABEL](0x0A4L-label.md) — основное имя на данном языке (не более одного на язык), а ALIAS — другое имя того же объекта (несколько на язык, «also known as» в Wikidata). Используется в основном для поиска. Раскладка и действительность те же, что у LABEL.

## Раскладка {#레이아웃}

```
TAG WORD          0000 1010 0101 LLLL
[Length, расширяющий TAG]
Edge Id           запись LOCAL Reference
Subject           1 запись Reference
Object            1 Value UTF8-LANGUAGE-TEXT или запись LOCAL Reference
```

## Интерпретация и действительность {#해석과-유효성}

- Правила для Subject и Object те же, что у [LABEL](0x0A4L-label.md) (Object — [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) или LOCAL, разрешающийся в него).
- Для одного Subject и языка можно задать несколько ALIAS. Порядок — порядок в документе.
- Тот же текст, что у LABEL с тем же Subject и языком, как ALIAS не задают (для основного имени достаточно одного LABEL). Это правило — рекомендация.
- Документы спецификации geul.org ограничивают Object через [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, как у LABEL).

## Пример (не нормативно) {#예시-비규범}

Edge Id `0003`, Subject Q42 (`0141 002A`), Object `DNA` (en): язык `0761 656E` (BCP47 `en`) + 3 байта текста (нечётное число) → `UTF8-LANGUAGE-TEXT-ODD` (`0x079L`), `0794 0761 656E 444E 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, `LLLL=1001`. TAG — `0A59`.

```
0A59 0051 0003 0141 002A 0794 0761 656E 444E 4100
```

## Связанные страницы {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [DESCRIPTION](0x0A6L-description.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000A50/latest.geul`, прочитанный через `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A5000000000
BODY
#1 DECLARE 0x0A50
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "ALIAS"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
