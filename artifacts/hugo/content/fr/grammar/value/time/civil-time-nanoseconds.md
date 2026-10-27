---
title: "CIVIL-TIME-NANOSECONDS"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS est une Value qui contient une heure civile sans date sous forme d'un nombre de nanosecondes après minuit (Codec 0x21)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CIVIL-TIME-NANOSECONDS représente une heure civile sans date par un nombre de nanosecondes après minuit.

## Disposition

- Code : code direct de Value `0x21`. Famille TIME.
- On emploie le même type physique signed int64 de largeur fixe que `TIME(isAdjustedToUTC=false, unit=NANOS)` de Parquet.

```
TAG WORD          0x0A21 (0000 1010 0010 0001)  5 WORD au total
Payload WORD 1er (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2ème (bits 47..32)    Signed Nanoseconds
Payload WORD 3ème (bits 31..16)    Signed Nanoseconds
Payload WORD 4ème (bits 15..0)     Signed Nanoseconds low 16bit
```

## Interprétation et validité

- Les 4 WORD du Payload se lisent comme un compte signé en complément à deux sur 64 bits, dans l'ordre big-endian des WORD.
- Le type physique est signed int64, mais la plage valide est `0 <= value < 86,400×10^9` ns. On rejette les négatifs et les valeurs supérieures ou égales à la borne.
- `24:00` et les étiquettes de seconde intercalaire ne sont pas admis. Ni date, ni fuseau horaire, ni décalage UTC n'y figurent.
- Même une petite valeur emploie toujours 4 WORD.

## Longueur

- Le total est exactement de 5 WORD, soit le TAG de 1 WORD plus le Payload de 4 WORD, avec la longueur directe `LLLL=0100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 4 WORD, on rejette.

## Exemple

- Minuit est le Payload `0000 0000 0000 0000`, 5 WORD au total, `LLLL=0100`.
- 1 ns après minuit est le Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns est égal à la borne, donc n'est pas valide.
- `ffff ffff ffff ffff` vaut -1 en signed int64, donc n'est pas valide.

## Fondement normatif

- Le `TIME(isAdjustedToUTC=false, unit=NANOS)` d'[Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) stocke en `int64` les nanosecondes après minuit de l'heure locale, avec l'ordre signed.
- Le Time NANOSECOND du [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) de référence d'[Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) est défini comme entier signé de 64 bits, limite la plage valide à moins de 86 400 secondes minuit compris et n'admet pas de seconde intercalaire. GEUL n'ajoute que le TAG et le cadrage en WORD big-endian de 16 bits.
