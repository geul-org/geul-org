---
title: "TIMELINE (0x0B1L)"
weight: 177
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TIMELINE — Edge-высказывание для записи порядка событий."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TIMELINE — Edge-высказывание для записи порядка событий. Смысл: структура для выражения порядка мира и событий.

| Пункт | Значение |
|---|---|
| Имя | `TIMELINE` (BIND документа спецификации `TIMELINE`) |
| TAG ID | `0x0B1L` |
| Codec ID | `0x00000B10` |
| Документ спецификации | `0x00000000/codecs/0x00000B10/` (цель DECLARE `0B10`) |
| Раздел | 5 `0101` (Edge-высказывание), смещение C внутри раздела = 17 |
| Kind | Edge · семейство: высказывание, группа: структура |
| TAG WORD | `0000 1011 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Структура для выражения порядка мира и событий |
| Сторона Hugo | `edge/_index.md` |

## Раскладка {#레이아웃}

```
TAG WORD          0000 1011 0001 LLLL      Codec 0x0B1L
[Length, расширяющий TAG]
TAG для Codec     1 WORD. Подформат
Edge Id           запись LOCAL Reference
компоненты        определяет подформат
```

- Это Codec с подформатами. Подформат указывает 1 WORD TAG для Codec ([запись и TAG WORD](../record.md#레코드-레이아웃)).
- Подформаты и компоненты пока не определены.

## Документ Codec {#코덱-문서}

Раскладка пока не определена. В документе Codec есть только DECLARE (цель `0B10`). FIELD добавляются, когда раскладка будет определена.

## Связанные страницы {#관련-페이지}

- [WORLD](0x0B0L-world.md), [SCENE](0x0B2L-scene.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제) (как объявлять Codec с подформатами)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000B10/latest.geul`, прочитанный через `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B1000000000
BODY
#1 DECLARE 0x0B10
#2 BIND #1 "TIMELINE"
```
