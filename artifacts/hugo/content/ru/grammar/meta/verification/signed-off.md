---
title: "SIGNED-OFF"
weight: 67
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNED-OFF -- это Meta проверки, которая записывает через Reference подтверждение права на вклад (git Signed-off-by, DCO)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Подтверждение права на вклад (git `Signed-off-by`, DCO).

## Раскладка

```
TAG WORD          0001 1LLL L100 0010      Codec 0x42
[Length-расширенный TAG]
Payload           один Reference
```

- Codec: Meta `0x42`, класс проверки (`100`)
- Payload: встроенный Reference
- Количество: может быть несколько

## Интерпретация и валидность

- В опубликованных документах geul.org нет Reference, указывающих на физических лиц ([Issuer и публикация](/ru/grammar/issuer/#публикация-через-geulorg)). Указываются организации и Issuer. В порядке исключения указывать физическое лицо через [WIKIDATA-QID](/ru/grammar/reference/wikidata-qid/) разрешено.
