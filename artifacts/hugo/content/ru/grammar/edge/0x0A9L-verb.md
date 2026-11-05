---
title: "VERB (0x0A9L)"
weight: 169
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB — Edge-высказывание с глаголом."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB — Edge-высказывание с глаголом. Сокращённая форма — [VERB-SHORT](0x0A8L-verb-short.md) (`0x0A8L`) ([Edge](_index.md#서술-edge)).

| Пункт | Значение |
|---|---|
| Имя | `VERB` (BIND документа спецификации `VERB`) |
| TAG ID | `0x0A9L` |
| Codec ID | `0x00000A90` |
| Документ спецификации | `0x00000000/codecs/0x00000A90/` (цель DECLARE `0A90`) |
| Раздел | 5 `0101` (Edge-высказывание), смещение C внутри раздела = 9 |
| Kind | Edge · семейство: высказывание, группа: предложение |
| TAG WORD | `0000 1010 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Высказывание с глаголом |
| Сторона Hugo | `edge/_index.md` |

## Раскладка {#레이아웃}

Раскладка пока не определена. Используется общая раскладка Edge (TAG, [Length, расширяющий TAG], Edge Id, компоненты) ([Edge](_index.md#레이아웃)).

## Документ Codec {#코덱-문서}

Раскладка пока не определена. В документе Codec есть только DECLARE (цель `0A90`). FIELD добавляются, когда раскладка будет определена.

## Связанные страницы {#관련-페이지}

- [VERB-SHORT](0x0A8L-verb-short.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000A90/latest.geul`, прочитанный через `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A9000000000
BODY
#1 DECLARE 0x0A90
#2 BIND #1 "VERB"
```
