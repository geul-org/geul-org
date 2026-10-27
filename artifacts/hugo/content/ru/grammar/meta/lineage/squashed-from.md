---
title: "SQUASHED-FROM"
weight: 56
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "SQUASHED-FROM -- это Meta родословной, указывающая хеши содержимого исходных версий, слитых в одну (git squash)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает хеши содержимого исходных версий, слитых в одну (git squash).

## Раскладка

```
TAG WORD          0001 1LLL L011 0111      Codec 0x37
[Length-расширенный TAG]
Payload           один Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x37`, класс родословной (`011`)
- Payload: встроенный Value ([SHA-256-DIGEST](/ru/grammar/value/binary/sha-256-digest/))
- Количество: может быть несколько (по одному на каждую исходную версию)

## Интерпретация и валидность

- Формат дайджеста встроен как Value, чтобы оставить возможность сменить алгоритм хеширования. Сейчас хеш содержимого -- только SHA-256.
