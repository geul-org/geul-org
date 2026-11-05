---
title: "DESCRIPTION (0x0A6L)"
weight: 166
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION est un Edge d'énoncé qui relie à Subject, par Object, une description dans une langue donnée."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `DESCRIPTION` (BIND du document de spécification `DESCRIPTION`) |
| TAG ID | `0x0A6L` |
| Codec ID | `0x00000A60` |
| Document de spécification | `0x00000000/codecs/0x00000A60/` (cible de DECLARE `0A60`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 6 |
| Kind | Edge · famille : énoncé, groupe : désignation et nom |
| TAG WORD | `0000 1010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Liaison de la description de Subject dans une langue. Disposition identique à LABEL |
| Côté Hugo | `edge/description.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | enregistrement | tout enregistrement (marqueurs d'emplacement exclus) |  |
| 2 | `object` | #3 | enregistrement | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

DESCRIPTION est un Edge d'énoncé qui relie à Subject, par Object, une description dans une langue donnée. Codec `0x0A6L`.

La description est une courte formule qui distingue l'objet (description de Wikidata, par ex. « capitale et plus grande ville d'Allemagne »). Ce n'est ni une définition ni une affirmation sur l'objet. Une proposition sur l'objet s'écrit en [TRIPLE](0x0AAL-triple.md). La disposition est identique à [LABEL](0x0A4L-label.md). La description et sa langue tiennent dans un seul Object, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). Il n'y a pas de champ de valeur brute.

## Disposition {#레이아웃}

```
TAG WORD          0000 1010 0110 LLLL
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference
Object            1 Value UTF8-LANGUAGE-TEXT ou 1 enregistrement Reference LOCAL
```

## Interprétation et validité {#해석과-유효성}

- Les règles de Subject et d'Object sont celles de [LABEL](0x0A4L-label.md). Subject est exactement un enregistrement Reference complet. Object est exactement un enregistrement UTF8-LANGUAGE-TEXT (`0x078L`·`0x079L`) complet, ou une Reference LOCAL qui se résout en UTF8-LANGUAGE-TEXT par la liaison [REFERENCE-NODE](0x0A0L-reference-node.md) du même document.
- Un texte sans langue (UTF8-TEXT) ne peut pas être une DESCRIPTION. La description est unique par langue, et cette règle ne tient que s'il y a une langue. Une description commune à plusieurs langues s'écrit avec la langue `mul`.
- Il y a au plus une DESCRIPTION par Subject et par langue.
- La description sert à distinguer des objets de même nom. Il est préférable que, dans une même langue, le couple LABEL et DESCRIPTION ne se recoupe pas entre deux objets, mais la spécification ne le vérifie pas (Wikidata ne fait lui aussi que le recommander, sans l'imposer).
- Le document de spécification de geul.org restreint Object par [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, comme LABEL).

## Longueur {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

- L'enregistrement de langue de Object et le nombre d'octets du texte relèvent de l'enregistrement Object. Le curseur, une fois le dernier enregistrement lu, doit coïncider exactement avec la fin de l'Edge.
- Une description est plus longue qu'un label, et Object comme l'Edge dépassent facilement 15 WORD. On utilise alors l'extension de Length ([enregistrement](../record.md)).

## Exemple (non normatif) {#예시-비규범}

Edge Id `0009`, Subject Q64 (`0141 0040`), Object `capital and largest city of Germany` (en). La langue est un exemple au format LANGUAGE-BCP47-CODE (`en` a le numéro de registre `0x0784` et peut donc aussi s'écrire en SHORT-CODE).

- Object est la langue `0761 656E` (BCP47 `en`, 2 WORD) + un texte de 35 octets (impair, 18 WORD), donc `0x079L`, TAG 1 + TAG d'extension 1 + 20 = 22 WORD, `079E 0016 …`.
- L'Edge fait TAG 1 + TAG d'extension 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD, donc `LLLL=1110`, TAG `0A6E`, TAG d'extension `001C`.

```
0A6E 001C 0051 0009 0141 0040
079E 0016 0761 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Correspondance avec Wikidata {#위키데이터-대응}

- Les `descriptions` d'un élément (une par langue) → une DESCRIPTION par langue. Le code de langue est converti par la même table de correspondance des codes de langue que LABEL.

## Problèmes ouverts {#열린-문제}

- Existe-t-il des cas où admettre une description UTF8-TEXT sans langue (pour l'instant, non admise).

## Pages liées {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [CODEC](0x0BEL-codec.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000A60/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A6000000000
BODY
#1 DECLARE 0x0A60
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DESCRIPTION"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
