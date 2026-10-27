---
title: "Enregistrement et TAG WORD"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "Tout enregistrement commence par un TAG WORD de 16 bits. Prefix sur 3 bits, Kind sur 2 bits, Length sur 4 bits et Codec sur 7 bits fixent le genre et la longueur de l'enregistrement."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Les données GEUL sont une suite d'enregistrements. Tout enregistrement commence par un TAG WORD.

## Disposition de l'enregistrement

```
TAG WORD (16 bits)
┌──────────┬─────────┬──────────┬─────────────────────┐
│  Prefix  │  Kind   │  Length  │        Codec        │
│   3bit   │  2bit   │   4bit   │        7bit         │
│   000    │   KK    │   LLLL   │       CCCCCCC       │
└──────────┴─────────┴──────────┴─────────────────────┘
[TAG d'extension de Length]
[TAG d'extension de Codec]
[TAG propres au Codec]
Payload
```

- Le TAG WORD est `000K KLLL LCCC CCCC`.
- Les TAG d'extension se placent seulement dans l'ordre ci-dessus. Le TAG d'extension de Length suit toujours immédiatement le TAG WORD.
- La composition des TAG propres au Codec et du Payload est fixée par la spécification de chaque Codec. La longueur des TAG propres au Codec n'est pas inscrite dans le TAG WORD, car il faut de toute façon le livre de codes pour interpréter le Payload.
- Un Codec ayant des sous-formats indique le sous-format par 1 WORD de TAG propre au Codec (Edge WORLD, etc.).

## Ordre des octets

- La sérialisation canonique est big-endian.
- Les champs de bits se disposent à partir du bit de poids le plus fort.
- Dans un WORD, l'octet de poids fort vient en premier ; pour une valeur de plusieurs WORD, le WORD de poids fort vient en premier.
- La représentation en mémoire est laissée libre à l'implémentation.

## Kind (2 bits)

| Valeur | Kind | TAG WORD | Définition |
|---|---|---|---|
| `00` | Reference | `0000 0LLL LCCC CQQQ` | Désigne une cible. Le Codec et l'ID de la cible l'identifient |
| `01` | Value | `0000 1LLL LCCC CCCC` | Contient une valeur. Le Codec fixe l'interprétation du Payload |
| `10` | Edge | `0001 0LLL LCCC CCCC` | Relie d'autres enregistrements comme composants. Le Codec fixe le rôle et l'ordre des composants |
| `11` | Meta | `0001 1LLL LCCC CCCC` | Parle du document et des enregistrements |

- Le Kind est une propriété immuable du Codec. Un Codec une fois attribué ne change pas de Kind.
- Value et Edge ont le même format « Codec + Payload ». Seul l'Edge a d'autres enregistrements pour composants.
- Reference divise les 7 bits de Codec en Codec sur 4 bits et Quantifier sur 3 bits ([Reference](/fr/grammar/reference/)).

## Length (4 bits)

Length est le **nombre total de WORD** que l'enregistrement occupe. Il inclut le TAG WORD, les TAG d'extension, le Payload et le remplissage du dernier WORD.

| Valeur | Signification |
|---|---|
| `0000`~`1101` | 1 à 14 WORD (valeur + 1) |
| `1110` | Longueur étendue 1 : le nombre total de WORD est dans le WORD suivant (15 à 65 535) |
| `1111` | Longueur étendue 2 : le nombre total de WORD est dans les 2 WORD suivants (65 536 à 2³²−1) |

- De 1 à 14 WORD, on écrit obligatoirement la longueur directe. Une notation plus large n'est pas canonique.
- Le nombre total de WORD d'une longueur étendue inclut le TAG d'extension de Length lui-même.
- Aucun enregistrement ne dépasse 2³²−1 WORD.
- Un enregistrement de 1 WORD est un simple TAG WORD sans Payload. On ne l'emploie que si la spécification du Codec l'autorise (par ex. Meta `BODY`, `END`, suite d'octets vide, marqueurs d'emplacement).
- Même sans livre de codes, on peut sauter un enregistrement avec `position du suivant = début de l'enregistrement courant + Length`.

## Codec (7 bits)

| Valeur | Nom | Sens |
|---|---|---|
| `0x00`~`0x7B` | Code direct | Le TAG WORD seul fixe le Codec |
| `0x7C` | ISSUER-1WORD | Le TAG d'extension de Codec contient 1 WORD d'Issuer et 1 WORD de numéro de format |
| `0x7D` | ISSUER-2WORD | Le TAG d'extension de Codec contient 2 WORD d'Issuer et 1 WORD de numéro de format |
| `0x7E` | ISSUER-4WORD | Le TAG d'extension de Codec contient 4 WORD d'Issuer et 1 WORD de numéro de format |
| `0x7F` | ISSUER-16WORD | Le TAG d'extension de Codec contient 16 WORD d'Issuer et 1 WORD de numéro de format |

- L'espace des numéros de Codec est distinct pour chaque Kind. Un même numéro avec un Kind différent est un autre Codec.
- Un Codec qui n'est pas un code direct est un couple `(Issuer, numéro de format)`. Le numéro de format est défini par cet Issuer ([Issuer et publication](/fr/grammar/issuer/)). Un format d'extension se place sous l'Issuer de l'organisme qui a établi ce format.
- Un Codec doté d'un code direct n'est pas répertorié à part comme format d'Issuer.
- Les formats d'Issuer n'existent que pour Value et Edge. Reference utilise un Codec sur 4 bits, et Meta est une spécification commune définie par GEUL seul.
- Les bits de poids fort du Codec et du numéro de format indiquent la famille (Value, Edge) ou la classe (Meta). On connaît la famille même sans livre de codes.
- Les codes directs ne peuvent pas être repris. Seuls les formats dont la fréquence est avérée y sont placés.

## Enregistrement de format d'Issuer

```
TAG WORD          Codec = 0x7C~0x7F
[TAG d'extension de Length]
Issuer            1/2/4/16 WORD (le Codec fixe la largeur)
Numéro de format  1 WORD. Les bits de poids fort indiquent la famille
Payload           Valeur définie par le format
```

- Un décodeur qui ignore le format ne connaît que la famille du numéro de format et saute le Payload.

## Suites d'octets de longueur variable

Pour les valeurs dont la longueur est en octets (texte, URI, balise de langue, suite d'octets inconnue), on attribue les Codec (ou numéros de format) par **paires paire/impaire**.

- Si le bit de poids faible du Codec vaut `0`, le nombre d'octets est pair ; s'il vaut `1`, il est impair.
- Nombre d'octets = `2 × nombre de WORD du Payload − bit de poids faible`. Il n'y a pas de champ Byte Count.
- S'il est impair, l'octet de poids faible du dernier WORD est un remplissage `0x00`. S'il n'est pas `0x00`, on rejette.
- Une suite d'octets vide est un enregistrement de 1 WORD (le TAG WORD seul) du Codec pair.
- Les valeurs de taille fixe comme UUID, digest et adresses n'ont pas de paire.

## Exemple : lire un TAG WORD

Lisons `148A`.

```
0x148A = 0001 0100 1000 1010
         000 | 10 | 1001 | 0001010
Prefix 000, Kind 10(Edge), Length 1001(10 WORD), Codec 0x0A(TRIPLE)
```

Cet enregistrement est un Edge de 10 WORD dont le Codec est TRIPLE. Même sans livre de codes, on sait que l'enregistrement suivant se trouve 10 WORD plus loin.

## Marqueurs d'emplacement

Les TAG WORD `0x0000`~`0x0007` sont des enregistrements de 1 WORD du Codec réservé `0000` de Reference. Ils ne désignent aucune cible et occupent la place d'un champ d'enregistrement ([Marqueur d'emplacement](/fr/grammar/reference/slot-marker/)).

```
0x0000~0x0007 = 0000 0000 0000 0MMM
                Prefix 000, Kind 00(Reference), LLLL 0000(1 WORD), CCCC 0000, MMM = numéro du marqueur
```

| WORD | Nom | Sens | De quoi parle-t-on | Logique | Hypothèse sur le monde | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | Non renseigné | Document : cet emplacement n'a pas été rempli | Aucune affirmation | Monde ouvert | pas de snak |
| `0x0001` | UNKNOWN-VALUE | Inconnu | Monde : une valeur existe. On ne sait pas laquelle | `∃x. P(s, x)` | Existence fermée, identité ouverte | `somevalue` |
| `0x0002` | NO-VALUE | Aucune valeur | Monde : il n'y a pas de valeur | `¬∃x. P(s, x)` | Fermé pour (s, P, conditions restrictives) | `novalue` |
| `0x0003`~`0x0007` | Réservé | | | | | |

- Exemple : si les enfants (P40) sont ABSENT, on ne sait pas combien ; UNKNOWN-VALUE, au moins 1 ; NO-VALUE, 0. Si la date de fin (P582) est ABSENT, on ne sait pas si c'est encore valide ; UNKNOWN-VALUE, c'est terminé mais on ignore quand ; NO-VALUE, ce n'est pas terminé.
- Les 3 bits de poids faible `MMM` ne sont pas un Quantifier mais le numéro du marqueur (exception du Quantifier dans [Reference](/fr/grammar/reference/)).
- Un marqueur n'est valide que si la liste CODEC du champ admet exactement ce WORD. Avec un joker, un champ sans CODEC, une place d'enregistrement du HEAD ou du BODY, ou une place d'Edge Id, il est invalid ([CODEC](/fr/grammar/edge/codec/)).
- Obligations du lecteur :
  1. UNKNOWN-VALUE n'est pas une valeur mais une affirmation d'existence. Il n'est ni égal ni différent d'aucune valeur, et deux UNKNOWN-VALUE ne sont pas considérés comme la même valeur. Les TRIPLE contenant UNKNOWN-VALUE ne se fusionnent pas comme doublons.
  2. NO-VALUE se ferme dans les conditions restrictives de cette proposition. Avec un TRIPLE de valeur de même Subject, Predicate et rank dont les conditions restrictives ne se distinguent pas, c'est une contradiction et le vérificateur avertit (sans rejeter).
  3. Le rank s'applique à l'identique. Pour choisir la valeur représentative (truthy), les TRIPLE à marqueur sont aussi candidats.
  4. Utilisé comme valeur de QUALIFIER, il change le sens de cette restriction (`P582 = UNKNOWN` : terminé, date inconnue. `P582 = NONE` : non terminé).
  5. ABSENT ne dit rien du monde. On n'emploie pas UNKNOWN-VALUE pour une valeur que l'on n'a pas pu transcrire.

## Forme canonique

Un même contenu doit donner les mêmes octets. C'est ce qui rend univoques le hachage du contenu et la signature.

- On emploie la notation de longueur la plus courte (de 1 à 14 WORD, la longueur directe).
- Les entiers s'écrivent sur la largeur la plus courte. On suit la forme canonique fixée par la spécification de chaque Codec.
- Les enregistrements non canoniques sont rejetés.
