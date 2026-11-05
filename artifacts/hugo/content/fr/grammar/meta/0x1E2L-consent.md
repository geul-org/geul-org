---
title: "CONSENT (0x1E2L)"
weight: 482
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Indique l'étendue du consentement et son fondement."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `CONSENT` (BIND `CONSENT` du document de spécification) |
| TAG ID | `0x1E2L` |
| Codec ID | `0x00001E20` |
| Document de spécification | `0x00000000/codecs/0x00001E20/` (cible du DECLARE `1E20`) |
| Section | 15 `1111` (Meta), décalage C dans la section = 2 |
| Kind | Meta · classe : politique |
| TAG WORD | `0001 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Étendue du consentement et fondement |
| Côté Hugo | `meta/policy/consent.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `consent` | #2 | enregistrement | `000F` toute la section 0 (joker, Reference), `020F` toute la section 1 (joker, Reference), `040F` toute la section 2 (joker, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

Indique l'étendue du consentement et son fondement.

## Disposition {#레이아웃}

```
TAG WORD          0001 1110 0010 LLLL      Codec 0x1E2L
[TAG d'extension Length]
Payload           Reference désignant le fondement du consentement, ou texte
```

- Codec : Meta `0x1E2L`, classe politique
- Payload : Reference ou Value intégrée
- Nombre : plusieurs possibles

## Problèmes ouverts {#열린-문제}

- Structure de l'expression de l'étendue (finalité, durée, communication à des tiers).

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001E20/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E2000000000
BODY
#1 DECLARE 0x1E20
#2 FIELD #1 record
#3 BIND #1 "CONSENT"
#4 BIND #2 "consent"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
