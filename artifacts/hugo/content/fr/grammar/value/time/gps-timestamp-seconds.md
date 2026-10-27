---
title: "GPS-TIMESTAMP-SECONDS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-SECONDS est une Value qui contient un nombre de secondes signé depuis l'epoch GPS 1980-01-06T00:00:00 GPS (format d'Issuer GPS 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-SECONDS est un nombre de secondes signé depuis l'epoch GPS `1980-01-06T00:00:00 GPS`. On ne le divise pas par numéro de semaine GPS et on ne le tronque pas à la largeur de rollover de semaine du champ de diffusion (broadcast).

Cette représentation en compte cumulé n'est pas le wire format de diffusion de l'IS-GPS-200, mais un profil propre à GEUL qui fait correspondre l'échelle de temps GPS à un signed int64 de largeur fixe.

## Disposition

- Code : Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0063` GPS, numéro de format `0x4000`. Famille TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  7 WORD au total
Issuer            1 WORD  0x0063 (GPS)
Numéro de format  1 WORD  0x4000
Payload WORD 1er (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2ème (bits 47..32)    Signed Seconds
Payload WORD 3ème (bits 31..16)    Signed Seconds
Payload WORD 4ème (bits 15..0)     Signed Seconds low 16bit
```

## Interprétation et validité

- Les 4 WORD du Payload se lisent comme un compte signé en complément à deux sur 64 bits, dans l'ordre big-endian des WORD.
- La plage valide va de `-2^63` à `2^63-1` secondes. Un nombre négatif est un instant de temps GPS antérieur à l'epoch GPS.
- Le compte est une valeur continue à partir de l'epoch. On n'applique ni troncature ni rollover du champ de numéro de semaine de diffusion.
- Même une petite valeur emploie toujours 4 WORD. Les paramètres de conversion UTC n'y sont pas contenus.

## Longueur

- Le total est exactement de 7 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 4 WORD, avec la longueur directe `LLLL=0110`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 4 WORD, on rejette.

## Exemple

- L'epoch GPS est le Payload `0000 0000 0000 0000`, 7 WORD au total, `LLLL=0110`.
- 1 seconde après l'epoch est le Payload `0000 0000 0000 0001`.
- 1 seconde avant l'epoch est le Payload `ffff ffff ffff ffff`.

## Fondement normatif et statut du format

- La [documentation technique de GPS.gov](https://www.gps.gov/technical-documentation) est la source officielle de diffusion des spécifications d'interface GPS.
- L'[IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) fixe que le temps GPS est une échelle de temps continue dont la semaine 0 commence à minuit le 1980-01-06, et définit le numéro de semaine GPS et les champs de diffusion time-of-week/Z-count.
- L'IS-GPS-200 ne définit pas de représentation wire signed int64 cumulée depuis l'epoch actuelle. Le compte continu sans rollover, le signed int64 et la disposition en WORD big-endian de GEUL sont une correspondance propre à GEUL.
