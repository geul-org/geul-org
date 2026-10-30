---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK est la disposition qui écrit les relations entre nœuds TOULMIN (attaque, exclusion, exécution, lien de jugement, définition, nom). Elle se compose de REF src et dst, d'un WORD de flags, d'un seuil de confiance facultatif, d'une intensité d'attaque facultative et d'un SPAN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK est la disposition qui écrit les relations entre nœuds dans un graphe TOULMIN. Le genre de relation est fixé par le Codec (ou le numéro de format ISSUER de GEUL).

## Codec

| Codec | Nom | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | règle → règle. Entame progressivement le jugement selon l'intensité d'attaque |
| `0x69` | SUPERSEDES | `X supersedes Y` | règle → règle. Si Active, retire la cible de l'agrégation |
| `0x70` | RUN | `run c when n` | règle → cas |
| `0x71` | DO | `do fn when n` | règle → FuncRef |
| `0x72` | DO-ONCE | `do fn once when n` | règle → FuncRef |
| `0x73` | UNDO | `undo fn when n` | règle → FuncRef |
| `0x74` | CHECKING | `checking c` | règle → cas. Jugement sans effet de bord |
| ISSUER `0x0000`/`0xC020` | REQUIRES | `f is required` | cas → champ |
| ISSUER `0x0000`/`0xC021` | MEANS | `means` de Definitions | terme défini → valeur ou type |
| ISSUER `0x0000`/`0xC022` | HAS | `has` de Definitions | terme défini → champ |
| ISSUER `0x0000`/`0xC023` | RUNS | point d'entrée `run c` | point d'entrée → cas (exécution) |
| ISSUER `0x0000`/`0xC024` | EVALUATES | point d'entrée `check c` | point d'entrée → cas (jugement) |
| ISSUER `0x0000`/`0xC025` | TRIGGERS | déclencheur `run c` | déclencheur → cas |
| ISSUER `0x0000`/`0xC026` | UNTIL | `every … until c` | déclencheur → cas |
| ISSUER `0x0000`/`0xC027` | SAME-AS | | nœud → identifiant global |
| ISSUER `0x0000`/`0xC028` | IMPORTED-FROM | `see a from path` | alias → chemin (TEXT) |
| ISSUER `0x0000`/`0xC029` | LABEL | nom entre accents graves | nœud → TEXT. Notation du nom |

## Disposition

```
ID               enregistrement Reference LOCAL (Edge Id)
src              REF
dst              REF. Pour DO, DO-ONCE et UNDO, FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         1 WORD d'opérateur (2 bits de poids fort) + Value UNSIGNED-DECIMAL (pourcentage)
[F_FORCE]        SIGNED-DECIMAL Value. Intensité d'attaque (0 à 1). ATTACKS seulement
SPAN             largeur fixée par SOURCE × 2
```

| flag | Sens |
|---|---|
| b0 F_ONCE | Exécuté une seule fois (le `once` d'UNDO) |
| b1 F_GATE | Il y a un champ de seuil de confiance |
| b2 F_STRIKE | Relation barrée |
| b3 F_ORDERED | Appartient à une liste ordonnée `1.` |
| b4 F_FORCE | Un champ d'intensité d'attaque est présent. ATTACKS seulement |

| Opérateur de seuil | Sens |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- Les champs conditionnels suivent l'ordre des flags (F_GATE, F_FORCE). Un champ dont le flag est éteint n'occupe pas de place.

## Intensité d'attaque

L'intensité d'attaque (Force) dit avec quelle intensité une arête ATTACKS attaque sa cible. Elle va de 0 à 1 et vaut 1 en l'absence de F_FORCE.

- Dans le jugement, la contribution `(v+1)/2` de la valeur de jugement v de l'attaquant est multipliée par l'intensité F. Une attaque de réfutation (COUNTER) entre dans le terme du dénominateur sous la forme `F·(v+1)/2`, une attaque d'exception (EXCEPT) dans le seuil `Π(1 − F·(v+1)/2)`. Avec F = 0, l'attaque n'a aucun effet sur le jugement.
- La valeur suit les règles numériques de [TOULMIN](/fr/grammar/edge/toulmin/#valeurs-numériques). L'encodeur supprime les zéros finaux du coefficient (0.5 est `C=5, E=−1`, 1.0 est `C=1, E=0`). Le décodeur accepte jusqu'à 4 décimales.
- Une surface qui n'écrit pas d'intensité (`don't X when Y`, en coréen `` `Y` 면 `X` 는 무효다``) éteint F_FORCE.
- Une surface qui écrit une intensité (en coréen `` `Y` 면 `X` 를 0.5의 세기로 공격한다``) allume F_FORCE et porte la valeur. Même quand on écrit 1, comme dans `1.0의 세기로`, F_FORCE est allumé et porte 1. Ainsi la surface d'origine revient telle quelle.
- L'intensité d'attaque est un axe distinct de la force du nœud (Strict, Defeasible, Defeater). La force appartient au nœud, l'intensité d'attaque à l'arête ATTACKS.

### Exemple

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``. Edge Id 5, l'attaquant Y est l'Edge Id 3, la cible X l'Edge Id 2, largeur de SPAN 1 WORD.

```
16E8                  TAG WORD: Edge, 14 WORD au total, Codec 0x68 (ATTACKS)
0088 0005             ID      LOCAL 5
0088 0003             src     LOCAL 3 (Y, attaquant)
0088 0002             dst     LOCAL 2 (X, cible)
0010                  flags   F_FORCE
0990 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    octet de début 0x40, nombre d'octets 0x1A
```

La même arête sans intensité a des flags `0000` et pas de champ F_FORCE. Son TAG WORD est `14E8` (10 WORD au total).

## Interprétation et validité

- REF est l'Edge Id d'un enregistrement de ce document (champs communs de [TOULMIN](/fr/grammar/edge/toulmin/#champs-communs)).
- La forme de dst est fixée par le Codec. Pour DO, DO-ONCE et UNDO, FuncRef (REF(ALIAS, 0 s'il n'y en a pas) + VerbCode 1 WORD, [NODE](/fr/grammar/edge/toulmin/node/#champs)) ; pour LABEL et IMPORTED-FROM, le REF d'un enregistrement TEXT ; pour les autres, le REF d'un nœud.
- `do … once` est exprimé par le Codec DO-ONCE. Dans les flags de DO-ONCE, on n'emploie pas F_ONCE (rejeté s'il est activé). Le `once` d'UNDO s'écrit par F_ONCE.
- L'opérateur de seuil est dans les 2 bits de poids fort du WORD d'opérateur, les 14 autres bits valent 0. Le pourcentage est une Value UNSIGNED-DECIMAL avec `E=0`, de 0 à 100.
- Les bits b5 à b15 des flags sont réservés et doivent valoir 0. Sinon, on rejette.
- F_FORCE ne s'emploie que sur ATTACKS. S'il est allumé dans un autre Codec (SUPERSEDES, liens d'exécution et de jugement, relations au format ISSUER), on rejette.
- Si l'intensité d'attaque n'est pas une Value SIGNED-DECIMAL, sort de 0 à 1 ou ne s'écrit pas exactement avec 4 décimales, on rejette.
- Une chaîne `A > B > C` de SUPERSEDES s'écrit avec un SUPERSEDES par paire.

## Pages liées

- [TOULMIN](/fr/grammar/edge/toulmin/), [NODE](/fr/grammar/edge/toulmin/node/), [SOURCE et sections](/fr/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/fr/grammar/value/decimal/unsigned-decimal/), [SIGNED-DECIMAL](/fr/grammar/value/decimal/signed-decimal/)
