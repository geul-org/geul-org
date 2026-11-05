---
title: "CONDITIONAL (0x0EFL)"
weight: 239
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "CONDITIONAL — Codec группы выражений исполняемых Edge."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CONDITIONAL — Codec группы выражений исполняемых Edge. Значение: условное выражение.

| Пункт | Значение |
|---|---|
| Имя | `CONDITIONAL` (BIND документа спецификации `CONDITIONAL`) |
| TAG ID | `0x0EFL` |
| Codec ID | `0x00000EF0` |
| Документ спецификации | `0x00000000/codecs/0x00000EF0/` (цель DECLARE `0EF0`) |
| Раздел | 7 `0111` (Edge, исполнение), смещение внутри раздела C = 15 |
| Kind | Edge · семейство: исполнение, группа: выражения |
| TAG WORD | `0000 1110 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в указателе | Условное выражение. Условие, значение при истинности, значение при ложности |
| Страница Hugo | `edge/_index.md` |

## Компоненты {#구성요소}

Условие, значение при истинности, значение при ложности.

- Компоненты указываются LOCAL ID (REF) этого документа. REF `0` означает отсутствие. На месте выражения ставится выражение-Edge или символ ([Edge](_index.md#실행-edge)).
- Коды операторов, представление типов и раскладка Payload пока не определены ([Edge](_index.md#실행-edge), открытые проблемы).

## Документ Codec {#코덱-문서}

Раскладка пока не определена. Документ Codec содержит только DECLARE (цель `0EF0`). FIELD добавляются после определения раскладки.

## Связанные страницы {#관련-페이지}

- [Edge — исполняемый Edge](_index.md#실행-edge), [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000EF0/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000EF000000000
BODY
#1 DECLARE 0x0EF0
#2 BIND #1 "CONDITIONAL"
```
