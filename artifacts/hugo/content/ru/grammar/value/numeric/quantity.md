---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY — Value, хранящий одну величину четырьмя записями: точная десятичная величина, Reference единицы, нижняя и верхняя границы."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY — Value, представляющий одну величину точным десятичным числом, единицей, нижней и верхней границами. Прямой код Value `0x06`, семейство NUMERIC. Каждая из четырёх частей — полная запись. Единица и границы — [необязательные поля](/ru/grammar/codec-spec/), поэтому при пропуске пишется ABSENT (`0x0000`).

## Раскладка

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[Length extension TAG] если всего 15 WORD и более
amount            запись Value SIGNED-DECIMAL
unit              запись Reference (элемент-единица), 0x0000 для безразмерной величины
lower             запись Value SIGNED-DECIMAL, 0x0000 ABSENT, если опущено
upper             запись Value SIGNED-DECIMAL, 0x0000 ABSENT, если опущено
```

## Интерпретация и допустимость

- amount — [SIGNED-DECIMAL](/ru/grammar/value/decimal/signed-decimal/) `C×10^E`. C и E сохраняют число знаков исходной записи: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Это одно и то же число, но с разным числом значащих цифр, поэтому это разные Value. Верхнего предела числа цифр coefficient нет (дополнительный код с минимальным числом WORD, переменная длина).
- unit — ровно одна полная запись Reference либо `0x0000`. Подойдёт любой Reference, указывающий на элемент-единицу (для единиц Wikidata — WIKIDATA-QID). `0x0000` — безразмерная величина (количество, доля, население и т. п.).
- lower и upper — каждая запись SIGNED-DECIMAL либо `0x0000`. Достаточно и одной из двух. Симметричный диапазон (`652 ± 1`) тоже записывается двумя границами (`651`, `653`). Поскольку всё равно нужны два значения для несимметричных диапазонов, формата с одним ± мы не вводим.
- Единица — часть значения. Её не отделяют в QUALIFIER и т. п. (без неё нельзя понять, `652` — это км или м).
- Значение, пересчитанное в единицы SI, не хранится. Это производное значение, вычисляемое по единице и таблице пересчёта.
- Курсор после чтения четырёх записей должен точно совпасть с концом Payload. Любая другая форма — invalid.
- В документах-спецификациях geul.org это описано четырьмя полями-записями: amount (`0810`), unit (`0780`·`0000`), lower и upper (`0810`·`0000`) ([Спецификация Codec](/ru/grammar/codec-spec/)).

## Длина

- Общая длина: TAG 1 WORD + (Length extension TAG) + четыре записи. Десятичная запись — это TAG 1 + показатель 2 + coefficient не менее 1 WORD.
- Малое безразмерное число без границ занимает 8 WORD. От 15 WORD используется расширенная длина ([Записи и TAG WORD](/ru/grammar/record/)).

## Примеры

Безразмерное `1.20`:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit, lower, upper `0000`.

`652 km`, диапазон `[651, 653]` (km = Q828224):

```
0F06 0011
0990 0000 0000 028C
0120 000C A340
0990 0000 0000 028B
0990 0000 0000 028D
```

- Всего 17 WORD, поэтому `LLLL=1110`, extension TAG `0011`.

## Соответствие Wikidata

- datavalue `quantity` `{"amount","unit","lowerBound","upperBound"}` → amount, unit, lower, upper. Строки amount и границ (`+1.20`, включая экспоненциальную запись) переносятся в C и E с сохранением числа знаков.
- unit `"1"` — безразмерная величина (`0x0000`), `http://www.wikidata.org/entity/Qn` — WIKIDATA-QID. Другие единицы и числа и границы неверного формата не преобразуются, а исходный текст сохраняется как UTF8-TEXT.
- Выборка Wikidata (около 42 тыс. quantity из начала дампа): безразмерных 61 %, с границами 13 % (из них симметричных 93 %), самый длинный amount — 31 символ.

## Стандартная основа

- Десятичная запись и сохранение числа знаков: понятия coefficient, exponent и quantum в decimal-форматах [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (GEUL SIGNED-DECIMAL).
- Модель количества в Wikidata: Wikibase DataModel `QuantityValue`.

## Связанные страницы

- [Value](/ru/grammar/value/), [SIGNED-DECIMAL](/ru/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/ru/grammar/value/numeric/coordinate-geo/), [CODEC](/ru/grammar/edge/codec/), [WIKIDATA-QID](/ru/grammar/reference/wikidata-qid/)
