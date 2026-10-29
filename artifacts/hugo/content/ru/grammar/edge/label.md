---
title: "LABEL"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL -- описательный Edge, который связывает с Subject одно имя на конкретном языке через Object UTF8-LANGUAGE-TEXT (Codec 0x04)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL -- описательный Edge, который связывает с Subject одно имя (label) на конкретном языке в роли Object. Codec `0x04`. Это не Edge, представляющий лемму в общей лексикологии.

Имя и его язык хранятся в одном Object, [UTF8-LANGUAGE-TEXT](/ru/grammar/value/text/utf8-language-text/). Полей с сырым значением нет.

## Раскладка

```
TAG WORD          0001 0LLL L000 0100
[TAG расширения Length]
Edge Id           запись LOCAL Reference
Subject           1 запись Reference
Object            Value UTF8-LANGUAGE-TEXT или 1 запись LOCAL Reference
```

## Интерпретация и допустимость

- Subject -- ровно одна полная запись Reference. Границу находят по Length самого Subject; если это не Reference или запись неполная, это invalid.
- Object -- ровно одна полная запись [UTF8-LANGUAGE-TEXT](/ru/grammar/value/text/utf8-language-text/) (`0x4A`, `0x4B`). Правила языка и текста (допускаются обе языковые формы, сравнение одного языка) следуют этому формату.
- Object может быть и LOCAL Reference. Тогда он должен разрешаться в UTF8-LANGUAGE-TEXT через привязку [REFERENCE-NODE](/ru/grammar/edge/reference-node/) того же документа. Если он не разрешается или разрешается в объект другого рода, это invalid.
- Документ спецификации geul.org записывает это ограничение через [CODEC](/ru/grammar/edge/codec/) (Object = `084A`, `084B`, `0008`). Цель разрешения LOCAL через CODEC не выражается.
- Если Object не одна из двух форм выше или запись неполная, это invalid. Текст без языка (UTF8-TEXT) LABEL быть не может. Машинное имя без языка записывают через [BIND](/ru/grammar/edge/bind/). Имя, общее для нескольких языков, записывают с языком `mul`.
- LABEL с одним Subject и языком -- не более одного. Другие имена записывают как [ALIAS](/ru/grammar/edge/alias/).

## Длина

```
всего = 1 + N_len + N_id + N_subject + N_object WORD
```

- Языковую запись Object и число байтов текста ведёт не Edge, а запись Object. Позиция после чтения последней записи должна точно совпасть с концом Edge.

## Пример (ненормативный)

Код языка `0784` для `en` -- номер в GEUL Language Registry v2 (документ спецификации `0x0000/0x0000000000000848`, версия 2).

### LANGUAGE-SHORT-CODE

Edge Id `0007`, Subject Q22686 (`00A0 589e`), Object `Donald Trump` (en).

- Object -- язык `08C8 0784` (SHORT-CODE, 2 WORD) + текст 12 байт (чётное, 6 WORD), то есть `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), всего 9 WORD: `0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70`.
- Edge -- TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. TAG -- `1684`.

```
1684 0088 0007 00A0 589e 0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70
```

### LANGUAGE-BCP47-CODE

Edge Id `0008`, Subject Q155 (`00A0 009b`), Object `Brasil` (pt-BR).

- Object -- язык `09C7 7074 2d42 5200` (BCP47 `pt-BR`, 4 WORD) + текст 6 байт (чётное, 3 WORD), всего 8 WORD: `0BCA 09C7 7074 2d42 5200 4272 6173 696c`.
- Edge -- TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, `LLLL=1100`. TAG -- `1604`.

```
1604 0088 0008 00A0 009b 0BCA 09C7 7074 2d42 5200 4272 6173 696c
```

## Связанные страницы

- [Edge](/ru/grammar/edge/), [ALIAS](/ru/grammar/edge/alias/), [DESCRIPTION](/ru/grammar/edge/description/), [BIND](/ru/grammar/edge/bind/)
- [UTF8-LANGUAGE-TEXT](/ru/grammar/value/text/utf8-language-text/), [LANGUAGE-SHORT-CODE](/ru/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/ru/grammar/value/text/language-bcp47-code/)
- [LOCAL](/ru/grammar/reference/local/), [REFERENCE-NODE](/ru/grammar/edge/reference-node/)
