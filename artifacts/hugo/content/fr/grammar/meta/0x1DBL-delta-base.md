---
title: "DELTA-BASE (0x1DBL)"
weight: 475
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Marqueur indiquant que ce fichier de version n'est pas un instantané mais un diff par rapport à une version de base du même document (delta d'un packfile git)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `DELTA-BASE` (BIND `DELTA-BASE` du document de spécification) |
| TAG ID | `0x1DBL` |
| Codec ID | `0x00001DB0` |
| Document de spécification | `0x00000000/codecs/0x00001DB0/` (cible du DECLARE `1DB0`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 27 |
| Kind | Meta · classe : lignée |
| TAG WORD | `0001 1101 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Ce fichier de version est un diff par rapport à une version de base du même document (ID de version sur 2 WORD) (git packfile delta) |
| Côté Hugo | `meta/lineage/delta-base.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | valeur brute 2 WORD | `0620` UNSIGNED-INTEGER |  |

Marqueur indiquant que ce fichier de version n'est pas un instantané mais un **diff** par rapport à une version de base du même document (delta d'un packfile git). La version elle-même reste définie comme un instantané. Le hachage du contenu, la liste des versions et les signatures portent tous sur l'instantané restauré par application du diff ([stockage par diff](../document.md#diff-저장)).

## Disposition {#레이아웃}

```
TAG WORD          0001 1101 1011 LLLL      Codec 0x1DBL
ID de version     2 WORD non signés (version de base du même document)
```

- Codec : Meta `0x1DBL`, classe lignée
- Payload : ID de version sur 2 WORD (valeur brute)
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- On ne l'emploie que dans un document qui a un [DOC-ID](0x1C7L-doc-id.md). La liste des versions `versions.geul`, qui n'a pas de `DOC-ID`, les documents de liste (versions de `issuers/`) et les documents anonymes n'ont pas de diff.
- La version de base est une version publiée du même `DOC-ID`, antérieure à cette version. `0` (aucune version) est invalid.
- Le hachage du contenu de l'instantané restauré doit être égal au hachage de cette version dans la liste des versions ([PUBLICATION](../edge/0x0B8L-publication.md)). Sinon, ce diff est invalid. C'est pourquoi on n'écrit pas séparément le hachage du résultat dans le diff.
- Seul un document dont tous les enregistrements du BODY sont des Edge (enregistrements ayant un Edge Id) peut être mis en diff, car l'unité du diff est le LOCAL ID (Edge Id).
- La règle de restauration de l'instantané suit le [stockage par diff](../document.md#diff-저장). La suppression relève de [DELTA-REMOVE](0x1DCL-delta-remove.md).
- Il n'y a pas de marqueur distinct d'ajout ou de révision. Si l'Edge Id d'un BODY de diff existe dans la base, c'est une révision ; sinon, c'est un ajout. Les ajouts reçoivent leur numéro à partir de [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) de la liste des versions. Réutiliser un LOCAL ID supprimé est invalid ([révision](../document.md#개정)).

## Exemple {#예시}

Diff par rapport à la version de base 3 :

```
1DB2 0000 0003
```

- TAG `1DB2` (Meta `0x1DBL`, `LLLL=0010`, 3 WORD), ID de version `0000 0003`.

## Problèmes ouverts {#열린-문제}

1. Intervalle des instantanés : tous les combien de versions placer un instantané complet (longueur de la chaîne de diffs et coût de restauration).
2. Faut-il limiter la version de base à la version immédiatement précédente ?
3. Emplacement de stockage du fichier de diff : à la place du fichier de version (`<ID de version>.geul`) ou en relation avec l'adresse par hachage du contenu `<Issuer>/hashes/` (`hashes/` se retrouve par le hachage du contenu de l'instantané).

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001DB0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DB000000000
BODY
#1 DECLARE 0x1DB0
#2 FIELD #1 0x0002
#3 BIND #1 "DELTA-BASE"
#4 BIND #2 "version"
#5 CODEC #2 0x0620
```
