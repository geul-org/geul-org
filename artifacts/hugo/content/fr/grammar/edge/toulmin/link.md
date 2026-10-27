---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK est la disposition qui écrit les relations entre nœuds TOULMIN (attaque, exclusion, exécution, lien de jugement, définition, nom). Elle se compose de REF src et dst, d'un WORD de flags, d'un seuil de confiance facultatif et d'un SPAN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK est la disposition qui écrit les relations entre nœuds dans un graphe TOULMIN. Le genre de relation est fixé par le Codec (ou le numéro de format ISSUER de GEUL).

## Codec

| Codec | Nom | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | règle → règle. Entame progressivement le jugement |
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
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED
[F_GATE]         1 WORD d'opérateur (2 bits de poids fort) + Value UNSIGNED-DECIMAL (pourcentage)
SPAN             largeur fixée par SOURCE × 2
```

| flag | Sens |
|---|---|
| b0 F_ONCE | Exécuté une seule fois (le `once` d'UNDO) |
| b1 F_GATE | Il y a un champ de seuil de confiance |
| b2 F_STRIKE | Relation barrée |
| b3 F_ORDERED | Appartient à une liste ordonnée `1.` |

| Opérateur de seuil | Sens |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

## Interprétation et validité

- REF est l'Edge Id d'un enregistrement de ce document (champs communs de [TOULMIN](/fr/grammar/edge/toulmin/#champs-communs)).
- La forme de dst est fixée par le Codec. Pour DO, DO-ONCE et UNDO, FuncRef (REF(ALIAS, 0 s'il n'y en a pas) + VerbCode 1 WORD, [NODE](/fr/grammar/edge/toulmin/node/#champs)) ; pour LABEL et IMPORTED-FROM, le REF d'un enregistrement TEXT ; pour les autres, le REF d'un nœud.
- `do … once` est exprimé par le Codec DO-ONCE. Dans les flags de DO-ONCE, on n'emploie pas F_ONCE (rejeté s'il est activé). Le `once` d'UNDO s'écrit par F_ONCE.
- L'opérateur de seuil est dans les 2 bits de poids fort du WORD d'opérateur, les 14 autres bits valent 0. Le pourcentage est une Value UNSIGNED-DECIMAL avec `E=0`, de 0 à 100.
- Les bits b4 à b15 des flags sont réservés et doivent valoir 0. Sinon, on rejette.
- Une chaîne `A > B > C` de SUPERSEDES s'écrit avec un SUPERSEDES par paire.

## Pages liées

- [TOULMIN](/fr/grammar/edge/toulmin/), [NODE](/fr/grammar/edge/toulmin/node/), [SOURCE et sections](/fr/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/fr/grammar/value/decimal/unsigned-decimal/)
