---
title: "WORLD (0x0B0L)"
weight: 176
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "WORLD — Edge-высказывание для записи картины мира."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WORLD — Edge-высказывание для записи картины мира. Смысл: структура для выражения картины мира.

| Пункт | Значение |
|---|---|
| Имя | `WORLD` (BIND документа спецификации `WORLD`) |
| TAG ID | `0x0B0L` |
| Codec ID | `0x00000B00` |
| Документ спецификации | `0x00000000/codecs/0x00000B00/` (цель DECLARE `0B00`) |
| Раздел | 5 `0101` (Edge-высказывание), смещение C внутри раздела = 16 |
| Kind | Edge · семейство: высказывание, группа: структура |
| TAG WORD | `0000 1011 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Структура для выражения картины мира |
| Сторона Hugo | `edge/_index.md` |

## Раскладка {#레이아웃}

```
TAG WORD          0000 1011 0000 LLLL      Codec 0x0B0L
[Length, расширяющий TAG]
TAG для Codec     1 WORD. Подформат
Edge Id           запись LOCAL Reference
компоненты        определяет подформат
```

- Это Codec с подформатами. Подформат указывает 1 WORD TAG для Codec ([запись и TAG WORD](../record.md#레코드-레이아웃)).
- Подформаты и компоненты пока не определены.

## Документ Codec {#코덱-문서}

Раскладка пока не определена. В документе Codec есть только DECLARE (цель `0B00`). FIELD добавляются, когда раскладка будет определена.

## Связанные страницы {#관련-페이지}

- [TIMELINE](0x0B1L-timeline.md), [SCENE](0x0B2L-scene.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제) (как объявлять Codec с подформатами)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000B00/latest.geul`, прочитанный через `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B0000000000
BODY
#1 DECLARE 0x0B00
#2 BIND #1 "WORLD"
```
