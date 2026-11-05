---
title: "QUANTITY (0x066L)"
weight: 102
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY est une Value qui représente une quantité par un nombre, une unité, une borne inférieure et une borne supérieure."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `QUANTITY` (document de spécification BIND `QUANTITY`) |
| TAG ID | `0x066L` |
| Codec ID | `0x00000660` |
| Document de spécification | `0x00000000/codecs/0x00000660/` (cible DECLARE `0660`) |
| Section | 3 `0011` (Value), offset C dans la section = 6 |
| Kind | Value · famille : NUMERIC |
| TAG WORD | `0000 0110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | amount en Value numérique (entier, BINARY-FLOAT, nombre décimal, fraction), Reference d'unité, borne inférieure et borne supérieure. L'unité et les bornes peuvent être omises (ABSENT `0x0000`) |
| Côté Hugo | `value/numeric/quantity.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `amount` | #2 | enregistrement | `0680` SIGNED-DECIMAL, `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 2 | `unit` | #3 | enregistrement | `000F` toute la section 0 (joker, Reference), `020F` toute la section 1 (joker, Reference), `040F` toute la section 2 (joker, Reference), `0000` ABSENT (champ facultatif) |  |
| 3 | `lower` | #4 | enregistrement | `0680` SIGNED-DECIMAL, `0000` ABSENT (champ facultatif), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 4 | `upper` | #5 | enregistrement | `0680` SIGNED-DECIMAL, `0000` ABSENT (champ facultatif), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |

QUANTITY est une Value qui représente une quantité par un nombre, une unité, une borne inférieure et une borne supérieure. Son code direct Value est `0x066L`, sa famille est NUMERIC. Les quatre parties sont chacune un enregistrement complet. L'unité et les bornes sont des [champs facultatifs](../codec-spec.md) : si on les omet, on écrit ABSENT (`0x0000`).

## Disposition {#레이아웃}

```
TAG WORD          0000 0110 0110 LLLL      Codec 0x066L
[TAG d'extension de Length] à partir de 15 WORD au total
amount            enregistrement de Value numérique (entier, BINARY-FLOAT, nombre décimal, fraction)
unit              enregistrement Reference (entité d'unité), 0x0000 si sans unité
lower             enregistrement de Value numérique, 0x0000 ABSENT si omis
upper             enregistrement de Value numérique, 0x0000 ABSENT si omis
```

## Interprétation et validité {#해석과-유효성}

- amount est exactement un enregistrement de Value numérique complet. Les Codec reçus sont au nombre de six : [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`), [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`), [BINARY-FLOAT](0x063L-binary-float.md) (`0x063L`), [FRACTION](0x067L-fraction.md) (`0x067L`), [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`), [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`). La liste est fermée et n'est pas un joker. BOOL, COORDINATE-EARTH·COORDINATE-GEO, QUANTITY lui-même (imbrication interdite, profondeur fixe) et les autres Value ne sont pas reçus. Aucun marqueur d'emplacement (`0x0000`, etc.) ne peut être utilisé pour amount.
- Les enregistrements intérieurs suivent aussi la forme canonique de chaque Codec (entiers et coefficient en nombre minimal de WORD, BINARY-FLOAT sur 1/2/4/8 WORD, FRACTION selon ses règles). Si un enregistrement intérieur est non canonique, QUANTITY tout entier est invalid.
- Si amount, lower ou upper est un BINARY-FLOAT, la valeur doit être finie. NaN et ±Infinity sont invalid (même règle que pour la latitude et la longitude de [COORDINATE-EARTH](0x064L-coordinate-earth.md)).
- Le format du nombre suit la notation d'origine. Un texte d'origine entier est porté en INTEGER, un texte décimal en DECIMAL, une fraction en FRACTION, une valeur binaire IEEE 754 en BINARY-FLOAT, et l'encodeur ne normalise pas en changeant de format. Les C et E de DECIMAL portent tels quels les chiffres de la notation d'origine : `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. Ces deux valeurs sont le même nombre, mais leurs chiffres significatifs diffèrent : ce sont donc des Value différentes. Il n'y a pas de borne supérieure au nombre de chiffres de l'entier ni du coefficient (nombre minimal de WORD, longueur variable).
- unit est exactement un enregistrement Reference complet, ou `0x0000`. N'importe quelle Reference désignant une entité d'unité peut servir (pour les unités Wikidata, WIKIDATA-QID). `0x0000` signifie sans unité (dénombrement, rapport, population, etc.).
- lower et upper sont chacun soit un enregistrement de l'un des six mêmes Codec que amount, soit `0x0000` ABSENT. Pour le marqueur d'emplacement, seule l'omission ABSENT est admise. Il est permis de n'en avoir qu'un des deux. Les Codec des trois nombres n'ont pas besoin d'être identiques.
- lower ≤ amount ≤ upper se compare par valeur numérique, non par octets ni par Codec. Même si les types diffèrent, on compare en tant que nombres (par ex. SIGNED-INTEGER `652` et SIGNED-DECIMAL `651.5`). FRACTION se compare comme un rationnel exact. Un intervalle symétrique (`652 ± 1`) s'écrit lui aussi avec une borne inférieure et une borne supérieure (`651`, `653`). Comme il existe des intervalles asymétriques qui exigent de toute façon deux valeurs, on ne définit pas de format qui se réduirait à un seul ±.
- L'unité fait partie de la valeur. On ne détache pas l'unité dans un QUALIFIER ou autre (une fois détachée, on ne sait plus si `652` est en km ou en m).
- Un enregistrement amount extrait est tel quel un enregistrement de Value indépendant. Si l'on a besoin du nombre sans unité, on utilise cet enregistrement sans ré-encoder.
- La valeur convertie en unité SI n'est pas portée. C'est une valeur dérivée, calculable à partir de l'unité et d'une table de conversion.
- Le curseur après la lecture des quatre enregistrements doit coïncider exactement avec la fin du Payload. Toute autre forme est invalid.
- Le document de spécification geul.org décrit quatre champs d'enregistrement : amount (`0610`·`0620`·`0630`·`0670`·`0680`·`0690`), unit (`000F`·`020F`·`040F`·`0000`), lower et upper (`0610`·`0620`·`0630`·`0670`·`0680`·`0690`·`0000`) ([document de spécification de Codec](../codec-spec.md)).

## Longueur {#길이}

- Le total est 1 WORD de TAG + (TAG d'extension de Length) + les quatre enregistrements. Un enregistrement entier fait TAG 1 + Payload 1 WORD ou plus, un enregistrement BINARY-FLOAT fait 2·3·5·9 WORD, un enregistrement de nombre décimal fait TAG 1 + exposant 2 + coefficient 1 WORD ou plus, un enregistrement FRACTION fait 5 WORD ou plus.
- Un petit entier sans unité ni bornes fait 6 WORD, un petit nombre décimal 8 WORD. À partir de 15 WORD, on utilise la longueur étendue ([Enregistrement et TAG WORD](../record.md)).

## Exemple {#예시}

`1.20` sans unité :

```
0667 0683 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0667` (Codec `0x066L`, 8 WORD), amount `0683 FFFF FFFE 0078` (E = -2, C = 120), unit·lower·upper `0000`.

Entier `42` sans unité :

```
0665 0611 002A 0000 0000 0000
```

- TAG `0665` (6 WORD), amount `0611 002A` (SIGNED-INTEGER 42), unit·lower·upper `0000`.

Fraction `2/3` sans unité (deux tiers des voix des présents) :

```
0668 0674 0611 0002 0621 0003 0000 0000 0000
```

- TAG `0668` (9 WORD), amount `0674 0611 0002 0621 0003` ([FRACTION](0x067L-fraction.md) 2/3), unit·lower·upper `0000`.

`652 km`, intervalle `[651, 653]` (km = Q828224) :

```
066E 0011
0683 0000 0000 028C
0142 000C A340
0683 0000 0000 028B
0683 0000 0000 028D
```

- Le total étant de 17 WORD, `LLLL=1110`, TAG d'extension `0011`.

## Correspondance avec Wikidata {#위키데이터-대응}

- Le datavalue `quantity` `{"amount","unit","lowerBound","upperBound"}` → amount·unit·lower·upper. Les chaînes de amount et de bornes (`+1.20`, y compris en notation exponentielle) sont reportées en C et E avec leurs chiffres tels quels.
- Les amount et bornes de Wikidata étant des chaînes décimales, même s'ils ont la forme d'un entier (`+652`), ils sont reportés en SIGNED-DECIMAL. La conversion de Wikidata n'utilise pas les autres Codec numériques.
- L'unité `"1"` est sans unité (`0x0000`), `http://www.wikidata.org/entity/Qn` est un WIKIDATA-QID. Les autres unités et les nombres ou bornes de forme non conforme ne sont pas convertis, et le texte d'origine est conservé en UTF8-TEXT.
- Échantillon Wikidata (environ 42 000 quantity au début du dump) : 61 % sans unité, 13 % avec bornes (dont 93 % symétriques), amount le plus long 31 caractères.

## Fondement normatif {#표준-근거}

- Notation décimale et conservation des chiffres : concepts de coefficient, d'exposant et de quantum du décimal de [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL de GEUL).
- Modèle de quantité de Wikidata : `QuantityValue` du DataModel de Wikibase.

## Pages liées {#관련-페이지}

- [Value](_index.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [CODEC](../edge/0x0BEL-codec.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000660/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000066000000000
BODY
#1 DECLARE 0x0660
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 record
#6 BIND #1 "QUANTITY"
#7 BIND #2 "amount"
#8 BIND #3 "unit"
#9 BIND #4 "lower"
#10 BIND #5 "upper"
#11 CODEC #2 0x0680
#12 CODEC #3 0x000F
#33 CODEC #3 0x020F
#34 CODEC #3 0x040F
#13 CODEC #3 0x0000
#14 CODEC #4 0x0680
#15 CODEC #4 0x0000
#16 CODEC #5 0x0680
#17 CODEC #5 0x0000
#18 CODEC #2 0x0610
#19 CODEC #2 0x0620
#20 CODEC #2 0x0630
#21 CODEC #2 0x0670
#22 CODEC #2 0x0690
#23 CODEC #4 0x0610
#24 CODEC #4 0x0620
#25 CODEC #4 0x0630
#26 CODEC #4 0x0670
#27 CODEC #4 0x0690
#28 CODEC #5 0x0610
#29 CODEC #5 0x0620
#30 CODEC #5 0x0630
#31 CODEC #5 0x0670
#32 CODEC #5 0x0690
```
