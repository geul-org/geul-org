---
title: "CONFIDENCE (0x1E8L)"
weight: 488
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Указывает степень доверия к документу в целом."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `CONFIDENCE` (BIND документа спецификации `CONFIDENCE`) |
| TAG ID | `0x1E8L` |
| Codec ID | `0x00001E80` |
| Документ спецификации | `0x00000000/codecs/0x00001E80/` (цель DECLARE `1E80`) |
| Раздел | 15 `1111` (Meta), смещение в разделе C = 8 |
| Kind | Meta · класс: проверка |
| TAG WORD | `0001 1110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Степень доверия |
| Сторона Hugo | `meta/verification/confidence.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([Документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `confidence` | #2 | запись | `0690` UNSIGNED-DECIMAL |  |

Указывает степень доверия к документу в целом. Степень доверия на уровне записи записывается как QUALIFIER, прикрепляемый к целевому Edge (свойство не определено, [SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).

## Раскладка {#레이아웃}

```
TAG WORD          0001 1110 1000 LLLL      Codec 0x1E8L
[Length — расширяющий TAG]
Payload           UNSIGNED-DECIMAL Value, от 0 до 1 включительно
```

- Codec: Meta `0x1E8L`, класс проверки
- Payload: встроенный Value ([UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md))
- Количество: не более одного

## Интерпретация и валидность {#해석과-유효성}

- Кто присвоил значение, указывается вместе с ним через [GENERATED-BY](0x1D3L-generated-by.md) и т. п.

## Открытые проблемы {#열린-문제}

- Шкала (0–1) и связь с вердиктом TOULMIN.

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001E80/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E8000000000
BODY
#1 DECLARE 0x1E80
#2 FIELD #1 record
#5 CODEC #2 0x0690
#3 BIND #1 "CONFIDENCE"
#4 BIND #2 "confidence"
```
