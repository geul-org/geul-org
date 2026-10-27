---
title: "MESSAGE"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "MESSAGE -- это Meta родословной, которая записывает причину изменения текстом с указанием языка (git commit message)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает причину изменения (git commit message).

## Раскладка

```
TAG WORD          0001 1LLL L011 1000      Codec 0x38
[Length-расширенный TAG]
Сообщение         1 Value UTF8-LANGUAGE-TEXT
```

- Codec: Meta `0x38`, класс родословной (`011`)
- Payload: встроенный Value ([UTF8-LANGUAGE-TEXT](/ru/grammar/value/text/utf8-language-text/))
- Количество: не более одного на язык

## Интерпретация и валидность

- Сообщение и язык вместе помещаются в один UTF8-LANGUAGE-TEXT. MESSAGE на одном языке -- один.
- Документ спецификации geul.org записывает его через [CODEC](/ru/grammar/edge/codec/) `084A` и `084B`.
