---
title: "SIGNED-DECIMAL"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL est une Value qui contient un décimal exact C×10^E à partir d'un exposant signé E sur 32 bits et d'un coefficient C en complément à deux sur le nombre minimal de WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-DECIMAL est une Value de décimal exact (exact decimal) à coefficient signé. Code direct de Value `0x10`, famille DECIMAL. Les 2 premiers WORD du Payload sont l'exposant décimal `E` signé sur 32 bits, le reste est le coefficient `C` en complément à deux sur le nombre minimal de WORD, et la valeur est `C×10^E`.

## Disposition

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x10
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1er–2ème (32 bits)       Signed Base-10 Exponent E
Payload WORD 3ème–Nème (1 WORD ou plus)  Signed Two's-complement Coefficient C
```

## Interprétation

- `E` est un entier signé de 32 bits en complément à deux big-endian, écrit à partir du WORD de poids fort.
- `C` est l'entier de précision arbitraire en complément à deux obtenu en concaténant tous les WORD restants à partir du WORD de poids fort.
- `C` suit la même règle du nombre minimal de WORD que [SIGNED-INTEGER](/fr/grammar/value/numeric/signed-integer/). Les WORD `0000` ou `ffff` de tête qu'on pourrait effacer sont interdits.

## Longueur et validité

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe) et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Enregistrement et TAG WORD](/fr/grammar/record/)).
- Le Payload fait au moins 3 WORD, puisqu'il y a l'exposant (2 WORD) et au moins 1 WORD de coefficient.
- La canonicité de la représentation en octets ne vérifie que la représentation du coefficient sur le nombre minimal de WORD.

## Exemple

| Représentation de la valeur | Payload (`E` + `C`) | Verdict |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | représentation en octets canonique |
| `10×10^-1` | `ffff ffff 000a` | représentation en octets canonique ; sa relation canonique avec la représentation ci-dessus est un problème ouvert |
| `1×10^0` | `0000 0000 0000 0001` | non canonique : `0000` de tête du coefficient inutile |
| Payload de 7 WORD | longueur directe `LLLL=0111`, 8 WORD au total | structure de longueur canonique |

## Statut du format

- Cette disposition, qui associe un exposant `E` signé sur 32 bits et un coefficient `C` sur le nombre minimal de WORD, est un format propre à GEUL, qui n'est ni l'interchange decimal d'IEEE 754 ni le `DECIMAL` d'Apache Parquet.
- Le `DECIMAL` de Parquet emploie `unscaledValue × 10^(-scale)` et des métadonnées obligatoires precision/scale, stocke l'unscaled value du type physique byte-array en complément à deux big-endian, et son scale est supérieur ou égal à 0. Ce format place un `E` signé dans le corps et n'a pas de métadonnées de precision : ce n'est donc pas le même format.
- Pour échanger avec IEEE 754 decimal ou le `DECIMAL` de Parquet, il faut une conversion explicite qui fixe la plage, precision/scale, le quantum et la politique des valeurs spéciales.
- Références de comparaison : [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Problèmes ouverts

- Il existe plusieurs couples exposant/coefficient qui représentent le même nombre, comme `10×10^-1` et `1×10^0`.
- On n'a pas encore fixé si ce format conserve le quantum, comment juger l'égalité de valeur, ni comment normaliser l'exposant canonique.
- Une implémentation ne doit donc pas imposer arbitrairement une normalisation d'exposant/coefficient allant au-delà de la règle du nombre minimal de WORD du coefficient.
