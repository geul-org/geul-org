---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS est une Value qui contient un nombre de nanosecondes signé sur int64 depuis l'epoch Unix (format d'Issuer IEEE 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS est un nombre de nanosecondes signé depuis l'epoch Unix `1970-01-01T00:00:00Z`. Comme pour les seconds-since-the-Epoch de POSIX, chaque jour compte exactement 86 400 secondes et les secondes intercalaires ne sont pas comptées.

## Disposition

- Code : Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, numéro de format `0x4000`. Famille TIME.
- Pour l'échange de données industrielles, on emploie le même type physique signed int64 de largeur fixe que `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` de Parquet.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  7 WORD au total
Issuer            1 WORD  0x0040 (IEEE)
Numéro de format  1 WORD  0x4000
Payload WORD 1er (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2ème (bits 47..32)    Signed Nanoseconds
Payload WORD 3ème (bits 31..16)    Signed Nanoseconds
Payload WORD 4ème (bits 15..0)     Signed Nanoseconds low 16bit
```

## Interprétation et validité

- Les 4 WORD du Payload se lisent comme un compte signé en complément à deux sur 64 bits, dans l'ordre big-endian des WORD.
- La plage valide va de `-2^63` à `2^63-1` ns, soit pour l'instant de `1677-09-21 00:12:43.145224192Z` à `2262-04-11 23:47:16.854775807Z`.
- Même une petite valeur emploie toujours 4 WORD. On ne doit pas la réduire à une représentation entière sur le nombre minimal de WORD.
- Ni fuseau horaire, ni décalage UTC d'origine, ni étiquette de seconde intercalaire, ni table de secondes intercalaires n'y figurent.

## Longueur

- Le total est exactement de 7 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 4 WORD, avec la longueur directe `LLLL=0110`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 4 WORD, on rejette.

## Exemple

- L'epoch est le Payload `0000 0000 0000 0000`, 7 WORD au total, `LLLL=0110`.
- 1 ns après l'epoch est le Payload `0000 0000 0000 0001`.
- 1 ns avant l'epoch est le Payload `ffff ffff ffff ffff`.

## Fondement normatif

- Le [`timespec` de POSIX.1-2024](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) définit les membres `time_t tv_sec` et `long tv_nsec` et `0 <= tv_nsec < 10^9`. La largeur concrète et la représentation de `time_t` dépendent de l'environnement d'implémentation, et il ne définit pas de wire format signed int64 de nanosecondes cumulées combinant les deux membres.
- [Seconds Since the Epoch de POSIX.1-2024](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) compte exactement 86 400 secondes par jour.
- Le `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` d'[Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) stocke les nanosecondes depuis l'epoch Unix dans un seul `int64`. GEUL n'ajoute à ce type physique que le TAG et le cadrage en WORD big-endian de 16 bits.
