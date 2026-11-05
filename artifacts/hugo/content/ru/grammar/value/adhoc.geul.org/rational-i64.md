---
title: "RATIONAL-I64"
weight: 1020
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 — Value, представляющее рациональное число несократимой дробью из big-endian int64 numerator и int64 denominator."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 — Value, представляющее рациональное число несократимой дробью из big-endian int64 numerator и int64 denominator. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, номер Codec `0x00000702`, семейство NUMERIC.

## Раскладка {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  всего 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Номер Codec       2 WORD  0x00000702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## Интерпретация и действительность {#해석과-유효성}

- Каждый int64 — целое фиксированной ширины в дополнительном коде, склеенное начиная со старшего WORD; значение равно `numerator / denominator`.
- ABI-заполнения нет.
- Payload составляет ровно 8 WORD, а denominator должен быть положительным.
- Допускается только несократимая форма с `gcd(|numerator|, denominator) = 1`. Ноль записывается только как `0/1`.

## Формальный статус {#형식-지위}

- Два int64, положительный denominator, наибольший общий делитель 1 и каноническая запись `0/1` — не заимствованный внешний wire-стандарт, а собственный формат GEUL.
- Эта страница полностью определяет представление, включая интерпретацию каждого int64 в дополнительном коде, порядок компонент и framing big-endian WORD.

## Длина {#길이}

- Общая длина — ровно 13 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 8 WORD; используется прямая длина `LLLL=1100`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 8 WORD, значение отклоняется.

## Пример {#예시}

- numerator `1`, denominator `2` — действительное `1/2`. `2/4`, `0/2` и denominator `-2` — invalid.
