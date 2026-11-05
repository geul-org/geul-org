---
title: "DERIVED-FROM (0x1D2L)"
weight: 466
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indique que ce document dérive de documents ou de matériaux d'une autre lignée."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `DERIVED-FROM` (BIND `DERIVED-FROM` du document de spécification) |
| TAG ID | `0x1D2L` |
| Codec ID | `0x00001D20` |
| Document de spécification | `0x00000000/codecs/0x00001D20/` (cible du DECLARE `1D20`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 18 |
| Kind | Meta · classe : lignée |
| TAG WORD | `0001 1101 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Dérivé d'enregistrements ou de matériaux d'une autre lignée. Pour figer une version précise d'un matériau externe, on joint au [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) du HEAD un QUALIFIER de hachage du texte original (P4092) (git submodule). |
| Côté Hugo | `meta/lineage/derived-from.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `source` | #2 | enregistrement | `000F` toute la section 0 (joker, Reference), `020F` toute la section 1 (joker, Reference), `040F` toute la section 2 (joker, Reference), `07C0` SHA-256-DIGEST, `0740` URI-EVEN, `0750` URI-ODD |  |

Indique que ce document dérive de documents ou de matériaux d'une autre lignée.

## Disposition {#레이아웃}

```
TAG WORD          0001 1101 0010 LLLL      Codec 0x1D2L
[TAG d'extension Length]
Payload           Une Reference, ou un SHA-256-DIGEST (hachage du contenu), ou une Value URI
```

- Codec : Meta `0x1D2L`, classe lignée
- Payload : Reference ou Value intégrée
- Nombre : plusieurs possibles

## Interprétation et validité {#해석과-유효성}

- Si le document dérive d'un document GEUL, on place son hachage du contenu ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)) ; s'il s'agit d'un matériau externe, un [URI](../value/0x074L-uri.md). Pour figer par un hachage l'édition d'un matériau externe, on joint au [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) du HEAD un QUALIFIER de hachage du texte original (P4092).
- L'origine au niveau de l'enregistrement relève de l'Edge de fondement [SOURCE](../edge/0x0C0L-source.md) ; pour un ancien enregistrement avant déplacement, scission ou fusion, c'est le QUALIFIER P1365 de l'Edge cible (dont la valeur est l'ancien Id d'Edge) qui s'en charge.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001D20/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D2000000000
BODY
#1 DECLARE 0x1D20
#2 FIELD #1 record
#3 BIND #1 "DERIVED-FROM"
#4 BIND #2 "source"
#5 CODEC #2 0x000F
#9 CODEC #2 0x020F
#10 CODEC #2 0x040F
#6 CODEC #2 0x07C0
#7 CODEC #2 0x0740
#8 CODEC #2 0x0750
```
