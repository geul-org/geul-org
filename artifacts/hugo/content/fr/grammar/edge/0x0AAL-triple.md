---
title: "TRIPLE (0x0AAL)"
weight: 170
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE est un Edge d'énoncé qui contient une proposition (Predicate, Subject, Object) et son rang (rank)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `TRIPLE` (BIND du document de spécification `TRIPLE`) |
| TAG ID | `0x0AAL` |
| Codec ID | `0x00000AA0` |
| Document de spécification | `0x00000000/codecs/0x00000AA0/` (cible de DECLARE `0AA0`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 10 |
| Kind | Edge · famille : énoncé, groupe : proposition |
| TAG WORD | `0000 1010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Proposition dans l'ordre Predicate, Subject, Object, et rank. Object est une valeur ou un marqueur UNKNOWN-VALUE·NO-VALUE. Son sens est l'ensemble de tous les QUALIFIER qui désignent son Edge Id |
| Côté Hugo | `edge/triple.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `predicate` | #2 | enregistrement | `000F` section 0 entière (joker, Reference), `020F` section 1 entière (joker, Reference), `040F` section 2 entière (joker, Reference) |  |
| 2 | `subject` | #3 | enregistrement | `000F` section 0 entière (joker, Reference), `020F` section 1 entière (joker, Reference), `040F` section 2 entière (joker, Reference) |  |
| 3 | `object` | #4 | enregistrement | `000F` section 0 entière (joker, Reference), `020F` section 1 entière (joker, Reference), `040F` section 2 entière (joker, Reference), `060F` section 3 entière (joker, Value), `080F` section 4 entière (joker, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |
| 4 | `rank` | #5 | valeur brute 1 WORD | `0620` UNSIGNED-INTEGER | `0x0000` normal, `0x0001` preferred, `0x0002` deprecated |

TRIPLE est un Edge d'énoncé qui contient une proposition (Predicate, Subject, Object) et son rang (rank). Codec `0x0AAL`.

Les conditions qui qualifient la proposition (instants de début et de fin, portée d'application, etc.) s'attachent par un [QUALIFIER](0x0ABL-qualifier.md) qui désigne l'Edge Id du TRIPLE. La source (references de Wikidata) s'attache par l'Edge de fondement [SOURCE](0x0C0L-source.md) qui désigne l'Edge Id du TRIPLE.

## Disposition {#레이아웃}

```
TAG WORD          0000 1010 1010 LLLL
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Predicate         enregistrement Reference (WIKIDATA-PID, etc.)
Subject           enregistrement Reference
Object            enregistrement Reference ou Value, ou marqueur d'emplacement 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank {#rank}

| Code | Nom | Sens |
|---|---|---|
| `0` | normal | par défaut |
| `1` | preferred | valeur actuelle, faisant le plus autorité |
| `2` | deprecated | valeur jugée fausse ou périmée mais conservée à titre d'archive |

- Identique au statement rank de Wikidata. La valeur représentative (truthy de Wikidata) est, parmi les mêmes Subject et Predicate, preferred s'il y en a, sinon normal.
- Une source qui n'attribue pas de rank utilise `0` (normal).
- Tout autre code est invalid.

## Interprétation et validité {#해석과-유효성}

- Predicate et Subject sont chacun exactement un enregistrement Reference complet.
- Object est exactement un enregistrement Reference ou Value complet, ou 1 WORD du [marqueur d'emplacement](../slot-marker.md) `0x0010` (UNKNOWN-VALUE) ou `0x0020` (NO-VALUE). ABSENT (`0x0000`) n'est pas accepté. Object n'est pas un champ facultatif.
- Après la lecture d'Object, il doit rester exactement 1 WORD (Rank).
- Le document de spécification de geul.org place pour le champ de valeur brute Rank le [CODEC](0x0BEL-codec.md) UNSIGNED-INTEGER (`0620`) et l'[ENUM](0x0BDL-enum.md) 0·1·2. Pour le champ Object, il place les CODEC `000F`·`020F`·`040F` (toute Reference), `060F`·`080F` (toute Value), `0010` (UNKNOWN-VALUE), `0020` (NO-VALUE). Pour les champs Predicate et Subject, les CODEC `000F`·`020F`·`040F` (toute Reference). Comme ce sont des jokers, les marqueurs d'emplacement ne sont pas acceptés.
- **Le sens d'un TRIPLE est l'ensemble de tous les QUALIFIER qui désignent son Edge Id dans le même document.** Le lecteur rassemble les QUALIFIER avant d'interpréter le TRIPLE. Un TRIPLE lu sans QUALIFIER peut être une proposition privée de sa qualification (par ex. « chef de l'exécutif » sans la qualification temporelle).

## Inconnu et absent {#알-수-없음과-없음}

Le marqueur d'emplacement à la place d'Object n'est pas une valeur mais une assertion sur la proposition.

| Object | Sens | Logique |
|---|---|---|
| valeur v | l'une des valeurs du Predicate de Subject est v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0010`) | il y a une valeur. On ignore laquelle (`somevalue` de Wikidata) | `∃x. P(s, x)` |
| NO-VALUE (`0x0020`) | il n'y a pas de valeur (`novalue` de Wikidata) | `¬∃x. P(s, x)` |
| pas de TRIPLE | n'asserte rien (monde ouvert) | |

- **On lit à l'intérieur de la condition de qualification.** La portée de `∃` et de `¬∃` est fixée par les QUALIFIER qui désignent ce TRIPLE. Une fois un QUALIFIER attaché, la clôture ne vaut que dans cette portée. « De 1811 à 1816, il n'y avait pas de banque centrale » s'écrit en attachant des QUALIFIER P580·P582 à un TRIPLE NO-VALUE. Cela ne contredit pas un TRIPLE de valeur d'une autre période pour le même Predicate.
- **Le rank s'applique de la même façon.** Lors du choix de la valeur représentative (truthy), les TRIPLE UNKNOWN-VALUE·NO-VALUE sont aussi candidats. S'il y a un preferred, seul preferred reste.
- **Deux UNKNOWN-VALUE ne sont pas égaux.** UNKNOWN-VALUE n'est ni égal ni différent de quelque valeur que ce soit (résultat de comparaison indéterminé), et deux UNKNOWN-VALUE ne sont pas non plus considérés comme la même valeur. Chaque occurrence est une quantification existentielle indépendante. Ainsi, deux TRIPLE UNKNOWN-VALUE identiques à l'octet près ne sont pas des doublons et ne sont pas fusionnés (il peut y avoir deux enfants, ou un seul).
- Si, pour les mêmes Subject, Predicate et rank, un TRIPLE NO-VALUE coexiste avec un TRIPLE de valeur (ou UNKNOWN-VALUE) sans que les conditions de qualification les distinguent, c'est une contradiction. Le vérificateur avertit. Il ne rejette pas (cet état existe aussi dans Wikidata).
- On n'écrit pas en UNKNOWN-VALUE une valeur qu'on n'a pas pu convertir (la source a une valeur).

## Exemple (non normatif) {#예시-비규범}

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, `LLLL=1001`. Le TAG est `0000 1010 1010 1001` = `0AA9`.

```
0AA9 0051 0005 0191 001F 0141 002A 0141 0005 0000
```

Q30 (États-Unis) P1304 (banque centrale) NO-VALUE, normal. De 1811 à 1816, il n'y avait pas de banque centrale (les QUALIFIER P580·P582 sont dans l'exemple de [QUALIFIER](0x0ABL-qualifier.md)). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD, `LLLL=1000`. Le TAG est `0000 1010 1010 1000` = `0AA8`.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- « Pas d'enfant (P40) » s'écrit `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## Problèmes ouverts {#열린-문제}

- scope (contexte d'une affirmation : monde, point de vue) : à fixer quand un usage apparaîtra.
- Forme abrégée repliant TRIPLE et QUALIFIER en un enregistrement : une fois la déclaration de champs répétés ([DECLARE](0x0BBL-declare.md), problèmes ouverts) disponible.

## Pages liées {#관련-페이지}

- [Edge](_index.md), [QUALIFIER](0x0ABL-qualifier.md), [SOURCE](0x0C0L-source.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [marqueur d'emplacement](../slot-marker.md)
- [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000AA0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AA000000000
BODY
#1 DECLARE 0x0AA0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 0x0001
#6 ENUM #5 0x0000
#7 ENUM #5 0x0001
#8 ENUM #5 0x0002
#9 BIND #1 "TRIPLE"
#10 BIND #2 "predicate"
#11 BIND #3 "subject"
#12 BIND #4 "object"
#13 BIND #5 "rank"
#14 BIND #6 "normal"
#15 BIND #7 "preferred"
#16 BIND #8 "deprecated"
#17 CODEC #5 0x0620
#18 CODEC #4 0x000F
#22 CODEC #4 0x020F
#23 CODEC #4 0x040F
#19 CODEC #4 0x060F
#24 CODEC #4 0x080F
#20 CODEC #4 0x0010
#21 CODEC #4 0x0020
#25 CODEC #2 0x000F
#26 CODEC #2 0x020F
#27 CODEC #2 0x040F
#28 CODEC #3 0x000F
#29 CODEC #3 0x020F
#30 CODEC #3 0x040F
```
