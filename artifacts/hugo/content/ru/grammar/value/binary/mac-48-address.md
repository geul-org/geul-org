---
title: "MAC-48-ADDRESS"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS — формат Issuer IEEE фиксированной длины 6 WORD, хранящий 48-битный MAC-адрес IEEE 802 в исходном порядке octet."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS — это Value фиксированной ширины, хранящий значение 48-битного MAC-адреса IEEE 802. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, номер формата `0xC000`, семейство BINARY. Payload — ровно 3 WORD (6 octet, 48 bit).

## Раскладка

```
TAG WORD          0x0AFC (0000 1010 1111 1100)  всего 6 WORD
Issuer            1 WORD  0x0040 (IEEE)
Номер формата     1 WORD  0xC000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## Интерпретация и допустимость

- Шесть octet 48-битного MAC-адреса остаются в порядке octet строковой записи и передачи по LAN. Octet 0–1, 2–3 и 4–5 группируются в WORD от старшего octet к младшему.
- В средах IEEE 802 каждый octet передаётся начиная с least-significant bit, но по этой причине bit внутри octet не переворачиваются. I/G и U/L остаются в least-significant bit octet 0 и в следующем за ним bit.
- I/G=0 — individual-адрес, который в destination используется как unicast; I/G=1 — group-адрес, используемый как multicast или broadcast. U/L=0 — universally administered адрес, U/L=1 — locally administered адрес.
- Из-за значений I/G или U/L структурно не исключается ни один pattern. Представимы universally/locally administered и individual/group адреса, а также locally administered, randomized, spoofed и виртуальные MAC-адреса как 48-битные значения.
- Это значение сохраняет только 48 bit наблюдавшегося или предъявленного адреса. Оно не гарантирует постоянный адрес конкретного устройства, глобальную уникальность, аутентификацию устройства или пользователя, владение и устойчивую связь с одним и тем же устройством.
- Этот формат работает только с MAC-адресами IEEE 802 ровно в 48 bit. EUI-64 и другие 64-битные MAC-адреса не хранятся. IEEE RA описывает исторический термин `MAC-48` как устаревший, но не каждый 48-битный MAC-адрес можно назвать EUI-48, поэтому этот формат автоматически не отождествляется с EUI-48.
- Если Payload не равен ровно 3 WORD, значение отклоняется.

## Основание в стандартах

- [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) от IEEE Registration Authority записывает 48-битный MAC-адрес LAN шестью octet в порядке передачи и поясняет, что каждый octet передаётся начиная с least-significant bit, а I/G и U/L — два least-significant bit первого octet. Этот формат сохраняет позиции octet и bit без изменений.
- [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) от IEEE Registration Authority определяет I/G=0/1 как individual/group и U/L=0/1 как universal/local administration, а также поясняет, что local-адреса не уникальны глобально. Там же описаны историческая связь и различие терминов `MAC-48` и EUI-48.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) поясняет, что EUI-48 и EUI-64 могут использоваться, в частности, как MAC-адреса. Это не значит, что EUI-64 помещается в эту 48-битную запись.
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) и [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) фиксируют, что реальные устройства могут случайно создавать и менять locally administered MAC-адреса. Поэтому по одному MAC-значению постоянная identity устройства не выводится.
- GEUL TAG, назначение Issuer, прямая Length и framing 16-битными WORD — не часть IEEE 802 и перечисленных материалов, а правила, которые добавляет этот формат.

## Длина

- Всего ровно 6 WORD: 1 WORD TAG, 1 WORD Issuer, 1 WORD номера формата и 3 WORD Payload; используется прямая длина `LLLL=0101`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 3 WORD, значение отклоняется.

## Примеры

Locally administered individual (unicast) адрес `02:00:5e:10:00:00` (у первого octet `0x02` I/G=0, U/L=1):

```
0afc 0040 c000 0200 5e10 0000
```
