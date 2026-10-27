---
title: "IPV6-ADDRESS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS — формат Issuer IETF фиксированной длины 11 WORD, хранящий 128 bit адреса IPv6 в исходном порядке."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS — это Value фиксированной ширины, хранящий 128-битное значение адреса IPv6. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, номер формата `0xC002`, семейство BINARY. Payload — ровно 8 WORD (128 bit).

## Раскладка

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  всего 11 WORD
Issuer            1 WORD  0x0020 (IETF)
Номер формата     1 WORD  0xC002
Payload           8 WORD (128 бит)  адрес IPv6, от high-order bit к low-order bit
```

## Интерпретация и допустимость

- Восемь Payload WORD склеиваются начиная со старшего WORD, и 128 bit поля адреса IPv6 читаются в исходном порядке. В каждом WORD первый octet — старшие 8 bit.
- Payload хранит только 128 bit одного адреса. Длина префикса CIDR, порт и транспортный протокол не хранятся.
- Zone identifier не входит в 128 bit адреса, поэтому в Payload его не кладут. Scoped address, которому нужна zone, получает её из внешнего контекста: интерфейса либо Edge, Reference или Profile.
- Можно представить любой 128-битный pattern. Эксплуатационный смысл и применимость pattern unspecified, loopback, multicast, специальных и зарезервированных определяются внешним контекстом и не ограничивают структурную допустимость.
- IPV4-ADDRESS и IPV6-ADDRESS — разные форматы. Адрес IPv6 вида IPv4-mapped тоже сохраняется как 128-битное значение IPv6 и автоматически не отождествляется с IPV4-ADDRESS и не нормализуется к нему.
- Этот Value можно использовать как компонент идентификатора Reference, но scope и политика ссылки не содержатся в bit pattern адреса.

## Основание в стандартах

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) определяет адрес IPv6 как 128-битный identifier и задаёт bit format адресов, включая unicast, anycast, multicast и IPv4-mapped IPv6. Этот формат сохраняет эти 128 bit без переинтерпретации.
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) определяет Source Address и Destination Address пакета IPv6 как 128-битные поля. Payload WORD сохраняют порядок этого поля адреса от high-order bit к low-order bit.
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) указывает, что zone неглобального адреса не кодируется в самом адресе, а определяется контекстом. Поэтому zone identifier находится вне Payload.
- Строковую запись из RFC 4291 можно использовать только для пояснений и ввода-вывода. [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) не определяет внутренний формат хранения, поэтому его string canonicalization не используется как canonicalization этой binary-записи.
- GEUL TAG, назначение Issuer, прямая Length и framing 16-битными WORD — не часть этих RFC, а правила, которые добавляет этот формат.

## Длина

- Всего ровно 11 WORD: 1 WORD TAG, 1 WORD Issuer, 1 WORD номера формата и 8 WORD Payload; используется прямая длина `LLLL=1010`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 8 WORD, значение отклоняется.

## Примеры

Адрес IPv6 `2001:db8::1`:

```
0d7c 0020 c002 2001 0db8 0000 0000 0000 0000 0000 0001
```

- Сокращённая запись строки на Payload не влияет.
