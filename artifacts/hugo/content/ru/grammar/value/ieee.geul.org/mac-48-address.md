---
title: "MAC-48-ADDRESS"
weight: 1031
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS — Value фиксированной ширины, содержащее значение 48-битного MAC-адреса IEEE 802."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS — Value фиксированной ширины, содержащее значение 48-битного MAC-адреса IEEE 802. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, номер Codec `0x0000C000`, семейство BINARY. Payload составляет ровно 3 WORD (6 octet, 48 бит).

## Раскладка {#레이아웃}

```
TAG WORD          0x09D7 (0000 1001 1101 0111)  всего 8 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Номер Codec       2 WORD  0x0000C000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## Интерпретация и действительность {#해석과-유효성}

- Шесть octet 48-битного MAC-адреса остаются в том порядке octet, в каком они записываются в строковой нотации и передаются по LAN. Octet 0–1, 2–3 и 4–5 объединяются в WORD, причём в каждом WORD сначала идёт старший octet, затем младший.
- В средах IEEE 802 каждый octet передаётся начиная с least-significant bit, но по этой причине биты внутри octet не переворачиваются. I/G и U/L остаются в least-significant bit octet 0 и в следующем за ним бите.
- I/G=0 — individual-адрес, который в destination используется как unicast; I/G=1 — group-адрес, используемый как multicast или broadcast. U/L=0 — universally administered адрес, U/L=1 — locally administered адрес.
- Значения I/G и U/L не исключают структурно ни одного pattern. Выражаются и universally/locally administered, и individual/group адреса; locally administered, randomized, spoofed и virtual MAC-адреса тоже можно представить 48-битным значением.
- Это значение сохраняет только 48 бит наблюдавшегося или предъявленного адреса. Оно не гарантирует ни постоянный адрес конкретного устройства, ни глобальную уникальность, ни аутентификацию устройства или пользователя, ни владение, ни устойчивую привязку к одному и тому же устройству.
- Этот формат охватывает только MAC-адреса IEEE 802 ровно в 48 бит. EUI-64 и другие 64-битные MAC-адреса в него не входят. IEEE RA описывает исторический термин `MAC-48` как obsolete, но не всякий 48-битный MAC-адрес можно называть EUI-48, поэтому этот формат автоматически не отождествляется с EUI-48.
- Если Payload не равен ровно 3 WORD, значение отклоняется.

## Стандартные основания {#표준-근거}

- IEEE Registration Authority в [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) записывает 48-битный MAC-адрес LAN шестью octet в порядке передачи и поясняет, что каждый octet передаётся начиная с least-significant bit, а I/G и U/L — два least-significant bit первого octet. Этот формат сохраняет позиции octet и бит без изменений.
- IEEE Registration Authority в [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) определяет I/G=0/1 как individual/group, U/L=0/1 как universal/local administration и поясняет, что local-адрес не глобально уникален. Там же объясняется историческое соотношение терминов `MAC-48` и EUI-48 и их различие.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) поясняет, что EUI-48 и EUI-64 могут использоваться, в частности, как MAC-адреса. Это не означает, что EUI-64 помещается в данную 48-битную запись.
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) и [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) фиксируют, что реальные устройства могут случайно создавать и менять locally administered MAC-адреса. Поэтому по одному лишь значению MAC нельзя выводить постоянную identity устройства.
- TAG GEUL, назначение Issuer, прямой Length и framing в 16-битные WORD — не часть IEEE 802 или перечисленных материалов, а правила, которые добавляет этот формат.

## Длина {#길이}

- Общая длина — ровно 8 WORD: TAG 1 WORD, Issuer 2 WORD, номер Codec 2 WORD и Payload 3 WORD; используется прямая длина `LLLL=0111`. Расширяющего TAG Length, descriptor и заполнения нет.
- Если Payload не равен ровно 3 WORD, значение отклоняется.

## Пример {#예시}

Locally administered individual (unicast) адрес `02:00:5e:10:00:00` (у первого octet `0x02` I/G=0, U/L=1):

```
09D7 0000 000D 0000 C000 0200 5E10 0000
```
