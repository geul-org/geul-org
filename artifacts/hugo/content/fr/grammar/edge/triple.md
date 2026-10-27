---
title: "TRIPLE"
weight: 11
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE est un Edge de description (Codec 0x0A) qui contient une proposition (Predicate, Subject, Object) et son rang (rank). L'Object peut être, à la place d'une valeur, inconnu (UNKNOWN-VALUE) ou sans valeur (NO-VALUE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIPLE est un Edge de description qui contient une proposition (Predicate, Subject, Object) et son rang (rank). Codec `0x0A`.

Les conditions qui restreignent la proposition (date de début ou de fin, étendue d'application, etc.) se joignent par des [QUALIFIER](/fr/grammar/edge/qualifier/) désignant l'Edge Id du TRIPLE. La provenance (references de Wikidata) se joint par l'Edge de fondement [SOURCE](/fr/grammar/edge/source/) désignant l'Edge Id du TRIPLE.

## Disposition

```
TAG WORD          0001 0LLL L000 1010
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Predicate         enregistrement Reference (WIKIDATA-PID, etc.)
Subject           enregistrement Reference
Object            enregistrement Reference ou Value, ou marqueur d'emplacement 0x0001 UNKNOWN-VALUE, 0x0002 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank

| Code | Nom | Sens |
|---|---|---|
| `0` | normal | Par défaut |
| `1` | preferred | Valeur actuelle, la plus autorisée |
| `2` | deprecated | Valeur jugée fausse ou périmée mais conservée comme trace |

- Identique au statement rank de Wikidata. La valeur représentative (truthy de Wikidata) parmi un même Subject et Predicate est preferred s'il y en a, sinon normal.
- Une source qui n'attribue pas de rank emploie `0` (normal).
- Tout autre code est invalid.

## Interprétation et validité

- Predicate et Subject sont chacun exactement un enregistrement Reference complet.
- Object est exactement un enregistrement Reference ou Value complet, ou 1 WORD de [marqueur d'emplacement](/fr/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE) ou `0x0002` (NO-VALUE). ABSENT (`0x0000`) n'est pas admis. Object n'est pas un champ facultatif.
- Après la lecture d'Object, il doit rester exactement 1 WORD (Rank).
- Le document de spécification de geul.org place sur le champ valeur brute Rank le [CODEC](/fr/grammar/edge/codec/) UNSIGNED-INTEGER (`0802`) et les [ENUM](/fr/grammar/edge/enum/) 0, 1, 2. Sur le champ Object, il place les CODEC `0780` (toute Reference), `0F80` (toute Value), `0001` (UNKNOWN-VALUE), `0002` (NO-VALUE). Predicate et Subject n'acceptent pas de marqueur d'emplacement.
- **Le sens d'un TRIPLE est l'ensemble de tous les QUALIFIER du même document qui désignent son Edge Id.** Avant d'interpréter un TRIPLE, le lecteur rassemble les QUALIFIER. Un TRIPLE lu sans QUALIFIER peut être une proposition privée de ses restrictions (par ex. « chef de l'exécutif » sans la restriction temporelle).

## Inconnu et aucune valeur

Un marqueur d'emplacement à la place d'Object n'est pas une valeur mais une affirmation sur la proposition.

| Object | Sens | Logique |
|---|---|---|
| Valeur v | L'une des valeurs du Predicate du Subject est v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0001`) | Une valeur existe. On ne sait pas laquelle (`somevalue` de Wikidata) | `∃x. P(s, x)` |
| NO-VALUE (`0x0002`) | Il n'y a pas de valeur (`novalue` de Wikidata) | `¬∃x. P(s, x)` |
| Pas de TRIPLE | N'affirme rien (monde ouvert) | |

- **On lit dans les conditions restrictives.** La portée de `∃` et `¬∃` est fixée par les QUALIFIER qui désignent ce TRIPLE. Une fois les QUALIFIER joints, la fermeture ne vaut que dans cette portée. « Il n'y a pas eu de banque centrale de 1811 à 1816 » s'écrit en joignant des QUALIFIER P580 et P582 à un TRIPLE NO-VALUE. Cela ne contredit pas les TRIPLE de valeur d'autres périodes pour le même Predicate.
- **Le rank s'applique à l'identique.** Pour choisir la valeur représentative (truthy), les TRIPLE UNKNOWN-VALUE et NO-VALUE sont aussi candidats. S'il y a un preferred, seul preferred reste.
- **Deux UNKNOWN-VALUE ne sont pas égaux.** UNKNOWN-VALUE n'est ni égal ni différent d'aucune valeur (résultat de la comparaison indéterminé), et deux UNKNOWN-VALUE ne sont pas considérés comme la même valeur. C'est une quantification existentielle indépendante à chaque occurrence. Deux TRIPLE UNKNOWN-VALUE aux octets identiques ne sont donc pas des doublons et ne se fusionnent pas (il peut y avoir deux enfants ou un seul).
- Si, pour un même Subject, Predicate et rank, un TRIPLE NO-VALUE coexiste avec un TRIPLE de valeur (ou UNKNOWN-VALUE) sans que les conditions restrictives les distinguent, c'est une contradiction. Le vérificateur avertit. Il ne rejette pas (cet état existe aussi dans Wikidata).
- On n'emploie pas UNKNOWN-VALUE pour une valeur que l'on n'a pas pu transcrire (l'origine a une valeur).

## Exemple (non normatif)

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, `LLLL=1001`. Le TAG est `0001 0 1001 0001010` = `148A`.

```
148A 0088 0005 00A8 001f 00A0 002a 00A0 0005 0000
```

Q30 (États-Unis) P1304 (banque centrale) NO-VALUE, normal. De 1811 à 1816, il n'y avait pas de banque centrale (les QUALIFIER P580 et P582 figurent dans l'exemple de [QUALIFIER](/fr/grammar/edge/qualifier/)). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD, `LLLL=1000`. Le TAG est `0001 0 1000 0001010` = `140A`.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- « Pas d'enfant (P40) » s'écrit `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`.

## Problèmes ouverts

- scope (contexte d'une affirmation : monde, point de vue) : à fixer quand un usage apparaîtra.
- Forme abrégée repliant TRIPLE et QUALIFIER en un seul enregistrement : après l'apparition de la déclaration de champs répétés (problèmes ouverts de [DECLARE](/fr/grammar/edge/declare/)).

## Pages liées

- [Edge](/fr/grammar/edge/), [QUALIFIER](/fr/grammar/edge/qualifier/), [SOURCE](/fr/grammar/edge/source/), [LABEL](/fr/grammar/edge/label/), [ALIAS](/fr/grammar/edge/alias/), [Marqueur d'emplacement](/fr/grammar/reference/slot-marker/)
- [WIKIDATA-PID](/fr/grammar/reference/wikidata-pid/), [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/)
