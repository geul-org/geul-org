---
title: "BIT-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR — формат Issuer GEUL: после 32-битного числа битов N идут N бит в порядке MSB-first."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR — это сырая bit sequence с объявленной длиной. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, номер формата `0xC002`, семейство BINARY. Первые 2 Payload WORD — unsigned 32-битный bit count `N`, за ними следуют `ceil(N/16)` WORD.

## Раскладка

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[расширяющий Length TAG] если всего 15 WORD и более
Issuer            1 WORD  0x0000 (GEUL)
Номер формата     1 WORD  0xC002
Payload WORD 1st–2nd       Bit Count N (старшие 16bit │ младшие 16bit)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## Интерпретация и допустимость

- `N` — значение, прочитанное из первых 2 Payload WORD как big-endian unsigned 32-битное целое.
- Биты payload заполняют каждый WORD по порядку, начиная со старшего бита.
- Число payload WORD — ровно `ceil(N/16)`, а неиспользуемые младшие биты последнего WORD должны быть равны 0.
- При `N=0` payload WORD нет. Два WORD count уже образуют Payload, поэтому конфликта с правилом «Payload — минимум 1 WORD» нет.

## Статус формата

- Unsigned 32-битный bit count, раскладка MSB-first и нулевой padding последнего WORD — не цитата внешнего промышленного стандарта, а собственный framing GEUL.
- Представление определяет эта страница, включая правила GEUL TAG, Length и 16-битного WORD.

## Длина

- Всего — число WORD: 1 WORD TAG, расширяющий Length TAG (если есть), 1 WORD Issuer, 1 WORD номера формата и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110` и `1111`, при этом расширяющий TAG тоже входит в общее число ([Запись и TAG WORD](/ru/grammar/record/)).

## Примеры

- Пустой bit vector — count `0000 0000`, payload нет, всего 5 WORD, `LLLL=0100`.
- Bit sequence `101` — count `0000 0003`, payload `a000`, всего 6 WORD, `LLLL=0101`.
