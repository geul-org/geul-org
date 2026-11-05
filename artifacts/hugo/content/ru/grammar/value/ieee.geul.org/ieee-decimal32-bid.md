---
title: "IEEE-DECIMAL32-BID"
weight: 1027
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-BID — Value, представляющее interchange encoding BID типа decimal32 по IEEE 754."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-BID — Value, представляющее interchange encoding BID типа decimal32 по IEEE 754. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, номер Codec `0x00002003`, семейство DECIMAL. Битовый образ BID сохраняется без изменений и отличается от DPD.

## Раскладка {#레이아웃}

```
TAG WORD          0x09D6  всего 7 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Номер Codec       2 WORD  0x00002003
Payload           2 WORD (32 бита)  IEEE decimal32 BID Interchange
```

## Интерпретация {#해석}

- Два WORD Payload, склеенные начиная со старшего WORD, читаются как битовая строка interchange BID типа decimal32 по IEEE 754.
- Битовый образ сохраняется и произвольно не переинтерпретируется как DPD или SIGNED-DECIMAL.
- Специальные значения и payload произвольно не нормализуются.

## Действительность и длина {#유효성과-길이}

- Общая длина — ровно 7 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 2 WORD; используется прямая длина `LLLL=0110`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 2 WORD, значение отклоняется.
- Семантическая действительность битовой строки определяется правилами IEEE BID interchange.

## Пример {#예시}

| Структура | Вердикт |
|---|---|
| `09D6 0000 000D 0000 2003` + 2 WORD битовой строки BID | каноническая структура длины |
| `09D6 0000 000D 0000 2003` + 4 WORD | invalid: ширина Payload не совпадает |
| номер Codec `0x00002000` для тех же 32 бит | это формат DPD, а не данный тип |

## Стандартные основания {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): применяется binary coefficient encoding (BID) interchange format decimal32. Выбранное 32-битное кодирование сохраняется без числового преобразования в допускаемую IEEE альтернативу DPD; GEUL добавляет только TAG и framing в big-endian WORD.
