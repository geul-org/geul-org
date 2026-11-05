---
title: "CRC32C"
weight: 1033
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C — Value фиксированной ширины, содержащее результат CRC-32C."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C — Value фиксированной ширины, содержащее результат CRC-32C. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, номер Codec `0x0000C000`, семейство BINARY. Payload составляет ровно 2 WORD (32 бита).

## Раскладка {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  всего 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Номер Codec       2 WORD  0x0000C000
Payload           2 WORD  CRC32C старшие 16bit │ младшие 16bit
```

## Интерпретация и действительность {#해석과-유효성}

- В нотации параметров CRC: width 32, полином Castagnoli `0x1EDC6F41`, refin/refout true, init `0xFFFFFFFF`, xorout `0xFFFFFFFF`.
- Вычисленный результат — беззнаковое 32-битное целое — сохраняется в порядке big-endian WORD. Эта сериализация не является ни расположением поля Checksum в SCTP по RFC 3309, ни самим byte mapping digest iSCSI по RFC 3720.
- Если Payload не равен 2 WORD, значение отклоняется.

## Стандартные основания {#표준-근거}

- Вычисление CRC-32C, полином Castagnoli и правила отражения следуют определению CRC32C в [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) и [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- TAG GEUL, Length и framing вычисленного 32-битного целого в 16-битные big-endian WORD — правила, которые добавляет этот формат.

## Длина {#길이}

- Общая длина — ровно 7 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 2 WORD; используется прямая длина `LLLL=0110`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 2 WORD, значение отклоняется.

## Пример {#예시}

Контрольное значение CRC-32C для ASCII `123456789` — `0xE3069283`:

```
09D6 0000 0007 0000 C000 E306 9283
```
