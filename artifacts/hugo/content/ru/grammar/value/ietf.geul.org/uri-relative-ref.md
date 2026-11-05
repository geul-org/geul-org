---
title: "URI-RELATIVE-REF"
weight: 1036
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF — Value, содержащее ASCII-байты по грамматике relative-ref из RFC 3986."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF — Value, содержащее ASCII-байты по грамматике `relative-ref` из RFC 3986. Base URI и результат resolve в Payload не помещаются.

## Раскладка {#레이아웃}

- Код: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, номер Codec `0x00008000` (чётное число байт) и `0x00008001` (нечётное число байт). Семейство TEXT.
- Число байт определяется младшим битом номера Codec и числом WORD Payload: `2 × число WORD Payload − младший бит`; Byte Count не вводится ([Value](../_index.md)).

```
TAG WORD            0000 1001 1101 LLLL      Codec 0x09DL
[Length расш. TAG]  если всего 15 WORD и более
Issuer              2 WORD  0x00000007 (IETF)
Номер Codec         2 WORD  0x00008000/0x00008001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## Интерпретация и действительность {#해석과-유효성}

- Последовательность байт должна соответствовать грамматике RFC 3986 `relative-ref = relative-part [ "?" query ] [ "#" fragment ]`.
- Терминалы грамматики URI — символы US-ASCII. Допустимые символы ASCII хранятся как есть, а при percent-encoding octet используется форма `pct-encoded = "%" HEXDIG HEXDIG`. Не-ASCII символы нельзя помещать напрямую литеральными байтами.
- Поскольку `relative-part` может быть `path-empty`, пустая последовательность байт тоже грамматически допустимый `relative-ref`.
- Base URI, контекст resolution и результат resolve относятся к контексту вне этого формата.
- Внутри WORD первым идёт старший byte. Если число байт нечётно (нечётный код), неиспользуемый младший byte последнего WORD должен быть `00`.
- Число WORD Payload равно `ceil(число байт/2)`. Если код нечётный, а младший byte последнего WORD не равен `00`, значение отклоняется.

## Стандартные основания {#표준-근거}

- Грамматика `relative-ref`, символов URI и percent-encoding следует [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- Пара чётного и нечётного кодов, нулевое заполнение, TAG/Length GEUL и размещение в 16-битных WORD — правила framing этого формата. Base URI и результат интерпретации ссылки относятся к контексту RFC, но в Payload не помещаются.

## Длина {#길이}

- Общая длина — число WORD: TAG 1 WORD, расширяющий TAG Length (если есть), Issuer 2 WORD, номер Codec 2 WORD и Payload. До 14 WORD включительно используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; расширяющий TAG тоже входит в общее число ([Length](../../record.md)).
- 0 byte по смыслу допустимо как пустой `relative-ref` и не имеет WORD Payload. Его физическая раскладка — открытая проблема ниже.

## Пример {#예시}

- `a/b?x=1` — это 7 byte (нечётное число), поэтому номер Codec `0x00008001`, а Payload `612F 623F 783D 3100`. Всего 9 WORD, значит `LLLL=1000`. Целиком: `09D8 0000 0007 0000 8001 612F 623F 783D 3100`.

## Открытые проблемы {#열린-문제}

- Физическая раскладка пустого `relative-ref` (0 byte). Запись без Payload не согласуется с правилом «минимальный Payload 1 WORD», поэтому пока не определена.
