---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY — Value, хранящий одну величину четырьмя записями: величина в виде числовой записи Value (целое, BINARY-FLOAT, десятичное, дробь), Reference единицы, нижняя и верхняя границы."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY — Value, представляющий одну величину числом, единицей, нижней и верхней границами. Прямой код Value `0x06`, семейство NUMERIC. Каждая из четырёх частей — полная запись. Единица и границы — [необязательные поля](/ru/grammar/codec-spec/), поэтому при пропуске пишется ABSENT (`0x0000`).

## Раскладка

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[Length extension TAG] если всего 15 WORD и более
amount            числовая запись Value (целое, BINARY-FLOAT, десятичное, дробь)
unit              запись Reference (элемент-единица), 0x0000 для безразмерной величины
lower             числовая запись Value, 0x0000 ABSENT, если опущено
upper             числовая запись Value, 0x0000 ABSENT, если опущено
```

## Интерпретация и допустимость

- amount — ровно одна полная числовая запись Value. Допускаются шесть Codec: [SIGNED-INTEGER](/ru/grammar/value/numeric/signed-integer/) (`0x01`), [UNSIGNED-INTEGER](/ru/grammar/value/numeric/unsigned-integer/) (`0x02`), [BINARY-FLOAT](/ru/grammar/value/numeric/binary-float/) (`0x03`), [FRACTION](/ru/grammar/value/numeric/fraction/) (`0x07`), [SIGNED-DECIMAL](/ru/grammar/value/decimal/signed-decimal/) (`0x10`), [UNSIGNED-DECIMAL](/ru/grammar/value/decimal/unsigned-decimal/) (`0x11`). Список закрыт, это не wildcard. BOOL, COORDINATE-EARTH и COORDINATE-GEO, сам QUANTITY (вложение запрещено, глубина фиксирована) и прочие Value не допускаются. В amount нельзя писать маркер позиции (`0x0000` и т. п.).
- Внутренние записи тоже следуют канонической форме своего Codec (минимальное число WORD для целых и coefficient, 1/2/4/8 WORD для BINARY-FLOAT, FRACTION — по своим правилам). Если внутренняя запись неканонична, весь QUANTITY — invalid.
- Если amount, lower или upper — BINARY-FLOAT, значение должно быть конечным. NaN и ±Infinity — invalid (то же правило, что для широты и долготы в [COORDINATE-EARTH](/ru/grammar/value/numeric/coordinate-earth/)).
- Формат числа следует исходной записи как есть. Целое в оригинале хранится как INTEGER, дробное десятичное — как DECIMAL, простая дробь — как FRACTION, двоичное значение IEEE 754 — как BINARY-FLOAT; кодировщик не нормализует, меняя формат. C и E в DECIMAL сохраняют число знаков исходной записи: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Это одно и то же число, но с разным числом значащих цифр, поэтому это разные Value. Верхнего предела числа цифр целого и coefficient нет (минимальное число WORD, переменная длина).
- unit — ровно одна полная запись Reference либо `0x0000`. Подойдёт любой Reference, указывающий на элемент-единицу (для единиц Wikidata — WIKIDATA-QID). `0x0000` — безразмерная величина (количество, доля, население и т. п.).
- lower и upper — каждая запись одного из тех же шести Codec, что и amount, либо `0x0000` ABSENT. Из маркеров позиции допускается только пропуск ABSENT. Достаточно и одной из двух. Codec трёх чисел не обязаны совпадать. Симметричный диапазон (`652 ± 1`) тоже записывается двумя границами (`651`, `653`). Поскольку всё равно нужны два значения для несимметричных диапазонов, формата с одним ± мы не вводим.
- lower ≤ amount ≤ upper сравнивается по числовому значению, а не по байтам или Codec. Даже при разных типах сравниваются числа (например, SIGNED-INTEGER `652` и SIGNED-DECIMAL `651.5`). FRACTION сравнивается как точное рациональное число.
- Единица — часть значения. Её не отделяют в QUALIFIER и т. п. (без неё нельзя понять, `652` — это км или м).
- Извлечённая запись amount — это как есть самостоятельная запись Value. Если нужно число без единицы, эту запись берут без повторного кодирования.
- Значение, пересчитанное в единицы SI, не хранится. Это производное значение, вычисляемое по единице и таблице пересчёта.
- Курсор после чтения четырёх записей должен точно совпасть с концом Payload. Любая другая форма — invalid.
- В документах-спецификациях geul.org это описано четырьмя полями-записями: amount (`0801`·`0802`·`0803`·`0807`·`0810`·`0811`), unit (`0780`·`0000`), lower и upper (`0801`·`0802`·`0803`·`0807`·`0810`·`0811`·`0000`) ([Спецификация Codec](/ru/grammar/codec-spec/)).

## Длина

- Общая длина: TAG 1 WORD + (Length extension TAG) + четыре записи. Целочисленная запись — это TAG 1 + Payload не менее 1 WORD, запись BINARY-FLOAT — 2, 3, 5 или 9 WORD, десятичная запись — TAG 1 + показатель 2 + coefficient не менее 1 WORD. Запись FRACTION — не менее 5 WORD.
- Малое безразмерное целое без границ занимает 6 WORD, малое десятичное — 8 WORD. От 15 WORD используется расширенная длина ([Записи и TAG WORD](/ru/grammar/record/)).

## Примеры

Безразмерное `1.20`:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit, lower, upper `0000`.

Безразмерное целое `42`:

```
0A86 0881 002A 0000 0000 0000
```

- TAG `0A86` (6 WORD), amount `0881 002A` (SIGNED-INTEGER 42), unit, lower, upper `0000`.

Безразмерная дробь `2/3` (две трети голосов присутствующих):

```
0C06 0A07 0881 0002 0882 0003 0000 0000 0000
```

- TAG `0C06` (9 WORD), amount `0A07 0881 0002 0882 0003` ([FRACTION](/ru/grammar/value/numeric/fraction/) 2/3), unit, lower, upper `0000`.

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
- amount и границы в Wikidata — десятичные строки, поэтому даже в целочисленном виде (`+652`) они переносятся как SIGNED-DECIMAL. Преобразование Wikidata не использует другие числовые Codec.
- unit `"1"` — безразмерная величина (`0x0000`), `http://www.wikidata.org/entity/Qn` — WIKIDATA-QID. Другие единицы и числа и границы неверного формата не преобразуются, а исходный текст сохраняется как UTF8-TEXT.
- Выборка Wikidata (около 42 тыс. quantity из начала дампа): безразмерных 61 %, с границами 13 % (из них симметричных 93 %), самый длинный amount — 31 символ.

## Стандартная основа

- Десятичная запись и сохранение числа знаков: понятия coefficient, exponent и quantum в decimal-форматах [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (GEUL SIGNED-DECIMAL).
- Модель количества в Wikidata: Wikibase DataModel `QuantityValue`.

## Связанные страницы

- [Value](/ru/grammar/value/), [SIGNED-DECIMAL](/ru/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/ru/grammar/value/numeric/coordinate-geo/), [CODEC](/ru/grammar/edge/codec/), [WIKIDATA-QID](/ru/grammar/reference/wikidata-qid/)
