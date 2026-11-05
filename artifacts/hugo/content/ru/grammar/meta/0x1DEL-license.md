---
title: "LICENSE (0x1DEL)"
weight: 478
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Указывает лицензию на этот документ и на произведения внутри байтовой последовательности."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `LICENSE` (BIND документа спецификации `LICENSE`) |
| TAG ID | `0x1DEL` |
| Codec ID | `0x00001DE0` |
| Документ спецификации | `0x00000000/codecs/0x00001DE0/` (цель DECLARE `1DE0`) |
| Раздел | 14 `1110` (Meta), смещение в разделе C = 30 |
| Kind | Meta · класс: политика |
| TAG WORD | `0001 1101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Лицензия. Reference |
| Сторона Hugo | `meta/policy/license.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `license` | #2 | запись | `000F` весь раздел 0 (шаблон, Reference), `020F` весь раздел 1 (шаблон, Reference), `040F` весь раздел 2 (шаблон, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0740` URI-EVEN, `0750` URI-ODD |  |

Указывает лицензию на этот документ и на произведения внутри байтовой последовательности.

## Раскладка {#레이아웃}

```
TAG WORD          0001 1101 1110 LLLL      Codec 0x1DEL
[Length — расширяющий TAG]
Payload           Reference, указывающий на лицензию, либо UTF8-TEXT с идентификатором SPDX, либо URI Value
```

- Codec: Meta `0x1DEL`, класс политики
- Payload: встроенный Reference или Value ([UTF8-TEXT](../value/0x072L-utf8-text.md), [URI](../value/0x074L-uri.md))
- Количество: не более одного

## Интерпретация и валидность {#해석과-유효성}

- Документы, опубликованные на geul.org, распространяются под CC0. Для частных публикаций лицензию определяет Issuer ([Issuer](../issuer.md)).
- Записывается исходная лицензия первоисточника.

## Открытые проблемы {#열린-문제}

- Хранить ли идентификатор SPDX текстом или как Reference на сущность GEUL.

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001DE0/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DE000000000
BODY
#1 DECLARE 0x1DE0
#2 FIELD #1 record
#3 BIND #1 "LICENSE"
#4 BIND #2 "license"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0740
#9 CODEC #2 0x0750
```
