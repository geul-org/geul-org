---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY est une Value qui contient une quantité en quatre enregistrements : une quantité sous forme d'enregistrement Value numérique (entier, BINARY-FLOAT, décimal, fraction), une Reference d'unité, des bornes inférieure et supérieure."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY est une Value qui représente une quantité par un nombre, une unité et des bornes inférieure et supérieure. Code direct de Value `0x06`, famille NUMERIC. Chacune des quatre parties est un enregistrement complet. L'unité et les bornes étant des [champs facultatifs](/fr/grammar/codec-spec/), on écrit ABSENT (`0x0000`) quand on les omet.

## Disposition

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[TAG d'extension de Length] à partir de 15 WORD au total
amount            enregistrement Value numérique (entier, BINARY-FLOAT, décimal, fraction)
unit              enregistrement Reference (élément d'unité), 0x0000 si sans unité
lower             enregistrement Value numérique, 0x0000 ABSENT si omise
upper             enregistrement Value numérique, 0x0000 ABSENT si omise
```

## Interprétation et validité

- amount est exactement un enregistrement Value numérique complet. Six Codec sont acceptés : [SIGNED-INTEGER](/fr/grammar/value/numeric/signed-integer/) (`0x01`), [UNSIGNED-INTEGER](/fr/grammar/value/numeric/unsigned-integer/) (`0x02`), [BINARY-FLOAT](/fr/grammar/value/numeric/binary-float/) (`0x03`), [FRACTION](/fr/grammar/value/numeric/fraction/) (`0x07`), [SIGNED-DECIMAL](/fr/grammar/value/decimal/signed-decimal/) (`0x10`) et [UNSIGNED-DECIMAL](/fr/grammar/value/decimal/unsigned-decimal/) (`0x11`). C'est une liste fermée, pas un joker. BOOL, COORDINATE-EARTH et COORDINATE-GEO, QUANTITY elle-même (pas d'imbrication, profondeur fixe) et les autres Value ne sont pas acceptés. On ne peut pas écrire de marqueur de position (`0x0000`, etc.) pour amount.
- Les enregistrements internes suivent aussi la forme canonique de leur Codec (nombre minimal de WORD pour les entiers et le coefficient, 1/2/4/8 WORD pour BINARY-FLOAT, FRACTION selon ses propres règles). Si un enregistrement interne n'est pas canonique, toute la QUANTITY est invalid.
- Si amount, lower ou upper est un BINARY-FLOAT, ce doit être une valeur finie. NaN et ±Infinity sont invalid (même règle que la latitude et la longitude de [COORDINATE-EARTH](/fr/grammar/value/numeric/coordinate-earth/)).
- Le format du nombre suit tel quel la notation d'origine. Un original entier se contient en INTEGER, un original à décimales en DECIMAL, un original fractionnaire en FRACTION, une valeur binaire IEEE 754 en BINARY-FLOAT ; l'encodeur ne normalise pas en changeant de format. C et E d'un DECIMAL conservent tel quel le nombre de chiffres de la notation d'origine : `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Ce sont le même nombre mais avec des chiffres significatifs différents, donc des Value différentes. Le nombre de chiffres des entiers et du coefficient n'est pas plafonné (nombre minimal de WORD, longueur variable).
- unit est exactement un enregistrement Reference complet, ou `0x0000`. Toute Reference qui désigne un élément d'unité convient (pour les unités de Wikidata, WIKIDATA-QID). `0x0000` signifie sans unité (comptage, rapport, population, etc.).
- lower et upper sont chacun un enregistrement de l'un des six mêmes Codec qu'amount, ou `0x0000` ABSENT. Le seul marqueur de position accepté est l'omission ABSENT. L'un des deux suffit. Les trois nombres n'ont pas besoin du même Codec. Un intervalle symétrique (`652 ± 1`) s'écrit aussi avec les deux bornes (`651`, `653`). Comme il existe des intervalles asymétriques qui exigent de toute façon deux valeurs, on ne prévoit pas de forme réduite à un seul ±.
- lower ≤ amount ≤ upper se compare par valeur numérique, non par octets ni par Codec. Même si les types diffèrent, on compare les nombres (p. ex. SIGNED-INTEGER `652` et SIGNED-DECIMAL `651.5`). FRACTION se compare comme nombre rationnel exact.
- L'unité fait partie de la valeur. On ne la détache pas dans un QUALIFIER ou autre (détachée, on ne saurait plus si `652` est en km ou en m).
- Extrait, l'enregistrement amount est tel quel un enregistrement Value autonome. Quand on a besoin du nombre sans l'unité, on utilise cet enregistrement sans réencoder.
- On ne contient pas la valeur convertie en unités SI. C'est une valeur dérivée qui se calcule à partir de l'unité et de la table de conversion.
- Le curseur après lecture des quatre enregistrements doit coïncider exactement avec la fin du Payload. Toute autre forme est invalid.
- Le document de spécification de geul.org s'écrit avec quatre champs d'enregistrement : amount (`0801`, `0802`, `0803`, `0807`, `0810`, `0811`), unit (`0780`, `0000`), lower et upper (`0801`, `0802`, `0803`, `0807`, `0810`, `0811`, `0000`) ([Documents de spécification de Codec](/fr/grammar/codec-spec/)).

## Longueur

- Le total est le TAG de 1 WORD + (TAG d'extension de Length) + quatre enregistrements. Un enregistrement entier fait au moins TAG 1 + Payload 1 WORD, un enregistrement BINARY-FLOAT fait 2, 3, 5 ou 9 WORD, et un enregistrement décimal fait au moins TAG 1 + exposant 2 + coefficient 1 WORD. Un enregistrement FRACTION fait au moins 5 WORD.
- Un petit entier sans unité ni bornes fait 6 WORD, un petit décimal 8 WORD. À partir de 15 WORD, on emploie la longueur étendue ([Enregistrement et TAG WORD](/fr/grammar/record/)).

## Exemple

`1.20` sans unité :

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078` (E = -2, C = 120), unit, lower et upper `0000`.

Entier `42` sans unité :

```
0A86 0881 002A 0000 0000 0000
```

- TAG `0A86` (6 WORD), amount `0881 002A` (SIGNED-INTEGER 42), unit, lower et upper `0000`.

Fraction `2/3` sans unité (les deux tiers des voix présentes) :

```
0C06 0A07 0881 0002 0882 0003 0000 0000 0000
```

- TAG `0C06` (9 WORD), amount `0A07 0881 0002 0882 0003` ([FRACTION](/fr/grammar/value/numeric/fraction/) 2/3), unit, lower et upper `0000`.

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
- L'amount et les bornes de Wikidata sont des chaînes décimales ; même en forme d'entier (`+652`), on les transcrit en SIGNED-DECIMAL. La conversion de Wikidata n'utilise pas d'autres Codec numériques.
- L'unit `"1"` est sans unité (`0x0000`), `http://www.wikidata.org/entity/Qn` est WIKIDATA-QID. Pour les autres unités et les nombres ou bornes mal formés, on ne convertit pas et l'on conserve le texte d'origine en UTF8-TEXT.
- Échantillon de Wikidata (environ 42 000 quantity en tête de dump) : sans unité 61 %, avec bornes 13 % (dont symétriques 93 %), plus long amount 31 caractères.

## Fondement normatif

- Notation décimale et conservation du nombre de chiffres : notions de coefficient, exponent et quantum du decimal d'[IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL de GEUL).
- Modèle de quantité de Wikidata : `QuantityValue` du Wikibase DataModel.

## Pages liées

- [Value](/fr/grammar/value/), [SIGNED-DECIMAL](/fr/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/fr/grammar/value/numeric/coordinate-geo/), [CODEC](/fr/grammar/edge/codec/), [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/)
