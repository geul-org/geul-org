---
title: "BODY (0x1C3L)"
weight: 451
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Запись, которая завершает HEAD и начинает BODY."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `BODY` (BIND документа спецификации `BODY`) |
| TAG ID | `0x1C3L` |
| Codec ID | `0x00001C30` |
| Документ спецификации | `0x00000000/codecs/0x00001C30/` (цель DECLARE `1C30`) |
| Раздел | 14 `1110` (Meta), смещение в разделе C = 3 |
| Kind | Meta · класс: структура |
| TAG WORD | `0001 1100 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | 1 WORD. Завершает HEAD документа и начинает BODY. |
| Сторона Hugo | `meta/structure/body.md` |

## Поля (документ спецификации) {#필드-규격-문서}

В документе спецификации нет FIELD. Поля Payload не объявляются.

Запись, которая завершает HEAD и начинает BODY.

## Раскладка {#레이아웃}

```
TAG WORD          0001 1100 0011 LLLL      Codec 0x1C3L
[Length — расширяющий TAG]
```

- Codec: Meta `0x1C3L`, класс структуры
- Payload: нет (1 WORD)
- Количество: не более одного на документ

## Интерпретация и валидность {#해석과-유효성}

- Если HEAD пуст, запись опускается. Документ без `BODY` целиком является BODY. Если в HEAD есть Meta или HEAD Edge ([SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) для всего документа и его QUALIFIER), запись ставится.
- Payload нет. Всего 1 WORD.

## Пример {#예시}

- `0x1C30`

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001C30/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C3000000000
BODY
#1 DECLARE 0x1C30
#2 BIND #1 "BODY"
```
