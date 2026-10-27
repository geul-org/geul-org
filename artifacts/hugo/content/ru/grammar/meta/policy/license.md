---
title: "LICENSE"
weight: 81
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "LICENSE -- это Meta политики, которая записывает лицензию на этот документ и на произведения внутри байтовой последовательности."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает лицензию на этот документ и на произведения внутри байтовой последовательности.

## Раскладка

```
TAG WORD          0001 1LLL L101 0000      Codec 0x50
[Length-расширенный TAG]
Payload           Reference на лицензию, либо идентификатор SPDX в UTF8-TEXT, либо Value URI
```

- Codec: Meta `0x50`, класс политики (`101`)
- Payload: встроенный Reference или Value ([UTF8-TEXT](/ru/grammar/value/text/utf8-text/), [URI](/ru/grammar/value/text/uri/))
- Количество: не более одного

## Интерпретация и валидность

- Опубликованные документы geul.org -- CC0. Для частных публикаций лицензию определяет Issuer ([Issuer](/ru/grammar/issuer/)).
- Записывается исходная лицензия исходного произведения.

## Открытые вопросы

- Записывать идентификатор SPDX текстом или как Reference на сущность GEUL.
