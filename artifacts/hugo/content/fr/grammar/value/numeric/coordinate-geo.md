---
title: "COORDINATE-GEO"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-30T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO est une Value qui contient un point d'un corps céleste (planète, satellite, etc.) par une Reference du corps céleste, la latitude et la longitude en binary64, l'incertitude en binary32 et une Reference de son unité."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-GEO est une Value de coordonnées qui représente un point d'un corps céleste désigné (planète, satellite, astéroïde, etc.) par sa latitude, sa longitude et son incertitude. Code direct de Value `0x05`, famille NUMERIC. C'est le format [COORDINATE-EARTH](/fr/grammar/value/numeric/coordinate-earth/) (`0x04`) précédé d'une Reference du corps céleste (Globe), et les règles de latitude, longitude, incertitude et unité sont celles de COORDINATE-EARTH.

## Disposition

```
TAG WORD          0000 1LLL L000 0101      Codec 0x05
[TAG d'extension de Length] à partir de 15 WORD au total
Globe             1 enregistrement Reference (Reference désignant le corps céleste, Quantifier Identified)
Latitude          4 WORD en valeur brute, IEEE 754 binary64 (degrés)
Longitude         4 WORD en valeur brute, IEEE 754 binary64 (degrés)
Uncertainty       2 WORD en valeur brute, IEEE 754 binary32 (en unité Unit)
Unit              1 enregistrement Reference, ou marqueur d'emplacement 0x0000 ABSENT
```

## Interprétation et validité

- Le Payload commence par l'enregistrement Globe. Globe est exactement un enregistrement Reference complet, de Quantifier Identified (`000`). Toute Reference qui désigne un corps céleste convient : [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/) (corps célestes nommés), [GEUL](/fr/grammar/reference/geul/), un [LOCAL](/fr/grammar/reference/local/) du même document (corps céleste défini dans le document), un corps céleste d'un autre document ([EXTERNAL-POINTER](/fr/grammar/reference/external-pointer/), [EXTERNAL-ISSUER](/fr/grammar/reference/external-issuer/)), etc. Les corps célestes sont innombrables et ceux qui ont un QID n'en sont qu'une partie.
- Après Globe viennent 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) et un enregistrement Unit. Le curseur après lecture de Unit doit coïncider avec la fin de l'enregistrement.
- Latitude : `-90 ≤ φ ≤ 90`, Longitude : `-360 ≤ λ ≤ 360`. La plage est plus large que sur la Terre pour contenir sans changement les valeurs des systèmes de coordonnées de corps célestes qui comptent la longitude de 0 à 360° (est ou ouest), ainsi que les valeurs négatives écrites dans le sens opposé. La plage est la même que celle du modèle de données globecoordinate de Wikidata (Wikibase `LatLongValue`). `λ` et `λ ± 360` sont le même méridien, et GEUL ne les normalise pas. Les autres règles (binary64, valeurs finies, ordre des axes, sens d'Uncertainty et d'Unit, expression de l'inconnu) sont celles de COORDINATE-EARTH.
- Le système de coordonnées suit, pour chaque corps céleste, la convention de ce corps (latitude planétocentrique, longitude est ou ouest de 0 à 360°, etc.). Le système de coordonnées propre à chaque corps céleste est fixé par un document GEUL à part.
- Pour une Uncertainty en unité de distance (mètre, etc.), c'est une distance sur la surface du corps céleste. Pour une unité angulaire (degré, minute d'arc, seconde d'arc), c'est le rayon angulaire en latitude et longitude, quelle que soit la taille du corps céleste.
- Pour les coordonnées terrestres (Q2), on recommande COORDINATE-EARTH. Mettre la Terre dans ce format n'est pas invalid non plus, et celui qui compare les aligne sur la même coordonnée.
- Le document de spécification de geul.org `0x0000/0x0000000000000805` place sur les champs en valeur brute Latitude, Longitude et Uncertainty le [CODEC](/fr/grammar/edge/codec/) BINARY-FLOAT (`0803`), et sur le champ d'enregistrement Unit les CODEC `0780` (toute Reference) et `0000` (ABSENT).

## Longueur

- Le total est le TAG de 1 WORD + (TAG d'extension de Length) + enregistrement Globe + 10 WORD + enregistrement Unit.
- Si Globe fait 2 WORD (quand le QID tient dans 1 WORD) et Unit est ABSENT, 14 WORD, `LLLL=1101`, TAG `0E85`. Si Unit est une Reference (2 WORD ou plus), on dépasse 15 WORD et l'on emploie la longueur étendue : TAG `0F05`, le WORD suivant porte le nombre total de WORD ([Enregistrement et TAG WORD](/fr/grammar/record/)).

## Correspondance Wikidata

- Une globecoordinate dont le globe n'est pas la Terre (Q2) s'écrit avec ce format. Globe = WIKIDATA-QID (élément du globe). La correspondance latitude, longitude, precision → Uncertainty et Unit est celle de COORDINATE-EARTH (precision étant une résolution d'enregistrement en degrés, on le transcrit tel quel quelle que soit la taille du corps céleste).
- Corps célestes hors de la Terre dans l'échantillon de Wikidata (environ 24 000 revendications de coordonnées) : Mars (Q111), Cérès (Q596), la Lune (Q405), Mercure (Q308), Vénus (Q313), etc., 23 cas. Les 41 cas dont le globe est vide ne sont pas convertis et leur texte d'origine est conservé en UTF8-TEXT.

## Exemple

Mars (Q111) 4.5, 137.4, incertitude inconnue :

```
0E85 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `0E85` (Codec `0x05`, `LLLL=1101`, 14 WORD), Globe `00A0 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, inconnu).
- Notation textuelle : `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

Le même point, precision 0,1° (Unit degré Q28390) :

```
0F05 0010 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 00A0 6EE6
```

- TAG `0F05` (`LLLL=1110`, longueur étendue), total `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `00A0 6EE6` (Q28390).

## Fondement normatif

- Sens : latitude, longitude et `u` (quand Unit est le mètre) de la [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870). Le seul système de coordonnées enregistré pour `crs` dans la RFC 5870 étant `wgs84`, on désigne les corps célestes hors de la Terre par la Reference Globe de GEUL.
- Valeurs : [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (latitude, longitude), binary32 (incertitude).
- Plage de longitude : `-360 ≤ λ ≤ 360` du modèle de données globecoordinate de Wikidata, [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo).

## Problèmes ouverts

1. Documents de systèmes de coordonnées par corps céleste : définition de la latitude (planétocentrique ou planétographique) et direction et plage de la longitude pour chaque corps céleste.

## Pages liées

- [Value](/fr/grammar/value/), [COORDINATE-EARTH](/fr/grammar/value/numeric/coordinate-earth/), [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/), [GEUL](/fr/grammar/reference/geul/), [LOCAL](/fr/grammar/reference/local/)
