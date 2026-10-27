---
title: "LOCAL"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL est une Reference de déclaration qui désigne une cible par un ID émis par ce document. L'Edge Id est aussi un LOCAL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LOCAL est une Reference de déclaration qui désigne une cible par un ID émis par ce document. Elle réfère à une cible du document sans Issuer externe et n'a pas de sens hors du document. Pour désigner depuis l'extérieur du document, on place dans le document le Meta [DOC-ID](/fr/grammar/meta/declaration/doc-id/), et les autres documents le désignent par une Reference de pointeur.

## Disposition

```
TAG WORD          0000 0LLL L000 1QQQ      CCCC = 0001
[TAG d'extension de Length]
LOCAL ID          unsigned big-endian sur la largeur la plus courte
```

| LOCAL ID | Total | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0088` |
| `65536..2^32-1` | 3 WORD | `0x0108` |
| `2^32..2^48-1` | 4 WORD | `0x0188` |
| `2^48..2^64-1` | 5 WORD | `0x0208` |

- Le TAG WORD est `0000 0 LLLL 0001 QQQ`. Pour Identified (`000`), les 7 bits de poids faible valent `0x08`.
- On suit la règle commune des Reference qui écrit l'ID de cible sur le plus petit nombre de WORD.

## Edge Id

- Le LOCAL qui est le premier élément du Payload d'un Edge est la déclaration de l'Edge Id de cet Edge ([Edge](/fr/grammar/edge/)). Le Quantifier du LOCAL qui déclare un Edge Id est toujours `000`.
- Un LOCAL à une autre place du Payload d'un Edge est une mention. Une cible de ce document s'écrit en LOCAL à chaque mention. Il n'existe pas de code de pointeur à part pour désigner une cible de ce document.

## Attribution des identifiants

- L'ID est un entier attribué par l'encodeur. La grandeur du nombre et l'ordre d'attribution n'ont d'autre sens que l'identité.
- **UNIQUE (obligatoire).** Dans un document, un LOCAL ID ne désigne qu'une seule cible. Un Edge Id n'est déclaré qu'une fois par document (les Edge de HEAD et du BODY partagent un seul espace de numéros). Si plus d'un Edge déclare le même Edge Id, invalid.
- **AUTO INCREMENT (recommandé).** Un nouvel ID s'attribue comme le maximum des ID attribués jusqu'ici dans ce document + 1, et croît dans l'ordre du document. C'est aussi vrai d'une version à l'autre (on crée une nouvelle valeur supérieure à l'ID supprimé). Ce n'est qu'une recommandation et non une condition de validité, et un document où il ne croît pas est aussi valide. Le décodeur ne s'appuie pas sur la grandeur ni la continuité des ID.
- L'ID `0` n'est pas attribué. Il ne désigne aucune cible et n'est pas employé comme Edge Id. Les ID de cible sont attribués à partir de `1`.
- Un document se désigne, de l'intérieur comme de l'extérieur, par un seul [DOC-POINTER](/fr/grammar/reference/doc-pointer/) (il se désigne lui-même par le DOC-POINTER de son `DOC-ID`). On peut aussi attacher à un document `BIND`, `LABEL` et des Edge de jugement.
- L'Issuer lui-même se désigne par [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/). L'ID de document `0` est le document d'index des définitions de termes de l'Issuer.
- Les Codec qui donnent un sens à `0` à une place de composant ([TOULMIN](/fr/grammar/edge/toulmin/), « aucun » des REF et des Edge d'exécution ; « document entier » du Target du [SOURCE](/fr/grammar/edge/source/#origine-du-document-entier) du HEAD) suivent la règle de ce Codec. C'est une convention interne à ce Codec, différente des [marqueurs d'emplacement](/fr/grammar/reference/slot-marker/).
- Un ID une fois attribué n'est pas réutilisé dans le même document.
- On emploie toujours la largeur minimale qui puisse exprimer la valeur.

## Identité et portée

- Dans un même document, des LOCAL ID de même valeur entière sont la même cible. La largeur de l'encodage ne fait pas partie de l'identité.
- Un LOCAL Identified représente une cible identifiée. On ne l'emploie pas comme anonyme, non précisé, null ou sentinelle. Pour dire qu'une valeur existe sans qu'on la connaisse (UNKNOWN-VALUE) ou qu'il n'y en a pas (NO-VALUE), on écrit un [marqueur d'emplacement](/fr/grammar/reference/slot-marker/) dans le champ qui le reçoit.
- Deux LOCAL ID différents sont seulement des Reference différentes, et cela ne signifie pas que les cibles réelles sont différentes.
- On n'étend pas l'identité d'un LOCAL hors du document. Un même nombre dans un autre document n'a aucun rapport.
- Un LOCAL Variable (`100`) est une variable de discours nommée ([Reference](/fr/grammar/reference/), Variable).

## Fusion

Pour fusionner plusieurs documents en un, on construit pour chaque document d'origine une table de correspondance `old ID → new ID`, on réattribue tous les LOCAL ID avec les ID du nouveau document et l'on change toutes les références.

- Les ID qui étaient identiques dans un même document d'origine doivent le rester après la fusion.
- Un même nombre dans des documents d'origine différents n'a aucun rapport, et on ne les fusionne pas automatiquement en une même Reference.
- S'il reste ne serait-ce qu'un LOCAL non converti, on refuse la fusion.

## Validité

Les encodages ou attributions suivants sont invalid.

- Encodage non minimal avec un WORD `0x0000` de tête (exception : la valeur 0 en 1 WORD `0x0000`)
- Quantifier différent de `000`, ou ID valant `0`, à la place de la déclaration d'un Edge Id
- Un ID attribué en recouvrement à des cibles différentes dans un même document
- Même Edge Id déclaré plus d'une fois dans un même document

## Exemple

| LOCAL ID | Suite de WORD |
|---:|---|
| 1 | `0088 0001` |
| 65535 | `0088 ffff` |
| 65536 | `0108 0001 0000` |
| 4294967295 | `0108 ffff ffff` |
| 1, Variable | `008C 0001` |

## Pages liées

- [Reference](/fr/grammar/reference/), [DOC-POINTER](/fr/grammar/reference/doc-pointer/), [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/fr/grammar/reference/external-pointer/)
- [Edge](/fr/grammar/edge/)
