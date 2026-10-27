---
title: "DURATION-SECONDS"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS est une Value qui contient une durée écoulée en secondes sur int64 signé, sans epoch (Codec 0x23)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-SECONDS est une durée écoulée signée en secondes, sans epoch. Ce n'est ni un instant ni une période calendaire en mois ou en années.

## Disposition

- Code : code direct de Value `0x23`. Famille TIME.
- On emploie le même type physique signed int64 de largeur fixe que `Duration(SECOND)` d'Arrow.

```
TAG WORD          0x0A23 (0000 1010 0010 0011)  5 WORD au total
Payload WORD 1er (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2ème (bits 47..32)    Signed Seconds
Payload WORD 3ème (bits 31..16)    Signed Seconds
Payload WORD 4ème (bits 15..0)     Signed Seconds low 16bit
```

## Interprétation et validité

- Les 4 WORD du Payload se lisent comme un compte signé en complément à deux sur 64 bits, dans l'ordre big-endian des WORD.
- La plage valide va de `-2^63` à `2^63-1` secondes. Le signe est le sens de l'écoulement et ne désigne pas l'instant d'une epoch particulière.
- Même une petite valeur emploie toujours 4 WORD.

## Longueur

- Le total est exactement de 5 WORD, soit le TAG de 1 WORD plus le Payload de 4 WORD, avec la longueur directe `LLLL=0100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 4 WORD, on rejette.

## Exemple

- 0 seconde est le Payload `0000 0000 0000 0000`, 5 WORD au total, `LLLL=0100`.
- 1 seconde est le Payload `0000 0000 0000 0001`.
- -1 seconde est le Payload `ffff ffff ffff ffff`.

## Fondement normatif

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) désigne `Schema.fbs` comme source de référence des types de données standard d'Arrow.
- Dans le [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) de référence d'Arrow, `Duration` est une durée absolue indépendante du calendrier, qui admet l'unité SECOND et se représente toujours par un entier signé de 8 octets. GEUL n'y ajoute que le TAG et le cadrage en WORD big-endian de 16 bits.
