---
title: "RATIONAL-I64"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 — формат Issuer ADHOC фиксированной длины 11 WORD для рационального числа: несократимая дробь с числителем int64 и положительным знаменателем int64."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 — Value, представляющий рациональное число несократимой дробью из big-endian int64 numerator и int64 denominator. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, номер формата `0x0702`, семейство NUMERIC.

## Раскладка

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  всего 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Номер формата     1 WORD  0x0702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Интерпретация и допустимость

- Каждый int64 — целое фиксированной ширины в дополнительном коде, составленное из WORD начиная со старшего; значение равно `numerator / denominator`.
- ABI padding нет.
- Payload содержит ровно 8 WORD, и denominator положителен.
- Допускается только несократимая форма, где `gcd(|numerator|, denominator) = 1`. Ноль записывается только как `0/1`.

## Статус формата

- Два int64, положительный denominator, наибольший общий делитель 1 и canonicalization `0/1` — не заимствование внешнего wire-стандарта, а собственный формат GEUL.
- Эта страница полностью определяет представление, включая трактовку каждого int64 в дополнительном коде, порядок компонентов и big-endian WORD framing.

## Длина

- Всего ровно 11 WORD: TAG 1 WORD, Issuer 1 WORD, номер формата 1 WORD и Payload 8 WORD; используется прямая длина `LLLL=1010`. Length extension TAG, descriptor и padding нет.
- Если Payload не равен ровно 8 WORD, запись отвергается.

## Пример

- numerator `1`, denominator `2` — допустимое `1/2`. `2/4`, `0/2` и denominator `-2` — invalid.
