---
title: "IEEE-DECIMAL128-BID"
weight: 1025
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-BID — Value, представляющее interchange encoding BID типа decimal128 по IEEE 754."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-BID — Value, представляющее interchange encoding BID типа decimal128 по IEEE 754. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, номер Codec `0x00002005`, семейство DECIMAL. Битовый образ BID сохраняется без изменений и отличается от DPD.

## Раскладка {#레이아웃}

```
TAG WORD          0x09DC  всего 13 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Номер Codec       2 WORD  0x00002005
Payload           8 WORD (128 бит)  IEEE decimal128 BID Interchange
```

## Интерпретация {#해석}

- Восемь WORD Payload, склеенные начиная со старшего WORD, читаются как битовая строка interchange BID типа decimal128 по IEEE 754.
- Битовый образ сохраняется и произвольно не переинтерпретируется как DPD или exact decimal.
- Специальные значения и payload произвольно не нормализуются.

## Действительность и длина {#유효성과-길이}

- Общая длина — ровно 13 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 8 WORD; используется прямая длина `LLLL=1100`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 8 WORD, значение отклоняется.
- Семантическая действительность битовой строки определяется правилами IEEE BID interchange.

## Пример {#예시}

| Структура | Вердикт |
|---|---|
| `09DC 0000 000D 0000 2005` + 8 WORD битовой строки BID | каноническое |
| общая длина не равна 13 WORD (`LLLL=1100`) | invalid: не совпадает с фиксированной шириной Payload |

## Стандартные основания {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): применяется binary coefficient encoding (BID) interchange format decimal128. Выбранное 128-битное кодирование сохраняется без числового преобразования в допускаемую IEEE альтернативу DPD; GEUL добавляет только TAG и framing в big-endian WORD.
