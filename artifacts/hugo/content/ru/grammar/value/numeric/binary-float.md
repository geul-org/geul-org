---
title: "BINARY-FLOAT"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT — Value, хранящий битовую строку IEEE 754 binary16/32/64/128 interchange в неизменном виде."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY-FLOAT — Value, представляющий скаляр IEEE 754 binary interchange. Прямой код Value `0x03`, семейство NUMERIC. Если Payload занимает 1/2/4/8 WORD, это соответственно binary16/32/64/128. Битовая строка interchange сохраняется как есть; другие размеры Payload не допускаются.

## Раскладка

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x03
[Length extension TAG] если всего 15 WORD и более
Payload WORD 1st  (старший WORD)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (младший WORD)   IEEE Binary Interchange Nth
```

## Интерпретация

- Payload WORD склеиваются в порядке big-endian и читаются как битовая строка IEEE 754 binary interchange соответствующей ширины.
- Битовые шаблоны interchange сохраняются, включая NaN payload и signed zero.
- Декодер не должен заменять NaN произвольным одним каноническим NaN и не должен стирать знак signed zero.
- Способ округления и поведение арифметики этот формат сериализации не определяет.

## Длина

Общая длина — число WORD: TAG 1 WORD, Length extension TAG (если есть) и Payload ([Записи и TAG WORD](/ru/grammar/record/)).

| Формат | Payload | Код Length | Length extension TAG | Общая Length |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | нет | 2 WORD |
| binary32 | 2 WORD | `0010` | нет | 3 WORD |
| binary64 | 4 WORD | `0100` | нет | 5 WORD |
| binary128 | 8 WORD | `1000` | нет | 9 WORD |

binary128 тоже укладывается в прямой диапазон 1–14 WORD, поэтому Length extension TAG не используется.

## Допустимость

- Payload — ровно 1, 2, 4 или 8 WORD.
- Каждый размер Payload должен точно соответствовать представлению Length из таблицы выше.
- Перекодирование с изменением ширины и padding WORD до или после Payload не допускаются.

## Примеры

| Формат | TAG | Length extension TAG | Пример Payload | Вердикт |
|---|---|---|---|---|
| binary16 | `0883` | нет | `0000` | канонично |
| binary32 | `0903` | нет | `0000 0000` | канонично |
| binary64 | `0A03` | нет | `0000 0000 0000 0000` | канонично |
| binary128 | `0C03` | нет | битовая строка из 8 WORD | канонично |
| любой | не совпадает с размером, заданным Length | любой | любой | invalid |

## Стандартная основа

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): применяется кодирование binary16, binary32, binary64, binary128 interchange. GEUL добавляет к этой битовой строке только TAG и 16-битное big-endian-обрамление WORD.
