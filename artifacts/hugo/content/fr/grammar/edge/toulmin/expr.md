---
title: "EXPR"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXPR est la disposition d'expression conditionnelle employée par PREDICATE-DECLARE (Codec 0x61). Elle contient l'arbre de l'expression conditionnelle sous forme d'enregistrements d'expression à plat en ordre préfixe, avec sa propre table d'étiquettes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXPR est la disposition qui écrit l'expression conditionnelle de Rules de TANGEUL. Elle est employée par PREDICATE-DECLARE (déclaration de prédicat), Codec `0x61`. Elle contient l'arbre de l'expression conditionnelle mis à plat en ordre préfixe, et les chaînes de caractères de l'expression sont désignées par la table d'étiquettes interne à l'enregistrement. Elle est ainsi autonome, sans enregistrement TEXT.

## Disposition

```
ID                     enregistrement Reference LOCAL (Edge Id)
Nombre de nœuds 1 WORD nombre total d'enregistrements d'expression
Nombre d'étiquettes 1 WORD
Étiquettes × nombre d'étiquettes    enregistrements Value UTF8-TEXT
Enregistrements d'expression × nombre de nœuds   ordre préfixe
```

- Une étiquette est une chaîne de caractères : nom de champ, valeur chaîne, étape de chemin, nom de fonction. Une chaîne vide est aussi une étiquette. Un enregistrement d'expression désigne une étiquette par un indice (1 WORD) numéroté à partir de 0.
- Les enregistrements d'expression placent un parent suivi de ses enfants (ordre préfixe). Le nombre d'enfants de chaque enregistrement et cet ordre déterminent un arbre unique.

## Enregistrement d'expression

Un enregistrement d'expression commence par 1 WORD d'en-tête.

```
En-tête 1 WORD   2 bits de poids faible du genre (b15–14) | bit de poids fort du genre (b13) | nombre d'enfants sur 13 bits (b12–0)
```

Genre = `(b13 << 2) | b15–14`.

| Genre | Nom | Nombre d'enfants | Après l'en-tête |
|---|---|---|---|
| 0 | COMPARE | 0 | 1 WORD d'opérateur de comparaison, 1 WORD d'étiquette de champ, emplacement de valeur |
| 1 | LOGIC | n | 1 WORD d'opérateur logique |
| 2 | NOT | 1 | rien |
| 3 | EITHER | n | rien |
| 4 | EXISTS | 1 | 1 WORD d'opérateur de quantification, opérande cible, 1 WORD d'étiquette du nom lié |
| 5 | CALL | 0 | 1 WORD d'étiquette d'alias, 1 WORD d'étiquette du nom de fonction |
| 6 | COMPARE-X | 0 | 1 WORD d'opérateur de comparaison, 1 WORD d'étiquette de champ, 1 WORD de marqueur de gauche [+ opérande], emplacement de valeur |
| 7 | Réservé | | |

- Les enregistrements enfants suivent les champs placés après l'en-tête. L'enfant d'un EXISTS est une seule condition.
- COMPARE est une comparaison `<champ> <opérateur> <valeur>` sans opérande de part ni d'autre. S'il y a un opérande d'un côté, on emploie COMPARE-X.
- Si le marqueur de gauche de COMPARE-X vaut `1`, un opérande suit ; s'il vaut `0`, il n'y en a pas. S'il y a un opérande de gauche, l'étiquette de champ est une chaîne vide.
- CALL est un appel de fonction hôte à la place d'un prédicat. S'il s'agit d'une fonction de ce document, l'étiquette d'alias est une chaîne vide.

### Emplacement de valeur

```
Genre de valeur 1 WORD   0 nombre, 1 chaîne, 2 opérande
Valeur                   0 : enregistrement Value UNSIGNED-INTEGER
                         1 : 1 WORD d'étiquette
                         2 : opérande (seulement dans COMPARE-X)
```

- Si la chaîne de la valeur est exactement la notation décimale canonique d'un entier non négatif, on l'écrit comme Value UNSIGNED-INTEGER. Les autres valeurs s'écrivent comme étiquette. La chaîne de la valeur est ainsi restituée telle quelle.

### Opérande

```
Genre d'opérande 1 WORD   0 chemin, 1 référence de critère, 2 appel de fonction
Chemin, référence de critère   nombre d'étapes 1 WORD + 1 WORD d'étiquette × nombre d'étapes
Appel de fonction              1 WORD d'étiquette d'alias + 1 WORD d'étiquette du nom de fonction
```

- Un chemin est un chemin dans les données d'entrée, une référence de critère un chemin dans le critère de jugement (SPEC) injecté par `with`.

### Codes d'opérateurs

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

### Évaluation d'une entrée inconnue

Quand l'entrée est un marqueur d'emplacement, les opérateurs de comparaison s'évaluent à 3 valeurs (vrai, faux, indéterminé U). Pour NO-VALUE, `is empty` est vrai et les autres comparaisons fausses. Pour UNKNOWN-VALUE, `is not empty` est vrai et `equals`, `is in` et les comparaisons de taille sont U. Pour ABSENT et l'absence de description, tous les opérateurs donnent U. Les opérateurs logiques suivent Kleene à 3 valeurs fortes, et si le prédicat est U, le jugement du nœud est Review. Cette évaluation fait partie du noyau fixe ([TOULMIN](/fr/grammar/edge/toulmin/#juger-sur-linconnu)).

## Interprétation et validité

- Le nombre de nœuds doit être égal au nombre d'enregistrements d'expression à plat. La position atteinte après lecture du dernier enregistrement d'expression doit coïncider exactement avec la fin de l'enregistrement.
- Si un indice d'étiquette est supérieur ou égal au nombre d'étiquettes, on rejette.
- Le nombre d'enfants de NOT et d'EXISTS doit être 1.
- On rejette un genre inconnu (7) ou un genre de valeur ou d'opérande inconnu.
- Le nombre d'enfants est sur 13 bits (maximum 8191).

## Pages liées

- [TOULMIN](/fr/grammar/edge/toulmin/), [NODE](/fr/grammar/edge/toulmin/node/)
- [UTF8-TEXT](/fr/grammar/value/text/utf8-text/), [UNSIGNED-INTEGER](/fr/grammar/value/numeric/unsigned-integer/)
