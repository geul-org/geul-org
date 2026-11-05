---
title: "IPV6-ADDRESS"
weight: 1035
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS — Value фиксированной ширины, содержащее 128-битное значение адреса IPv6."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS — Value фиксированной ширины, содержащее 128-битное значение адреса IPv6. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, номер Codec `0x0000C002`, семейство BINARY. Payload составляет ровно 8 WORD (128 бит).

## Раскладка {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  всего 13 WORD
Issuer            2 WORD  0x00000007 (IETF)
Номер Codec       2 WORD  0x0000C002
Payload           8 WORD (128 бит)  IPv6 address, high-order bit → low-order bit
```

## Интерпретация и действительность {#해석과-유효성}

- Восемь WORD Payload, склеенные начиная со старшего WORD, читаются как 128 бит поля адреса IPv6 в исходном порядке. В каждом WORD первый octet — старшие 8 бит.
- Payload содержит только 128 бит одного адреса. Длина префикса CIDR, port и transport protocol не включаются.
- Zone identifier не входит в 128 бит адреса, поэтому в Payload не помещается. Scoped-адрес, которому нужна zone, передаётся внешним контекстом — interface либо Edge, Reference, Profile.
- Выразим любой 128-битный pattern. Эксплуатационный смысл и применимость pattern, таких как unspecified, loopback, multicast, специальные и зарезервированные, определяются внешним контекстом и структурную действительность не ограничивают.
- IPV4-ADDRESS и IPV6-ADDRESS — разные форматы. Адрес IPv6 вида IPv4-mapped тоже сохраняется как 128-битное значение IPv6 и автоматически не отождествляется с IPV4-ADDRESS и не нормализуется в него или из него.
- Это Value можно использовать как идентифицирующий компонент Reference, но scope и политика ссылки в битовом образе адреса не содержатся.

## Стандартные основания {#표준-근거}

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) определяет адрес IPv6 как 128-битный identifier и задаёт битовый формат адресов, включая unicast, anycast, multicast и IPv4-mapped IPv6. Этот формат сохраняет эти 128 бит без переинтерпретации.
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) определяет Source Address и Destination Address пакета IPv6 как поля по 128 бит. WORD Payload сохраняют порядок битов этого поля адреса от high-order bit к low-order bit.
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) указывает, что zone non-global адреса не кодируется в самом адресе, а задаётся контекстом. Поэтому zone identifier находится вне Payload.
- Строковую нотацию RFC 4291 можно использовать только для пояснений и ввода-вывода. [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) не задаёт внутренний формат хранения, поэтому его каноникализация строк не используется как каноникализация этой binary-записи.
- TAG GEUL, назначение Issuer, прямой Length и framing в 16-битные WORD — не часть этих RFC, а правила, которые добавляет этот формат.

## Длина {#길이}

- Общая длина — ровно 13 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 8 WORD; используется прямая длина `LLLL=1100`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 8 WORD, значение отклоняется.

## Пример {#예시}

Адрес IPv6 `2001:db8::1`:

```
09DC 0000 0007 0000 C002 2001 0DB8 0000 0000 0000 0000 0000 0001
```

- Сокращённая запись строки на Payload не влияет.
