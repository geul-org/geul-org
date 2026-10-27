---
title: "DERIVED-FROM"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DERIVED-FROM — это Meta родословной, указывающая документ или материал из другой родословной, от которого произведён этот документ."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает, что этот документ произведён от документа или материала из другой родословной.

## Раскладка

```
TAG WORD          0001 1LLL L011 0001      Codec 0x31
[Length extension TAG]
Payload           Reference, либо SHA-256-DIGEST (хеш содержимого), либо Value URI
```

- Codec: Meta `0x31`, класс родословной (`011`)
- Payload: встроенный Reference или Value
- Количество: может быть несколько

## Интерпретация и валидность

- Если документ произведён от документа GEUL, указывается его хеш содержимого ([SHA-256-DIGEST](/ru/grammar/value/binary/sha-256-digest/)), а если от внешнего материала — [URI](/ru/grammar/value/text/uri/). Чтобы зафиксировать издание внешнего материала хешем, к [SOURCE](/ru/grammar/edge/source/#источник-всего-документа) в HEAD добавляют QUALIFIER с хешем исходного текста (P4092).
- Источник на уровне записи берёт на себя Edge оснований [SOURCE](/ru/grammar/edge/source/), а прежние записи до перемещения, разделения и объединения — QUALIFIER P1365 на целевом Edge (значение — прежний Edge Id).
