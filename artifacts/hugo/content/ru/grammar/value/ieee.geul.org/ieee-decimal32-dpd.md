---
title: "IEEE-DECIMAL32-DPD"
weight: 1028
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-DPD — Value, представляющее interchange encoding DPD типа decimal32 по IEEE 754."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-DPD — Value, представляющее interchange encoding DPD типа decimal32 по IEEE 754. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, номер Codec `0x00002000`, семейство DECIMAL. Битовый образ DPD сохраняется без изменений и отличается от BID.

## Раскладка {#레이아웃}

```
TAG WORD          0x09D6  всего 7 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Номер Codec       2 WORD  0x00002000
Payload           2 WORD (32 бита)  IEEE decimal32 DPD Interchange
```

## Интерпретация {#해석}

- Два WORD Payload, склеенные начиная со старшего WORD, читаются как битовая строка interchange DPD типа decimal32 по IEEE 754.
- Битовый образ сохраняется и произвольно не переинтерпретируется как BID или SIGNED-DECIMAL.
- Специальные значения и payload произвольно не нормализуются.

## Действительность и длина {#유효성과-길이}

- Общая длина — ровно 7 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 2 WORD; используется прямая длина `LLLL=0110`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 2 WORD, значение отклоняется.
- Семантическая действительность битовой строки определяется правилами IEEE DPD interchange.

## Пример {#예시}

| Структура | Вердикт |
|---|---|
| `09D6 0000 000D 0000 2000` + 2 WORD битовой строки DPD | каноническая структура длины |
| `09D6 0000 000D 0000 2000` + 4 WORD | invalid: ширина Payload не совпадает |
| номер Codec `0x00002003` для тех же 32 бит | это формат BID, а не данный тип |

## Стандартные основания {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): применяется decimal coefficient encoding (DPD) interchange format decimal32. Выбранное 32-битное кодирование сохраняется без числового преобразования в допускаемую IEEE альтернативу BID; GEUL добавляет только TAG и framing в big-endian WORD.
