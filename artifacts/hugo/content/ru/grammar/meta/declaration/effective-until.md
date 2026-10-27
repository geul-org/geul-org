---
title: "EFFECTIVE-UNTIL"
weight: 21
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-UNTIL -- это Meta объявления, задающая конец срока действия этой версии (срочный закон) через Value даты или временной метки."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Объявляет конец срока действия этой версии (срочный закон). С этого момента эта версия перестаёт действовать.

## Раскладка

```
TAG WORD          0001 1LLL L001 0100      Codec 0x14
[Length-расширенный TAG]
Payload           один Value TIME
```

- Codec: Meta `0x14`, класс объявления (`001`)
- Payload: встроенный Value ([GREGORIAN-DATE](/ru/grammar/value/time/gregorian-date/) или [POSIX-TIMESTAMP-SECONDS](/ru/grammar/value/time/posix-timestamp-seconds/))
- Количество: не более одного

## Интерпретация и валидность

- Если его нет, версия действует до вступления в силу следующей версии.
- После истечения срока действующей редакции нет. Прежняя редакция не возрождается.
