---
title: "CONSENT (0x1E2L)"
weight: 482
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Указывает объём и основание согласия."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `CONSENT` (BIND документа спецификации `CONSENT`) |
| TAG ID | `0x1E2L` |
| Codec ID | `0x00001E20` |
| Документ спецификации | `0x00000000/codecs/0x00001E20/` (цель DECLARE `1E20`) |
| Раздел | 15 `1111` (Meta), смещение в разделе C = 2 |
| Kind | Meta · класс: политика |
| TAG WORD | `0001 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Объём и основание согласия |
| Сторона Hugo | `meta/policy/consent.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `consent` | #2 | запись | `000F` весь раздел 0 (шаблон, Reference), `020F` весь раздел 1 (шаблон, Reference), `040F` весь раздел 2 (шаблон, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Указывает объём и основание согласия.

## Раскладка {#레이아웃}

```
TAG WORD          0001 1110 0010 LLLL      Codec 0x1E2L
[Length — расширяющий TAG]
Payload           Reference или текст, указывающий на основание согласия
```

- Codec: Meta `0x1E2L`, класс политики
- Payload: встроенный Reference или Value
- Количество: может быть несколько

## Открытые проблемы {#열린-문제}

- Структура выражения объёма (цель, срок, передача третьим лицам).

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001E20/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E2000000000
BODY
#1 DECLARE 0x1E20
#2 FIELD #1 record
#3 BIND #1 "CONSENT"
#4 BIND #2 "consent"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
