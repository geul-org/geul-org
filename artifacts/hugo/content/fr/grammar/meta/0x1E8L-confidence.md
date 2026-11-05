---
title: "CONFIDENCE (0x1E8L)"
weight: 488
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Indique le degré de confiance du document entier."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `CONFIDENCE` (BIND `CONFIDENCE` du document de spécification) |
| TAG ID | `0x1E8L` |
| Codec ID | `0x00001E80` |
| Document de spécification | `0x00000000/codecs/0x00001E80/` (cible du DECLARE `1E80`) |
| Section | 15 `1111` (Meta), décalage C dans la section = 8 |
| Kind | Meta · classe : vérification |
| TAG WORD | `0001 1110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Degré de confiance |
| Côté Hugo | `meta/verification/confidence.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `confidence` | #2 | enregistrement | `0690` UNSIGNED-DECIMAL |  |

Indique le degré de confiance du document entier. Le degré de confiance au niveau de l'enregistrement s'écrit avec un QUALIFIER joint à l'Edge cible (propriété non encore fixée, [SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).

## Disposition {#레이아웃}

```
TAG WORD          0001 1110 1000 LLLL      Codec 0x1E8L
[TAG d'extension Length]
Payload           Value UNSIGNED-DECIMAL, de 0 à 1 inclus
```

- Codec : Meta `0x1E8L`, classe vérification
- Payload : Value intégrée ([UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md))
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- On indique aussi qui a attribué la valeur, par [GENERATED-BY](0x1D3L-generated-by.md) ou autre.

## Problèmes ouverts {#열린-문제}

- Échelle (0 à 1) et relation avec le verdict de TOULMIN.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001E80/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E8000000000
BODY
#1 DECLARE 0x1E80
#2 FIELD #1 record
#5 CODEC #2 0x0690
#3 BIND #1 "CONFIDENCE"
#4 BIND #2 "confidence"
```
