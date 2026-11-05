---
title: "GENERATED-BY (0x1D3L)"
weight: 467
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Indique l'entité qui a produit le document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `GENERATED-BY` (BIND `GENERATED-BY` du document de spécification) |
| TAG ID | `0x1D3L` |
| Codec ID | `0x00001D30` |
| Document de spécification | `0x00000000/codecs/0x00001D30/` (cible du DECLARE `1D30`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 19 |
| Kind | Meta · classe : lignée |
| TAG WORD | `0001 1101 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Entité génératrice. Personne, modèle, moteur de règles |
| Côté Hugo | `meta/lineage/generated-by.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `agent` | #2 | enregistrement | N'importe quel enregistrement (hors marqueur d'emplacement) |  |
| 2 | `version` | #5 | enregistrement | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0000` ABSENT (champ facultatif) |  |

Indique l'entité qui a produit le document. Il peut s'agir d'une personne, d'un modèle ou d'un moteur de règles.

## Disposition {#레이아웃}

```
TAG WORD          0001 1101 0011 LLLL      Codec 0x1D3L
[TAG d'extension Length]
Entité génératrice  Reference (personne, modèle, moteur de règles)
Version             Value UTF8-TEXT, ou marqueur d'omission 0x0000 (champ facultatif)
```

- Codec : Meta `0x1D3L`, classe lignée
- Payload : Reference intégrée + texte de version (facultatif)
- Nombre : plusieurs possibles

## Interprétation et validité {#해석과-유효성}

- S'il s'agit d'un modèle, on indique aussi la version du modèle.
- Si la version est inconnue ou non indiquée, on omet cet emplacement et l'on met ABSENT (`0x0000`) (champ facultatif de [CODEC](../edge/0x0BEL-codec.md)). La spécification `0x1D30` de geul.org est faite de deux champs d'enregistrement : agent (sans CODEC) et version (`0720`, `0730`, `0000`).
- Pour la version source (commit) d'un programme, le format de [TRANSFORMED-BY](0x1D4L-transformed-by.md) (condensat, obligatoire) est plus exact. La version de GENERATED-BY sert à écrire en texte ce qui n'est pas un ID de commit, comme le nom et la version d'un modèle.
- Dans les documents publiés sur geul.org, on ne place pas de Reference désignant une personne physique ([Issuer et publication](../issuer.md#geulorg-공표)). On désigne une organisation ou un Issuer. À titre d'exception, désigner une personne physique par [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) est admis.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001D30/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D3000000000
BODY
#1 DECLARE 0x1D30
#2 FIELD #1 record
#3 BIND #1 "GENERATED-BY"
#4 BIND #2 "agent"
#5 FIELD #1 record
#6 BIND #5 "version"
#7 CODEC #5 0x0720
#8 CODEC #5 0x0730
#9 CODEC #5 0x0000
```
