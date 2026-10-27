---
title: "WIKIDATA-QID"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID — Reference-декларация, указывающая на элемент (Item) Wikidata по числу из Q-идентификатора."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-QID — Reference-декларация, указывающая на элемент (Item) Wikidata. Числовая часть Q-идентификатора без `Q` записывается как беззнаковое целое.

## Раскладка

```
TAG WORD          0000 0LLL L010 0QQQ      CCCC = 0100
[Length extension TAG]
QID               unsigned big-endian наименьшей ширины
```

- QID записывается наименьшей шириной. `Q1`~`Q65535` занимают в сумме 2 WORD, выше — 3 WORD.
- Данные Wikidata распространяются под CC0.
- Variable — анонимная переменная вида, на который указывает этот элемент ([Reference](/ru/grammar/reference/), Variable).

## Пример

| Элемент | WORD sequence |
|---|---|
| `Q5` (human) | `00A0 0005` |
| `Q76` (Barack Obama) | `00A0 004C` |
| `Q884` (South Korea) | `00A0 0374` |
| `Q317521` (Elon Musk) | `0120 0004 D851` |
| `Q30461` (president), Variable | `00A4 76FD` |

## Связанные страницы

- [Reference](/ru/grammar/reference/), [WIKIDATA-PID](/ru/grammar/reference/wikidata-pid/), [TRIPLE](/ru/grammar/edge/triple/)
