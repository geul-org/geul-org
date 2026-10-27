---
title: "UNSIGNED-INTEGER"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER est une Value qui contient un entier non signé sous forme de magnitude big-endian sur le nombre minimal de WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-INTEGER est une Value qui représente une valeur entière non signée. Code direct de Value `0x02`, famille NUMERIC. Tout le Payload se lit comme une magnitude unsigned de précision arbitraire dans l'ordre big-endian des WORD. Le Payload fait au moins 1 WORD et seule la représentation canonique sur le nombre minimal de WORD est admise.

## Disposition

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x02
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1er  (WORD de poids fort)   Unsigned Magnitude 1er
...
Payload WORD Nème (WORD de poids faible) Unsigned Magnitude Nème
```

## Interprétation

- Le premier WORD du Payload est la position la plus haute, le dernier la plus basse.
- Si le Payload fait N WORD, on le lit comme une seule magnitude unsigned de `16N` bits.
- Cette largeur n'est pas une largeur de stockage déclarée et il n'y a pas de descriptor de largeur en bits.

## Représentation canonique

- 0 est le Payload de 1 WORD `0000`.
- Quand le Payload fait 2 WORD ou plus, si le premier WORD est `0000`, c'est non canonique, car l'effacer ne change pas la valeur.
- Le décodeur doit rejeter les représentations ayant un WORD zéro de tête inutile.

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe) et du Payload. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue `1110` ou `1111`, le TAG d'extension comptant aussi dans le total ([Enregistrement et TAG WORD](/fr/grammar/record/)).
- Les largeurs déclarées comme UINT8, UINT16, UINT32 ne sont pas conservées : seule la valeur numérique l'est.

## Exemple

| Valeur | WORD du Payload | Verdict |
|---:|---|---|
| 0 | `0000` | canonique |
| 1 | `0001` | canonique |
| 65535 | `ffff` | canonique |
| 65536 | `0001 0000` | canonique |
| 1 | `0000 0001` | non canonique : `0000` de tête inutile |
| Payload de 7 WORD | 7 WORD après le TAG `0b82` (longueur directe `LLLL=0111`, 8 WORD au total) | canonique |
| Payload de 7 WORD | 7 WORD après un TAG de longueur étendue et la valeur d'extension `0009` | non canonique : jusqu'à 14 WORD, on écrit la longueur directe |

## Statut du format

- Cette expression, qui normalise une magnitude unsigned de précision arbitraire en suite de WORD de 16 bits minimale et l'associe au TAG GEUL, est un profil de scalaire propre à GEUL.
- Pour échanger avec des types externes de largeur fixe comme UINT8/16/32/64, il faut un contrôle de plage et une conversion de largeur explicite.
