---
title: "AUTHOR (0x1CBL)"
weight: 459
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Указывает субъекта, написавшего содержимое документа (git author)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `AUTHOR` (BIND документа спецификации `AUTHOR`) |
| TAG ID | `0x1CBL` |
| Codec ID | `0x00001CB0` |
| Документ спецификации | `0x00000000/codecs/0x00001CB0/` (цель DECLARE `1CB0`) |
| Раздел | 14 `1110` (Meta), смещение в разделе C = 11 |
| Kind | Meta · класс: происхождение |
| TAG WORD | `0001 1100 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Автор. Reference (git author) |
| Сторона Hugo | `meta/provenance/author.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | запись | любая запись (кроме маркера места) |  |

Указывает субъекта, написавшего содержимое документа (git author).

## Раскладка {#레이아웃}

```
TAG WORD          0001 1100 1011 LLLL      Codec 0x1CBL
[Length — расширяющий TAG]
Payload           одна запись Reference (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL и т. д.)
```

- Codec: Meta `0x1CBL`, класс происхождения
- Payload: встроенный Reference
- Количество: не более одного

## Интерпретация и валидность {#해석과-유효성}

- Reference не зависит от Codec. Это может быть человек, организация, модель или движок правил ([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [GEUL](../reference/0x00AL-geul.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [LOCAL](../reference/0x005L-local.md) и др.).
- В документах, опубликованных на geul.org, Reference на физическое лицо не ставится ([Issuer и публикация](../issuer.md#geulorg-공표)). Указывается организация или Issuer. Исключение: указывать физическое лицо через [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) допускается.
- Если это LOCAL, этот объект описывается в BODY.

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001CB0/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CB000000000
BODY
#1 DECLARE 0x1CB0
#2 FIELD #1 record
#3 BIND #1 "AUTHOR"
#4 BIND #2 "actor"
```
