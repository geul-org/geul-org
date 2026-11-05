---
title: "EDGE-ISSUER-2WORD (0x1BDL)"
weight: 445
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "EDGE-ISSUER-2WORD — формат Edge, определяемый Issuer."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDGE-ISSUER-2WORD — формат Edge, определяемый Issuer. Это одна из трёх последних ячеек области Edge, ширина Issuer равна 2 WORD. Раскладка ISSUER у трёх Kind одинакова ([Запись и TAG WORD](../record.md#issuer-형식-레코드)).

| Пункт | Значение |
|---|---|
| Имя | `EDGE-ISSUER-2WORD` (BIND документа спецификации `EDGE-ISSUER-2WORD`) |
| TAG ID | `0x1BDL` |
| Codec ID | `0x00001BD0` |
| Документ спецификации | `0x00000000/codecs/0x00001BD0/` (цель DECLARE `1BD0`) |
| Раздел | 13 `1101` (Edge (конечные 3 ячейки ISSUER)), смещение внутри раздела C = 29 |
| Kind | Edge · классификация: формат Issuer |
| TAG WORD | `0001 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в указателе | Issuer 2 WORD и номер Codec 2 WORD. Формат определяет документ Codec Issuer |
| Страница Hugo | `edge/_index.md` |

## Раскладка {#레이아웃}

```
TAG WORD          0001 1011 1101 LLLL      Codec 0x1BDL
[расширяющий TAG Length]
Issuer            2 WORD
Номер Codec       2 WORD. Определяется Issuer
Edge Id           запись LOCAL Reference. Первый элемент после Issuer и номера Codec
Остаток Payload   Определяет документ Codec, выпущенный Issuer
```

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе задаёт порядок полей Payload ([документ спецификации Codec](../codec-spec.md)). Edge Id Edge не объявляется как FIELD. Edge Id у EDGE-ISSUER идёт после номера Codec, перед полем `payload` ([раскладка](#레이아웃)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемая форма (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | Простое значение 2 WORD |  |  |
| 2 | `codec` | #3 | Простое значение 2 WORD |  |  |
| 3 | `payload` | #4 | Остаток простого значения (`0xFFFF`) |  |  |

Состав `payload` определяет документ Codec этого Issuer.

## Интерпретация и действительность {#해석과-유효성}

- GEUL знает по Length только границу Payload. Декодер, не знающий формата, доходит до Kind, Length, Issuer и номера Codec и пропускает остаток по Length.
- Payload начинается с Edge Id (LOCAL Reference) ([Edge](_index.md#레이아웃)). Компоненты после Edge Id определяет документ Codec Issuer.
- Issuer записывается наименьшей шириной, в которую помещается значение ([Issuer и публикация](../issuer.md#issuer-등급)). Issuer 2 WORD позволяет записать любое значение.
- Номер Codec занимает 2 WORD. Issuer назначает его без пересечений внутри своего `codecs/` независимо от Kind. Если номеров не хватает, получите ещё один Issuer.
- Документ Codec размещается в `<Issuer>/codecs/<номер Codec>/` этого Issuer ([адрес публикации и список версий](../publishing.md#id-표기)).
- Лицензию формата Issuer определяет сам Issuer ([Issuer и публикация](../issuer.md#라이선스)).

## Связанные страницы {#관련-페이지}

- [Edge — формат Issuer Edge](_index.md#issuer-형식-edge), [EDGE-ISSUER-4WORD](0x1BEL-edge-issuer-4word.md), [EDGE-ISSUER-16WORD](0x1BFL-edge-issuer-16word.md)
- [Запись и TAG WORD](../record.md#issuer-형식-레코드), [Issuer и публикация](../issuer.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x00001BD0/latest.geul`, прочитанный командой `geul show` (16-ричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001BD000000000
BODY
#1 DECLARE 0x1BD0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "EDGE-ISSUER-2WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
