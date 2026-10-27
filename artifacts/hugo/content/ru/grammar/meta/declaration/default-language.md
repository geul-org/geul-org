---
title: "DEFAULT-LANGUAGE"
weight: 23
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DEFAULT-LANGUAGE -- это Meta объявления, задающая язык текста документа по умолчанию через Value языка."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Объявляет язык текста документа по умолчанию. Текст, для которого язык не указан отдельно, написан на этом языке.

## Раскладка

```
TAG WORD          0001 1LLL L001 0110      Codec 0x16
[Length-расширенный TAG]
Payload           один Value языка
```

- Codec: Meta `0x16`, класс объявления (`001`)
- Payload: встроенный Value ([LANGUAGE-BCP47-CODE](/ru/grammar/value/text/language-bcp47-code/) или [LANGUAGE-SHORT-CODE](/ru/grammar/value/text/language-short-code/))
- Количество: не более одного

## Интерпретация и валидность

- Документ TANGEUL указывает локаль, на которой он написан (например, `en`, `ko`).

## Пример

- `en`: `0x1916 0x08C6 0x656E`
