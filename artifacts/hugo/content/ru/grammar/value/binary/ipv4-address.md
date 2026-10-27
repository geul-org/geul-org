---
title: "IPV4-ADDRESS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS — формат Issuer IETF фиксированной длины 5 WORD, хранящий 32 bit адреса IPv4 в network byte order."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS — это Value фиксированной ширины, хранящий 32-битное значение адреса IPv4. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, номер формата `0xC001`, семейство BINARY. Payload — ровно 2 WORD (32 bit).

## Раскладка

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  всего 5 WORD
Issuer            1 WORD  0x0020 (IETF)
Номер формата     1 WORD  0xC001
Payload           2 WORD  octet адреса 1–2 │ octet адреса 3–4
```

## Интерпретация и допустимость

- Octet адреса остаются в network byte order. В каждом WORD первый octet — старшие 8 bit, следующий octet — младшие 8 bit.
- Payload хранит только 32 bit одного адреса. Длина префикса CIDR, порт и транспортный протокол не хранятся.
- Можно представить любой 32-битный pattern. Эксплуатационный смысл и применимость таких pattern, как unspecified, специальные, зарезервированные и multicast, определяются внешним контекстом и не ограничивают структурную допустимость.
- IPV4-ADDRESS и IPV6-ADDRESS — разные форматы. Адрес IPv6 вида IPv4-mapped автоматически не преобразуется в этот формат и не нормализуется к тому же значению.
- Этот Value можно использовать как компонент идентификатора Reference, но политика и срок жизни такой ссылки не содержатся в bit pattern адреса.
- Если Payload не равен ровно 2 WORD, значение отклоняется.

## Основание в стандартах

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) определяет адрес IPv4 как значение фиксированной длины 4 octet (32 bit), а Source Address и Destination Address — как 32-битные поля. В Payload сохраняются порядок передачи octet из Appendix B и правило most-significant-bit-first для каждого octet.
- GEUL TAG, назначение Issuer, группировка в 16-битные WORD и Length — не часть RFC 791, а правила framing, которые добавляет этот формат.

## Длина

- Всего ровно 5 WORD: 1 WORD TAG, 1 WORD Issuer, 1 WORD номера формата и 2 WORD Payload; используется прямая длина `LLLL=0100`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 2 WORD, значение отклоняется.

## Примеры

Адрес IPv4 `1.2.3.4`:

```
0a7c 0020 c001 0102 0304
```
