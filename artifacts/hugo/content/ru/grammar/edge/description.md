---
title: "DESCRIPTION"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION -- описательный Edge, который связывает с Subject одно короткое описание на конкретном языке (Codec 0x06). Раскладка та же, что у LABEL."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIPTION -- описательный Edge, который связывает с Subject одно описание на конкретном языке в роли Object. Codec `0x06`.

Описание -- короткая фраза, отличающая объект (description в Wikidata, например «столица и крупнейший город Германии»). Это не определение объекта и не утверждение. Высказывания об объекте записывают как [TRIPLE](/ru/grammar/edge/triple/). Раскладка та же, что у [LABEL](/ru/grammar/edge/label/). Описание и его язык хранятся в одном Object, [UTF8-LANGUAGE-TEXT](/ru/grammar/value/text/utf8-language-text/). Полей с сырым значением нет.

## Раскладка

```
TAG WORD          0001 0LLL L000 0110
[TAG расширения Length]
Edge Id           запись LOCAL Reference
Subject           1 запись Reference
Object            Value UTF8-LANGUAGE-TEXT или 1 запись LOCAL Reference
```

## Интерпретация и допустимость

- Правила для Subject и Object те же, что у [LABEL](/ru/grammar/edge/label/). Subject -- ровно одна полная запись Reference. Object -- ровно одна полная запись UTF8-LANGUAGE-TEXT (`0x4A`, `0x4B`) либо LOCAL Reference, разрешаемый в UTF8-LANGUAGE-TEXT через привязку [REFERENCE-NODE](/ru/grammar/edge/reference-node/) того же документа.
- Текст без языка (UTF8-TEXT) DESCRIPTION быть не может. Описание одно на язык, и правило работает только при наличии языка. Описание, общее для нескольких языков, записывают с языком `mul`.
- DESCRIPTION с одним Subject и языком -- не более одного.
- Описание служит для отличия от других объектов с тем же именем. Желательно, чтобы пара LABEL и DESCRIPTION на одном языке не совпадала у двух объектов, но спецификация этого не проверяет (в Wikidata это тоже лишь рекомендация, а не принуждение).
- Документ спецификации geul.org ограничивает Object через [CODEC](/ru/grammar/edge/codec/) (`084A`, `084B`, `0008`, как у LABEL).

## Длина

```
всего = 1 + N_len + N_id + N_subject + N_object WORD
```

- Языковую запись Object и число байтов текста ведёт запись Object. Позиция после чтения последней записи должна точно совпасть с концом Edge.
- Описание длиннее метки, поэтому и Object, и Edge легко превышают 15 WORD. Тогда используют расширение Length ([запись](/ru/grammar/record/)).

## Пример (ненормативный)

Edge Id `0009`, Subject Q64 (`00A0 0040`), Object `capital and largest city of Germany` (en). Язык -- пример формата LANGUAGE-BCP47-CODE (у `en` есть номер в реестре `0x0784`, поэтому его можно записать и как SHORT-CODE).

- Object -- язык `08C6 656E` (BCP47 `en`, 2 WORD) + текст 35 байт (нечётное, 18 WORD), то есть `0x4B`, TAG 1 + TAG расширения 1 + 20 = 22 WORD, `0F4B 0016 …`.
- Edge -- TAG 1 + TAG расширения 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD, поэтому `LLLL=1110`, TAG `1706`, TAG расширения `001C`.

```
1706 001C 0088 0009 00A0 0040
0F4B 0016 08C6 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Соответствие Wikidata

- `descriptions` элемента (по одному на язык) → по одному DESCRIPTION на язык. Код языка переносится по той же таблице соответствия кодов языков, что и у LABEL.

## Открытые вопросы

- Есть ли случаи, где стоит разрешить описание в UTF8-TEXT без языка (сейчас не разрешено).

## Связанные страницы

- [Edge](/ru/grammar/edge/), [LABEL](/ru/grammar/edge/label/), [ALIAS](/ru/grammar/edge/alias/), [CODEC](/ru/grammar/edge/codec/)
- [UTF8-LANGUAGE-TEXT](/ru/grammar/value/text/utf8-language-text/), [LOCAL](/ru/grammar/reference/local/), [REFERENCE-NODE](/ru/grammar/edge/reference-node/)
