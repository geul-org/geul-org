---
title: "RULE-DECLARE (0x103L)"
weight: 259
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "RULE-DECLARE — NODE Codec, записывающий узел графа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RULE-DECLARE — NODE Codec, записывающий узел графа TOULMIN. Значение: объявление утверждения (Warrant). Может быть атаковано.

| Пункт | Значение |
|---|---|
| Имя | `RULE-DECLARE` (BIND `RULE-DECLARE` документа спецификации) |
| TAG ID | `0x103L` |
| Codec ID | `0x00001030` |
| Документ спецификации | `0x00000000/codecs/0x00001030/` (объект DECLARE `1030`) |
| Раздел | 8 `1000` (Edge TOULMIN), смещение внутри раздела C = 3 |
| Kind | Edge · семейство: TOULMIN, группа: объявление, раскладка: NODE |
| TAG WORD | `0001 0000 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | объявление утверждения (Warrant). Может быть атаковано |
| Сторона Hugo | `edge/toulmin/node.md` |

## Раскладка {#레이아웃}

Раскладка — [NODE](_index.md#node). Заголовок в 1 WORD задаёт role, level, форму Claim и условные поля.

| Пункт | Значение |
|---|---|
| TANGEUL | general rule, имя правила в Rules |
| Узел | утверждение (Warrant) |

- role должен быть 0 (general).
- Общие поля (ID, REF, SPAN) и числовые правила следуют [TOULMIN](_index.md#공통-필드).

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1030`). Условные поля раскладки NODE и ширину SPAN, задаваемую SOURCE, нельзя объявить через FIELD, поэтому объявление полей остаётся открытой проблемой ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001030/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000103000000000
BODY
#1 DECLARE 0x1030
#2 BIND #1 "RULE-DECLARE"
```
