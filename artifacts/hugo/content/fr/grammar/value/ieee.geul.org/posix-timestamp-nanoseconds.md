---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1032
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS est le nombre de nanosecondes signé depuis l'epoch Unix `1970-01-01T00:00:00Z`. Comme pour les seconds-since-the-Epoch de POSIX, chaque jour compte exactement 86 400 secondes et les leap seconds ne sont pas comptées."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


POSIX-TIMESTAMP-NANOSECONDS est le nombre de nanosecondes signé depuis l'epoch Unix `1970-01-01T00:00:00Z`. Comme pour les seconds-since-the-Epoch de POSIX, chaque jour compte exactement 86 400 secondes et les leap seconds ne sont pas comptées.

## Disposition {#레이아웃}

- Code : Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, numéro de Codec `0x00004000`. Famille TIME.
- Pour l'échange de données industrielles, on utilise le même type physique int64 signé de largeur fixe que Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  9 WORD au total
Issuer            2 WORD  0x0000000D (IEEE)
Numéro de Codec   2 WORD  0x00004000
Payload WORD 1er (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2ème (bits 47..32)    Signed Nanoseconds
Payload WORD 3ème (bits 31..16)    Signed Nanoseconds
Payload WORD 4ème (bits 15..0)     Signed Nanoseconds low 16bit
```

## Interprétation et validité {#해석과-유효성}

- Les 4 WORD du Payload sont lus ensemble comme un signed count en complément à deux de 64 bits, en ordre de WORD big-endian.
- La plage valide est de `-2^63` à `2^63-1` ns, et la plage des instants va de `1677-09-21 00:12:43.145224192Z` à `2262-04-11 23:47:16.854775807Z`.
- Même une petite valeur utilise toujours 4 WORD. On ne la réduit pas à une représentation entière minimale en WORD.
- Ni timezone, ni offset UTC d'origine, ni label de leap second, ni table de leap seconds ne sont inclus.

## Length {#길이}

- Le total est de 9 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 4 WORD ; on utilise la longueur directe `LLLL=1000`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 4 WORD, on rejette.

## Exemple {#예시}

- L'epoch est le Payload `0000 0000 0000 0000`, 9 WORD au total, `LLLL=1000`.
- 1 ns après l'epoch est le Payload `0000 0000 0000 0001`.
- 1 ns avant l'epoch est le Payload `FFFF FFFF FFFF FFFF`.

## Référence normative {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) définit les membres `time_t tv_sec` et `long tv_nsec`, avec `0 <= tv_nsec < 10^9`. La largeur et la représentation concrètes de `time_t` dépendent de l'environnement d'implémentation, et POSIX ne définit pas de wire format en int64 signé de nanosecondes cumulées combinant les deux membres.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) compte chaque jour pour exactement 86 400 secondes.
- Le `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` d'[Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) stocke les nanosecondes depuis l'epoch Unix dans un seul `int64`. GEUL n'ajoute à ce type physique que le TAG et le framing en WORD big-endian de 16 bits.
