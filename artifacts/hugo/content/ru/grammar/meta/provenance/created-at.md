---
title: "CREATED-AT"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CREATED-AT -- это Meta происхождения, которая записывает время написания документа как Value TIME (git author date)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает время написания документа (git author date).

## Раскладка

```
TAG WORD          0001 1LLL L010 0010      Codec 0x22
[Length-расширенный TAG]
Payload           один Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS и т. п.)
```

- Codec: Meta `0x22`, класс происхождения (`010`)
- Payload: встроенный Value (семейство TIME: [GREGORIAN-DATE](/ru/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/ru/grammar/value/time/posix-timestamp-seconds/) и т. п.)
- Количество: не более одного

## Интерпретация и валидность

- Формат выбирается среди Value семейства TIME. Если нужна точность, используется наносекундный формат, определённый Issuer (например, [POSIX-TIMESTAMP-NANOSECONDS](/ru/grammar/value/time/posix-timestamp-nanoseconds/)).
