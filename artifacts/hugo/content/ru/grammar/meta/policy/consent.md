---
title: "CONSENT"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "CONSENT -- это Meta политики, которая записывает область и основание согласия через Reference или текст."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает область и основание согласия.

## Раскладка

```
TAG WORD          0001 1LLL L101 0100      Codec 0x54
[Length-расширенный TAG]
Payload           Reference на основание согласия либо текст
```

- Codec: Meta `0x54`, класс политики (`101`)
- Payload: встроенный Reference или Value
- Количество: может быть несколько

## Открытые вопросы

- Структура выражения области (цель, срок, передача третьим лицам).
