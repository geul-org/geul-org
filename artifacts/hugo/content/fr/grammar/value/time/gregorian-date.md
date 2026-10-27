---
title: "GREGORIAN-DATE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE est une Value qui contient un nombre de jours signé sur int32, avec le 1970-01-01 du calendrier grégorien proleptique comme jour 0 (Codec 0x20)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GREGORIAN-DATE est un nombre de jours signé dont le jour 0 est le `1970-01-01` du calendrier grégorien proleptique. Il ne contient ni fuseau horaire ni heure du jour.

## Disposition

- Code : code direct de Value `0x20`. Famille TIME.
- On emploie le même type physique signed int32 de largeur fixe que Date32 d'Arrow et `DATE` de Parquet.

```
TAG WORD          0x0920 (0000 1001 0010 0000)  3 WORD au total
Payload WORD 1er (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2ème (bits 15..0)     Signed Day Count low 16bit
```

## Interprétation et validité

- Les 2 WORD du Payload se lisent comme un nombre de jours signé en complément à deux sur 32 bits, dans l'ordre big-endian des WORD.
- La plage valide va de `-2^31` à `2^31-1` jours. Un nombre négatif est une date antérieure à l'epoch.
- Pour retrouver année, mois et jour à partir du nombre de jours, on emploie le calendrier grégorien proleptique, sans transition historique de calendrier.
- Même une petite valeur emploie toujours 2 WORD.

## Longueur

- Le total est exactement de 3 WORD, soit le TAG de 1 WORD plus le Payload de 2 WORD, avec la longueur directe `LLLL=0010`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 2 WORD, on rejette.

## Exemple

| Date | Payload | Length totale |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `ffff ffff` | 3 WORD (`LLLL=0010`) |

## Relation avec EDTF

- Une précision plus grossière que le jour, l'incertitude ou l'approximation et les intervalles s'écrivent avec [EDTF](/fr/grammar/value/time/edtf/). Une date qu'on peut écrire exactement en GREGORIAN-DATE ne s'écrit pas en EDTF (forme canonique d'EDTF).

## Fondement normatif

- Le `DATE` d'[Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) est un `int32` qui stocke le nombre de jours depuis l'epoch Unix du 1970-01-01, avec l'ordre signed.
- Date32 d'[Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) et de son [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) de référence stocke le nombre de jours depuis l'epoch Unix en entier signé de 32 bits.
- Le calcul inverse grégorien proleptique est le calendar profile de GEUL adopté par ce format. On garde le sens de nombre de jours int32 d'Arrow et Parquet, et l'on n'ajoute que le TAG et le cadrage en WORD big-endian de 16 bits.
