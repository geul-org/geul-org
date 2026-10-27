---
title: "DURATION-NANOSECONDS"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS est une Value qui contient une durée écoulée en nanosecondes sur int64 signé, sans epoch (format d'Issuer GEUL 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS est une durée écoulée signée en nanosecondes, sans epoch. Ce n'est ni un instant ni une période calendaire en mois ou en années.

## Disposition

- Code : Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, numéro de format `0x4000`. Famille TIME.
- On emploie le même type physique signed int64 de largeur fixe que `Duration(NANOSECOND)` d'Arrow.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  7 WORD au total
Issuer            1 WORD  0x0000 (GEUL)
Numéro de format  1 WORD  0x4000
Payload WORD 1er (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2ème (bits 47..32)    Signed Nanoseconds
Payload WORD 3ème (bits 31..16)    Signed Nanoseconds
Payload WORD 4ème (bits 15..0)     Signed Nanoseconds low 16bit
```

## Interprétation et validité

- Les 4 WORD du Payload se lisent comme un compte signé en complément à deux sur 64 bits, dans l'ordre big-endian des WORD.
- La plage valide va de `-2^63` à `2^63-1` ns. Le signe est le sens de l'écoulement et ne désigne pas l'instant d'une epoch particulière.
- Même une petite valeur emploie toujours 4 WORD.

## Longueur

- Le total est exactement de 7 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 4 WORD, avec la longueur directe `LLLL=0110`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 4 WORD, on rejette.

## Exemple

- 0 ns est le Payload `0000 0000 0000 0000`, 7 WORD au total, `LLLL=0110`.
- 1 ns est le Payload `0000 0000 0000 0001`.
- -1 ns est le Payload `ffff ffff ffff ffff`.

## Fondement normatif

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) désigne `Schema.fbs` comme source de référence des types de données standard d'Arrow.
- Dans le [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) de référence d'Arrow, `Duration` est une durée absolue indépendante du calendrier, qui admet l'unité NANOSECOND et se représente toujours par un entier signé de 8 octets. GEUL n'y ajoute que le TAG et le cadrage en WORD big-endian de 16 bits.
