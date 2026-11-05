---
title: "IEEE-DECIMAL64-BID"
weight: 1029
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-BID — Value, представляющее interchange encoding BID типа decimal64 по IEEE 754."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-BID — Value, представляющее interchange encoding BID типа decimal64 по IEEE 754. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, номер Codec `0x00002004`, семейство DECIMAL. Битовый образ BID сохраняется без изменений и отличается от DPD.

## Раскладка {#레이아웃}

```
TAG WORD          0x09D8  всего 9 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Номер Codec       2 WORD  0x00002004
Payload           4 WORD (64 бит)  IEEE decimal64 BID Interchange
```

## Интерпретация {#해석}

- Четыре WORD Payload, склеенные начиная со старшего WORD, читаются как битовая строка interchange BID типа decimal64 по IEEE 754.
- Битовый образ сохраняется и произвольно не переинтерпретируется как DPD или exact decimal.
- Специальные значения и payload произвольно не нормализуются.

## Действительность и длина {#유효성과-길이}

- Общая длина — ровно 9 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 4 WORD; используется прямая длина `LLLL=1000`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 4 WORD, значение отклоняется.
- Семантическая действительность битовой строки определяется правилами IEEE BID interchange.

## Пример {#예시}

| Структура | Вердикт |
|---|---|
| `09D8 0000 000D 0000 2004` + 4 WORD битовой строки BID | каноническая структура длины |
| `09D8 0000 000D 0000 2004` + 2 WORD | invalid: ширина Payload не совпадает |
| номер Codec `0x00002001` для тех же 64 бит | это формат DPD, а не данный тип |

## Стандартные основания {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): применяется binary coefficient encoding (BID) interchange format decimal64. Выбранное 64-битное кодирование сохраняется без числового преобразования в допускаемую IEEE альтернативу DPD; GEUL добавляет только TAG и framing в big-endian WORD.
