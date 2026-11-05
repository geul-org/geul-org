---
title: "LANGUAGE-BCP47-CODE (0x076L·0x077L)"
weight: 118
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE — Value, хранящий полный языковой тег BCP 47 в виде ASCII-последовательности байтов."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE — Value, хранящий полный языковой тег BCP 47 в виде ASCII-последовательности байтов. Используется пара кодов «чётный/нечётный»: 0x076L/0x077L.

| Пункт | Значение |
|---|---|
| Имя | `LANGUAGE-BCP47-CODE` (группа «чётный/нечётный». Имена по кодам — в таблице участников ниже) |
| TAG ID | `0x076L`·`0x077L` |
| Раздел | 3 `0011` (Value), смещение C внутри раздела = 22~23 |
| Kind | Value · семейство: TEXT |
| Описание в индексе | ASCII-последовательность байтов полного языкового тега BCP 47 в canonical casing. Чётное и нечётное число байтов |
| Сторона Hugo | `value/text/language-bcp47-code.md` |

## Участники {#구성원}

Эта страница охватывает пару кодов «чётный/нечётный». У чётного кода число байтов чётное, у нечётного — нечётное ([запись и TAG WORD](../record.md#가변-길이-바이트열)). Документ Codec заведён на каждый код. Поля в двух документах Codec совпадают, различаются только цель DECLARE и имя (BIND).

| TAG ID | Имя | Число байтов | Codec ID | Документ спецификации | TAG WORD |
|---|---|---|---|---|---|
| `0x076L` | `LANGUAGE-BCP47-CODE-EVEN` | чётное | `0x00000760` | `0x00000000/codecs/0x00000760/` | `0000 0111 0110 LLLL` |
| `0x077L` | `LANGUAGE-BCP47-CODE-ODD` | нечётное | `0x00000770` | `0x00000000/codecs/0x00000770/` | `0000 0111 0111 LLLL` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | остаток, простое значение (`0xFFFF`) |  |  |

LANGUAGE-BCP47-CODE — Value, хранящий полный языковой тег BCP 47. Применяется, когда язык нужно указать точно, вплоть до script, region и variant.

## Раскладка {#레이아웃}

- Код: прямой код Value `0x076L` (чётное число байтов) и `0x077L` (нечётное число байтов). Семейство TEXT.
- Число байтов определяется младшим битом Codec и числом Payload WORD: `2 × число Payload WORD − младший бит`. Byte Count не вводится ([Value](_index.md)).
- Payload — не текст UTF-8, а ASCII-последовательность байтов тега BCP 47.

```
TAG WORD          0000 0111 011P LLLL      Codec 0x076L/0x077L
[расширяющий Length TAG] если всего 15 WORD и более
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## Интерпретация и действительность {#해석과-유효성}

- Последовательность байтов должна быть well-formed языковым тегом BCP 47 по RFC 5646. Пустая строка не допускается.
- В Payload используются только ASCII-буквы, цифры и дефис-минус `-`. Разделителем обязательно служит ASCII `-`; `_`, пробелы и не-ASCII символы не допускаются.
- Сравнение тегов BCP 47 не учитывает регистр. Canonical profile GEUL записывает все разделители как `-`, а подтеги language/extlang/variant/extension/private-use — строчными, script — в Titlecase, region — заглавными.
- Одной well-formed формы недостаточно. Действительность registered подтегов и grandfathered тегов определяется по конкретному snapshot реестра IANA Language Subtag Registry, и дату этого snapshot или версию реестра нужно сохранять вместе со значением.
- Теги private-use и подтеги private-use допускаются, если они well-formed по грамматике RFC 5646. Но их смысл зависит от договорённости сторон и не определён реестром IANA, поэтому общая совместимость не гарантируется.
- Если в том же snapshot у deprecated подтега или grandfathered тега есть Preferred-Value, каноническая форма GEUL записывает эту замену в canonical casing. Тег в устаревшей записи можно принять как вход, но каноническим форматом хранения он не является.
- BCP 47 — ASCII-профиль, поэтому требования Unicode normalization вроде UTF-8 NFC не применяются.
- Внутри WORD старший byte идёт первым. Если число байтов нечётное (нечётный код), неиспользуемый младший byte последнего WORD должен быть `00`.
- Число Payload WORD равно `ceil(число байтов/2)`. Если код нечётный, а младший byte последнего WORD не равен `00`, значение отвергается.

## Основание в стандартах {#표준-근거}

- Грамматика языковых тегов, нечувствительность к регистру и понятия deprecated/Preferred-Value соответствуют [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- Реестр, по которому определяется действительность тега, — [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- Пара кодов «чётный/нечётный», zero padding, политика хранения в canonical casing и расчёт Length — правила обрамления GEUL.

## Длина {#길이}

- Всего — число WORD: 1 WORD TAG, расширяющий Length TAG (если есть) и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`; расширяющий TAG также входит в общее число ([Length](../record.md)).

## Связь с LANGUAGE-SHORT-CODE {#language-short-code와의-관계}

- Тег, у которого есть номер в GEUL Language Registry, можно записать одним WORD [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md).
- Тег без номера в реестре (в том числе тег с extension и private-use) записывается как LANGUAGE-BCP47-CODE. LANGUAGE-BCP47-CODE используется и тогда, когда нужно сохранить исходный вид полного тега.
- SHORT-CODE `n` и LANGUAGE-BCP47-CODE тега, связанного в реестре с `n` (без учёта регистра), обозначают один и тот же язык.

## Пример {#예시}

- `ko-KR` — ASCII, 5 byte (нечётное), поэтому `LANGUAGE-BCP47-CODE-ODD` (`0x077L`), Payload — `6B6F 2D4B 5200`.
- TAG 1 WORD и Payload 3 WORD дают всего 4 WORD, `LLLL=0011`. Целиком: `0773 6B6F 2D4B 5200`.

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00000760/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные цифры заглавные).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000076000000000
BODY
#1 DECLARE 0x0760
#2 FIELD #1 rest
#3 BIND #1 "LANGUAGE-BCP47-CODE-EVEN"
#4 BIND #2 "bytes"
```

Выше — документ Codec для `LANGUAGE-BCP47-CODE-EVEN` (`0x076L`). В документах Codec других участников (`LANGUAGE-BCP47-CODE-ODD`) различаются только Codec ID в DOC-ID, цель DECLARE и имя, привязанное в `#1` (BIND).
