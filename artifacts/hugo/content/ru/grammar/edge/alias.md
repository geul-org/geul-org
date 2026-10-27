---
title: "ALIAS"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS -- описательный Edge, который связывает с Subject одно другое имя (псевдоним) (Codec 0x05). Раскладка та же, что у LABEL."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS -- описательный Edge, который связывает с Subject одно другое имя (псевдоним) в роли Object. Codec `0x05`.

[LABEL](/ru/grammar/edge/label/) -- основное имя на данном языке (не более одного на язык), а ALIAS -- другое имя того же объекта (на каждом языке их может быть несколько; в Wikidata «also known as»). Используется в основном для поиска. Раскладка и допустимость те же, что у LABEL.

## Раскладка

```
TAG WORD          0001 0LLL L000 0101
[TAG расширения Length]
Edge Id           запись LOCAL Reference
Subject           1 запись Reference
Object            Value UTF8-LANGUAGE-TEXT или 1 запись LOCAL Reference
```

## Интерпретация и допустимость

- Правила для Subject и Object те же, что у [LABEL](/ru/grammar/edge/label/) (Object -- [UTF8-LANGUAGE-TEXT](/ru/grammar/value/text/utf8-language-text/) или LOCAL, разрешаемый в него).
- Для одного Subject и языка можно задать несколько ALIAS. Порядок -- порядок в документе.
- Для одного Subject и языка ALIAS с тем же текстом, что и LABEL, не задают (основного имени достаточно в одном LABEL). Это правило -- рекомендация.
- Документ спецификации geul.org ограничивает Object через [CODEC](/ru/grammar/edge/codec/) (`084A`, `084B`, `0008`, как у LABEL).

## Пример (ненормативный)

Edge Id `0003`, Subject Q42 (`00A0 002a`), Object `DNA` (en): язык `08C6 656e` (BCP47 `en`) + текст 3 байта (нечётное) → `UTF8-LANGUAGE-TEXT-ODD` (`0x4B`), `0A4B 08C6 656e 444e 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, `LLLL=1001`. TAG -- `1485`.

```
1485 0088 0003 00A0 002a 0A4B 08C6 656e 444e 4100
```

## Связанные страницы

- [Edge](/ru/grammar/edge/), [LABEL](/ru/grammar/edge/label/), [DESCRIPTION](/ru/grammar/edge/description/), [UTF8-LANGUAGE-TEXT](/ru/grammar/value/text/utf8-language-text/)
