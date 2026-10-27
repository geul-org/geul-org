---
title: "MODIFIED-AT"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "MODIFIED-AT -- это Meta происхождения, которая записывает время изменения документа как Value TIME."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает время изменения документа.

## Раскладка

```
TAG WORD          0001 1LLL L010 0011      Codec 0x23
[Length-расширенный TAG]
Payload           один Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS и т. п.)
```

- Codec: Meta `0x23`, класс происхождения (`010`)
- Payload: встроенный Value (семейство TIME: [GREGORIAN-DATE](/ru/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/ru/grammar/value/time/posix-timestamp-seconds/) и т. п.)
- Количество: не более одного

## Интерпретация и валидность

- Формат выбирается среди Value семейства TIME. Если нужна точность, используется наносекундный формат, определённый Issuer (например, [POSIX-TIMESTAMP-NANOSECONDS](/ru/grammar/value/time/posix-timestamp-nanoseconds/)).
