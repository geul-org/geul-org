---
title: "DOC-ID (0x1C7L)"
weight: 455
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Déclare l'identifiant de ce document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `DOC-ID` (BIND `DOC-ID` du document de spécification) |
| TAG ID | `0x1C7L` |
| Codec ID | `0x00001C70` |
| Document de spécification | `0x00000000/codecs/0x00001C70/` (cible du DECLARE `1C70`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 7 |
| Kind | Meta · classe : définition |
| TAG WORD | `0001 1100 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Identifiant de ce document. Reference intégrée `DOC-POINTER` (Issuer, ID de document, version 0). Pour un document de codec, `CODEC-POINTER` (Issuer, Codec ID, version 0) |
| Côté Hugo | `meta/declaration/doc-id.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | enregistrement | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |

Déclare l'identifiant de ce document. Il est nécessaire pour qu'un autre document puisse désigner ce document et les objets qu'il contient.

## Disposition {#레이아웃}

```
TAG WORD          0001 1100 0111 LLLL      Codec 0x1C7L
[TAG d'extension Length]
Document          Enregistrement Reference DOC-POINTER. (Issuer, ID de document, version 0). CODEC-POINTER pour un document de codec
```

- Codec : Meta `0x1C7L`, classe définition
- Payload : une Reference intégrée [DOC-POINTER](../reference/0x041L-doc-pointer.md) (Issuer, ID de document, version 0)
- Nombre : au plus un. Obligatoire pour les documents de version sous `docs/<ID de document>/` et `codecs/<Codec ID>/`

## Interprétation et validité {#해석과-유효성}

- Le Payload est exactement un enregistrement Reference `DOC-POINTER` (Issuer, ID de document, version `0`). On n'emploie que `0` comme ID de version. La version est attribuée non par le document mais par la liste des versions. Un document de codec emploie `CODEC-POINTER` (Issuer, Codec ID, version `0`) ([CODEC-POINTER](../reference/0x042L-codec-pointer.md)).
- Ainsi, la notation qui désigne « ce document » est la même dans le DOC-ID, dans l'enregistrement PUBLICATION de la liste des versions et dans les citations d'autres documents.
- Indépendamment de la version, un même document a le même `DOC-ID`. L'ID de version et le hachage du contenu ne sont pas écrits dans le document ([version](../document.md#버전)).
- Il n'existe pas d'adresse par nom de document ([adresses de publication et liste des versions](../publishing.md#문서-이름)). Le titre lisible par l'humain relève du [LABEL](../edge/0x0A4L-label.md) d'énoncé.
- En son absence, le document est anonyme et ne peut être désigné que par le hachage de son contenu. Il est nécessaire pour qu'un autre document puisse désigner un LOCAL de ce document par une Reference d'indication.
- Celui qui récupère un document vérifie que le `DOC-ID` du document reçu est égal à l'Issuer et à l'ID de document demandés.
- L'ID de document `0x0000000000000000` est le document d'index des définitions de termes de l'Issuer ([Issuer](../issuer.md)). Comme c'est lui aussi un document de version sous `docs/<ID de document>/`, on y place un DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). L'Issuer lui-même est représenté par [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- Pour les documents de version `<ID de version>.geul` de `<Issuer>/docs/<ID de document>/` et `<Issuer>/codecs/<Codec ID>/` sous `.well-known/geul/` (documents de spécification compris), le `DOC-ID` est obligatoire.
- Les documents de liste font exception et n'ont pas de `DOC-ID` : la liste des versions `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md)) et les versions `<ID de version>.geul` de la liste des Issuer `issuers/` ([adresses de publication et liste des versions](../publishing.md#목록-문서)). Ce dont il s'agit est indiqué par le DOC-POINTER de l'enregistrement. La version d'un document de liste est désignée par le PUBLICATION de son `versions.geul`, au moyen d'un DOC-POINTER (`0x00000000`, ID de document réservé, ID de version). L'adresse par hachage du contenu `<Issuer>/hashes/` est une copie des documents ci-dessus et suit donc l'original.
- L'ID de document `0xFFFFFFFFFFFFFFFF` est réservé dans tous les Issuer (de même que `0x0000000000000000`) et sert à la liste des Issuer de l'Issuer `0x00000000`. Les autres Issuer ne l'utilisent pas. Comme les documents de liste n'ont pas de `DOC-ID`, cette valeur n'apparaît que dans le DOC-POINTER des enregistrements de `issuers/versions.geul`.
- Un document de spécification de Codec est un document de codec de l'Issuer GEUL `0x00000000`. Il n'a pas d'ID de document et place comme `DOC-ID` un CODEC-POINTER (`0x00000000`, Codec ID, `0`). Le Codec ID est le TAG WORD de Kind·Codec écrit sur 32 bits (`0x0B80` → `0x00000B80`) ([document de spécification](../codec-spec.md)).

## Exemple {#예시}

- Issuer `0x00000002`, document `0x…0005` : `1C79 0418 0000 0002 0000 0000 0000 0005 0000 0000` (TAG Meta 1 + TAG Reference 1 + Issuer 2 + ID de document 4 + version 2 = 10 WORD)

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001C70/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C7000000000
BODY
#1 DECLARE 0x1C70
#2 FIELD #1 record
#5 CODEC #2 0x0410
#3 BIND #1 "DOC-ID"
#4 BIND #2 "doc"
#6 CODEC #2 0x0420
```
