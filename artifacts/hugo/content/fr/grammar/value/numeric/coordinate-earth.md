---
title: "COORDINATE-EARTH"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH est une Value qui contient un point de la Terre (WGS 84) par sa latitude et sa longitude en binary64, son incertitude en binary32 et une Reference de l'unité de l'incertitude."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-EARTH est une Value de coordonnées qui représente un point de la Terre par sa latitude, sa longitude et son incertitude. Code direct de Value `0x04`, famille NUMERIC. Le sens est celui de `geo:latitude,longitude;u=incertitude` de la [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI) (système de coordonnées WGS 84), contenu non comme chaîne mais comme valeurs numériques de largeur fixe. L'incertitude s'accompagne de son unité. Les coordonnées d'un corps céleste hors de la Terre s'écrivent avec [COORDINATE-GEO](/fr/grammar/value/numeric/coordinate-geo/) (`0x05`).

## Disposition

```
TAG WORD          0000 1LLL L000 0100      Codec 0x04
Latitude          4 WORD en valeur brute, IEEE 754 binary64 (degrés)
Longitude         4 WORD en valeur brute, IEEE 754 binary64 (degrés)
Uncertainty       2 WORD en valeur brute, IEEE 754 binary32 (en unité Unit)
Unit              1 enregistrement Reference, ou marqueur d'emplacement 0x0000 ABSENT
```

## Interprétation et validité

- Le Payload est Latitude 4 WORD, Longitude 4 WORD, Uncertainty 2 WORD, puis exactement un enregistrement Unit. Le curseur après lecture de Unit doit coïncider avec la fin de l'enregistrement.
- Le système de coordonnées est WGS 84 (`crs=wgs84` par défaut de la RFC 5870).
- Latitude et Longitude sont des binary64 IEEE 754 obtenus en concaténant les WORD du Payload en ordre big-endian (même disposition de bits que binary64 de [BINARY-FLOAT](/fr/grammar/value/numeric/binary-float/)). L'unité est le degré (°).
  - Les valeurs doivent être finies. NaN et ±Infinity sont invalid.
  - Latitude : `-90 ≤ φ ≤ 90` (positif vers le nord) ; Longitude : `-180 ≤ λ ≤ 180` (positif vers l'est).
  - L'ordre des axes est latitude puis longitude (comme la RFC 5870 et ISO 6709). Ce n'est pas l'ordre x (longitude) puis y (latitude) de WKB et GeoJSON.
- Uncertainty est un binary32 IEEE 754 obtenu en concaténant 2 WORD en big-endian (même disposition de bits que binary32 de BINARY-FLOAT). Cela signifie que la position réelle se trouve dans ce rayon, et la valeur se lit dans l'unité Unit.
  - Elle doit être finie et supérieure ou égale à `+0`. Négatif, `-0` (`8000 0000`), NaN et ±Infinity sont invalid.
  - `0` (quand Unit existe) : coordonnée exacte. C'est la même quelle que soit l'unité employée.
- Unit est une Reference qui désigne l'unité de l'Uncertainty. Une Value n'est pas admise. Le Quantifier est Identified (`000`).
  - On recommande d'employer les éléments d'unité de Wikidata [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/) : degré Q28390, minute d'arc Q209426, seconde d'arc Q829073, mètre Q11573, millimètre Q174789, etc. Une unité sans QID se désigne par une autre Reference (LOCAL, GEUL, etc.). Si plusieurs Reference désignent la même unité, le QID est la forme canonique.
  - Si Unit est le mètre (Q11573), Uncertainty est identique au `u` de la RFC 5870.
- **Inconnu** : à la place d'Unit, on écrit [ABSENT](/fr/grammar/reference/slot-marker/) (`0x0000`) et Uncertainty est `+0` (`0000 0000`). C'est la même chose que lorsque `u` est omis dans la RFC 5870. Si Unit est ABSENT mais que Uncertainty n'est pas `+0`, invalid (on fixe une seule expression).
- L'altitude n'est pas contenue. Si nécessaire, on la fixera par un format distinct. L'altitude de Wikidata n'a pas été employée dans l'échantillon (0/23 066), et s'il y a une valeur, on ne convertit pas et l'on conserve le texte d'origine en UTF8-TEXT.
- On recommande d'employer ce format pour les coordonnées terrestres. Une coordonnée qui met la Terre (Q2) dans COORDINATE-GEO n'est pas non plus invalid, et celui qui compare les aligne sur la même coordonnée.
- Le document de spécification de geul.org `0x0000/0x0000000000000804` place sur les champs en valeur brute Latitude, Longitude et Uncertainty le [CODEC](/fr/grammar/edge/codec/) BINARY-FLOAT (`0803`) (4 WORD = binary64, 2 WORD = binary32), et sur le champ d'enregistrement Unit les CODEC `0780` (toute Reference) et `0000` (ABSENT).

## Longueur

- Le total est le TAG de 1 WORD + 10 WORD + l'enregistrement Unit.

| Unit | Total | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `0D84` (`LLLL=1011`) |
| Quand le QID tient dans 1 WORD (2 WORD, par ex. degré Q28390) | 13 WORD | `0E04` (`LLLL=1100`) |
| Quand le QID fait 2 WORD (3 WORD, par ex. minute d'arc Q209426) | 14 WORD | `0E84` (`LLLL=1101`) |
| Enregistrement Unit de 4 WORD ou plus | 15 WORD ou plus | longueur étendue ([Enregistrement et TAG WORD](/fr/grammar/record/)) |

- On ne place pas de paire de Codec pair/impair.

## Correspondance Wikidata

globecoordinate de Wikidata : `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | Ce format (Terre). Les autres corps célestes : COORDINATE-GEO |
| latitude, longitude | binary64 tel quel (les valeurs de Wikidata étant à l'origine du binary64, il n'y a pas de perte) |
| precision (degrés) | Uncertainty et Unit. Voir « Précision » ci-dessous |
| precision null ou absente | Unit = ABSENT, Uncertainty = `+0` (inconnu) |
| altitude | Écartée (toujours null) |

- Le precision de Wikidata n'est pas une erreur de mesure mais la **résolution d'enregistrement** (en quelle unité de degrés, minutes ou secondes la coordonnée a été écrite). L'Uncertainty de GEUL le transcrit sans changer cette valeur. Ce n'est pas un rayon qui ajouterait les erreurs de mesure ou de système de coordonnées.

### Précision

On transcrit precision sans conversion. On choisit la première unité parmi degré, minute d'arc et seconde d'arc qui restitue la notation d'origine.

| precision d'origine (exemples) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k degrés) | degré Q28390 | le binary32 de cette valeur |
| Notation décimale courte comme `0.0166667` | degré Q28390 | le binary32 de cette valeur |
| `0.016666666666667` (1/60°) | minute d'arc Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | seconde d'arc Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0,1″) | seconde d'arc Q829073 | `0.1` |

- Conversion directe : dans l'ordre degré, minute d'arc (×60), seconde d'arc (×3600), on prend comme Uncertainty le binary32 le plus proche de precision multiplié par le nombre d'unités, et l'on emploie la première unité pour laquelle la conversion inverse ci-dessous restitue exactement le precision d'origine.
- Conversion inverse : on divise la notation décimale la plus courte de l'Uncertainty (le nombre le plus court qui se relit comme ce binary32) par le nombre d'unités pour revenir en degrés, et on l'écrit comme Wikibase l'écrit dans le dump (14 chiffres significatifs, notation exponentielle `1.0e-6` ou `2.7777777777778e-5` en dessous de `1e-4`). La base de chargement (jsonb) la conserve sous la forme décimale `0.0000010` ou `0.000027777777777778`.
- Si aucune unité ne restitue l'original (notation à 17 chiffres significatifs `0.0002777777777777778`, valeurs aberrantes qui ressemblent à des valeurs calculées, etc.), on ne convertit pas la coordonnée et l'on conserve le texte d'origine en UTF8-TEXT. Il en va de même d'un precision négatif et d'un corps céleste vide.
- Échantillon Q1–Q10000 de Wikidata (7 026 revendications de coordonnées, 6 824 avec precision) : 5 933 restituent l'original (86,9 % ; degré 4 104, seconde d'arc 1 370, minute d'arc 459). Sur les 891 qui ne le restituent pas, 753 sont de la famille 1/3600 et 1/60 en notation à 17 chiffres significatifs.

## Exemple

Berlin 52.516666666667, 13.383333333333, precision 1/60° (minute d'arc 1) :

```
0E84 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0120 0003 3212
```

- TAG `0E84` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0120 0003 3212` (WIKIDATA-QID Q209426, minute d'arc).
- Notation textuelle : `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

Le même point à incertitude inconnue : `0D84 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## Fondement normatif

- Sens : [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — ordre latitude puis longitude, incertitude `u` (mètres), système de coordonnées par défaut WGS 84. Si Unit est le mètre, Uncertainty = `u`.
- Valeurs : [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitude, longitude), binary32 (incertitude).
- Ordre et plage des axes : ISO 6709 (Standard representation of geographic point location by coordinates).
- Unité : éléments d'unité de Wikidata (QID). La disposition à largeur fixe, le champ Unit et l'expression de l'inconnu sont des règles de GEUL.

## Problèmes ouverts

1. Altitude.
2. Le format qui conserve la chaîne d'origine ISO 6709 (COORDINATE-ISO6709) sera fixé quand un usage apparaîtra.
3. Moyen de transcrire sans perte la notation à 17 chiffres significatifs du precision de Wikidata (environ 11 % de l'échantillon).

## Pages liées

- [Value](/fr/grammar/value/), [COORDINATE-GEO](/fr/grammar/value/numeric/coordinate-geo/), [BINARY-FLOAT](/fr/grammar/value/numeric/binary-float/), [Marqueur d'emplacement](/fr/grammar/reference/slot-marker/)
- Le format d'Issuer [POINT2-BINARY64](/fr/grammar/value/vector/point2-binary64/) est un point 2D général qui laisse au contexte externe le système de coordonnées, l'unité et le sens des axes, tandis que ce format est une coordonnée géographique sur la Terre.
