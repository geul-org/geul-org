---
title: "PARENT"
weight: 49
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "PARENT -- это Meta родословной, указывающая хеш содержимого непосредственно предыдущей версии (git parent). Если их несколько, это слияние."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает хеш содержимого непосредственно предыдущей версии (git parent).

## Раскладка

```
TAG WORD          0001 1LLL L011 0000      Codec 0x30
[Length-расширенный TAG]
Payload           один Value SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x30`, класс родословной (`011`)
- Payload: встроенный Value ([SHA-256-DIGEST](/ru/grammar/value/binary/sha-256-digest/))
- Количество: может быть несколько (слияние)

## Интерпретация и валидность

- Если его нет, это первая версия, а если несколько -- слияние (git merge commit).
- Входит в [хеш содержимого](/ru/grammar/document/#хеш-содержимого), поэтому вся история образует цепочку хешей.
- Документ списка версий указывает на непосредственно предыдущий документ списка ([PUBLICATION](/ru/grammar/edge/publication/)).
- Формат дайджеста встроен как Value, чтобы оставить возможность сменить алгоритм хеширования. Сейчас хеш содержимого -- только SHA-256.

## Пример

- `0x1F30 0x0014 0x0F61 0x0012 <16 WORD>` (Meta 20 WORD = TAG + Length-расширение + встроенный Value 18 WORD)
