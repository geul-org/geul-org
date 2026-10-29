---
title: "UTF8-TEXT"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-30T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT — Value, хранящий строку UTF-8 без языка. Использует пару кодов чётных/нечётных байт 0x40/0x41."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT — это Value, хранящий valid UTF-8 последовательность байт по RFC 3629. Используется для строк без языка: идентификаторов, кодов, имён файлов.

## Раскладка

- Код: прямой код Value `0x40` (чётное число байт) и `0x41` (нечётное число байт). Семейство TEXT.
- Число байт определяется младшим битом Codec и числом WORD Payload: `2 × число WORD Payload − младший бит`; Byte Count не используется ([Value](/ru/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x40/0x41
[Length extension TAG] если всего 15 WORD и более
Payload WORD 1st ... Nth          байты UTF-8 / нулевой padding в конце
```

## Интерпретация и допустимость

- Последовательность байт должна быть well-formed shortest-form UTF-8 по грамматике RFC 3629. Результат декодирования содержит только Unicode scalar value в диапазоне `U+0000..U+10FFFF` и не содержит диапазон surrogate `U+D800..U+DFFF`.
- U+FEFF в начале Payload (байты UTF-8 `EF BB BF`) разрешён и является символом, как и U+FEFF в любом другом месте. Обработка signature U+FEFF в начале (BOM), описанная в RFC 3629, не применяется: он не удаляется и не толкуется как signature, исходный текст сохраняется как есть.
- Нормализация Unicode не навязывается. Исходная последовательность декодированных scalar сохраняется как есть.
- Valid последовательность байт UTF-8 помещается в Payload без преобразований. Внутри WORD первым идёт старший byte. Если число байт нечётное (нечётный код), неиспользуемый младший byte последнего WORD должен быть `00`.
- Число WORD Payload равно `ceil(число байт/2)`. Если код нечётный, а младший byte последнего WORD не `00`, значение отклоняется.

## Основание в стандартах

- Диапазон scalar UTF-8 и well-formed последовательности байт следуют [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Пара чётного/нечётного кодов, нулевой padding, GEUL TAG/Length и размещение в 16-битных WORD — canonical правила framing этого формата.

## Длина

- Всего — число WORD: TAG 1 WORD, Length extension TAG (если есть) и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110`/`1111`, и extension TAG тоже входит в общее число ([Length](/ru/grammar/record/)).
- Строка в 0 byte записывается как запись из 1 WORD (только TAG WORD) с чётным кодом ([Value](/ru/grammar/value/)).

## Примеры

- `A` (`41`) — 1 byte (нечётное число), поэтому `UTF8-TEXT-ODD` (`0x41`), Payload `4100`, всего 2 WORD, `LLLL=0001`. Целиком: `08C1 4100`.
- Пустая строка — 1 WORD `0840` (`UTF8-TEXT-EVEN`, только TAG WORD).
