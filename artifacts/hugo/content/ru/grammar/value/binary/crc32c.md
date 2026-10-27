---
title: "CRC32C"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C — формат Issuer IETF фиксированной длины 5 WORD, хранящий 32 bit результата CRC-32C Castagnoli."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C — это Value фиксированной ширины, хранящий результат CRC-32C. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, номер формата `0xC000`, семейство BINARY. Payload — ровно 2 WORD (32 bit).

## Раскладка

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  всего 5 WORD
Issuer            1 WORD  0x0020 (IETF)
Номер формата     1 WORD  0xC000
Payload           2 WORD  CRC32C старшие 16bit │ младшие 16bit
```

## Интерпретация и допустимость

- В нотации параметров CRC: width 32, полином Castagnoli `0x1EDC6F41`, refin/refout true, init `0xffffffff`, xorout `0xffffffff`.
- Результат вычисления, unsigned 32-битное целое, сохраняется в порядке big-endian WORD. Эта сериализация сама по себе — не раскладка поля SCTP Checksum из RFC 3309 и не byte mapping дайджеста iSCSI из RFC 3720.
- Если Payload не равен 2 WORD, значение отклоняется.

## Основание в стандартах

- Вычисление CRC-32C, полином Castagnoli и правила отражения следуют определениям CRC32C в [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) и [RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- GEUL TAG, Length и framing вычисленного 32-битного целого 16-битными big-endian WORD — правила, которые добавляет этот формат.

## Длина

- Всего ровно 5 WORD: 1 WORD TAG, 1 WORD Issuer, 1 WORD номера формата и 2 WORD Payload; используется прямая длина `LLLL=0100`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 2 WORD, значение отклоняется.

## Примеры

Контрольное значение CRC-32C для ASCII `123456789` — `0xe3069283`:

```
0A7C 0020 C000 e306 9283
```
