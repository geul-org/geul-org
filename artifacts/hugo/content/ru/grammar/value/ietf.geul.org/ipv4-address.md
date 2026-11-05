---
title: "IPV4-ADDRESS"
weight: 1034
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS — Value фиксированной ширины, содержащее 32-битное значение адреса IPv4."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS — Value фиксированной ширины, содержащее 32-битное значение адреса IPv4. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, номер Codec `0x0000C001`, семейство BINARY. Payload составляет ровно 2 WORD (32 бита).

## Раскладка {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  всего 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
Номер Codec       2 WORD  0x0000C001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## Интерпретация и действительность {#해석과-유효성}

- Octet адреса остаются в network byte order. В каждом WORD первый octet — старшие 8 бит, следующий — младшие 8 бит.
- Payload содержит только 32 бита одного адреса. Длина префикса CIDR, port и transport protocol не включаются.
- Выразим любой 32-битный pattern. Эксплуатационный смысл и применимость pattern, таких как unspecified, специальные, зарезервированные и multicast, определяются внешним контекстом и структурную действительность не ограничивают.
- IPV4-ADDRESS и IPV6-ADDRESS — разные форматы. Адрес IPv6 вида IPv4-mapped автоматически не преобразуется в этот формат и не нормализуется в то же значение.
- Это Value можно использовать как идентифицирующий компонент Reference, но политика ссылки и срок её жизни в битовом образе адреса не содержатся.
- Если Payload не равен ровно 2 WORD, значение отклоняется.

## Стандартные основания {#표준-근거}

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) определяет адрес IPv4 как 4 octet (32 бита) фиксированной длины, а Source Address и Destination Address — как поля по 32 битаа. Порядок передачи octet из Appendix B и правило most-significant-bit-first для каждого octet сохраняются в Payload.
- TAG GEUL, назначение Issuer, объединение в 16-битные WORD и Length — не часть RFC 791, а правила framing, которые добавляет этот формат.

## Длина {#길이}

- Общая длина — ровно 7 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 2 WORD; используется прямая длина `LLLL=0110`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 2 WORD, значение отклоняется.

## Пример {#예시}

Адрес IPv4 `1.2.3.4`:

```
09D6 0000 0007 0000 C001 0102 0304
```
