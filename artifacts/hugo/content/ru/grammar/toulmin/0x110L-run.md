---
title: "RUN (0x110L)"
weight: 272
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "RUN — LINK Codec, записывающий отношение графа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RUN — LINK Codec, записывающий отношение графа TOULMIN. Значение: композиция выполнения. Если узел Active, выполняет нижестоящее дело (DAG).

| Пункт | Значение |
|---|---|
| Имя | `RUN` (BIND `RUN` документа спецификации) |
| TAG ID | `0x110L` |
| Codec ID | `0x00001100` |
| Документ спецификации | `0x00000000/codecs/0x00001100/` (объект DECLARE `1100`) |
| Раздел | 8 `1000` (Edge TOULMIN), смещение внутри раздела C = 16 |
| Kind | Edge · семейство: TOULMIN, группа: выполнение, раскладка: LINK |
| TAG WORD | `0001 0001 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | композиция выполнения. Если узел Active, выполняет нижестоящее дело (DAG) |
| Сторона Hugo | `edge/toulmin/link.md` |

## Раскладка {#레이아웃}

Раскладка — [LINK](_index.md#link) (ID, src, dst, flags, условные поля, SPAN).

| Пункт | Значение |
|---|---|
| TANGEUL | `run c when n` |
| src → dst | правило → дело |

- dst — REF узла.
- F_FORCE не используется (если он включён, запись отклоняется).
- Общие поля (ID, REF, SPAN) и числовые правила следуют [TOULMIN](_index.md#공통-필드).

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1100`). Условные поля раскладки LINK и ширину SPAN, задаваемую SOURCE, нельзя объявить через FIELD, поэтому объявление полей остаётся открытой проблемой ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001100/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000110000000000
BODY
#1 DECLARE 0x1100
#2 BIND #1 "RUN"
```
