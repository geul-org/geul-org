---
title: "IEEE-DECIMAL64-BID"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-BID — Value фиксированной длины 7 WORD, хранящий битовую строку IEEE 754 decimal64 BID interchange в неизменном виде."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-BID — Value, представляющий IEEE 754 decimal64 BID interchange encoding. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, номер формата `0x2004`, семейство DECIMAL. Битовый шаблон BID сохраняется как есть и отличается от DPD.

## Раскладка

```
TAG WORD          0x0B7C  всего 7 WORD
Issuer            1 WORD  0x0040 (IEEE)
Номер формата     1 WORD  0x2004
Payload           4 WORD (64 бит)  IEEE decimal64 BID Interchange
```

## Интерпретация

- Четыре Payload WORD, склеенные начиная со старшего, читаются как битовая строка IEEE 754 decimal64 BID interchange.
- Битовый шаблон сохраняется и не переинтерпретируется произвольно как DPD или формат exact decimal.
- Специальные значения и payload произвольно не нормализуются.

## Допустимость и длина

- Общая длина — ровно 7 WORD: TAG 1 WORD, Issuer 1 WORD, номер формата 1 WORD и Payload 4 WORD; используется прямая длина `LLLL=0110`. Length extension TAG, descriptor и padding нет.
- Если Payload не равен ровно 4 WORD, запись отвергается.
- Семантическая допустимость битовой строки определяется правилами IEEE BID interchange.

## Примеры

| Структура | Вердикт |
|---|---|
| `0B7C 0040 2004` + битовая строка BID из 4 WORD | каноническая структура длины |
| `0B7C 0040 2004` + 2 WORD | invalid: ширина Payload не совпадает |
| тот же 64-битный шаблон с номером формата `0x2001` | формат DPD, а не этот тип |

## Стандартная основа

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): применяется двоичное кодирование коэффициента (BID) в interchange format decimal64. Выбранное 64-битное кодирование сохраняется, без числового преобразования в допускаемую IEEE альтернативу DPD; GEUL добавляет только TAG и big-endian-обрамление WORD.
