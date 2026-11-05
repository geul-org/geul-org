---
title: "MESSAGE (0x1D9L)"
weight: 473
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indique la raison du changement (git commit message)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `MESSAGE` (BIND `MESSAGE` du document de spécification) |
| TAG ID | `0x1D9L` |
| Codec ID | `0x00001D90` |
| Document de spécification | `0x00000000/codecs/0x00001D90/` (cible du DECLARE `1D90`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 25 |
| Kind | Meta · classe : lignée |
| TAG WORD | `0001 1101 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Raison du changement. Value UTF8-LANGUAGE-TEXT, une par langue (git commit message) |
| Côté Hugo | `meta/lineage/message.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `message` | #2 | enregistrement | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Indique la raison du changement (git commit message).

## Disposition {#레이아웃}

```
TAG WORD          0001 1101 1001 LLLL      Codec 0x1D9L
[TAG d'extension Length]
Message           1 Value UTF8-LANGUAGE-TEXT
```

- Codec : Meta `0x1D9L`, classe lignée
- Payload : Value intégrée ([UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md))
- Nombre : au plus un par langue

## Interprétation et validité {#해석과-유효성}

- Le message et la langue tiennent dans un seul UTF8-LANGUAGE-TEXT. Il n'y a qu'un MESSAGE par langue.
- Le document de spécification de geul.org s'écrit avec les [CODEC](../edge/0x0BEL-codec.md) `0780` et `0790`.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001D90/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D9000000000
BODY
#1 DECLARE 0x1D90
#2 FIELD #1 record
#3 BIND #1 "MESSAGE"
#4 BIND #2 "message"
#5 CODEC #2 0x0780
#6 CODEC #2 0x0790
```
