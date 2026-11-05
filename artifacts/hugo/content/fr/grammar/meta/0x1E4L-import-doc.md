---
title: "IMPORT-DOC (0x1E4L)"
weight: 484
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "Importe un document externe au moyen d'un IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `IMPORT-DOC` (BIND `IMPORT-DOC` du document de spécification) |
| TAG ID | `0x1E4L` |
| Codec ID | `0x00001E40` |
| Document de spécification | `0x00000000/codecs/0x00001E40/` (cible du DECLARE `1E40`) |
| Section | 15 `1111` (Meta), décalage C dans la section = 4 |
| Kind | Meta · classe : IMPORT |
| TAG WORD | `0001 1110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Importe un document externe au moyen d'un IMPORT ID. Reference intégrée `DOC-POINTER` (`CODEC-POINTER` pour un document de codec) + IMPORT ID |
| Côté Hugo | `meta/import/import-doc.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #4 | enregistrement | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `import-id` | #2 | valeur brute du reste (`0xFFFF`) |  |  |

Importe un document externe au moyen d'un IMPORT ID. Le document à importer est désigné par [DOC-POINTER](../reference/0x041L-doc-pointer.md), et la largeur de l'Issuer est aussi portée par DOC-POINTER.

## Disposition {#레이아웃}

```
TAG WORD          0001 1110 0100 LLLL      Codec 0x1E4L
[TAG d'extension Length]
Document          Enregistrement Reference DOC-POINTER (Issuer, ID de document, ID de version. La version 0 désigne la dernière). CODEC-POINTER pour un document de codec
IMPORT ID         Tout le reste. Non signé de la largeur la plus courte
```

- Codec : Meta `0x1E4L`, classe IMPORT
- Payload : Reference intégrée `DOC-POINTER` (Issuer, ID de document, ID de version) + valeur brute IMPORT ID
- Nombre : plusieurs possibles (un par IMPORT ID)

## Interprétation et validité {#해석과-유효성}

- Le document est exactement un enregistrement DOC-POINTER. Pour importer un document de codec, c'est un enregistrement [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, Codec ID, ID de version). Il se termine par sa propre Length, et le reste est l'IMPORT ID.
- L'IMPORT ID fait au moins 1 WORD, de la largeur la plus courte. La largeur de l'IMPORT ID est fixée ici par la longueur de l'enregistrement, et dans [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) par le Codec.
- Dans un même document, on n'attribue pas deux fois le même IMPORT ID.
- Si l'on indique un ID de version, la liaison se fait à cette édition ; avec `0`, à la dernière édition au moment de l'interprétation (ou à l'édition en vigueur à l'instant indiqué) ([révision](../document.md#개정)).
- Les [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) du BODY désignent les LOCAL du document importé par IMPORT ID. Le document importé lui-même est désigné par DOC-POINTER.
- Le HEAD du document importé n'est pas importé. Les objets de ce document s'interprètent selon les déclarations de ce document.
- On ne peut pas chercher d'un document à l'autre avec un IMPORT ID. Un dépôt qui charge plusieurs documents développe l'IMPORT ID en chemin complet (Issuer, ID de document, ID de version, LOCAL ID) pour le stocker.

## Exemple {#예시}

- IMPORT ID 1, Issuer `0x00000002`, document `0x…0002`, dernière version : `1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001` (TAG Meta 1 + DOC-POINTER 9 + IMPORT ID 1 = 11 WORD)

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001E40/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E4000000000
BODY
#1 DECLARE 0x1E40
#4 FIELD #1 record
#10 CODEC #4 0x0410
#2 FIELD #1 rest
#6 BIND #1 "IMPORT-DOC"
#7 BIND #2 "import-id"
#9 BIND #4 "doc"
#11 CODEC #4 0x0420
```
