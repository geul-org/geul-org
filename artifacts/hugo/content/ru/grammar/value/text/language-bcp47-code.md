---
title: "LANGUAGE-BCP47-CODE"
weight: 71
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE — Value, хранящий полный language tag BCP 47 как ASCII-последовательность байт. Использует пару кодов чётных/нечётных байт 0x46/0x47."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE — это Value, хранящий полный language tag BCP 47. Используется, когда язык нужно записать точно, вплоть до script, region и variant.

## Раскладка

- Код: прямой код Value `0x46` (чётное число байт) и `0x47` (нечётное число байт). Семейство TEXT.
- Число байт определяется младшим битом Codec и числом WORD Payload: `2 × число WORD Payload − младший бит`; Byte Count не используется ([Value](/ru/grammar/value/)).
- Payload — не UTF-8 текст, а ASCII-последовательность байт тега BCP 47.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x46/0x47
[Length extension TAG] если всего 15 WORD и более
Payload WORD 1st ... Nth          байты тега BCP 47 / нулевой padding в конце
```

## Интерпретация и допустимость

- Последовательность байт должна быть well-formed language tag BCP 47 по RFC 5646. Пустая строка не допускается.
- В Payload используются только ASCII-буквы, цифры и hyphen-minus `-`. Разделитель обязательно ASCII `-`; `_`, пробелы и не-ASCII символы не допускаются.
- Сравнение тегов BCP 47 не зависит от регистра. Canonical profile GEUL записывает все разделители как `-`, subtag language/extlang/variant/extension/private-use — строчными буквами, script — в Titlecase, region — прописными.
- Одной well-formed недостаточно. Допустимость registered subtag и grandfathered tag определяется по конкретному snapshot IANA Language Subtag Registry, и дату snapshot или версию registry нужно сохранять вместе со значением.
- Private-use tag и private-use subtag допускаются, если они well-formed по грамматике RFC 5646. Но их смысл зависит от договорённости сторон и не определён в registry IANA, поэтому общая совместимость не гарантируется.
- Если в том же snapshot у deprecated subtag или grandfathered tag есть Preferred-Value, canonical форма GEUL использует это заменяющее значение в canonical регистре. Тег в deprecated-написании можно принять как вход, но canonical формой хранения он не является.
- BCP 47 — это ASCII profile, поэтому требования нормализации Unicode, такие как UTF-8 NFC, не применяются.
- Внутри WORD первым идёт старший byte. Если число байт нечётное (нечётный код), неиспользуемый младший byte последнего WORD должен быть `00`.
- Число WORD Payload равно `ceil(число байт/2)`. Если код нечётный, а младший byte последнего WORD не `00`, значение отклоняется.

## Основание в стандартах

- Грамматика language tag, нечувствительная к регистру интерпретация и понятия deprecated/Preferred-Value следуют [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- Registry, по которому определяется допустимость тега, — [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- Пара чётного/нечётного кодов, нулевой padding, политика хранения в canonical регистре и вычисление Length — правила framing GEUL.

## Длина

- Всего — число WORD: TAG 1 WORD, Length extension TAG (если есть) и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110`/`1111`, и extension TAG тоже входит в общее число ([Length](/ru/grammar/record/)).

## Связь с LANGUAGE-SHORT-CODE

- Тег, у которого есть номер в GEUL Language Registry, можно записать в 1 WORD как [LANGUAGE-SHORT-CODE](/ru/grammar/value/text/language-short-code/).
- Тег без номера в реестре (включая теги с extension или private-use) записывается как LANGUAGE-BCP47-CODE. LANGUAGE-BCP47-CODE используется и тогда, когда нужно сохранить исходную запись полного тега.
- SHORT-CODE `n` и LANGUAGE-BCP47-CODE тега, который реестр привязал к `n` (без учёта регистра), обозначают один и тот же язык.

## Пример

- `ko-KR` — это 5 байт ASCII (нечётное число), поэтому используется `LANGUAGE-BCP47-CODE-ODD` (`0x47`), Payload — `6b6f 2d4b 5200`.
- TAG 1 WORD и Payload 3 WORD дают всего 4 WORD, `LLLL=0011`. Целиком: `09C7 6b6f 2d4b 5200`.
