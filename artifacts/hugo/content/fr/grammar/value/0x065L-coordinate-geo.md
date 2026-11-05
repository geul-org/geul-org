---
title: "COORDINATE-GEO (0x065L)"
weight: 101
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO est une Value de coordonnées qui représente un point d'un corps céleste désigné (planète, satellite, astéroïde, etc.) par sa latitude, sa longitude et une incertitude."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `COORDINATE-GEO` (document de spécification BIND `COORDINATE-GEO`) |
| TAG ID | `0x065L` |
| Codec ID | `0x00000650` |
| Document de spécification | `0x00000000/codecs/0x00000650/` (cible DECLARE `0650`) |
| Section | 3 `0011` (Value), offset C dans la section = 5 |
| Kind | Value · famille : NUMERIC |
| TAG WORD | `0000 0110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Reference du corps céleste, latitude et longitude en binary64, incertitude en binary32 et Reference de son unité |
| Côté Hugo | `value/numeric/coordinate-geo.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `globe` | #2 | enregistrement | `0050` LOCAL, `00A0` GEUL, `00F0` GEUL-SIDX, `0140` WIKIDATA-QID, `0200` EXTERNAL-POINTER-1WORD, `0250` EXTERNAL-POINTER-2WORD, `02A0` EXTERNAL-POINTER-4WORD, `02F0` EXTERNAL-ISSUER-2WORD, `0340` EXTERNAL-ISSUER-4WORD, `0390` EXTERNAL-ISSUER-16WORD |  |
| 2 | `latitude` | #3 | valeur brute 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `longitude` | #4 | valeur brute 4 WORD | `0630` BINARY-FLOAT |  |
| 4 | `uncertainty` | #5 | valeur brute 2 WORD | `0630` BINARY-FLOAT |  |
| 5 | `unit` | #26 | enregistrement | `000F` toute la section 0 (joker, Reference), `020F` toute la section 1 (joker, Reference), `040F` toute la section 2 (joker, Reference), `0000` ABSENT (champ facultatif) |  |

COORDINATE-GEO est une Value de coordonnées qui représente un point d'un corps céleste désigné (planète, satellite, astéroïde, etc.) par sa latitude, sa longitude et une incertitude. Son code direct Value est `0x065L`, sa famille est NUMERIC. C'est le format de [COORDINATE-EARTH](0x064L-coordinate-earth.md) (`0x064L`) précédé d'une Reference de corps céleste (Globe) ; les règles de latitude, de longitude, d'incertitude et d'unité sont celles de COORDINATE-EARTH.

## Disposition {#레이아웃}

```
TAG WORD          0000 0110 0101 LLLL      Codec 0x065L
[TAG d'extension de Length] à partir de 15 WORD au total
Globe             1 enregistrement Reference (Reference désignant le corps céleste, Quantifier Identified)
Latitude          4 WORD valeur brute, IEEE 754 binary64 (degrés)
Longitude         4 WORD valeur brute, IEEE 754 binary64 (degrés)
Uncertainty       2 WORD valeur brute, IEEE 754 binary32 (en unité Unit)
Unit              1 enregistrement Reference, ou marqueur d'emplacement 0x0000 ABSENT
```

## Interprétation et validité {#해석과-유효성}

- Le Payload commence par l'enregistrement Globe. Globe est exactement un enregistrement Reference complet, de Quantifier Identified. N'importe quelle Reference désignant un corps céleste peut servir : [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) (corps célestes nommés), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md) du même document (corps céleste défini dans le document), corps céleste d'un autre document ([EXTERNAL-POINTER](../reference/0x020L-external-pointer-1word.md)·[EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)), etc. Les corps célestes sont innombrables et ceux qui ont un QID n'en sont qu'une partie.
- Après Globe viennent 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) et un enregistrement Unit. Le curseur après la lecture de Unit doit coïncider avec la fin de l'enregistrement.
- Latitude vérifie `-90 ≤ φ ≤ 90`, Longitude vérifie `-360 ≤ λ ≤ 360`. L'intervalle est plus large que pour la Terre afin de porter sans les modifier à la fois les valeurs des systèmes de coordonnées célestes qui comptent la longitude de 0 à 360° (est ou ouest) et les valeurs négatives écrites dans le sens inverse. L'intervalle est celui du modèle de données globecoordinate de Wikidata (`LatLongValue` de Wikibase). `λ` et `λ ± 360` désignent le même méridien et GEUL ne normalise pas. Les autres règles (binary64, valeur finie, ordre des axes, sens de Uncertainty et Unit, représentation de l'inconnue) sont celles de COORDINATE-EARTH.
- Le système de coordonnées suit, pour chaque corps céleste, la convention de ce corps (latitude planétocentrique, longitude est ou ouest de 0 à 360°, etc.). Le système de coordonnées propre à chaque corps est défini dans un document GEUL distinct.
- Une Uncertainty en unité de distance (mètre, etc.) est une distance à la surface du corps céleste. Une unité angulaire (degré, minute d'arc, seconde d'arc) est un rayon angulaire en latitude et longitude, quelle que soit la taille du corps céleste.
- Pour les coordonnées de la Terre (Q2), on recommande COORDINATE-EARTH. Écrire la Terre dans ce format n'est pas invalid non plus ; le côté qui compare les ramène à la même coordonnée.
- Le document de spécification geul.org `0x00000000/codecs/0x00000650` place [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`) sur les champs de valeur brute Latitude, Longitude et Uncertainty, et CODEC `000F`·`020F`·`040F` (toute Reference) et `0000` (ABSENT) sur le champ d'enregistrement Unit.

## Longueur {#길이}

- Le total est 1 WORD de TAG + (TAG d'extension de Length) + l'enregistrement Globe + 10 WORD + l'enregistrement Unit.
- Si Globe fait 2 WORD (QID tenant sur 1 WORD) et que Unit est ABSENT, le total est de 14 WORD, `LLLL=1101`, TAG `065D`. Si Unit est une Reference (2 WORD ou plus), le total dépasse 15 WORD et on utilise la longueur étendue : TAG `065E`, puis le WORD suivant contient le nombre total de WORD ([Enregistrement et TAG WORD](../record.md)).

## Correspondance avec Wikidata {#위키데이터-대응}

- Un globecoordinate dont le globe n'est pas la Terre (Q2) s'écrit dans ce format. Globe = WIKIDATA-QID (entité du globe). La correspondance de la latitude, de la longitude et de precision → Uncertainty·Unit est celle de COORDINATE-EARTH (precision étant une résolution d'enregistrement en degrés, elle est reportée telle quelle quelle que soit la taille du corps céleste).
- Corps célestes autres que la Terre dans l'échantillon Wikidata (environ 24 000 déclarations de coordonnées) : Mars (Q111), Cérès (Q596), Lune (Q405), Mercure (Q308), Vénus (Q313), etc., soit 23 cas. Les 41 cas dont le globe est vide ne sont pas convertis, et le texte d'origine est conservé en UTF8-TEXT.

## Exemple {#예시}

Mars (Q111) 4.5, 137.4, incertitude inconnue :

```
065D 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `065D` (Codec `0x065L`, `LLLL=1101`, 14 WORD), Globe `0141 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, inconnue).
- Notation textuelle : `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

Le même point, precision 0,1° (Unit degré Q28390) :

```
065E 0010 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 0141 6EE6
```

- TAG `065E` (`LLLL=1110`, longueur étendue), total `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `0141 6EE6` (Q28390).

## Fondement normatif {#표준-근거}

- Sens : latitude, longitude et `u` de la [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) (lorsque Unit est le mètre). Le seul système de coordonnées enregistré pour `crs` dans la RFC 5870 étant `wgs84`, les corps célestes autres que la Terre sont désignés par la Reference Globe de GEUL.
- Valeurs numériques : [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitude, longitude), binary32 (incertitude).
- Intervalle de longitude : `-360 ≤ λ ≤ 360` de [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo), le modèle de données globecoordinate de Wikidata.

## Problèmes ouverts {#열린-문제}

1. Documents de système de coordonnées par corps céleste : définition de la latitude (planétocentrique, planétographique) et sens et intervalle de la longitude pour chaque corps.

## Pages liées {#관련-페이지}

- [Value](_index.md), [COORDINATE-EARTH](0x064L-coordinate-earth.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000650/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000065000000000
BODY
#1 DECLARE 0x0650
#2 FIELD #1 record
#3 FIELD #1 0x0004
#4 FIELD #1 0x0004
#5 FIELD #1 0x0002
#6 BIND #1 "COORDINATE-GEO"
#7 BIND #2 "globe"
#8 BIND #3 "latitude"
#9 BIND #4 "longitude"
#10 BIND #5 "uncertainty"
#11 CODEC #3 0x0630
#12 CODEC #4 0x0630
#13 CODEC #2 0x0050
#14 CODEC #2 0x00A0
#15 CODEC #2 0x00F0
#16 CODEC #2 0x0140
#17 CODEC #2 0x0200
#18 CODEC #2 0x0250
#19 CODEC #2 0x02A0
#22 CODEC #2 0x02F0
#23 CODEC #2 0x0340
#24 CODEC #2 0x0390
#25 CODEC #5 0x0630
#26 FIELD #1 record
#27 BIND #26 "unit"
#28 CODEC #26 0x000F
#30 CODEC #26 0x020F
#31 CODEC #26 0x040F
#29 CODEC #26 0x0000
```
