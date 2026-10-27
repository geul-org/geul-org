---
title: "TAI-TIMESTAMP-SECONDS"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-SECONDS est une Value qui contient un nombre de secondes SI signé depuis 1970-01-01T00:00:00 TAI (format d'Issuer BIPM 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-SECONDS est un nombre de secondes SI signé depuis `1970-01-01T00:00:00 TAI`. Cette représentation en compte cumulé n'est pas un wire format normalisé par le BIPM, mais un profil propre à GEUL qui fait correspondre l'échelle de temps TAI à un signed int64 de largeur fixe.

## Disposition

- Code : Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0060` BIPM, numéro de format `0x4000`. Famille TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  7 WORD au total
Issuer            1 WORD  0x0060 (BIPM)
Numéro de format  1 WORD  0x4000
Payload WORD 1er (bits 63..48)     Signed SI Seconds high 16bit
Payload WORD 2ème (bits 47..32)    Signed SI Seconds
Payload WORD 3ème (bits 31..16)    Signed SI Seconds
Payload WORD 4ème (bits 15..0)     Signed SI Seconds low 16bit
```

## Interprétation et validité

- Les 4 WORD du Payload se lisent comme un compte signé en complément à deux sur 64 bits, dans l'ordre big-endian des WORD.
- La plage valide va de `-2^63` à `2^63-1` secondes. Un nombre négatif est un instant TAI antérieur à l'epoch fixée par GEUL.
- Même une petite valeur emploie toujours 4 WORD. Ni décalage UTC ni table de secondes intercalaires n'y sont stockés.

## Longueur

- Le total est exactement de 7 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 4 WORD, avec la longueur directe `LLLL=0110`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 4 WORD, on rejette.

## Exemple

- L'epoch TAI de GEUL est le Payload `0000 0000 0000 0000`, 7 WORD au total, `LLLL=0110`.
- 1 seconde après l'epoch est le Payload `0000 0000 0000 0001`.
- 1 seconde avant l'epoch est le Payload `ffff ffff ffff ffff`.

## Fondement normatif et statut du format

- La [brochure SI du BIPM, 9e édition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) fixe la seconde SI et l'échelle de temps du Temps atomique international (TAI).
- Le BIPM ne définit ni un compte cumulé signed int64 de secondes depuis l'epoch `1970-01-01 TAI` ni son wire encoding. L'epoch, le signed int64 et la disposition en WORD big-endian de GEUL sont une correspondance propre à GEUL.
- L'int64 de largeur fixe a été choisi pour la cohérence des échanges avec les autres profils de compte TIME, et ne signifie pas qu'on reproduit tel quel un format du BIPM.
