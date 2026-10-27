---
title: "CONFIDENCE"
weight: 68
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "CONFIDENCE -- это Meta проверки, которая записывает степень доверия ко всему документу как десятичный Value от 0 до 1."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Указывает степень доверия ко всему документу. Степень доверия на уровне записи записывается через QUALIFIER, прикреплённый к целевому Edge (свойство не определено, [SOURCE](/ru/grammar/edge/source/#представление-других-оснований)).

## Раскладка

```
TAG WORD          0001 1LLL L100 0011      Codec 0x43
[Length-расширенный TAG]
Payload           Value UNSIGNED-DECIMAL, от 0 до 1 включительно
```

- Codec: Meta `0x43`, класс проверки (`100`)
- Payload: встроенный Value ([UNSIGNED-DECIMAL](/ru/grammar/value/decimal/unsigned-decimal/))
- Количество: не более одного

## Интерпретация и валидность

- Кто выставил значение, указывается вместе через [GENERATED-BY](/ru/grammar/meta/lineage/generated-by/) и т. п.

## Открытые вопросы

- Шкала (0~1) и связь с вердиктом TOULMIN.
