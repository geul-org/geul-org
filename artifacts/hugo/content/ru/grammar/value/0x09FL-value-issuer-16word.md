---
title: "VALUE-ISSUER-16WORD (0x09FL)"
weight: 159
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "VALUE-ISSUER-16WORD — формат Value, определяемый Issuer."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VALUE-ISSUER-16WORD — формат Value, определяемый Issuer. Это одна из трёх последних ячеек области Value, ширина Issuer — 16 WORD. Раскладка ISSUER у трёх Kind одинакова ([запись и TAG WORD](../record.md#issuer-형식-레코드)).

| Пункт | Значение |
|---|---|
| Имя | `VALUE-ISSUER-16WORD` (BIND в документе спецификации `VALUE-ISSUER-16WORD`) |
| TAG ID | `0x09FL` |
| Codec ID | `0x000009F0` |
| Документ спецификации | `0x00000000/codecs/0x000009F0/` (цель DECLARE `09F0`) |
| Раздел | 4 `0100` (Value), смещение C внутри раздела = 31 |
| Kind | Value · классификация: формат Issuer |
| TAG WORD | `0000 1001 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Issuer 16 WORD и номер Codec 2 WORD. Формат определяет документ Codec Issuer |
| Сторона Hugo | `value/_index.md` |

## Раскладка {#레이아웃}

```
TAG WORD          0000 1001 1111 LLLL      Codec 0x09FL
[расширяющий Length TAG]
Issuer            16 WORD
номер Codec       2 WORD. Определяется Issuer
Payload           определяется документом Codec, выпущенным Issuer
```

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | простое значение, 16 WORD |  |  |
| 2 | `codec` | #3 | простое значение, 2 WORD |  |  |
| 3 | `payload` | #4 | остаток, простое значение (`0xFFFF`) |  |  |

Состав `payload` определяет документ Codec данного Issuer.

## Интерпретация и действительность {#해석과-유효성}

- GEUL по Length знает лишь границу Payload. Декодер, не знающий формата, знает Kind, Length, Issuer и номер Codec и пропускает значение по Length.
- Интерпретацию Payload определяет документ Codec Issuer. Зарегистрированные сейчас Value формата Issuer перечислены в [индексе Codec](../codec-index.md#value-issuer-형식).
- Issuer записывается самой короткой шириной, в которую умещается значение ([Issuer и публикация](../issuer.md#issuer-등급)). Если старшие 12 WORD значения Issuer равны 0, оно invalid. Такое значение записывается кодом более узкой ширины.
- Номер Codec — 2 WORD. Issuer назначает его без пересечений внутри своего `codecs/` независимо от Kind. Если номеров не хватает, получают ещё один Issuer.
- Документ Codec размещается под `<Issuer>/codecs/<номер Codec>/` этого Issuer ([адрес публикации и список версий](../publishing.md#id-표기)).
- Лицензию формата Issuer определяет сам этот Issuer ([Issuer и публикация](../issuer.md#라이선스)).

## Связанные страницы {#관련-페이지}

- [Value — формат Issuer](_index.md#issuer-형식), [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md), [VALUE-ISSUER-4WORD](0x09EL-value-issuer-4word.md)
- [запись и TAG WORD](../record.md#issuer-형식-레코드), [Issuer и публикация](../issuer.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x000009F0/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные цифры заглавные).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000009F000000000
BODY
#1 DECLARE 0x09F0
#2 FIELD #1 0x0010
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "VALUE-ISSUER-16WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
