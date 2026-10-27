---
title: "URI-RELATIVE-REF"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF — Value, хранящий ASCII-последовательность байт по грамматике relative-ref RFC 3986. Использует номера форматов 0x8000/0x8001 Issuer IETF."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF — это Value, хранящий ASCII-последовательность байт по грамматике `relative-ref` RFC 3986. Base URI и результат resolve в Payload не помещаются.

## Раскладка

- Код: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, номер формата `0x8000` (чётное число байт) и `0x8001` (нечётное число байт). Семейство TEXT.
- Число байт определяется младшим битом номера формата и числом WORD Payload: `2 × число WORD Payload − младший бит`; Byte Count не используется ([Value](/ru/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] если всего 15 WORD и более
Issuer            1 WORD  0x0020 (IETF)
Номер формата     1 WORD  0x8000/0x8001
Payload WORD 1st ... Nth          байты relative-ref / нулевой padding в конце
```

## Интерпретация и допустимость

- Последовательность байт должна соответствовать грамматике RFC 3986 `relative-ref = relative-part [ "?" query ] [ "#" fragment ]`.
- Терминалы грамматики URI — символы US-ASCII. Допустимые ASCII-символы хранятся как есть, а percent-encoding octet использует форму `pct-encoded = "%" HEXDIG HEXDIG`. Не-ASCII символы нельзя вставлять напрямую как literal byte.
- Поскольку `relative-part` может быть `path-empty`, пустая последовательность байт — тоже грамматически допустимый `relative-ref`.
- Base URI, контекст resolution и результат resolve относятся к контексту вне этого формата.
- Внутри WORD первым идёт старший byte. Если число байт нечётное (нечётный код), неиспользуемый младший byte последнего WORD должен быть `00`.
- Число WORD Payload равно `ceil(число байт/2)`. Если код нечётный, а младший byte последнего WORD не `00`, значение отклоняется.

## Основание в стандартах

- Грамматика `relative-ref`, символов URI и percent-encoding следует [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- Пара чётного/нечётного кодов, нулевой padding, GEUL TAG/Length и размещение в 16-битных WORD — правила framing этого формата. Base URI и результат интерпретации ссылки относятся к контексту RFC, но в Payload не помещаются.

## Длина

- Всего — число WORD: TAG 1 WORD, Length extension TAG (если есть), Issuer 1 WORD, номер формата 1 WORD и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110`/`1111`, и extension TAG тоже входит в общее число ([Length](/ru/grammar/record/)).
- 0 byte — пустой `relative-ref`, по смыслу допустимый, и WORD Payload нет. Его физическое размещение — в разделе «Открытые вопросы» ниже.

## Примеры

- `a/b?x=1` — 7 байт (нечётное число), поэтому номер формата `0x8001`, Payload `612f 623f 783d 3100`. Всего 7 WORD, значит `LLLL=0110`. Целиком: `0B7C 0020 8001 612f 623f 783d 3100`.

## Открытые вопросы

- Физическое размещение пустого `relative-ref` (0 byte). Запись без Payload не согласуется с правилом «минимум 1 WORD Payload», поэтому пока не определено.
