---
title: "CODEC-POINTER (0x042L)"
weight: 66
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "CODEC-POINTER — указывающе-объявляющий Reference, указывающий на одну версию документа кодека, опубликованного Issuer."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC-POINTER — указывающе-объявляющий Reference, указывающий на одну версию документа кодека, опубликованного Issuer. У документа кодека нет ID документа, и на себя и свою версию он указывает через CODEC-POINTER.

| Пункт | Значение |
|---|---|
| Имя | `CODEC-POINTER` (BIND `CODEC-POINTER` в документе спецификации) |
| TAG ID | `0x042L` |
| Codec ID | `0x00000420` |
| Документ спецификации | `0x00000000/codecs/0x00000420/` (цель DECLARE `0420`) |
| Раздел | 2 `0010` (Reference прочее), смещение внутри раздела C = 2 |
| Kind | Reference · классификация: указание-объявление |
| TAG WORD | `0000 0100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Одна версия кодека Issuer. Issuer + Codec ID 2 WORD + ID версии 2 WORD, ID цели нет |
| Сторона Hugo | `reference/codec-pointer.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемая форма (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | остаток, простое значение (`0xFFFF`) |  |  |
| 2 | `codec` | #3 | простое значение 2 WORD |  |  |
| 3 | `version` | #4 | простое значение 2 WORD |  |  |

## Раскладка {#레이아웃}

```
TAG WORD          0000 0100 0010 LLLL      Codec 0x042L
[расширяющий TAG Length]
Issuer            2/4/16 WORD
Codec ID          2 WORD
ID версии         2 WORD
```

## Интерпретация и действительность {#해석과-유효성}

- Ширина Issuer — остаток Payload после вычитания Codec ID и ID версии (4 WORD). Payload равен одному из 6, 8, 20 WORD, любая другая длина invalid. Если значение Issuer помещается в более узкую ширину, это invalid (каноническая форма Issuer).
- Если Issuer занимает 16 WORD, всего получается 21 WORD, поэтому добавляется 1 WORD расширения Length.
- Codec ID — 32 бита. Codec ID прямого кода GEUL — это его TAG WORD (L=0), записанный в 32 битах (TRIPLE `0x0AAL` → `0x00000AA0`). Codec ID кодека Issuer — это номер Codec в записи, и Issuer назначает его так, чтобы он не повторялся внутри его `codecs/`, независимо от Kind ([адреса публикации и список версий](../publishing.md#id-표기)).
- ID версии `0` — последняя версия. Остальные значения фиксируются на этой версии.
- Это одна ячейка Codec `0x042L`. Квантификации нет (Identified). Раздел 2, поэтому как квантификацию или систему его не читают.
- Где используется: Meta [DOC-ID](../meta/0x1C7L-doc-id.md) документа кодека, [PUBLICATION](../edge/0x0B8L-publication.md), DEPRECATION и TOMBSTONE в списке версий кодека, [IMPORT-DOC](../meta/0x1E4L-import-doc.md), подключающий документ кодека. На этих местах он заменяет DOC-POINTER.
- Адрес публикации — `/.well-known/geul/<Issuer>/codecs/<Codec ID>/<ID версии>.geul` ([адреса публикации и список версий](../publishing.md#공표-주소)).

## Пример {#예시}

Кодек TRIPLE (Codec ID `0x00000AA0`) Issuer GEUL `0x00000000`.

| Версия | WORD sequence |
|---|---|
| 1 | `0426 0000 0000 0000 0AA0 0000 0001` |
| последняя (`0`) | `0426 0000 0000 0000 0AA0 0000 0000` |

- TAG 1 + Issuer 2 + Codec ID 2 + ID версии 2 = 7 WORD, `LLLL=0110`. TAG — `0000 0100 0010 0110` = `0426`.

## Связанные страницы {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [документ спецификации Codec](../codec-spec.md)
- [адреса публикации и список версий](../publishing.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00000420/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000042000000000
BODY
#1 DECLARE 0x0420
#2 FIELD #1 rest
#3 FIELD #1 0x0002
#4 FIELD #1 0x0002
#5 BIND #1 "CODEC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "version"
```
