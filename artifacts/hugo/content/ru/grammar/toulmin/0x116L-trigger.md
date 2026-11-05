---
title: "TRIGGER (0x116L)"
weight: 278
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TRIGGER — NODE Codec, записывающий узел графа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIGGER — NODE Codec, записывающий узел графа TOULMIN. Значение: точка входа по событию или периоду, без внешнего вызова.

| Пункт | Значение |
|---|---|
| Имя | `TRIGGER` (BIND `TRIGGER` документа спецификации) |
| TAG ID | `0x116L` |
| Codec ID | `0x00001160` |
| Документ спецификации | `0x00000000/codecs/0x00001160/` (объект DECLARE `1160`) |
| Раздел | 8 `1000` (Edge TOULMIN), смещение внутри раздела C = 22 |
| Kind | Edge · семейство: TOULMIN, группа: выполнение, раскладка: NODE |
| TAG WORD | `0001 0001 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | точка входа по событию или периоду, без внешнего вызова |
| Сторона Hugo | `edge/toulmin/node.md` |

## Раскладка {#레이아웃}

Раскладка — [NODE](_index.md#node). Заголовок в 1 WORD задаёт role, level, форму Claim и условные поля.

| Пункт | Значение |
|---|---|
| TANGEUL | `on`, `every`, `until` |
| Узел | точка входа по событию или периоду |

- role должен быть 0.
- Общие поля (ID, REF, SPAN) и числовые правила следуют [TOULMIN](_index.md#공통-필드).

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1160`). Условные поля раскладки NODE и ширину SPAN, задаваемую SOURCE, нельзя объявить через FIELD, поэтому объявление полей остаётся открытой проблемой ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001160/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000116000000000
BODY
#1 DECLARE 0x1160
#2 BIND #1 "TRIGGER"
```
