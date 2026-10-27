---
title: "WIKIDATA-PID"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID — Reference-декларация, указывающая на свойство (Property) Wikidata по числу из P-идентификатора."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-PID — Reference-декларация, указывающая на свойство (Property) Wikidata. Числовая часть P-идентификатора без `P` записывается как беззнаковое целое.

## Раскладка

```
TAG WORD          0000 0LLL L010 1QQQ      CCCC = 0101
[Length extension TAG]
PID               unsigned big-endian наименьшей ширины
```

- PID записывается наименьшей шириной. Нынешние номера свойств помещаются в 1 WORD, то есть всего 2 WORD; при значениях свыше 65535 запись естественно растёт до 3 WORD.
- Используется в основном на месте Predicate в [TRIPLE](/ru/grammar/edge/triple/) и Property в [QUALIFIER](/ru/grammar/edge/qualifier/).

## Пример

| Свойство | WORD sequence |
|---|---|
| `P31` (instance of) | `00A8 001F` |
| `P279` (subclass of) | `00A8 0117` |
| `P569` (date of birth) | `00A8 0239` |

## Связанные страницы

- [Reference](/ru/grammar/reference/), [WIKIDATA-QID](/ru/grammar/reference/wikidata-qid/), [TRIPLE](/ru/grammar/edge/triple/), [QUALIFIER](/ru/grammar/edge/qualifier/)
