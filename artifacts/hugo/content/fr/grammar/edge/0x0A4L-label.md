---
title: "LABEL (0x0A4L)"
weight: 164
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL est un Edge d'énoncé qui relie à Subject, par Object, un nom (label) dans une langue donnée."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `LABEL` (BIND du document de spécification `LABEL`) |
| TAG ID | `0x0A4L` |
| Codec ID | `0x00000A40` |
| Document de spécification | `0x00000000/codecs/0x00000A40/` (cible de DECLARE `0A40`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 4 |
| Kind | Edge · famille : énoncé, groupe : désignation et nom |
| TAG WORD | `0000 1010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Liaison du nom (label) de Subject dans une langue. Object est UTF8-LANGUAGE-TEXT |
| Côté Hugo | `edge/label.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | enregistrement | tout enregistrement (marqueurs d'emplacement exclus) |  |
| 2 | `object` | #3 | enregistrement | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

LABEL est un Edge d'énoncé qui relie à Subject, par Object, un nom (label) dans une langue donnée. Codec `0x0A4L`. Ce n'est pas un Edge qui représente le lemma de la lexicographie générale.

Le nom et sa langue tiennent dans un seul Object, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). Il n'y a pas de champ de valeur brute.

## Disposition {#레이아웃}

```
TAG WORD          0000 1010 0100 LLLL
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference
Object            1 Value UTF8-LANGUAGE-TEXT ou 1 enregistrement Reference LOCAL
```

## Interprétation et validité {#해석과-유효성}

- Subject est exactement un enregistrement Reference complet. Ses limites se trouvent par sa propre Length ; s'il n'est pas une Reference ou est incomplet, il est invalid.
- Object est exactement un enregistrement [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) complet (`0x078L`·`0x079L`). Les règles de la langue et du texte (les deux formats de langue sont admis, comparaison de même langue) suivent ce format.
- Object peut aussi être une Reference LOCAL. Elle doit alors être résolue en UTF8-LANGUAGE-TEXT par la liaison [REFERENCE-NODE](0x0A0L-reference-node.md) du même document. Si elle n'est pas résolue ou se résout en un objet d'une autre sorte, c'est invalid.
- Le document de spécification de geul.org écrit cette restriction avec [CODEC](0x0BEL-codec.md) (Object = `0780`·`0790`·`0050`). L'objet de résolution d'un LOCAL n'est pas exprimé par CODEC.
- Si Object n'est pas l'un de ces deux formats ou si l'enregistrement est incomplet, c'est invalid. Un texte sans langue (UTF8-TEXT) ne peut pas être un LABEL. Un nom pour machine sans langue s'écrit en [BIND](0x0A3L-bind.md). Un nom commun à plusieurs langues s'écrit avec la langue `mul`.
- Il y a au plus un LABEL par Subject et par langue. Les autres noms s'écrivent en [ALIAS](0x0A5L-alias.md).

## Longueur {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

- L'enregistrement de langue de Object et le nombre d'octets du texte relèvent de l'enregistrement Object, non de l'Edge. Le curseur, une fois le dernier enregistrement lu, doit coïncider exactement avec la fin de l'Edge.

## Exemple (non normatif) {#예시-비규범}

Le code de langue `0784` de `en` est le numéro du GEUL Language Registry v2 (document de spécification `0x00000000/codecs/0x000007A0`, version 2).

### LANGUAGE-SHORT-CODE {#language-short-code}

Edge Id `0007`, Subject Q22686 (`0141 589E`), Object `Donald Trump` (en).

- Object est la langue `07A1 0784` (SHORT-CODE, 2 WORD) + un texte de 12 octets (pair, 6 WORD), donc `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), 9 WORD au total : `0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70`.
- L'Edge fait TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. Le TAG est `0A4D`.

```
0A4D 0051 0007 0141 589E 0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70
```

### LANGUAGE-BCP47-CODE {#language-bcp47-code}

Edge Id `0008`, Subject Q155 (`0141 009B`), Object `Brasil` (pt-BR).

- Object est la langue `0773 7074 2D42 5200` (BCP47 `pt-BR`, 4 WORD) + un texte de 6 octets (pair, 3 WORD), donc 8 WORD au total : `0787 0773 7074 2D42 5200 4272 6173 696C`.
- L'Edge fait TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, `LLLL=1100`. Le TAG est `0A4C`.

```
0A4C 0051 0008 0141 009B 0787 0773 7074 2D42 5200 4272 6173 696C
```

## Pages liées {#관련-페이지}

- [Edge](_index.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md), [BIND](0x0A3L-bind.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md)
- [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000A40/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A4000000000
BODY
#1 DECLARE 0x0A40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "LABEL"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
