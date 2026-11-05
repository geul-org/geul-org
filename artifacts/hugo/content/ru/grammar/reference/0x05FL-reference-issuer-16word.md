---
title: "REFERENCE-ISSUER-16WORD (0x05FL)"
weight: 95
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "issuer"]
summary: "REFERENCE-ISSUER-16WORD — форма Reference, определяемая Issuer."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-ISSUER-16WORD — форма Reference, определяемая Issuer. Это одна из трёх последних ячеек зоны Reference, ширина Issuer — 16 WORD. Раскладка ISSUER у трёх Kind одинакова ([запись и TAG WORD](../record.md#issuer-형식-레코드)).

| Пункт | Значение |
|---|---|
| Имя | `REFERENCE-ISSUER-16WORD` (BIND `REFERENCE-ISSUER-16WORD` в документе спецификации) |
| TAG ID | `0x05FL` |
| Codec ID | `0x000005F0` |
| Документ спецификации | `0x00000000/codecs/0x000005F0/` (цель DECLARE `05F0`) |
| Раздел | 2 `0010` (Reference прочее), смещение внутри раздела C = 31 |
| Kind | Reference · классификация: форма Issuer |
| TAG WORD | `0000 0101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Issuer 16 WORD и номер Codec 2 WORD. Форму определяет документ Codec Issuer |
| Сторона Hugo | `reference/reference-issuer.md` |

## Раскладка {#레이아웃}

```
TAG WORD          0000 0101 1111 LLLL      Codec 0x05FL
[расширяющий TAG Length]
Issuer            16 WORD
Номер Codec       2 WORD. Определяет Issuer
Payload           Определяет документ Codec, выпущенный Issuer
```

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемая форма (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | простое значение 16 WORD |  |  |
| 2 | `codec` | #3 | простое значение 2 WORD |  |  |
| 3 | `payload` | #4 | остаток, простое значение (`0xFFFF`) |  |  |

Состав `payload` определяет документ Codec этого Issuer.

## Интерпретация и действительность {#해석과-유효성}

- GEUL по Length знает только границу Payload. Декодер, не знающий форму, знает Kind, Length, Issuer и номер Codec и пропускает остальное по Length.
- Смысл номера Codec, квантификацию и то, на что он указывает, определяет документ Codec, выпущенный Issuer. Общие правила Reference — наименьшая ширина ID цели, чтение квантификации — не применяются ([REFERENCE-ISSUER](_index.md#해석과-유효성)).
- Issuer записывают наименьшей шириной, в которую помещается значение ([Issuer и публикация](../issuer.md#issuer-등급)). Если старшие 12 WORD значения Issuer равны 0, это invalid. Такое значение записывают кодом меньшей ширины.
- Номер Codec — 2 WORD. Issuer назначает его так, чтобы он не повторялся внутри его `codecs/`, независимо от Kind. Если номеров не хватает, получают ещё один Issuer.
- Документ Codec размещают под `<Issuer>/codecs/<номер Codec>/` этого Issuer ([адреса публикации и список версий](../publishing.md#id-표기)).
- Лицензию формы Issuer определяет этот Issuer ([Issuer и публикация](../issuer.md#라이선스)).

## Связанные страницы {#관련-페이지}

- [REFERENCE-ISSUER](_index.md#reference-issuer), [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md)
- [запись и TAG WORD](../record.md#issuer-형식-레코드), [Issuer и публикация](../issuer.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Документ спецификации `0x00000000/codecs/0x000005F0/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000005F000000000
BODY
#1 DECLARE 0x05F0
#2 FIELD #1 0x0010
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "REFERENCE-ISSUER-16WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
