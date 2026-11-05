---
title: "FUNCTION-DECLARE (0x0E1L)"
weight: 225
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FUNCTION-DECLARE — Codec группы объявлений исполняемых Edge."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FUNCTION-DECLARE — Codec группы объявлений исполняемых Edge. Значение: объявление функции.

| Пункт | Значение |
|---|---|
| Имя | `FUNCTION-DECLARE` (BIND документа спецификации `FUNCTION-DECLARE`) |
| TAG ID | `0x0E1L` |
| Codec ID | `0x00000E10` |
| Документ спецификации | `0x00000000/codecs/0x00000E10/` (цель DECLARE `0E10`) |
| Раздел | 7 `0111` (Edge, исполнение), смещение внутри раздела C = 1 |
| Kind | Edge · семейство: исполнение, группа: объявления |
| TAG WORD | `0000 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в указателе | Объявление функции. Символ, список символов параметров, тип возврата, тело (BLOCK) |
| Страница Hugo | `edge/_index.md` |

## Компоненты {#구성요소}

Символ, список символов параметров, тип возврата, тело (BLOCK).

- Компоненты указываются LOCAL ID (REF) этого документа. REF `0` означает отсутствие. На месте выражения ставится выражение-Edge или символ ([Edge](_index.md#실행-edge)).
- Коды операторов, представление типов и раскладка Payload пока не определены ([Edge](_index.md#실행-edge), открытые проблемы).

## Документ Codec {#코덱-문서}

Раскладка пока не определена. Документ Codec содержит только DECLARE (цель `0E10`). FIELD добавляются после определения раскладки.

## Связанные страницы {#관련-페이지}

- [Edge — исполняемый Edge](_index.md#실행-edge), [TYPE-DECLARE](0x0E2L-type-declare.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000E10/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E1000000000
BODY
#1 DECLARE 0x0E10
#2 BIND #1 "FUNCTION-DECLARE"
```
