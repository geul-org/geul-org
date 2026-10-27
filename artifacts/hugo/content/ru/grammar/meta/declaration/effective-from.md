---
title: "EFFECTIVE-FROM"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-FROM -- это Meta объявления, задающая дату вступления этой версии в силу через Value даты или временной метки."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Объявляет дату вступления этой версии в силу. Дата вступления в силу отличается от момента публикации ([Редакция](/ru/grammar/document/#редакции)).

## Раскладка

```
TAG WORD          0001 1LLL L001 0011      Codec 0x13
[Length-расширенный TAG]
Payload           один Value TIME
```

- Codec: Meta `0x13`, класс объявления (`001`)
- Payload: встроенный Value ([GREGORIAN-DATE](/ru/grammar/value/time/gregorian-date/) или [POSIX-TIMESTAMP-SECONDS](/ru/grammar/value/time/posix-timestamp-seconds/))
- Количество: не более одного

## Интерпретация и валидность

- Если его нет, документ действует с момента публикации.
- Если есть [EFFECTIVE-UNTIL](/ru/grammar/meta/declaration/effective-until/), это значение должно быть раньше него.
- Если даты вступления в силу различаются по статьям, они указываются отдельно в QUALIFIER P580 (начало) и P582 (конец) на Edge этой статьи ([SOURCE](/ru/grammar/edge/source/#представление-других-оснований)).
- Это значение читается, когда документ интерпретируется на определённый момент времени.

## Пример

- Вступает в силу 1970-01-02: `0x1993 0x0920 0x0000 0x0001`
