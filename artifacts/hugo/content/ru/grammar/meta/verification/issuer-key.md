---
title: "ISSUER-KEY"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ISSUER-KEY -- это Meta проверки, которая объявляет ID алгоритма подписи и открытый ключ самостоятельно выданного (16 WORD) Issuer."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Объявляет открытый ключ самостоятельно выданного (16 WORD) Issuer. Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID алгоритма ‖ открытый ключ) ([Issuer 16 WORD](/ru/grammar/issuer/#issuer-в-16-word)).

## Раскладка

```
TAG WORD          0001 1LLL L100 0000      Codec 0x40
[Length-расширенный TAG]
ID алгоритма      1 WORD (0x0001 = Ed25519)
Открытый ключ     ширина определяется алгоритмом (Ed25519: 16 WORD)
```

- Codec: Meta `0x40`, класс проверки (`100`)
- Payload: сырое значение (ID алгоритма + открытый ключ)
- Количество: может быть несколько (смена ключа)

## Интерпретация и валидность

- Это класс проверки, поэтому он исключается из хеша содержимого.
- Issuer в 1, 2 и 4 WORD используют ключи, зарегистрированные на geul.org, поэтому не нуждаются в этой записи.
