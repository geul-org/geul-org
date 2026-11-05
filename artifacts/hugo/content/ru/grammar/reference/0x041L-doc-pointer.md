---
title: "DOC-POINTER (0x041L)"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER — указывающе-объявляющий Reference, указывающий на одну версию документа, опубликованного Issuer."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `DOC-POINTER` (BIND `DOC-POINTER` в документе спецификации) |
| TAG ID | `0x041L` |
| Codec ID | `0x00000410` |
| Документ спецификации | `0x00000000/codecs/0x00000410/` (цель DECLARE `0410`) |
| Раздел | 2 `0010` (Reference прочее), смещение внутри раздела C = 1 |
| Kind | Reference · классификация: указание-объявление |
| TAG WORD | `0000 0100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Сторона Hugo | `reference/doc-pointer.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемая форма (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | остаток, простое значение (`0xFFFF`) |  |  |
| 2 | `doc` | #3 | простое значение 4 WORD |  |  |
| 3 | `version` | #4 | простое значение 2 WORD |  |  |

DOC-POINTER — указывающе-объявляющий Reference, указывающий на одну версию документа, опубликованного Issuer. Он становится целью публикации, deprecate и удаления документа, цитируемой редакции и высказываний о документе.

## Раскладка {#레이아웃}

```
TAG WORD          0000 0100 0001 LLLL      Codec 0x041L
[расширяющий TAG Length]
Issuer            2/4/16 WORD
ID документа      4 WORD
ID версии         2 WORD
```

## Интерпретация и действительность {#해석과-유효성}

- Ширина Issuer — остаток Payload после вычитания ID документа и ID версии (6 WORD). Codec ширину не делит. Если ширина не 2, 4, 16 WORD или значение Issuer помещается в более узкую ширину, это invalid (каноническая форма Issuer).
- ID версии не опускают. Если разрешить опускание, ширину Issuer нельзя будет определить по одной длине Payload (Issuer 4 WORD без версии и Issuer 2 WORD с версией дают одинаковые 8 WORD).
- ID версии `0` — последняя версия. Он привязывается к действующей версии на момент интерпретации. Остальные значения фиксируются на этой версии ([PUBLICATION](../edge/0x0B8L-publication.md)).
- Документ с ID `0` — индексный документ определений терминов Issuer. На сам Issuer указывают через [ISSUER-POINTER](0x040L-issuer-pointer.md).
- Каждый Issuer резервирует ID документа `0x0000000000000000` и `0xFFFFFFFFFFFFFFFF` ([Issuer и публикация](../issuer.md#용어-정의-문서)). `0xFFFFFFFFFFFFFFFF` используется для списка Issuer `issuers/` у Issuer `0x00000000`, другие Issuer его не используют. PUBLICATION, DEPRECATION и TOMBSTONE в `issuers/versions.geul` указывают этим значением на версии списка ([адреса публикации и список версий](../publishing.md#목록-문서)).
- Это одна ячейка Codec `0x041L`. Квантификации нет (Identified).
- Форма для указания на документ Issuer — только DOC-POINTER. Указывать на документ через `EXTERNAL-ISSUER-*` (Issuer, ID документа, ID цели `0`) или `EXTERNAL-POINTER-*` (IMPORT ID, ID цели `0`) — invalid.
- Где используется: Meta [DOC-ID](../meta/0x1C7L-doc-id.md) и [IMPORT-DOC](../meta/0x1E4L-import-doc.md), PUBLICATION, DEPRECATION и TOMBSTONE в списке версий.
- У документа кодека нет ID документа. На документ кодека и его версию указывают через [CODEC-POINTER](0x042L-codec-pointer.md).

## Пример {#예시}

Документ `0xFFFF000000000001` Issuer GEUL `0x00000000`.

| Версия | WORD sequence |
|---|---|
| 1 | `0418 0000 0000 FFFF 0000 0000 0001 0000 0001` |
| последняя (`0`) | `0418 0000 0000 FFFF 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 2 + ID документа 4 + ID версии 2 = 9 WORD, `LLLL=1000`. TAG — `0000 0100 0001 1000` = `0418`.

## Связанные страницы {#관련-페이지}

- [Reference](_index.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [PUBLICATION](../edge/0x0B8L-publication.md)
- [Issuer и публикация](../issuer.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000410/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000041000000000
BODY
#1 DECLARE 0x0410
#2 FIELD #1 rest
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "DOC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "version"
```
