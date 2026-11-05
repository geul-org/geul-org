---
title: "SHA-256-DIGEST (0x07CL)"
weight: 124
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST — Value фиксированной ширины, хранящий результат SHA-256 из семейства SHA-2 целиком."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Пункт | Значение |
|---|---|
| Имя | `SHA-256-DIGEST` (BIND в документе спецификации `SHA-256-DIGEST`) |
| TAG ID | `0x07CL` |
| Codec ID | `0x000007C0` |
| Документ спецификации | `0x00000000/codecs/0x000007C0/` (цель DECLARE `07C0`) |
| Раздел | 3 `0011` (Value), смещение C внутри раздела = 28 |
| Kind | Value · семейство: BINARY |
| TAG WORD | `0000 0111 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | Результат SHA-256, фиксированный Payload 16 WORD |
| Сторона Hugo | `value/binary/sha-256-digest.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD в документе — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | простое значение, 16 WORD |  |  |

SHA-256-DIGEST — Value фиксированной ширины, хранящий результат SHA-256 из семейства SHA-2 целиком. Прямой код Value `0x07CL`, семейство BINARY. Payload — ровно 16 WORD (256 бит), усечение (truncation) не допускается.

## Раскладка {#레이아웃}

```
TAG WORD          0x07CE (0000 0111 1100 1110)  LLLL=1110
расш. Length TAG  1 WORD  0x0012 (всего 18 WORD)
Payload           16 WORD  SHA-256 Digest
```

## Интерпретация и действительность {#해석과-유효성}

- 32 octet Payload читаются в том порядке, в каком их выдаёт SHA-256. В каждом WORD первым идёт старший octet.
- К битовой строке digest отдельного преобразования endian в GEUL не применяется. Выходная последовательность octet просто группируется по два octet по порядку и оформляется 16-битными WORD в big-endian.
- Если Payload не равен 16 WORD или результат произвольно усечён, значение отвергается. Descriptor и padding нет.

## Основание в стандартах {#표준-근거}

- Алгоритм SHA-256 и 256-битный результат соответствуют NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL TAG, Length и обрамление 16-битными WORD — правила, которые добавляет этот формат, и частью алгоритма SHA-2 они не являются.

## Длина {#길이}

- Всего — ровно 18 WORD: TAG 1 WORD, расширяющий Length TAG 1 WORD и Payload 16 WORD; используется `LLLL=1110`. Descriptor и padding нет.
- Если Payload не равен ровно 16 WORD, значение отвергается.

## Пример {#예시}

- Octet digest от `d[0]` до `d[31]` размещаются в WORD Payload по порядку: от `(d[0]<<8)|d[1]` до `(d[30]<<8)|d[31]`. Полная Length всегда равна 18 WORD.

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x000007C0/latest.geul`, прочитанный командой `geul show` (шестнадцатеричные цифры заглавные).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007C000000000
BODY
#1 DECLARE 0x07C0
#2 FIELD #1 0x0010
#3 BIND #1 "SHA-256-DIGEST"
#4 BIND #2 "digest"
```
