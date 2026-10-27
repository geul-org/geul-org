---
title: "REPLACES"
weight: 55
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REPLACES -- это Meta родословной, указывающая хеш содержимого переписанной версии (git amend, rebase). Исходная версия не удаляется."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает хеш содержимого переписанной версии (git amend, rebase).

## Раскладка

```
TAG WORD          0001 1LLL L011 0110      Codec 0x36
[Length-расширенный TAG]
Payload           один Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x36`, класс родословной (`011`)
- Payload: встроенный Value ([SHA-256-DIGEST](/ru/grammar/value/binary/sha-256-digest/))
- Количество: может быть несколько

## Интерпретация и валидность

- Исходная версия не удаляется (сохранение прежней редакции закона).
- Формат дайджеста встроен как Value, чтобы оставить возможность сменить алгоритм хеширования. Сейчас хеш содержимого -- только SHA-256.
