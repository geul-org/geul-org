---
title: "COORDINATE-EARTH (0x064L)"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH est une Value de coordonnées qui représente un point de la Terre par sa latitude, sa longitude et une incertitude."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `COORDINATE-EARTH` (document de spécification BIND `COORDINATE-EARTH`) |
| TAG ID | `0x064L` |
| Codec ID | `0x00000640` |
| Document de spécification | `0x00000000/codecs/0x00000640/` (cible DECLARE `0640`) |
| Section | 3 `0011` (Value), offset C dans la section = 4 |
| Kind | Value · famille : NUMERIC |
| TAG WORD | `0000 0110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | latitude et longitude terrestres (WGS 84) en binary64, incertitude en binary32 et Reference de son unité (ABSENT = inconnue) |
| Côté Hugo | `value/numeric/coordinate-earth.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `latitude` | #2 | valeur brute 4 WORD | `0630` BINARY-FLOAT |  |
| 2 | `longitude` | #3 | valeur brute 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `uncertainty` | #4 | valeur brute 2 WORD | `0630` BINARY-FLOAT |  |
| 4 | `unit` | #12 | enregistrement | `000F` toute la section 0 (joker, Reference), `020F` toute la section 1 (joker, Reference), `040F` toute la section 2 (joker, Reference), `0000` ABSENT (champ facultatif) |  |

COORDINATE-EARTH est une Value de coordonnées qui représente un point de la Terre par sa latitude, sa longitude et une incertitude. Son code direct Value est `0x064L`, sa famille est NUMERIC. Son sens est celui de `geo:latitude,longitude;u=incertitude` de la [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (geo URI) (système de coordonnées WGS 84), mais elle est portée sous forme de valeurs numériques de largeur fixe et non de chaîne. L'incertitude est accompagnée de son unité. Les coordonnées d'un corps céleste autre que la Terre s'écrivent avec [COORDINATE-GEO](0x065L-coordinate-geo.md) (`0x065L`).

## Disposition {#레이아웃}

```
TAG WORD          0000 0110 0100 LLLL      Codec 0x064L
Latitude          4 WORD valeur brute, IEEE 754 binary64 (degrés)
Longitude         4 WORD valeur brute, IEEE 754 binary64 (degrés)
Uncertainty       2 WORD valeur brute, IEEE 754 binary32 (en unité Unit)
Unit              1 enregistrement Reference, ou marqueur d'emplacement 0x0000 ABSENT
```

## Interprétation et validité {#해석과-유효성}

- Le Payload est constitué de Latitude sur 4 WORD, Longitude sur 4 WORD, Uncertainty sur 2 WORD, puis d'exactement un enregistrement Unit. Le curseur après la lecture de Unit doit coïncider avec la fin de l'enregistrement.
- Le système de coordonnées est WGS 84 (`crs=wgs84` par défaut dans la RFC 5870).
- Latitude et Longitude sont des IEEE 754 binary64 obtenus en mettant bout à bout les WORD du Payload dans l'ordre big-endian (même disposition de bits que binary64 de [BINARY-FLOAT](0x063L-binary-float.md)). L'unité est le degré (°).
  - La valeur doit être finie. NaN et ±Infinity sont invalid.
  - Latitude vérifie `-90 ≤ φ ≤ 90` (le nord est positif), Longitude vérifie `-180 ≤ λ ≤ 180` (l'est est positif).
  - L'ordre des axes est latitude, longitude (comme dans la RFC 5870 et ISO 6709). Ce n'est pas l'ordre x (longitude), y (latitude) de WKB et GeoJSON.
- Uncertainty est un IEEE 754 binary32 obtenu en mettant bout à bout 2 WORD en big-endian (même disposition de bits que binary32 de BINARY-FLOAT). Elle signifie que la position réelle se trouve dans ce rayon, et sa valeur se lit dans l'unité Unit.
  - Elle doit être finie et supérieure ou égale à `+0`. Une valeur négative, `-0` (`8000 0000`), NaN et ±Infinity sont invalid.
  - `0` (lorsque Unit est présente) : coordonnée exacte. La valeur est la même quelle que soit l'unité utilisée.
- Unit est une Reference qui désigne l'unité de Uncertainty. Elle n'accepte pas de Value. Le Quantifier est Identified.
  - On recommande d'utiliser les entités d'unité de Wikidata, [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) : degré Q28390, minute d'arc Q209426, seconde d'arc Q829073, mètre Q11573, millimètre Q174789, etc. Une unité sans QID est désignée par une autre Reference (LOCAL, GEUL, etc.). Lorsque plusieurs Reference désignent la même unité, le QID est la forme canonique.
  - Si Unit est le mètre (Q11573), Uncertainty équivaut au `u` de la RFC 5870.
- **Inconnue** : on place [ABSENT](../slot-marker.md) (`0x0000`) à l'emplacement de Unit et on fixe Uncertainty à `+0` (`0000 0000`). C'est le cas où `u` est omis dans la RFC 5870. Si Unit est ABSENT et que Uncertainty n'est pas `+0`, c'est invalid (la représentation est fixée de façon unique).
- L'altitude n'est pas portée. Si nécessaire, on la définit dans un format distinct. L'altitude de Wikidata n'a pas été utilisée dans l'échantillon (0/23 066) ; lorsqu'une valeur existe, on ne la convertit pas et on conserve le texte d'origine en UTF8-TEXT.
- Pour les coordonnées terrestres, on recommande ce format. Une coordonnée qui indique la Terre (Q2) dans COORDINATE-GEO n'est pas invalid non plus ; le côté qui compare les ramène à la même coordonnée.
- Le document de spécification geul.org `0x00000000/codecs/0x00000640` place [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`) sur les champs de valeur brute Latitude, Longitude et Uncertainty (4 WORD = binary64, 2 WORD = binary32), et CODEC `000F`·`020F`·`040F` (toute Reference) et `0000` (ABSENT) sur le champ d'enregistrement Unit.

## Longueur {#길이}

- Le total est 1 WORD de TAG + 10 WORD + l'enregistrement Unit.

| Unit | Total | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `064B` (`LLLL=1011`) |
| QID tenant sur 1 WORD (2 WORD, par ex. degré Q28390) | 13 WORD | `064C` (`LLLL=1100`) |
| QID sur 2 WORD (3 WORD, par ex. minute d'arc Q209426) | 14 WORD | `064D` (`LLLL=1101`) |
| Enregistrement Unit de 4 WORD ou plus | 15 WORD ou plus | longueur étendue ([Enregistrement et TAG WORD](../record.md)) |

- On ne définit pas de paire de Codec pair/impair.

## Correspondance avec Wikidata {#위키데이터-대응}

globecoordinate de Wikidata : `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | ce format (la Terre). Les autres corps célestes relèvent de COORDINATE-GEO |
| latitude, longitude | binary64 tel quel (la valeur Wikidata étant à l'origine en binary64, il n'y a pas de perte) |
| precision (degrés) | Uncertainty et Unit. Voir « Précision » ci-dessous |
| precision null ou absente | Unit = ABSENT, Uncertainty = `+0` (inconnue) |
| altitude | écartée (toujours null) |

- La precision de Wikidata n'est pas une erreur de mesure mais une **résolution d'enregistrement** (la coordonnée a-t-elle été notée au degré, à la minute ou à la seconde près). L'Uncertainty de GEUL reporte cette valeur sans la modifier. Ce n'est pas un rayon auquel s'ajouteraient des erreurs de mesure ou de système de coordonnées.

### Précision {#정밀도}

On reporte la precision sans conversion. On choisit, parmi le degré, la minute d'arc et la seconde d'arc, la première unité qui restitue la notation d'origine.

| Texte d'origine de precision (exemples) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k degrés) | degré Q28390 | binary32 de cette valeur |
| notation décimale courte comme `0.0166667` | degré Q28390 | binary32 de cette valeur |
| `0.016666666666667` (1/60°) | minute d'arc Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | seconde d'arc Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0,1″) | seconde d'arc Q829073 | `0.1` |

- Conversion directe : dans l'ordre degré, minute d'arc (×60), seconde d'arc (×3600), on prend pour Uncertainty le binary32 le plus proche du produit de precision par le nombre d'unités, et on utilise la première unité pour laquelle la conversion inverse ci-dessous restitue exactement le texte d'origine de precision.
- Conversion inverse : on divise la notation décimale la plus courte de Uncertainty (le nombre le plus court qui se relit comme ce binary32) par le nombre d'unités pour revenir en degrés, puis on l'écrit comme Wikibase l'écrit dans le dump (14 chiffres significatifs, notation exponentielle `1.0e-6`·`2.7777777777778e-5` en dessous de `1e-4`). La base de chargement (jsonb) la conserve en notation décimale `0.0000010`·`0.000027777777777778`.
- Si aucune unité ne restitue le texte d'origine (notation à 17 chiffres significatifs `0.0002777777777777778`, valeurs aberrantes qui ressemblent à des valeurs calculées, etc.), on ne convertit pas la coordonnée entière et on conserve le texte d'origine en UTF8-TEXT. Il en va de même pour une precision négative et pour une valeur dont le corps céleste est vide.
- Échantillon Wikidata Q1–Q10000 (7 026 déclarations de coordonnées, 6 824 avec precision) : 5 933 restituent le texte d'origine (86,9 % ; degré 4 104, seconde d'arc 1 370, minute d'arc 459). Sur les 891 qui ne le restituent pas, 753 relèvent de la série 1/3600 et 1/60 en notation à 17 chiffres significatifs.

## Exemple {#예시}

Berlin 52.516666666667, 13.383333333333, precision 1/60° (1 minute d'arc) :

```
064D 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0142 0003 3212
```

- TAG `064D` (14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000` (binary32 1.0), Unit `0142 0003 3212` (WIKIDATA-QID Q209426, minute d'arc).
- Notation textuelle : `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

Le même point à incertitude inconnue : `064B 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## Fondement normatif {#표준-근거}

- Sens : [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — ordre latitude, longitude, incertitude `u` (en mètres), système de coordonnées par défaut WGS 84. Si Unit est le mètre, Uncertainty = `u`.
- Valeurs numériques : [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitude, longitude), binary32 (incertitude).
- Ordre des axes et intervalles : ISO 6709 (Standard representation of geographic point location by coordinates).
- Unité : entités d'unité de Wikidata (QID). La disposition de largeur fixe, le champ Unit et la représentation de l'inconnue sont des règles de GEUL.

## Problèmes ouverts {#열린-문제}

1. L'altitude.
2. Un format conservant le texte d'origine d'une chaîne ISO 6709 (COORDINATE-ISO6709) sera défini lorsqu'un usage apparaîtra.
3. Une façon de reporter sans perte la notation à 17 chiffres significatifs de la precision de Wikidata (environ 11 % de l'échantillon).

## Pages liées {#관련-페이지}

- [Value](_index.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [BINARY-FLOAT](0x063L-binary-float.md), [marqueur d'emplacement](../slot-marker.md)
- Le format d'Issuer [POINT2-BINARY64](adhoc.geul.org/point2-binary64.md) est un point bidimensionnel général dont le système de coordonnées, l'unité et le sens des axes sont laissés au contexte extérieur ; le présent format est une coordonnée géographique sur la Terre.

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000640/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000064000000000
BODY
#1 DECLARE 0x0640
#2 FIELD #1 0x0004
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "COORDINATE-EARTH"
#6 BIND #2 "latitude"
#7 BIND #3 "longitude"
#8 BIND #4 "uncertainty"
#9 CODEC #2 0x0630
#10 CODEC #3 0x0630
#11 CODEC #4 0x0630
#12 FIELD #1 record
#13 BIND #12 "unit"
#14 CODEC #12 0x000F
#16 CODEC #12 0x020F
#17 CODEC #12 0x040F
#15 CODEC #12 0x0000
```
