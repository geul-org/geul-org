---
title: "SIGNED-OFF (0x1E7L)"
weight: 487
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Confirmation du droit de contribuer (git Signed-off-by, DCO)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `SIGNED-OFF` (BIND `SIGNED-OFF` du document de spécification) |
| TAG ID | `0x1E7L` |
| Codec ID | `0x00001E70` |
| Document de spécification | `0x00000000/codecs/0x00001E70/` (cible du DECLARE `1E70`) |
| Section | 15 `1111` (Meta), décalage C dans la section = 7 |
| Kind | Meta · classe : vérification |
| TAG WORD | `0001 1110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Confirmation du droit de contribuer. Reference (git `Signed-off-by`, DCO) |
| Côté Hugo | `meta/verification/signed-off.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `signer` | #2 | enregistrement | N'importe quel enregistrement (hors marqueur d'emplacement) |  |

Confirmation du droit de contribuer (git `Signed-off-by`, DCO).

## Disposition {#레이아웃}

```
TAG WORD          0001 1110 0111 LLLL      Codec 0x1E7L
[TAG d'extension Length]
Payload           Une Reference
```

- Codec : Meta `0x1E7L`, classe vérification
- Payload : Reference intégrée
- Nombre : plusieurs possibles

## Interprétation et validité {#해석과-유효성}

- Dans les documents publiés sur geul.org, on ne place pas de Reference désignant une personne physique ([Issuer et publication](../issuer.md#geulorg-공표)). On désigne une organisation ou un Issuer. À titre d'exception, désigner une personne physique par [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) est admis.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001E70/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E7000000000
BODY
#1 DECLARE 0x1E70
#2 FIELD #1 record
#3 BIND #1 "SIGNED-OFF"
#4 BIND #2 "signer"
```
