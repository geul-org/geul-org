---
title: "UTF8-LANGUAGE-TEXT"
weight: 75
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-30T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT — текст с языком: одна запись языкового Value и текст UTF-8 в одном Value (Codec 0x4A/0x4B)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT — это текст с языком. Одна запись языкового Value и последовательность байт UTF-8 помещаются в один Value.

[UTF8-TEXT](/ru/grammar/value/text/utf8-text/) — строка без языка (идентификатор, код, имя файла, исходные байты), а этот формат — текст с языком (имя, заголовок, лозунг, предложение). Это разные значения, даже если байты совпадают. «Paris» (строка) и «Paris» (французский) не равны. Это то же разделение, что в RDF между `xsd:string` и `rdf:langString`.

## Раскладка

- Код: прямой код Value `0x4A` (текст с чётным числом байт) и `0x4B` (текст с нечётным числом байт). Семейство TEXT.

```
TAG WORD          0000 1LLL L100 101P      Codec 0x4A/0x4B (P = текст имеет нечётное число байт)
[Length extension TAG] если всего 15 WORD и более
Language          одна запись Value LANGUAGE-SHORT-CODE или LANGUAGE-BCP47-CODE (с TAG)
Text WORD 1st ... Nth             байты UTF-8 / при нечётном числе последний 0x00
```

## Интерпретация и допустимость

- Payload начинается с записи языка. Первый WORD Payload читается как TAG, и ровно столько, сколько указывает его Length, занимает запись языка, а остальное — байты текста. Запись языка обязательна. Если языка нет, используйте не этот формат, а UTF8-TEXT.
- Запись языка — ровно одна полная запись [LANGUAGE-SHORT-CODE](/ru/grammar/value/text/language-short-code/) (`0x48`) или [LANGUAGE-BCP47-CODE](/ru/grammar/value/text/language-bcp47-code/) (`0x46`, `0x47`). Другой Codec или неполная запись недопустимы. Допустимость записи языка определяется правилами соответствующего формата.
- Можно использовать обе языковые формы. Правило сравнения «тот же ли язык» такое же, как у [LABEL](/ru/grammar/edge/label/). SHORT-CODE и тег BCP 47, который реестр привязал к его номеру, — это один и тот же язык.
- `zxx` (нет лингвистического содержания) не используется. Такая строка — UTF8-TEXT. `und` (язык не определён) и `mul` (несколько языков) — тексты с языком, поэтому их использовать можно.
- Байты текста подчиняются тем же правилам, что и в UTF8-TEXT. Это должен быть well-formed UTF-8, U+FEFF в начале разрешён как символ, нормализация не навязывается, а исходный текст сохраняется как есть. Сравнивающая и индексирующая сторона приводит его к NFC при сравнении.
- Число байт текста равно `2 × (число WORD Payload − число WORD записи языка) − P`. P (младший бит Codec) показывает только чётность числа байт текста. Если оно нечётное, младший byte последнего WORD должен быть `00`.
- Пустой текст (0 byte) — это чётный код, в котором есть только запись языка.

## Где используется

- Значение monolingualtext Wikidata: `{"text":"Bundesrepublik Deutschland","language":"de"}` превращается в один такой формат. Оно напрямую помещается в Object [TRIPLE](/ru/grammar/edge/triple/) и в Value [QUALIFIER](/ru/grammar/edge/qualifier/). Свойство, rank и qualifier обеспечивает TRIPLE.
- Object у [LABEL](/ru/grammar/edge/label/) и [ALIAS](/ru/grammar/edge/alias/). Имя и язык несёт одно это значение.
- Тексты с заданным языком, например названия законов и статей.

## Соответствие кодов языка (Wikidata)

- Не все коды языков Wikidata и Wikimedia являются BCP 47 (например, `simple`, `map-bms`). Они переводятся в теги BCP 47 по таблице соответствий. Коды, которые перевести нельзя, обрабатываются по-разному в зависимости от применения.
  - Значение (monolingualtext): исходный datavalue сохраняется как UTF8-TEXT. Значение — часть утверждения, и если его отбросить, утверждение изменится.
  - Label, description, alias: пропускаются и фиксируются в отчёте. Эти Edge существуют только при наличии языка (текст без языка недопустим), а исходный текст остаётся в исходных данных.
- Если полученный тег имеет номер в GEUL Language Registry, используется LANGUAGE-SHORT-CODE, иначе — LANGUAGE-BCP47-CODE.

## Длина

- Всего — число WORD: TAG 1 WORD, Length extension TAG (если есть), запись языка и WORD текста. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина ([Length](/ru/grammar/record/)).
- Запись языка — 2 WORD для SHORT-CODE и `ceil(байт тега/2) + 1` WORD для BCP 47 (`de` — 2 WORD, `zh-Hant` — 5 WORD).

## Примеры

Все языки здесь — примеры формата LANGUAGE-BCP47-CODE. У `fr`, `ko` и `de` есть номера в реестре, поэтому их можно записать и как SHORT-CODE (2 WORD).

| Значение | Байт текста | Все WORD |
|---|---|---|
| "Paris" (fr) | 5 (нечётное) | `0ACB 08C6 6672 5061 7269 7300` |
| "" (ko) | 0 | `094A 08C6 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (чётное) | `0F4A 0011 08C6 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- «Paris»: TAG `0ACB` (Codec `0x4B`, `LLLL=0101`, всего 6 WORD), язык `08C6 6672` (BCP 47 `fr`), текст `5061 7269 7300` (5 byte, последний `00`).
- Третий пример занимает 17 WORD, поэтому используется Length extension (`LLLL=1110` в `0F4A`, extension TAG `0011`).

## Основание в стандартах

- Language tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`, `und` и `mul` — special-коды IANA Language Subtag Registry.
- Текст: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Различие строки и текста с языком: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## Открытые вопросы

- Проверка грамматики тега BCP 47 на уровне схемы. Сейчас проверяется только то, что значение ASCII и не пусто.

## Связанные страницы

- [Value](/ru/grammar/value/), [UTF8-TEXT](/ru/grammar/value/text/utf8-text/), [LANGUAGE-SHORT-CODE](/ru/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/ru/grammar/value/text/language-bcp47-code/), [LABEL](/ru/grammar/edge/label/)
