---
title: "LICENSE (0x1DEL)"
weight: 478
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Indique la licence de ce document et des œuvres contenues dans la suite d'octets."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `LICENSE` (BIND `LICENSE` du document de spécification) |
| TAG ID | `0x1DEL` |
| Codec ID | `0x00001DE0` |
| Document de spécification | `0x00000000/codecs/0x00001DE0/` (cible du DECLARE `1DE0`) |
| Section | 14 `1110` (Meta), décalage C dans la section = 30 |
| Kind | Meta · classe : politique |
| TAG WORD | `0001 1101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Licence. Reference |
| Côté Hugo | `meta/policy/license.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `license` | #2 | enregistrement | `000F` toute la section 0 (joker, Reference), `020F` toute la section 1 (joker, Reference), `040F` toute la section 2 (joker, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0740` URI-EVEN, `0750` URI-ODD |  |

Indique la licence de ce document et des œuvres contenues dans la suite d'octets.

## Disposition {#레이아웃}

```
TAG WORD          0001 1101 1110 LLLL      Codec 0x1DEL
[TAG d'extension Length]
Payload           Reference désignant la licence, ou UTF8-TEXT d'identifiant SPDX, ou Value URI
```

- Codec : Meta `0x1DEL`, classe politique
- Payload : Reference ou Value intégrée ([UTF8-TEXT](../value/0x072L-utf8-text.md), [URI](../value/0x074L-uri.md))
- Nombre : au plus un

## Interprétation et validité {#해석과-유효성}

- Les documents publiés sur geul.org sont sous CC0. Pour une publication privée, c'est l'Issuer qui décide ([Issuer](../issuer.md)).
- On consigne la licence d'origine de l'œuvre source.

## Problèmes ouverts {#열린-문제}

- Placer l'identifiant SPDX en texte ou en Reference d'entité GEUL.

## Texte du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00001DE0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DE000000000
BODY
#1 DECLARE 0x1DE0
#2 FIELD #1 record
#3 BIND #1 "LICENSE"
#4 BIND #2 "license"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0740
#9 CODEC #2 0x0750
```
