---
title: "DEFAULT-LANGUAGE (0x1CAL)"
weight: 458
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Объявляет язык текста документа по умолчанию."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `DEFAULT-LANGUAGE` (BIND документа спецификации `DEFAULT-LANGUAGE`) |
| TAG ID | `0x1CAL` |
| Codec ID | `0x00001CA0` |
| Документ спецификации | `0x00000000/codecs/0x00001CA0/` (цель DECLARE `1CA0`) |
| Раздел | 14 `1110` (Meta), смещение в разделе C = 10 |
| Kind | Meta · класс: объявление |
| TAG WORD | `0001 1100 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Язык по умолчанию |
| Сторона Hugo | `meta/declaration/default-language.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | запись | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |

Объявляет язык текста документа по умолчанию. Текст, язык которого отдельно не указан, считается написанным на этом языке.

## Раскладка {#레이아웃}

```
TAG WORD          0001 1100 1010 LLLL      Codec 0x1CAL
[Length — расширяющий TAG]
Payload           один Value языка
```

- Codec: Meta `0x1CAL`, класс объявления
- Payload: встроенный Value ([LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md) или [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md))
- Количество: не более одного

## Интерпретация и валидность {#해석과-유효성}

- В документах TANGEUL указывается локаль написания (например, `en`, `ko`).

## Пример {#예시}

- `en`: `0x1CA2 0x0761 0x656E`

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001CA0/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CA000000000
BODY
#1 DECLARE 0x1CA0
#2 FIELD #1 record
#3 BIND #1 "DEFAULT-LANGUAGE"
#4 BIND #2 "language"
#5 CODEC #2 0x07A0
#6 CODEC #2 0x0760
#7 CODEC #2 0x0770
```
