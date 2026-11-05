---
title: "IF (0x0F2L)"
weight: 242
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "IF — Codec группы операторов исполняемых Edge."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IF — Codec группы операторов исполняемых Edge. Значение: условное ветвление.

| Пункт | Значение |
|---|---|
| Имя | `IF` (BIND документа спецификации `IF`) |
| TAG ID | `0x0F2L` |
| Codec ID | `0x00000F20` |
| Документ спецификации | `0x00000000/codecs/0x00000F20/` (цель DECLARE `0F20`) |
| Раздел | 7 `0111` (Edge, исполнение), смещение внутри раздела C = 18 |
| Kind | Edge · семейство: исполнение, группа: операторы |
| TAG WORD | `0000 1111 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в указателе | Условное ветвление. Условие, BLOCK при истинности, ветка иначе (BLOCK или IF, 0 при отсутствии) |
| Страница Hugo | `edge/_index.md` |

## Компоненты {#구성요소}

Условие, BLOCK при истинности, ветка иначе (BLOCK или IF, 0 при отсутствии).

- Компоненты указываются LOCAL ID (REF) этого документа. REF `0` означает отсутствие. На месте выражения ставится выражение-Edge или символ ([Edge](_index.md#실행-edge)).
- Коды операторов, представление типов и раскладка Payload пока не определены ([Edge](_index.md#실행-edge), открытые проблемы).

## Документ Codec {#코덱-문서}

Раскладка пока не определена. Документ Codec содержит только DECLARE (цель `0F20`). FIELD добавляются после определения раскладки.

## Связанные страницы {#관련-페이지}

- [Edge — исполняемый Edge](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000F20/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F2000000000
BODY
#1 DECLARE 0x0F20
#2 BIND #1 "IF"
```
