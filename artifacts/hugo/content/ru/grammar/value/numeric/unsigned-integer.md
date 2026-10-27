---
title: "UNSIGNED-INTEGER"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER — Value, хранящий целое без знака как big-endian magnitude с минимальным числом WORD."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-INTEGER — Value, представляющий целое без знака. Прямой код Value `0x02`, семейство NUMERIC. Весь Payload читается как unsigned magnitude произвольной точности с порядком WORD big-endian. Payload занимает не менее 1 WORD, и допускается только каноническая запись с минимальным числом WORD.

## Раскладка

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x02
[Length extension TAG] если всего 15 WORD и более
Payload WORD 1st  (старший WORD)   Unsigned Magnitude 1st
...
Payload WORD Nth  (младший WORD)   Unsigned Magnitude Nth
```

## Интерпретация

- Первый Payload WORD — старший разряд, последний — младший.
- Если Payload занимает N WORD, он читается как один `16N`-битный unsigned magnitude.
- Эта ширина не является объявленной шириной хранения, descriptor битовой ширины нет.

## Каноническая запись

- 0 — это Payload в 1 WORD `0000`.
- Если Payload занимает 2 WORD и более и первый WORD равен `0000`, запись неканонична, так как значение не изменится от его удаления.
- Декодер обязан отвергать запись с лишним ведущим нулевым WORD.

## Длина

- Общая длина — число WORD: TAG 1 WORD, Length extension TAG (если есть) и Payload. До 14 WORD длина прямая, от 15 WORD используется расширенная длина `1110`·`1111`, и extension TAG тоже входит в общее число ([Записи и TAG WORD](/ru/grammar/record/)).
- Объявленная ширина вроде UINT8, UINT16, UINT32 не сохраняется, сохраняется только числовое значение.

## Примеры

| Значение | Payload WORD | Вердикт |
|---:|---|---|
| 0 | `0000` | канонично |
| 1 | `0001` | канонично |
| 65535 | `ffff` | канонично |
| 65536 | `0001 0000` | канонично |
| 1 | `0000 0001` | неканонично: лишний ведущий `0000` |
| Payload в 7 WORD | 7 WORD после TAG `0b82` (прямая длина `LLLL=0111`, всего 8 WORD) | канонично |
| Payload в 7 WORD | 7 WORD после TAG расширенной длины и расширенного значения `0009` | неканонично: до 14 WORD длина записывается прямой |

## Статус формата

- Это представление, нормализующее unsigned magnitude произвольной точности в цепочку 16-битных WORD минимальной длины и объединяющее её с TAG GEUL, — собственный scalar profile GEUL.
- При обмене с внешними типами фиксированной ширины, такими как UINT8/16/32/64, нужны проверка диапазона и явное преобразование ширины.
