---
title: "SOURCE и разделы"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Форматы ISSUER GEUL 0xC000~0xC005 для авторского исходного текста документа TOULMIN (SOURCE), строк (TEXT), границ разделов и дел (SECTION, CASE-BEGIN, CASE-END) и абзацев повествования (PROSE)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Записи, которыми задаются исходный текст и границы разделов документа TOULMIN. Все они — Edge, использующие номера форматов под `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` (GEUL) ([TOULMIN](/ru/grammar/edge/toulmin/#форматы-issuer)).

## Форматы

| Номер формата | Имя | Раскладка |
|---|---|---|
| `0xC000` | SOURCE | ID, WORD ширины SPAN, UTF8 Value |
| `0xC001` | TEXT | ID, UTF8 Value |
| `0xC002` | SECTION | ID, код раздела 1 WORD |
| `0xC003` | CASE-BEGIN | ID, REF (дело) |
| `0xC004` | CASE-END | ID, REF (дело) |
| `0xC005` | PROSE | ID, SPAN |

- ID — это Edge Id, REF — Edge Id записи этого документа (общие поля в [TOULMIN](/ru/grammar/edge/toulmin/#общие-поля)).
- UTF8 Value — запись [UTF8-TEXT](/ru/grammar/value/text/utf8-text/) Value. Байты хранятся как есть.

## SOURCE

Весь авторский исходный текст. Каждый SPAN — диапазон байтов внутри этого исходного текста.

```
ID
WORD ширины SPAN   старшие 2 бита = ширина (00=1, 01=2, 10=4, 11=8 WORD), остальные 14 бит = 0
Исходный текст     запись UTF8-TEXT Value
```

- SOURCE — первая запись BODY. В документе он один.
- SPAN состоит из двух полей: начальный байт и число байтов. Каждое поле — беззнаковое целое шириной (1/2/4/8 WORD), заданной WORD ширины SPAN.

## TEXT

Одно имя или одна строка. На него через REF указывают списки F_WITH·F_GROUNDS в NODE и LABEL·IMPORTED-FROM в LINK.

## SECTION

Начало раздела. Код раздела — 1 WORD.

| Код | Раздел | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | правила с условными выражениями |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` не используется. Разделы объявляются в порядке этих кодов.
- Заголовок раздела — PROSE сразу после SECTION.

## CASE-BEGIN, CASE-END

- Область дела — между CASE-BEGIN и CASE-END, указывающими на одно и то же дело (NODE CASE-DECLARE).

## PROSE

Абзац повествования, не являющийся правилом. Указывает только на диапазон (SPAN) исходного текста.

## Связанные страницы

- [TOULMIN](/ru/grammar/edge/toulmin/), [NODE](/ru/grammar/edge/toulmin/node/), [LINK](/ru/grammar/edge/toulmin/link/)
