---
title: "NEXT-LOCAL-ID (0x1DDL)"
weight: 477
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indique le LOCAL ID que la version suivante du document attribuera à un nouvel énoncé (auto increment d'un SGBD, AUTO_INCREMENT de MySQL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `NEXT-LOCAL-ID` (BIND `NEXT-LOCAL-ID` du document de spécification) |
| TAG ID | `0x1DDL` |
| Codec ID | `0x00001DD0` |
| Document de spécification | `0x00000000/codecs/0x00001DD0/` (cible du DECLARE `1DD0`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 29 |
| Kind | Meta · classe : lignée |
| TAG WORD | `0001 1101 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | LOCAL ID à attribuer ensuite (auto increment). Placé dans le HEAD de la liste des versions `versions.geul` |
| Côté Hugo | `meta/lineage/next-local-id.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `next` | #2 | valeur brute du reste (`0xFFFF`) |  |  |

Indique le LOCAL ID que la version suivante du document attribuera à un nouvel énoncé (auto increment d'un SGBD, MySQL `AUTO_INCREMENT`). Tous les LOCAL ID attribués dans n'importe quelle version du document sont inférieurs à cette valeur.

## Disposition {#레이아웃}

```
TAG WORD          0001 1101 1101 LLLL      Codec 0x1DDL
Payload           LOCAL ID à attribuer ensuite, entier non signé de la largeur la plus courte
```

- Codec : Meta `0x1DDL`, classe lignée
- Payload : valeur brute (entier non signé de la largeur la plus courte)
- Nombre : au plus un
- Emplacement : HEAD du document de liste des versions `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md))

## Interprétation et validité {#해석과-유효성}

- Le LOCAL ID (y compris l'Edge Id) est une identité qui dépasse les versions ([révision](../document.md#개정)). Un nouvel énoncé reçoit cette valeur, puis la valeur augmente de 1. Un LOCAL ID supprimé n'est pas réutilisé. Ainsi, même si l'énoncé qui porte la valeur maximale est supprimé, cette valeur ne diminue pas.
- Le LOCAL ID `0` n'est pas attribué, donc la première valeur est `1`. S'il n'y a pas encore de version, on ne place pas ce Meta et le numéro suivant est `1`.
- À chaque publication d'une version, l'instance de publication met à jour cette valeur dans le nouveau document de liste. Elle doit être supérieure à tout LOCAL ID employé dans les versions publiées. Si elle est inférieure ou égale, c'est invalid.
- La valeur ne fait que croître. Si elle est inférieure à celle du document de liste précédent ([PARENT](0x1D1L-parent.md)), c'est invalid.
- Elle n'existe pas dans un document sans gestion de versions (document sans `versions.geul`, document anonyme). Un tel document n'a pas non plus de diff ([DELTA-BASE](0x1DBL-delta-base.md)).
- On ne la place pas dans le corps du document (document de version). La mémorisation du numéro ne relève pas du contenu du document mais de l'état de l'instance de publication qui poursuit le document (côté refs de git, non côté commit).

## Exemple {#예시}

Prochain numéro à attribuer : 524 :

```
1DD1 020C
```

- TAG `1DD1` (Meta `0x1DDL`, `LLLL=0001`, 2 WORD), Payload `020C`.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001DD0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DD000000000
BODY
#1 DECLARE 0x1DD0
#2 FIELD #1 rest
#3 BIND #1 "NEXT-LOCAL-ID"
#4 BIND #2 "next"
```
