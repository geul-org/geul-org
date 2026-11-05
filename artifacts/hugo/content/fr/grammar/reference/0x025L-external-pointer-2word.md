---
title: "EXTERNAL-POINTER-2WORD (0x025L~0x029L)"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER est une Reference de désignation qui désigne le LOCAL ID d'un document importé par IMPORT-DOC du HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER est une Reference de désignation qui désigne le LOCAL ID d'un document importé par IMPORT-DOC du HEAD.

| Élément | Valeur |
|---|---|
| Nom | `EXTERNAL-POINTER-2WORD` (groupe 5Q. Noms par code dans le tableau des membres ci-dessous) |
| TAG ID | `0x025L~0x029L` |
| Section | 1 `0001` (Reference EXTERNAL), offset dans la section C = 5~9 |
| Kind | Reference · classification : désignation |
| Côté Hugo | `reference/external-pointer.md` (cette page traite aussi de [EXTERNAL-POINTER-1WORD](0x020L-external-pointer-1word.md) et [EXTERNAL-POINTER-4WORD](0x02AL-external-pointer-4word.md)) |

## Membres {#구성원}

Cette page traite d'un jeu complet du système 5Q, soit cinq codes. La quantification est l'offset dans la section `C % 5` ([Reference](_index.md#quantifier)). Il y a un document de Codec par code. Les champs des cinq documents de Codec sont identiques ; seuls la cible DECLARE et le nom (BIND) diffèrent.

| TAG ID | Nom | Quantification | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x025L` | `EXTERNAL-POINTER-2WORD-IDENTIFIED` | Identified | `0x00000250` | `0x00000000/codecs/0x00000250/` | `0000 0010 0101 LLLL` |
| `0x026L` | `EXTERNAL-POINTER-2WORD-GENERIC` | Generic | `0x00000260` | `0x00000000/codecs/0x00000260/` | `0000 0010 0110 LLLL` |
| `0x027L` | `EXTERNAL-POINTER-2WORD-FREE-CHOICE` | Free-choice | `0x00000270` | `0x00000000/codecs/0x00000270/` | `0000 0010 0111 LLLL` |
| `0x028L` | `EXTERNAL-POINTER-2WORD-UNIVERSAL` | Universal | `0x00000280` | `0x00000000/codecs/0x00000280/` | `0000 0010 1000 LLLL` |
| `0x029L` | `EXTERNAL-POINTER-2WORD-VARIABLE` | Variable | `0x00000290` | `0x00000000/codecs/0x00000290/` | `0000 0010 1001 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `import-id` | #2 | valeur brute 2 WORD |  |  |
| 2 | `target-id` | #3 | valeur brute restante (`0xFFFF`) |  |  |

EXTERNAL-POINTER est une Reference de désignation qui désigne le LOCAL ID d'un document importé par [IMPORT-DOC](../meta/0x1E4L-import-doc.md) du HEAD.

## Disposition {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x020L~0x02EL (section 1)
[TAG d'extension de Length]
IMPORT ID         largeur fixée par le Codec (1/2/4 WORD)
ID de cible       tout le reste. LOCAL ID du document importé, sur la largeur la plus courte
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Nom | Largeur de l'IMPORT ID |
|---|---|---|
| `0x020L~0x024L` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `0x025L~0x029L` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `0x02AL~0x02EL` | EXTERNAL-POINTER-4WORD | 4 WORD |

- La largeur est fixée par le numéro de système : si système − 6 (`C / 5`, avec `C` l'offset dans la section) vaut 0, 1, 2, la largeur est 1, 2, 4 WORD. La quantification est `C % 5`.

- On utilise le Codec le plus étroit dans lequel tient la valeur de l'IMPORT ID.
- L'IMPORT ID est la valeur attribuée par `IMPORT-DOC` de ce document. EXTERNAL-POINTER n'indique pas d'Issuer. L'Issuer et l'ID de document s'obtiennent à partir de cet `IMPORT-DOC`. La version est aussi fixée par cet `IMPORT-DOC` (fixe ou la plus récente).
- Pour un même LOCAL ID du document importé, c'est la même cible, qu'on l'écrive en LOCAL dans ce document ou en EXTERNAL-POINTER ici.
- Pour Variable, c'est une variable LOCAL du document importé.

## Validité {#유효성}

- Si ce document n'a pas d'`IMPORT-DOC` qui attribue cet IMPORT ID, c'est invalid.
- Si l'IMPORT ID tient dans un Codec plus étroit mais qu'on emploie un Codec plus large, on le rejette comme non-minimal.
- Si l'ID de cible vaut `0`, c'est invalid. Le document importé lui-même se désigne par [DOC-POINTER](0x041L-doc-pointer.md).
- Un WORD `0x0000` en tête de l'ID de cible est interdit.

## Exemple {#예시}

| Cible | Séquence de WORD |
|---|---|
| LOCAL 5 de l'IMPORT ID 1 | `0202 0001 0005` |
| LOCAL 65536 de l'IMPORT ID 1 | `0203 0001 0001 0000` |
| LOCAL 5 de l'IMPORT ID 70000 | `0253 0001 1170 0005` |

## Pages liées {#관련-페이지}

- [Reference](_index.md), [LOCAL](0x005L-local.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [DOC-POINTER](0x041L-doc-pointer.md)
- [IMPORT-DOC](../meta/0x1E4L-import-doc.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000250/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000025000000000
BODY
#1 DECLARE 0x0250
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "EXTERNAL-POINTER-2WORD-IDENTIFIED"
#5 BIND #2 "import-id"
#6 BIND #3 "target-id"
```

Ce qui précède est le document de Codec de `EXTERNAL-POINTER-2WORD-IDENTIFIED` (`0x025L`). Pour les autres membres (`EXTERNAL-POINTER-2WORD-GENERIC`, `EXTERNAL-POINTER-2WORD-FREE-CHOICE`, `EXTERNAL-POINTER-2WORD-UNIVERSAL`, `EXTERNAL-POINTER-2WORD-VARIABLE`), seuls le Codec ID du DOC-ID, la cible DECLARE et le nom lié (BIND) en `#1` diffèrent.
