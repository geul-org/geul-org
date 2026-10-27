---
title: "IEEE-DECIMAL32-BID"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-BID — Value фиксированной длины 5 WORD, хранящий битовую строку IEEE 754 decimal32 BID interchange в неизменном виде."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-BID — Value, представляющий IEEE 754 decimal32 BID interchange encoding. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, номер формата `0x2003`, семейство DECIMAL. Битовый шаблон BID сохраняется как есть и отличается от DPD.

## Раскладка

```
TAG WORD          0x0A7C  всего 5 WORD
Issuer            1 WORD  0x0040 (IEEE)
Номер формата     1 WORD  0x2003
Payload           2 WORD (32 бит)  IEEE decimal32 BID Interchange
```

## Интерпретация

- Два Payload WORD, склеенные начиная со старшего, читаются как битовая строка IEEE 754 decimal32 BID interchange.
- Битовый шаблон сохраняется и не переинтерпретируется произвольно как DPD или SIGNED-DECIMAL.
- Специальные значения и payload произвольно не нормализуются.

## Допустимость и длина

- Общая длина — ровно 5 WORD: TAG 1 WORD, Issuer 1 WORD, номер формата 1 WORD и Payload 2 WORD; используется прямая длина `LLLL=0100`. Length extension TAG, descriptor и padding нет.
- Если Payload не равен ровно 2 WORD, запись отвергается.
- Семантическая допустимость битовой строки определяется правилами IEEE BID interchange.

## Примеры

| Структура | Вердикт |
|---|---|
| `0A7C 0040 2003` + битовая строка BID из 2 WORD | каноническая структура длины |
| `0A7C 0040 2003` + 4 WORD | invalid: ширина Payload не совпадает |
| тот же 32-битный шаблон с номером формата `0x2000` | формат DPD, а не этот тип |

## Стандартная основа

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): применяется двоичное кодирование коэффициента (BID) в interchange format decimal32. Выбранное 32-битное кодирование сохраняется, без числового преобразования в допускаемую IEEE альтернативу DPD; GEUL добавляет только TAG и big-endian-обрамление WORD.
