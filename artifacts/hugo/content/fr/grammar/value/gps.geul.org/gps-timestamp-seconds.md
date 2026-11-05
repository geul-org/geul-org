---
title: "GPS-TIMESTAMP-SECONDS"
weight: 1024
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-SECONDS est le nombre de secondes signé depuis l'epoch GPS `1980-01-06T00:00:00 GPS`. Il n'est ni divisé par le numéro de GPS week ni tronqué à la largeur de week rollover du champ de broadcast."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


GPS-TIMESTAMP-SECONDS est le nombre de secondes signé depuis l'epoch GPS `1980-01-06T00:00:00 GPS`. Il n'est ni divisé par le numéro de GPS week ni tronqué à la largeur de week rollover du champ de broadcast.

Cette représentation en count cumulatif n'est pas le broadcast wire format d'IS-GPS-200 : c'est un profil propre à GEUL qui fait correspondre l'échelle de temps GPS à un int64 signé de largeur fixe.

## Disposition {#레이아웃}

- Code : Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000016` GPS, numéro de Codec `0x00004000`. Famille TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  9 WORD au total
Issuer            2 WORD  0x00000016 (GPS)
Numéro de Codec   2 WORD  0x00004000
Payload WORD 1er (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2ème (bits 47..32)    Signed Seconds
Payload WORD 3ème (bits 31..16)    Signed Seconds
Payload WORD 4ème (bits 15..0)     Signed Seconds low 16bit
```

## Interprétation et validité {#해석과-유효성}

- Les 4 WORD du Payload sont lus ensemble comme un signed count en complément à deux de 64 bits, en ordre de WORD big-endian.
- La plage valide est de `-2^63` à `2^63-1` secondes. Une valeur négative est un instant GPS-time antérieur à l'epoch GPS.
- Le count est une valeur continue à partir de l'epoch. On n'applique ni troncature ni rollover du champ de week-number du broadcast.
- Même une petite valeur utilise toujours 4 WORD. Les paramètres de conversion UTC ne sont pas inclus.

## Length {#길이}

- Le total est de 9 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 4 WORD ; on utilise la longueur directe `LLLL=1000`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 4 WORD, on rejette.

## Exemple {#예시}

- L'epoch GPS est le Payload `0000 0000 0000 0000`, 9 WORD au total, `LLLL=1000`.
- 1 seconde après l'epoch est le Payload `0000 0000 0000 0001`.
- 1 seconde avant l'epoch est le Payload `FFFF FFFF FFFF FFFF`.

## Référence normative et statut du format {#표준-근거와-형식-지위}

- La [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) est la source de diffusion officielle des spécifications d'interface GPS.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) établit que le GPS time est une échelle de temps continue dont la week 0 commence à minuit le 1980-01-06, et définit le GPS week number ainsi que les champs de broadcast time-of-week/Z-count.
- IS-GPS-200 ne définit pas de wire representation en int64 signé du count cumulatif depuis l'epoch en vigueur. Le count continu sans rollover, l'int64 signé et la disposition en WORD big-endian de GEUL sont une correspondance propre à GEUL.
