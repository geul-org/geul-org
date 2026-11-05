---
title: "LOCAL (0x005L~0x009L)"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL est une Reference de déclaration qui désigne une cible par un ID émis par ce document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `LOCAL` (groupe 5Q. Noms par code dans le tableau des membres ci-dessous) |
| TAG ID | `0x005L~0x009L` |
| Section | 0 `0000` (entité Reference), offset dans la section C = 5~9 |
| Kind | Reference · classification : déclaration |
| Côté Hugo | `reference/local.md` |

## Membres {#구성원}

Cette page traite d'un jeu complet du système 5Q, soit cinq codes. La quantification est l'offset dans la section `C % 5` ([Reference](_index.md#quantifier)). Il y a un document de Codec par code. Les champs des cinq documents de Codec sont identiques ; seuls la cible DECLARE et le nom (BIND) diffèrent.

| TAG ID | Nom | Quantification | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x005L` | `LOCAL-IDENTIFIED` | Identified | `0x00000050` | `0x00000000/codecs/0x00000050/` | `0000 0000 0101 LLLL` |
| `0x006L` | `LOCAL-GENERIC` | Generic | `0x00000060` | `0x00000000/codecs/0x00000060/` | `0000 0000 0110 LLLL` |
| `0x007L` | `LOCAL-FREE-CHOICE` | Free-choice | `0x00000070` | `0x00000000/codecs/0x00000070/` | `0000 0000 0111 LLLL` |
| `0x008L` | `LOCAL-UNIVERSAL` | Universal | `0x00000080` | `0x00000000/codecs/0x00000080/` | `0000 0000 1000 LLLL` |
| `0x009L` | `LOCAL-VARIABLE` | Variable | `0x00000090` | `0x00000000/codecs/0x00000090/` | `0000 0000 1001 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `local-id` | #2 | valeur brute restante (`0xFFFF`) |  |  |

LOCAL est une Reference de déclaration qui désigne une cible par un ID émis par ce document. Elle référence une cible du document sans Issuer externe. Pour la désigner depuis l'extérieur du document, on place dans le document le Meta [DOC-ID](../meta/0x1C7L-doc-id.md), et les autres documents le désignent par une Reference de désignation.

## Disposition {#레이아웃}

```
TAG WORD          0000 0000 0101 LLLL      Codec 0x005L~0x009L (Identified 0x005L)
[TAG d'extension de Length]
LOCAL ID          unsigned big-endian sur la largeur la plus courte
```

| LOCAL ID | Total | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0051` |
| `65536..2^32-1` | 3 WORD | `0x0052` |
| `2^32..2^48-1` | 4 WORD | `0x0053` |
| `2^48..2^64-1` | 5 WORD | `0x0054` |

- Les Codec sont `0x005L` (Identified), `0x006L` (Generic), `0x007L` (Free-choice), `0x008L` (Universal) et `0x009L` (Variable). Le TAG WORD d'Identified est `0000 0000 0101 LLLL`.
- On suit la règle commune des Reference qui écrit l'ID de cible sur le plus petit nombre de WORD.

## Edge Id {#edge-id}

- Le LOCAL qui est le premier élément du Payload d'un Edge est la déclaration de l'Edge Id de cet Edge ([Edge](../edge/_index.md)). Pour le LOCAL qui déclare un Edge Id, on n'emploie que Identified (`0x005L`).
- Un LOCAL à une autre place du Payload d'un Edge est une mention. Une cible de ce document s'écrit en LOCAL à chaque mention. Il n'existe pas de code de désignation à part pour désigner une cible de ce document.

## Attribution des identifiants {#식별자-할당}

- L'ID est un entier attribué par l'encodeur. La grandeur du nombre et l'ordre d'attribution n'ont d'autre sens que l'identité.
- **UNIQUE (obligatoire).** Dans un document, un LOCAL ID ne désigne qu'une seule cible. Un Edge Id n'est déclaré qu'une fois par document (les Edge de HEAD et de BODY partagent un seul espace de numéros). Si plus d'un Edge déclare le même Edge Id, c'est invalid.
- **AUTO INCREMENT (recommandé).** Un nouvel ID s'attribue comme le maximum des ID attribués jusqu'ici dans ce document + 1, et croît dans l'ordre du document. C'est aussi vrai d'une version à l'autre (on crée une nouvelle valeur supérieure à l'ID supprimé). Ce n'est qu'une recommandation et non une condition de validité, et un document où il ne croît pas est aussi valid. Le décodeur ne s'appuie pas sur la grandeur ni la continuité des ID.
- L'ID `0` n'est pas attribué. Il ne désigne aucune cible et n'est pas employé comme Edge Id. Les ID de cible sont attribués à partir de `1`.
- Un document se désigne, de l'intérieur comme de l'extérieur, par un seul [DOC-POINTER](0x041L-doc-pointer.md) (il se désigne lui-même par le DOC-POINTER de son `DOC-ID`). On peut aussi attacher à un document `BIND`, `LABEL` et des Edge de verdict.
- L'Issuer lui-même se désigne par [ISSUER-POINTER](0x040L-issuer-pointer.md). L'ID de document `0` est le document d'index des définitions de termes de l'Issuer.
- Les Codec qui donnent un sens à `0` à une place de composant (« aucun » des REF et des Edge d'exécution de [TOULMIN](../toulmin/_index.md) ; « document entier » du Target de [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) du HEAD) suivent la règle de ce Codec. C'est une convention interne à ce Codec, différente des [marqueurs d'emplacement](../slot-marker.md).
- Un ID une fois attribué n'est pas réutilisé dans le même document.
- On emploie toujours la largeur minimale qui puisse exprimer la valeur.

## Identité et portée {#동일성과-범위}

- Dans un même document, des LOCAL ID de même valeur entière désignent la même cible. La largeur de l'encodage ne fait pas partie de l'identité.
- Un LOCAL Identified représente une cible identifiée. On ne l'emploie pas comme anonyme, non précisé, null ou sentinelle. Pour dire qu'une valeur existe sans qu'on la connaisse (UNKNOWN-VALUE) ou qu'il n'y en a pas (NO-VALUE), on écrit un [marqueur d'emplacement](../slot-marker.md) dans le champ qui le reçoit.
- Deux LOCAL ID différents sont seulement des Reference différentes, et cela ne signifie pas que les cibles réelles sont différentes.
- On n'étend pas l'identité d'un LOCAL hors du document. Un même nombre dans un autre document n'a aucun rapport.
- Un LOCAL Variable (`0x009L`) est une variable de discours nommée ([Reference](_index.md) Variable).

## Fusion {#병합}

Pour fusionner plusieurs documents en un, on construit pour chaque document d'origine une table de correspondance `old ID → new ID`, on réattribue tous les LOCAL ID avec les ID du nouveau document et l'on change toutes les références.

- Des ID qui étaient identiques dans un même document d'origine doivent le rester après la fusion.
- Un même nombre dans des documents d'origine différents n'a aucun rapport et n'est pas fusionné automatiquement en une même Reference.
- Si un seul LOCAL n'a pas pu être remplacé, on refuse la fusion.

## Validité {#유효성}

Les encodages ou attributions suivants sont invalid.

- Un encodage non minimal avec un WORD `0x0000` en tête (exception : le 1 WORD `0x0000` pour la valeur 0)
- Un Codec à la place de déclaration d'Edge Id qui n'est pas Identified (`0x005L`), ou un ID égal à `0`
- Un même ID attribué à des cibles différentes dans un même document
- Un même Edge Id déclaré plus d'une fois dans un même document

## Exemple {#예시}

| LOCAL ID | Séquence de WORD |
|---:|---|
| 1 | `0051 0001` |
| 65535 | `0051 FFFF` |
| 65536 | `0052 0001 0000` |
| 4294967295 | `0052 FFFF FFFF` |
| 1, Variable | `0091 0001` |

## Pages liées {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Edge](../edge/_index.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000050/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000005000000000
BODY
#1 DECLARE 0x0050
#2 FIELD #1 rest
#3 BIND #1 "LOCAL-IDENTIFIED"
#4 BIND #2 "local-id"
```

Ce qui précède est le document de Codec de `LOCAL-IDENTIFIED` (`0x005L`). Pour les autres membres (`LOCAL-GENERIC`, `LOCAL-FREE-CHOICE`, `LOCAL-UNIVERSAL`, `LOCAL-VARIABLE`), seuls le Codec ID du DOC-ID, la cible DECLARE et le nom lié (BIND) en `#1` diffèrent.
