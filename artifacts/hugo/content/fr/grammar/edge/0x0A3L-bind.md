---
title: "BIND (0x0A3L)"
weight: 163
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND est un Edge d'énoncé qui lie à Subject un nom auquel la machine se conforme."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `BIND` (BIND du document de spécification `BIND`) |
| TAG ID | `0x0A3L` |
| Codec ID | `0x00000A30` |
| Document de spécification | `0x00000000/codecs/0x00000A30/` (cible de DECLARE `0A30`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 3 |
| Kind | Edge · famille : énoncé, groupe : désignation et nom |
| TAG WORD | `0000 1010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Lie à Subject un nom (`UTF8-TEXT-*`) auquel la machine se conforme. Unique dans sa portée, il doit correspondre exactement et n'a pas de langue |
| Côté Hugo | `edge/bind.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | enregistrement | tout enregistrement (marqueurs d'emplacement exclus) |  |
| 2 | `name` | #3 | enregistrement | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

BIND est un Edge d'énoncé qui lie à Subject un nom auquel la machine se conforme. Codec `0x0A3L`.

C'est une nomination. Le nom lisible par l'humain (titre par langue) relève de [LABEL](0x0A4L-label.md). Le nom d'un symbole de programme et le nom de domaine de la liste des Issuer s'écrivent avec le même enregistrement.

## Disposition {#레이아웃}

```
TAG WORD          0000 1010 0011 LLLL
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference, ou 1 WORD de TAG WORD de codec
nom               1 Value UTF8-TEXT-*
```

## Interprétation et validité {#해석과-유효성}

- Subject est exactement un enregistrement [Reference](../reference/_index.md) complet. Si c'est un LOCAL, c'est un objet de ce document (symbole, etc.) ; si c'est une Reference de désignation, c'est un objet d'un autre document. Le document lui-même est [DOC-POINTER](../reference/0x041L-doc-pointer.md), et l'Issuer lui-même est [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- Ou bien Subject est un seul TAG WORD de codec (Kind et Codec seulement, `LLLL = 0`, sans Payload). Ce n'est pas un enregistrement à Payload vide : il désigne ce code direct lui-même, c'est-à-dire son document de spécification (codec de l'Issuer GEUL `0x0000<TAG>`) ([document de spécification de Codec](../codec-spec.md), [DECLARE](0x0BBL-declare.md)). Exemple : `0B80` est PUBLICATION. Un codec au format Issuer n'est pas désigné sous cette forme.
- Les autres enregistrements (Value, etc.) ne peuvent pas être Subject. Le FIELD du document de spécification de BIND déclare Subject seulement en largeur `0` (enregistrement), cette contrainte est donc une règle du corps de BIND.
- Le nom est exactement une Value [UTF8-TEXT](../value/0x072L-utf8-text.md). Il n'a pas de langue et n'est pas normalisé. Les noms sont identiques si leurs octets le sont.
- La portée du nom est le document qui contient BIND. Dans un même document, on ne lie pas le même nom à des Subject différents.
- On peut lier plusieurs noms à un Subject (alias, anciens noms). Sauf décision contraire du document, le dernier BIND est le nom représentatif.
- Les autres enregistrements désignent un objet par ID LOCAL, non par nom. Le nom sert à s'accorder avec l'extérieur (fonctions de l'hôte, saisie d'adresse, humains).
- Les caractères utilisables dans un nom dépendent de l'usage. Le nom de domaine de la liste des Issuer suit les règles de domaine (minuscules, IDNA) ([adresse de publication et liste des versions](../publishing.md#issuer-목록)).
- On ne place pas de BIND dans la liste des versions. Il n'existe pas d'adresse par nom de document ([adresse de publication et liste des versions](../publishing.md#문서-이름)).

## Longueur {#길이}

```
total = 1 + N_len + N_id + N_subject + N_name WORD
```

## Exemple (non normatif) {#예시-비규범}

Symbole de programme : Edge Id `0003`, Subject LOCAL 7, nom `main`.

- Le nom `main` fait 4 octets (pair), soit `0722 6D61 696E`, 3 WORD.
- L'Edge fait TAG 1 + Edge Id 2 + Subject 2 + nom 3 = 8 WORD, TAG `0A37`.

```
0A37 0051 0003 0051 0007 0722 6D61 696E
```

## Pages liées {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [adresse de publication et liste des versions](../publishing.md#issuer-목록) (nom de domaine de la liste des Issuer)
- [LOCAL](../reference/0x005L-local.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000A30/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A3000000000
BODY
#1 DECLARE 0x0A30
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "BIND"
#5 BIND #2 "subject"
#6 BIND #3 "name"
#7 CODEC #3 0x0720
#8 CODEC #3 0x0730
```
