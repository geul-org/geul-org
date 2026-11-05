---
title: "BINARY (0x0EAL)"
weight: 234
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "BINARY — Codec группы выражений исполняемых Edge."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY — Codec группы выражений исполняемых Edge. Значение: бинарное выражение.

| Пункт | Значение |
|---|---|
| Имя | `BINARY` (BIND документа спецификации `BINARY`) |
| TAG ID | `0x0EAL` |
| Codec ID | `0x00000EA0` |
| Документ спецификации | `0x00000000/codecs/0x00000EA0/` (цель DECLARE `0EA0`) |
| Раздел | 7 `0111` (Edge, исполнение), смещение внутри раздела C = 10 |
| Kind | Edge · семейство: исполнение, группа: выражения |
| TAG WORD | `0000 1110 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в указателе | Бинарное выражение. Оператор 1 WORD, левый операнд, правый операнд |
| Страница Hugo | `edge/_index.md` |

## Компоненты {#구성요소}

Оператор 1 WORD, левый операнд, правый операнд.

- Компоненты указываются LOCAL ID (REF) этого документа. REF `0` означает отсутствие. На месте выражения ставится выражение-Edge или символ ([Edge](_index.md#실행-edge)).
- Коды операторов, представление типов и раскладка Payload пока не определены ([Edge](_index.md#실행-edge), открытые проблемы).

## Документ Codec {#코덱-문서}

Раскладка пока не определена. Документ Codec содержит только DECLARE (цель `0EA0`). FIELD добавляются после определения раскладки.

## Связанные страницы {#관련-페이지}

- [Edge — исполняемый Edge](_index.md#실행-edge), [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000EA0/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000EA000000000
BODY
#1 DECLARE 0x0EA0
#2 BIND #1 "BINARY"
```
