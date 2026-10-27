---
title: "RECORDED-AT"
weight: 38
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-AT -- это Meta происхождения, которая записывает время записи в документ как Value TIME (git commit date)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает время записи в документ (git commit date).

## Раскладка

```
TAG WORD          0001 1LLL L010 0101      Codec 0x25
[Length-расширенный TAG]
Payload           один Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS и т. п.)
```

- Codec: Meta `0x25`, класс происхождения (`010`)
- Payload: встроенный Value (семейство TIME: [GREGORIAN-DATE](/ru/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/ru/grammar/value/time/posix-timestamp-seconds/) и т. п.)
- Количество: не более одного

## Интерпретация и валидность

- Формат выбирается среди Value семейства TIME. Если нужна точность, используется наносекундный формат, определённый Issuer (например, [POSIX-TIMESTAMP-NANOSECONDS](/ru/grammar/value/time/posix-timestamp-nanoseconds/)).
- Документ списка версий ([PUBLICATION](/ru/grammar/edge/publication/)) использует это значение как время публикации, объявления устаревшим (deprecate) и удаления.

## Открытые вопросы

- Meta происхождения входит в хеш содержимого. Допускать ли, что запись одного и того же содержимого в другое время даёт другой хеш.
