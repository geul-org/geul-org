---
title: "PREDICATE-DECLARE (0x101L)"
weight: 257
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PREDICATE-DECLARE est le Codec TOULMIN qui déclare un prédicat (expression de verdict)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PREDICATE-DECLARE est le Codec TOULMIN qui déclare un prédicat (expression de verdict). Sa disposition est EXPR. EXPR est la disposition qui écrit l'expression conditionnelle de Rules de TANGEUL. L'arbre de l'expression est déployé et stocké en ordre préfixe, et les chaînes de l'expression sont désignées par une table d'étiquettes à l'intérieur de l'enregistrement. Il est donc complet à lui seul, sans enregistrement TEXT.

| Élément | Valeur |
|---|---|
| Nom | `PREDICATE-DECLARE` (BIND du document de spécification `PREDICATE-DECLARE`) |
| TAG ID | `0x101L` |
| Codec ID | `0x00001010` |
| Document de spécification | `0x00000000/codecs/0x00001010/` (cible de DECLARE `1010`) |
| Section | 8 `1000` (Edge TOULMIN), décalage dans la section C = 1 |
| Kind | Edge · famille : TOULMIN, groupe : déclaration, disposition : EXPR |
| TAG WORD | `0001 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Déclaration de prédicat. Fonction ou expression de verdict, critère de jugement (Spec), contrat de faits (Ground) |
| Côté Hugo | `edge/toulmin/expr.md` |

## Disposition {#레이아웃}

```
ID                     enregistrement LOCAL Reference (Edge Id)
nombre de nœuds 1 WORD  nombre total d'enregistrements d'expression
nombre d'étiquettes 1 WORD
étiquette × nombre d'étiquettes   enregistrement Value UTF8-TEXT
enregistrement d'expression × nombre de nœuds   ordre préfixe
```

- Une étiquette est une chaîne : nom de champ, valeur chaîne, étape de chemin, nom de fonction. Une chaîne vide est aussi une étiquette. Un enregistrement d'expression désigne une étiquette par un indice (1 WORD) numéroté à partir de 0.
- Les enregistrements d'expression placent le parent puis ses enfants à la suite (ordre préfixe). Le nombre d'enfants de chaque enregistrement et cet ordre déterminent un arbre unique.

## Enregistrement d'expression {#식-레코드}

Un enregistrement d'expression commence par 1 WORD d'en-tête.

```
en-tête 1 WORD   2 bits bas du genre (b15–14) | 1 bit haut du genre (b13) | nombre d'enfants sur 13 bits (b12–0)
```

Genre = `(b13 << 2) | b15–14`.

| Genre | Nom | Nombre d'enfants | Après l'en-tête |
|---|---|---|---|
| 0 | COMPARE | 0 | opérateur de comparaison 1 WORD, étiquette de champ 1 WORD, emplacement de valeur |
| 1 | LOGIC | n | opérateur logique 1 WORD |
| 2 | NOT | 1 | aucun |
| 3 | EITHER | n | aucun |
| 4 | EXISTS | 1 | opérateur de quantification 1 WORD, opérande cible, étiquette de nom lié 1 WORD |
| 5 | CALL | 0 | étiquette d'alias 1 WORD, étiquette de nom de fonction 1 WORD |
| 6 | COMPARE-X | 0 | opérateur de comparaison 1 WORD, étiquette de champ 1 WORD, marqueur gauche 1 WORD [+ opérande], emplacement de valeur |
| 7 | Reserved | | |

- Les enregistrements enfants suivent les champs placés après l'en-tête. L'enfant d'un EXISTS est une condition.
- COMPARE est une comparaison `<champ> <opérateur> <valeur>` sans opérande de part ni d'autre. S'il y a un opérande d'un côté au moins, on emploie COMPARE-X.
- Si le marqueur gauche de COMPARE-X vaut `1`, un opérande suit ; s'il vaut `0`, il n'y en a pas. S'il y a un opérande gauche, l'étiquette de champ est une chaîne vide.
- CALL est l'appel d'une fonction hôte à la place d'un prédicat. S'il s'agit d'une fonction de ce document, l'étiquette d'alias est une chaîne vide.

### Emplacement de valeur {#값-자리}

```
genre de valeur 1 WORD   0 nombre, 1 chaîne, 2 opérande
valeur                   0 : enregistrement Value UNSIGNED-INTEGER
                         1 : étiquette 1 WORD
                         2 : opérande (dans COMPARE-X seulement)
```

- Si la chaîne de valeur est exactement la notation décimale canonique d'un entier non négatif, on l'écrit en Value UNSIGNED-INTEGER. Les autres valeurs s'écrivent en étiquette. La chaîne de valeur est ainsi restituée telle quelle.

### Opérande {#피연산자}

```
genre d'opérande 1 WORD   0 chemin, 1 référence de critère, 2 appel de fonction
chemin, référence de critère   nombre d'étapes 1 WORD + étiquette 1 WORD × nombre d'étapes
appel de fonction         étiquette d'alias 1 WORD + étiquette de nom de fonction 1 WORD
```

- Le chemin est celui des données d'entrée ; la référence de critère est le chemin d'un critère de jugement (SPEC) injecté par `with`.

### Codes d'opérateur {#연산자-코드}

| Code | Opérateur de comparaison |
|---|---|
| `0x0301` | is empty |
| `0x0302` | is not empty |
| `0x0303` | equals |
| `0x0304` | is in |
| `0x0305` | is greater than |
| `0x0306` | is less than |
| `0x0307` | is at most |
| `0x0308` | is at least |

| Code | Opérateur logique |
|---|---|
| `0x0311` | and |
| `0x0312` | or |

| Code | Opérateur de quantification |
|---|---|
| `0x0321` | any |

### Évaluation d'une entrée inconnue {#미상-입력의-평가}

Quand l'entrée est un marqueur d'emplacement, les opérateurs de comparaison s'évaluent à 3 valeurs (vrai, faux, indéterminé U). Pour NO-VALUE, `is empty` est vrai et les autres comparaisons sont fausses. Pour UNKNOWN-VALUE, `is not empty` est vrai, et `equals`, `is in` et les comparaisons de taille sont U. Pour ABSENT et l'absence d'énoncé, tous les opérateurs sont U. Les opérateurs logiques suivent la logique forte à 3 valeurs de Kleene, et si le prédicat est U, le verdict du nœud est Review. Cette évaluation est le noyau fixe ([TOULMIN](_index.md#미상-위에서-판정하기)).

## Interprétation et validité {#해석과-유효성}

- Le nombre de nœuds doit être égal au nombre d'enregistrements d'expression déployés. La position atteinte après lecture du dernier enregistrement d'expression doit coïncider exactement avec la fin de l'enregistrement.
- Si un indice d'étiquette est supérieur ou égal au nombre d'étiquettes, on refuse.
- Le nombre d'enfants de NOT et d'EXISTS doit être 1.
- Un genre inconnu (7), un genre de valeur inconnu ou un genre d'opérande inconnu sont refusés.
- Le nombre d'enfants est sur 13 bits (8191 au maximum).

## Document de Codec {#코덱-문서}

Le document de Codec porte un DECLARE (cible `1010`). Dans la disposition EXPR, les premières valeurs brutes (nombre de nœuds, nombre d'étiquettes) fixent un nombre de répétitions et ne peuvent pas être déclarées par FIELD ; la déclaration des champs est donc un problème ouvert (répétition de [DECLARE](../edge/0x0BBL-declare.md#열린-문제)).

## Pages liées {#관련-페이지}

- [TOULMIN](_index.md), [NODE](_index.md#node)
- [UTF8-TEXT](../value/0x072L-utf8-text.md), [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00001010/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000101000000000
BODY
#1 DECLARE 0x1010
#2 BIND #1 "PREDICATE-DECLARE"
```
