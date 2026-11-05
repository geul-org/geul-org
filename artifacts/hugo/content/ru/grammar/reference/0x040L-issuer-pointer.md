---
title: "ISSUER-POINTER (0x040L)"
weight: 64
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER — указывающе-объявляющий Reference, указывающий на сам Issuer."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `ISSUER-POINTER` (BIND `ISSUER-POINTER` в документе спецификации) |
| TAG ID | `0x040L` |
| Codec ID | `0x00000400` |
| Документ спецификации | `0x00000000/codecs/0x00000400/` (цель DECLARE `0400`) |
| Раздел | 2 `0010` (Reference прочее), смещение внутри раздела C = 0 |
| Kind | Reference · классификация: указание-объявление |
| TAG WORD | `0000 0100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Сторона Hugo | `reference/issuer-pointer.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемая форма (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | остаток, простое значение (`0xFFFF`) |  |  |

ISSUER-POINTER — указывающе-объявляющий Reference, указывающий на сам Issuer. Он становится целью `BIND`, `LABEL` и Edge вердикта для имени Issuer.

## Раскладка {#레이아웃}

```
TAG WORD          0000 0100 0000 LLLL      Codec 0x040L
[расширяющий TAG Length]
Issuer            2/4/16 WORD
```

- Ширина Issuer — весь Payload. Codec ширину не делит. Если ширина не 2, 4, 16 WORD или значение Issuer помещается в более узкую ширину, это invalid (каноническая форма Issuer).
- Если Issuer занимает 16 WORD, всего получается 17 WORD, поэтому добавляется 1 WORD расширения Length.
- Это одна ячейка Codec `0x040L`. Квантификации нет (Identified).
- Значение Issuer следует назначению в [Issuer](../issuer.md).
- Применение: Subject BIND в списке Issuer `issuers/` ([адреса публикации и список версий](../publishing.md#issuer-목록)), LABEL с отображаемым именем Issuer, вердикты об Issuer, подписант и другие места, где целью является сам Issuer.
- Форма для указания на сам Issuer — только ISSUER-POINTER. Указывать на Issuer через `EXTERNAL-ISSUER-*` с ID документа `0` и ID цели `0` — invalid.

## Пример {#예시}

| Issuer | WORD sequence |
|---|---|
| GEUL `0x00000000` | `0402 0000 0000` |
| IEEE `0x0000000D` | `0402 0000 000D` |

## Связанные страницы {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [Issuer и публикация](../issuer.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000400/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000040000000000
BODY
#1 DECLARE 0x0400
#2 FIELD #1 rest
#3 BIND #1 "ISSUER-POINTER"
#4 BIND #2 "issuer"
```
