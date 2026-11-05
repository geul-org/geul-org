---
title: "DEFAULT-LANGUAGE (0x1CAL)"
weight: 458
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Déclare la langue par défaut des textes du document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `DEFAULT-LANGUAGE` (BIND `DEFAULT-LANGUAGE` du document de spécification) |
| TAG ID | `0x1CAL` |
| Codec ID | `0x00001CA0` |
| Document de spécification | `0x00000000/codecs/0x00001CA0/` (cible du DECLARE `1CA0`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 10 |
| Kind | Meta · classe : définition |
| TAG WORD | `0001 1100 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Langue par défaut |
| Côté Hugo | `meta/declaration/default-language.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | enregistrement | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |

Déclare la langue par défaut des textes du document. Un texte dont la langue n'est pas indiquée séparément est dans cette langue.

## Disposition {#레이아웃}

```
TAG WORD          0001 1100 1010 LLLL      Codec 0x1CAL
[TAG d'extension Length]
Payload           Une Value de langue
```

- Codec : Meta `0x1CAL`, classe définition
- Payload : Value intégrée ([LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md) ou [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md))
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- Un document TANGEUL indique la locale de rédaction (par exemple `en`, `ko`).

## Exemple {#예시}

- `en` : `0x1CA2 0x0761 0x656E`

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001CA0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CA000000000
BODY
#1 DECLARE 0x1CA0
#2 FIELD #1 record
#3 BIND #1 "DEFAULT-LANGUAGE"
#4 BIND #2 "language"
#5 CODEC #2 0x07A0
#6 CODEC #2 0x0760
#7 CODEC #2 0x0770
```
