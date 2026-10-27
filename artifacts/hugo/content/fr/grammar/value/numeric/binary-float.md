---
title: "BINARY-FLOAT"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT est une Value qui contient telle quelle la suite de bits d'interchange IEEE 754 binary16/32/64/128."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY-FLOAT est une Value qui représente un scalaire d'interchange binary IEEE 754. Code direct de Value `0x03`, famille NUMERIC. Un Payload de 1/2/4/8 WORD est respectivement binary16/32/64/128. La suite de bits d'interchange est conservée telle quelle, et aucune autre taille de Payload n'est admise.

## Disposition

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x03
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1er  (WORD de poids fort)   IEEE Binary Interchange 1er
...
Payload WORD Nème (WORD de poids faible) Binary Interchange Nème
```

## Interprétation

- On concatène les WORD du Payload en ordre big-endian et on les lit comme la suite de bits d'interchange binary IEEE 754 de la largeur correspondante.
- Les motifs de bits d'interchange, y compris le payload des NaN et le zéro signé, sont conservés.
- Le décodeur ne doit pas remplacer un NaN par un NaN canonique quelconque ni effacer le signe d'un zéro signé.
- Le mode d'arrondi et le comportement arithmétique ne sont pas fixés par ce format de sérialisation.

## Longueur

Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe) et du Payload ([Enregistrement et TAG WORD](/fr/grammar/record/)).

| Format | Payload | Code de Length | TAG d'extension de Length | Length totale |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | aucun | 2 WORD |
| binary32 | 2 WORD | `0010` | aucun | 3 WORD |
| binary64 | 4 WORD | `0100` | aucun | 5 WORD |
| binary128 | 8 WORD | `1000` | aucun | 9 WORD |

binary128 est lui aussi dans la plage directe de 1 à 14 WORD, donc il n'emploie pas de TAG d'extension de Length.

## Validité

- Le Payload fait exactement 1, 2, 4 ou 8 WORD.
- Chaque taille de Payload doit correspondre exactement à l'expression de Length du tableau ci-dessus.
- Un ré-encodage qui change la largeur et des WORD de remplissage avant ou après le Payload ne sont pas admis.

## Exemple

| Format | TAG | TAG d'extension de Length | Exemple de Payload | Verdict |
|---|---|---|---|---|
| binary16 | `0883` | aucun | `0000` | canonique |
| binary32 | `0903` | aucun | `0000 0000` | canonique |
| binary64 | `0A03` | aucun | `0000 0000 0000 0000` | canonique |
| binary128 | `0C03` | aucun | suite de bits de 8 WORD | canonique |
| quelconque | Incohérent avec la taille indiquée par Length | quelconque | quelconque | invalid |

## Fondement normatif

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/) : on applique les encodages d'interchange binary16, binary32, binary64, binary128. GEUL n'ajoute à cette suite de bits que le TAG et le cadrage big-endian en WORD de 16 bits.
