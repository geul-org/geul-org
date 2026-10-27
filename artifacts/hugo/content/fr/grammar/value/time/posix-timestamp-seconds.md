---
title: "POSIX-TIMESTAMP-SECONDS"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS est une Value qui contient un nombre de secondes signé sur int64 depuis l'epoch Unix (Codec 0x22)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-SECONDS est un nombre de secondes signé depuis l'epoch Unix `1970-01-01T00:00:00Z`. Comme pour les seconds-since-the-Epoch de POSIX, chaque jour compte exactement 86 400 secondes et les secondes intercalaires ne sont pas comptées.

## Disposition

- Code : code direct de Value `0x22`. Famille TIME.
- Pour l'échange de données industrielles, on emploie le même type physique signed int64 de largeur fixe que `timestamp[s]` d'Arrow.

```
TAG WORD          0x0A22 (0000 1010 0010 0010)  5 WORD au total
Payload WORD 1er (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2ème (bits 47..32)    Signed Seconds
Payload WORD 3ème (bits 31..16)    Signed Seconds
Payload WORD 4ème (bits 15..0)     Signed Seconds low 16bit
```

## Interprétation et validité

- Les 4 WORD du Payload se lisent comme un compte signé en complément à deux sur 64 bits, dans l'ordre big-endian des WORD.
- La plage valide va de `-2^63` à `2^63-1` secondes. Un nombre négatif est un instant antérieur à l'epoch.
- Même une petite valeur emploie toujours 4 WORD. On ne doit pas la réduire à une représentation entière sur le nombre minimal de WORD.
- Ni fuseau horaire, ni décalage UTC d'origine, ni étiquette de seconde intercalaire, ni table de secondes intercalaires n'y figurent.

## Longueur

- Le total est exactement de 5 WORD, soit le TAG de 1 WORD plus le Payload de 4 WORD, avec la longueur directe `LLLL=0100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 4 WORD, on rejette.

## Exemple

- L'epoch est le Payload `0000 0000 0000 0000`, 5 WORD au total, `LLLL=0100`.
- 1 seconde après l'epoch est le Payload `0000 0000 0000 0001`.
- 1 seconde avant l'epoch est le Payload `ffff ffff ffff ffff`.

## Fondement normatif

- Le [`timespec` de POSIX.1-2024](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) ne définit que les membres `time_t tv_sec` et `long tv_nsec` et ne définit pas de wire format qui sérialise les secondes cumulées en signed int64. La largeur concrète et la représentation de `time_t` dépendent de l'environnement d'implémentation et ne sont pas identiques à la représentation du Payload GEUL.
- [Seconds Since the Epoch de POSIX.1-2024](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) définit la correspondance calendaire des secondes après l'epoch et la règle des 86 400 secondes par jour.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) et son [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) de référence définissent le timestamp comme un entier signé de 64 bits depuis une epoch fixe, avec l'unité SECOND, et ne comptent pas les secondes intercalaires. GEUL n'ajoute à ce type physique que le TAG et le cadrage en WORD big-endian de 16 bits.
