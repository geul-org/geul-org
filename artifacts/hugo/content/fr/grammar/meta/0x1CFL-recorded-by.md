---
title: "RECORDED-BY (0x1CFL)"
weight: 463
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Indique l'entité qui a consigné le document (git committer)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `RECORDED-BY` (BIND `RECORDED-BY` du document de spécification) |
| TAG ID | `0x1CFL` |
| Codec ID | `0x00001CF0` |
| Document de spécification | `0x00000000/codecs/0x00001CF0/` (cible du DECLARE `1CF0`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 15 |
| Kind | Meta · classe : provenance |
| TAG WORD | `0001 1100 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Entité qui a consigné. Reference (git committer) |
| Côté Hugo | `meta/provenance/recorded-by.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | enregistrement | N'importe quel enregistrement (hors marqueur d'emplacement) |  |

Indique l'entité qui a consigné le document (git committer).

## Disposition {#레이아웃}

```
TAG WORD          0001 1100 1111 LLLL      Codec 0x1CFL
[TAG d'extension Length]
Payload           Un enregistrement Reference (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL, etc.)
```

- Codec : Meta `0x1CFL`, classe provenance
- Payload : Reference intégrée
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- La Reference ne se limite à aucun Codec. Il peut s'agir d'une personne, d'une organisation, d'un modèle ou d'un moteur de règles ([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [GEUL](../reference/0x00AL-geul.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [LOCAL](../reference/0x005L-local.md), etc.).
- Dans les documents publiés sur geul.org, on ne place pas de Reference désignant une personne physique ([Issuer et publication](../issuer.md#geulorg-공표)). On désigne une organisation ou un Issuer. À titre d'exception, désigner une personne physique par [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) est admis.
- Si c'est un LOCAL, on décrit cet objet dans le BODY.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001CF0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CF000000000
BODY
#1 DECLARE 0x1CF0
#2 FIELD #1 record
#3 BIND #1 "RECORDED-BY"
#4 BIND #2 "actor"
```
