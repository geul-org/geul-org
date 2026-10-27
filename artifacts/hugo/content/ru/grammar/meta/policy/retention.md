---
title: "RETENTION"
weight: 84
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "RETENTION -- это Meta политики, которая записывает срок хранения документа как Value времени окончания или длительности."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает срок хранения документа.

## Раскладка

```
TAG WORD          0001 1LLL L101 0011      Codec 0x53
[Length-расширенный TAG]
Payload           время окончания (GREGORIAN-DATE и т. п.) либо длительность (DURATION-SECONDS)
```

- Codec: Meta `0x53`, класс политики (`101`)
- Payload: встроенный Value (семейство TIME: [GREGORIAN-DATE](/ru/grammar/value/time/gregorian-date/) и т. п. либо [DURATION-SECONDS](/ru/grammar/value/time/duration-seconds/))
- Количество: не более одного

## Интерпретация и валидность

- Если это длительность, отсчёт ведётся от [RECORDED-AT](/ru/grammar/meta/provenance/recorded-at/).
