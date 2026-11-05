---
title: "SIGNED-OFF (0x1E7L)"
weight: 487
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Подтверждение права на вклад (git Signed-off-by, DCO)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `SIGNED-OFF` (BIND документа спецификации `SIGNED-OFF`) |
| TAG ID | `0x1E7L` |
| Codec ID | `0x00001E70` |
| Документ спецификации | `0x00000000/codecs/0x00001E70/` (цель DECLARE `1E70`) |
| Раздел | 15 `1111` (Meta), смещение в разделе C = 7 |
| Kind | Meta · класс: проверка |
| TAG WORD | `0001 1110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Подтверждение права на вклад. Reference (git `Signed-off-by`, DCO) |
| Сторона Hugo | `meta/verification/signed-off.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `signer` | #2 | запись | любая запись (кроме маркера места) |  |

Подтверждение права на вклад (git `Signed-off-by`, DCO).

## Раскладка {#레이아웃}

```
TAG WORD          0001 1110 0111 LLLL      Codec 0x1E7L
[Length — расширяющий TAG]
Payload           один Reference
```

- Codec: Meta `0x1E7L`, класс проверки
- Payload: встроенный Reference
- Количество: может быть несколько

## Интерпретация и валидность {#해석과-유효성}

- В документах, опубликованных на geul.org, Reference на физическое лицо не ставится ([Issuer и публикация](../issuer.md#geulorg-공표)). Указывается организация или Issuer. Исключение: указывать физическое лицо через [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) допускается.

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001E70/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E7000000000
BODY
#1 DECLARE 0x1E70
#2 FIELD #1 record
#3 BIND #1 "SIGNED-OFF"
#4 BIND #2 "signer"
```
