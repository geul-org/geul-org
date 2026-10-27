---
title: "IEEE-DECIMAL128-BID"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-BID — Value фиксированной длины 11 WORD, хранящий битовую строку IEEE 754 decimal128 BID interchange в неизменном виде."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-BID — Value, представляющий IEEE 754 decimal128 BID interchange encoding. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, номер формата `0x2005`, семейство DECIMAL. Битовый шаблон BID сохраняется как есть и отличается от DPD.

## Раскладка

```
TAG WORD          0x0D7C  всего 11 WORD
Issuer            1 WORD  0x0040 (IEEE)
Номер формата     1 WORD  0x2005
Payload           8 WORD (128 бит)  IEEE decimal128 BID Interchange
```

## Интерпретация

- Восемь Payload WORD, склеенные начиная со старшего, читаются как битовая строка IEEE 754 decimal128 BID interchange.
- Битовый шаблон сохраняется и не переинтерпретируется произвольно как DPD или формат exact decimal.
- Специальные значения и payload произвольно не нормализуются.

## Допустимость и длина

- Общая длина — ровно 11 WORD: TAG 1 WORD, Issuer 1 WORD, номер формата 1 WORD и Payload 8 WORD; используется прямая длина `LLLL=1010`. Length extension TAG, descriptor и padding нет.
- Если Payload не равен ровно 8 WORD, запись отвергается.
- Семантическая допустимость битовой строки определяется правилами IEEE BID interchange.

## Примеры

| Структура | Вердикт |
|---|---|
| `0D7C 0040 2005` + битовая строка BID из 8 WORD | канонично |
| всего не 11 WORD (`LLLL=1010`) | invalid: не совпадает с фиксированной шириной Payload |

## Стандартная основа

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): применяется двоичное кодирование коэффициента (BID) в interchange format decimal128. Выбранное 128-битное кодирование сохраняется, без числового преобразования в допускаемую IEEE альтернативу DPD; GEUL добавляет только TAG и big-endian-обрамление WORD.
