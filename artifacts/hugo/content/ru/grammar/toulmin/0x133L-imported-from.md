---
title: "IMPORTED-FROM (0x133L)"
weight: 307
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "IMPORTED-FROM — LINK Codec, записывающий отношение графа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IMPORTED-FROM — LINK Codec, записывающий отношение графа TOULMIN. Значение: псевдоним → путь (TEXT).

| Пункт | Значение |
|---|---|
| Имя | `IMPORTED-FROM` (BIND `IMPORTED-FROM` документа спецификации) |
| TAG ID | `0x133L` |
| Codec ID | `0x00001330` |
| Документ спецификации | `0x00000000/codecs/0x00001330/` (объект DECLARE `1330`) |
| Раздел | 9 `1001` (формат Edge TOULMIN), смещение внутри раздела C = 19 |
| Kind | Edge · семейство: формат TOULMIN, раскладка: LINK |
| TAG WORD | `0001 0011 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | псевдоним → путь (TEXT) |
| Сторона Hugo | `edge/toulmin/link.md` |

## Раскладка {#레이아웃}

Раскладка — [LINK](_index.md#link) (ID, src, dst, flags, условные поля, SPAN).

| Пункт | Значение |
|---|---|
| TANGEUL | `see a from path` |
| src → dst | псевдоним → путь (TEXT) |

- dst — REF записи TEXT.
- F_FORCE не используется (если он включён, запись отклоняется).
- Общие поля (ID, REF, SPAN) и числовые правила следуют [TOULMIN](_index.md#공통-필드).

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1330`). Условные поля раскладки LINK и ширину SPAN, задаваемую SOURCE, нельзя объявить через FIELD, поэтому объявление полей остаётся открытой проблемой ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001330/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000133000000000
BODY
#1 DECLARE 0x1330
#2 BIND #1 "IMPORTED-FROM"
```
