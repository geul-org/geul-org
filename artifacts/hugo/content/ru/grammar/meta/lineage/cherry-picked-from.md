---
title: "CHERRY-PICKED-FROM"
weight: 53
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "CHERRY-PICKED-FROM -- это Meta родословной, указывающая хеш содержимого исходной версии, из которой перенесено изменение из другой родословной (git cherry-pick -x)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает хеш содержимого исходной версии, из которой перенесено изменение из другой родословной (git cherry-pick `-x`).

## Раскладка

```
TAG WORD          0001 1LLL L011 0100      Codec 0x34
[Length-расширенный TAG]
Payload           один Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x34`, класс родословной (`011`)
- Payload: встроенный Value ([SHA-256-DIGEST](/ru/grammar/value/binary/sha-256-digest/))
- Количество: может быть несколько

## Интерпретация и валидность

- Формат дайджеста встроен как Value, чтобы оставить возможность сменить алгоритм хеширования. Сейчас хеш содержимого -- только SHA-256.
