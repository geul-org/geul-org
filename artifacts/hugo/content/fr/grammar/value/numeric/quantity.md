---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY est une Value qui contient une quantité en quatre enregistrements : une quantité décimale exacte, une Reference d'unité, des bornes inférieure et supérieure."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY est une Value qui représente une quantité par un décimal exact, une unité et des bornes inférieure et supérieure. Code direct de Value `0x06`, famille NUMERIC. Chacune des quatre parties est un enregistrement complet. L'unité et les bornes étant des [champs facultatifs](/fr/grammar/codec-spec/), on écrit ABSENT (`0x0000`) quand on les omet.

## Disposition

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[TAG d'extension de Length] à partir de 15 WORD au total
amount            enregistrement Value SIGNED-DECIMAL
unit              enregistrement Reference (élément d'unité), 0x0000 si sans unité
lower             enregistrement Value SIGNED-DECIMAL, 0x0000 ABSENT si omise
upper             enregistrement Value SIGNED-DECIMAL, 0x0000 ABSENT si omise
```

## Interprétation et validité

- amount est un [SIGNED-DECIMAL](/fr/grammar/value/decimal/signed-decimal/) `C×10^E`. C et E conservent tel quel le nombre de chiffres de la notation d'origine : `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Ce sont le même nombre mais avec des chiffres significatifs différents, donc des Value différentes. Le nombre de chiffres du coefficient n'est pas plafonné (complément à deux sur le nombre minimal de WORD, longueur variable).
- unit est exactement un enregistrement Reference complet, ou `0x0000`. Toute Reference qui désigne un élément d'unité convient (pour les unités de Wikidata, WIKIDATA-QID). `0x0000` signifie sans unité (comptage, rapport, population, etc.).
- lower et upper sont chacun un enregistrement SIGNED-DECIMAL ou `0x0000`. L'un des deux suffit. Un intervalle symétrique (`652 ± 1`) s'écrit aussi avec les deux bornes (`651`, `653`). Comme il existe des intervalles asymétriques qui exigent de toute façon deux valeurs, on ne prévoit pas de forme réduite à un seul ±.
- L'unité fait partie de la valeur. On ne la détache pas dans un QUALIFIER ou autre (détachée, on ne saurait plus si `652` est en km ou en m).
- On ne contient pas la valeur convertie en unités SI. C'est une valeur dérivée qui se calcule à partir de l'unité et de la table de conversion.
- Le curseur après lecture des quatre enregistrements doit coïncider exactement avec la fin du Payload. Toute autre forme est invalid.
- Le document de spécification de geul.org s'écrit avec quatre champs d'enregistrement : amount (`0810`), unit (`0780`, `0000`), lower et upper (`0810`, `0000`) ([Documents de spécification de Codec](/fr/grammar/codec-spec/)).

## Longueur

- Le total est le TAG de 1 WORD + (TAG d'extension de Length) + quatre enregistrements. Un enregistrement décimal fait au moins TAG 1 + exposant 2 + coefficient 1 WORD.
- Un petit nombre sans unité ni bornes fait 8 WORD. À partir de 15 WORD, on emploie la longueur étendue ([Enregistrement et TAG WORD](/fr/grammar/record/)).

## Exemple

`1.20` sans unité :

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit, lower et upper `0000`.

`652 km`, intervalle `[651, 653]` (km = Q828224) :

```
0F06 0011
0990 0000 0000 028C
0120 000C A340
0990 0000 0000 028B
0990 0000 0000 028D
```

- 17 WORD au total, donc `LLLL=1110`, TAG d'extension `0011`.

## Correspondance Wikidata

- Le datavalue `quantity` `{"amount","unit","lowerBound","upperBound"}` → amount, unit, lower, upper. Les chaînes d'amount et de bornes (`+1.20`, y compris la notation exponentielle) se transcrivent en C et E avec leurs chiffres tels quels.
- L'unit `"1"` est sans unité (`0x0000`), `http://www.wikidata.org/entity/Qn` est WIKIDATA-QID. Pour les autres unités et les nombres ou bornes mal formés, on ne convertit pas et l'on conserve le texte d'origine en UTF8-TEXT.
- Échantillon de Wikidata (environ 42 000 quantity en tête de dump) : sans unité 61 %, avec bornes 13 % (dont symétriques 93 %), plus long amount 31 caractères.

## Fondement normatif

- Notation décimale et conservation du nombre de chiffres : notions de coefficient, exponent et quantum du decimal d'[IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL de GEUL).
- Modèle de quantité de Wikidata : `QuantityValue` du Wikibase DataModel.

## Pages liées

- [Value](/fr/grammar/value/), [SIGNED-DECIMAL](/fr/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/fr/grammar/value/numeric/coordinate-geo/), [CODEC](/fr/grammar/edge/codec/), [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/)
