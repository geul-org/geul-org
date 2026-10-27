---
title: "SIGNED-DECIMAL"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL — Value, хранящий точное десятичное число C×10^E: показатель E (signed, 32 бита) и коэффициент C в дополнительном коде с минимальным числом WORD."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-DECIMAL — Value, представляющий точное десятичное число (exact decimal) с coefficient со знаком. Прямой код Value `0x10`, семейство DECIMAL. Первые 2 WORD Payload — signed 32-битный десятичный exponent `E`, остальное — coefficient `C` в дополнительном коде с минимальным числом WORD; значение равно `C×10^E`.

## Раскладка

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x10
[Length extension TAG] если всего 15 WORD и более
Payload WORD 1st–2nd (32 бита)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD и более)  Signed Two's-complement Coefficient C
```

## Интерпретация

- `E` — signed 32-битное big-endian целое в дополнительном коде, записанное начиная со старшего WORD.
- `C` — целое произвольной точности в дополнительном коде, полученное склейкой всех остальных WORD начиная со старшего.
- `C` подчиняется тому же правилу минимального числа WORD, что и [SIGNED-INTEGER](/ru/grammar/value/numeric/signed-integer/). Ведущие WORD `0000` или `ffff`, которые можно стереть, запрещены.

## Длина и допустимость

- Общая длина — число WORD: TAG 1 WORD, Length extension TAG (если есть) и Payload. До 14 WORD длина прямая, от 15 WORD используется расширенная длина `1110`·`1111`, и extension TAG тоже входит в общее число ([Записи и TAG WORD](/ru/grammar/record/)).
- Payload — exponent 2 WORD и coefficient не менее 1 WORD, то есть не менее 3 WORD.
- Каноничность байтового представления проверяется только по минимальной записи coefficient в WORD.

## Примеры

| Представление значения | Payload (`E` + `C`) | Вердикт |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | байтовое представление каноническое |
| `10×10^-1` | `ffff ffff 000a` | байтовое представление каноническое; canonical-отношение к записи выше — открытый вопрос |
| `1×10^0` | `0000 0000 0000 0001` | неканонично: ведущий `0000` в coefficient лишний |
| Payload 7 WORD | прямая длина `LLLL=0111`, всего 8 WORD | каноническая структура длины |

## Статус формата

- Эта раскладка, объединяющая signed 32-битный exponent `E` и coefficient `C` минимального числа WORD, — собственный формат GEUL, а не IEEE 754 decimal interchange и не Apache Parquet `DECIMAL`.
- Parquet `DECIMAL` использует `unscaledValue × 10^(-scale)` и обязательные metadata precision/scale, хранит unscaled value физического типа byte-array как big-endian целое в дополнительном коде, а scale неотрицателен. В этом формате signed `E` находится в самом теле и metadata precision нет, поэтому это не тот же формат.
- Для обмена с IEEE 754 decimal или Parquet `DECIMAL` нужно явное преобразование с определёнными политиками диапазона, precision/scale, quantum и специальных значений.
- Основа для сравнения: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Открытые вопросы

- Существует несколько пар exponent/coefficient, обозначающих одно число, как `10×10^-1` и `1×10^0`.
- Сохраняет ли этот формат quantum, как определяется равенство значений и как нормализуется canonical exponent — пока не решено.
- Поэтому реализация не должна произвольно навязывать нормализацию exponent/coefficient сверх правила минимального числа WORD для coefficient.
