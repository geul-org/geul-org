---
title: "CODEC (0x0BEL)"
weight: 190
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC est un Edge d'énoncé qui désigne un Kind et un Codec acceptés par un FIELD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `CODEC` (BIND du document de spécification `CODEC`) |
| TAG ID | `0x0BEL` |
| Codec ID | `0x00000BE0` |
| Document de spécification | `0x00000000/codecs/0x00000BE0/` (cible de DECLARE `0BE0`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 30 |
| Kind | Edge · famille : énoncé, groupe : divers |
| TAG WORD | `0000 1011 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Un Kind et un Codec acceptés par un champ. Champ, WORD cible (`000K KKKC CCCC LLLL`, LLLL 0000 exact · 1111 joker (les 32 cases de la section), un marqueur d'emplacement seulement comme cible exacte `0000`·`0010`·`0020`). Plusieurs pour un champ d'enregistrement (liste fermée), un seul pour un champ de valeur brute (la Value sans TAG) |
| Côté Hugo | `edge/codec.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | enregistrement | `0050` LOCAL |  |
| 2 | `target` | #4 | valeur brute 1 WORD |  |  |

CODEC est un Edge d'énoncé qui désigne un Kind et un Codec acceptés par un [FIELD](0x0BCL-field.md). Codec `0x0BEL`.

De même que [ENUM](0x0BDL-enum.md) attache un sens à une valeur de code d'un champ de valeur brute, CODEC attache un format au champ. Comme il y en a un par Edge, on peut en désigner plusieurs. La disposition est intégrée au décodeur ([document de spécification de Codec](../codec-spec.md)).

## Disposition {#레이아웃}

```
TAG WORD          0000 1011 1110 LLLL
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
champ             enregistrement Reference LOCAL désignant l'Edge FIELD
cible             1 WORD. 000K KKKC CCCC LLLL (LLLL = 0000 exact, 1111 joker)
```

## WORD cible {#대상-word}

- On conserve tel quel l'emplacement du Codec du TAG WORD (section `KKKK` et `CCCCC`). Les 3 bits de poids fort sont 0. `LLLL` vaut `0000` (exact) ou `1111` (joker) ; toute autre valeur est invalid.
- La valeur d'une cible exacte (`LLLL = 0000`) écrite sur 32 bits est le Codec ID de ce Codec (par ex. LOCAL `0x0050` → `0x00000050`, COORDINATE-EARTH `0x0640`, UTF8-LANGUAGE-TEXT `0x0780`). La cible désigne donc directement le document de spécification de ce Codec ([document de spécification de Codec](../codec-spec.md)).
- Une paire de codes pair/impair (texte, suite d'octets) se désigne aussi par des codes exacts. Pour accepter le pair et l'impair, on place les deux. Il n'y a pas de règle qui interprète la paire en bloc (il existe des codes adjacents qui ne sont pas une paire, comme NUMERIC `0x064L`/`0x065L`).

### Joker (`LLLL = 1111`) {#와일드카드-llll--1111}

- Avec `LLLL = 1111`, quelle que soit la valeur de `C`, on accepte toute la section `KKKK` (32 cases) du WORD cible. Dans une même section, `C` a le même sens quelle que soit sa valeur. On regarde seulement si la section de la cible est celle de l'enregistrement. On n'accepte pas au-delà de la section.
- Avec `LLLL = 1111`, on recommande la première case de la section (`C = 0`). C'est une recommandation, non une obligation. Un autre `C` de la même section est valid aussi.
- Si un Kind s'étend sur plusieurs sections, on énumère un CODEC par section.

| Cible | Sens |
|---|---|
| `000F`·`020F`·`040F` | toute Reference (sections 0~2, REFERENCE-ISSUER compris) |
| `060F`·`080F` | toute Value (sections 3·4, VALUE-ISSUER compris) |
| `0A0F`·`0C0F`·`0E0F`·`100F`·`120F`·`140F`·`160F`·`180F`·`1A0F` | tout Edge (sections 5~13, EDGE-ISSUER compris) |
| `1C0F`·`1E0F` | tout Meta (sections 14·15) |

- Les marqueurs d'emplacement de Reference (`0x000L~0x002L`) ne correspondent pas à `LLLL = 1111` (`000F` n'accepte pas ABSENT·UNKNOWN-VALUE·NO-VALUE). En revanche, pour une section dont la première case est attribuée, comme Value `0x060L` (BOOL) ou Edge `0x0A0L` (REFERENCE-NODE), `LLLL = 1111` l'inclut (pour n'accepter que BOOL, `0600` avec `LLLL = 0000`).
- Une cible avec `LLLL = 1111` ne désigne pas de document de spécification.
- L'indifférence à la quantification ou un groupe ne s'écrivent que par une énumération de CODEC (`LLLL = 0000`). Par ex. l'indifférence à la quantification de WIKIDATA-QID fait cinq cibles : `0140`, `0150`, `0160`, `0170`, `0180`.
- Les codes du système 5Q de Reference contiennent la quantification. La cible précise la quantification exacte. Pour accepter plusieurs Quantifier, on place plusieurs CODEC. La quantification de REFERENCE-ISSUER est fixée par le document de l'Issuer.

### Marqueur d'emplacement (cibles `0000`, `0010`, `0020`) {#자리-표지-대상-0000-0010-0020}

Les [marqueurs d'emplacement](../slot-marker.md) sont un groupe d'enregistrements de 1 WORD attribué aux trois premières cases `0x000L~0x002L` de la section 0 de Reference. Ils n'ont pas de quantification.

| Cible | Marqueur | Sens |
|---|---|---|
| `0000` | ABSENT | non écrit. Le champ est facultatif |
| `0010` | UNKNOWN-VALUE | inconnu. Accepte l'assertion qu'il y a une valeur |
| `0020` | NO-VALUE | absent. Accepte l'assertion qu'il n'y a pas de valeur |

- **Règle d'acceptation :** un marqueur n'est valid que si le même WORD figure comme cible exacte dans la liste CODEC de ce champ. Un joker et un champ d'enregistrement sans CODEC (« tout enregistrement ») n'acceptent pas de marqueur. Un marqueur à l'emplacement d'un enregistrement de HEAD ou de BODY, ou à celui d'un Edge Id, est invalid.
- Une liste qui ne contient que des cibles de marqueur (toujours un marqueur) est invalid (généralisation de la règle d'une liste ne contenant que `0000`). On l'utilise avec une cible `LLLL = 1111` ou une cible exacte (`000F`·`020F`·`040F` + `0000` = toute Reference ou omission).
- Un champ de valeur brute ne peut pas avoir de cible de marqueur. Une valeur brute n'a pas de TAG et sa largeur est fixée, il n'y a donc pas de place pour un marqueur de 1 WORD.
- Le sens d'un marqueur est fixé par la spécification du Codec qui l'accepte.

### Champ facultatif (cible `0000`) {#선택-필드-대상-0000}

- Si la liste CODEC d'un champ d'enregistrement contient la cible `0000`, ce champ est un **champ facultatif**. Pour l'omettre, on écrit à sa place 1 WORD `0x0000`. Cet enregistrement de 1 WORD est le marqueur d'emplacement ABSENT (non écrit).
- `0x0000` est une Reference, Codec `0x000L` (Reserved), `LLLL = 0000` (1 WORD au total). Il ne recoupe aucun autre enregistrement, et un décodeur qui ne connaît pas la spécification le saute comme un enregistrement de 1 WORD.
- Un champ facultatif occupe toujours sa place. Si on l'omet, on écrit toujours `0x0000` et l'on ne laisse pas la place vide (même pour un champ de queue). Ainsi un enregistrement n'a qu'une seule notation, et la décomposition est fixée par la seule position. La position et le nombre des champs facultatifs, et le recoupement de la liste avec celle d'autres champs, ne sont pas contraints.
- ABSENT n'est valid qu'à la place d'un champ facultatif. `0x0000` à l'emplacement d'un enregistrement de HEAD ou de BODY, d'un champ obligatoire ou d'un Edge Id est invalid.
- L'omission ne signifie pas « pas de valeur » mais « non écrit ». On n'asserte rien sur le monde. « Il n'y a pas de valeur » s'écrit en NO-VALUE (`0020`). Ce que signifie l'omission (par ex. sans cible du TAG, c'est cette version) est fixé par la spécification de chaque format.

## Interprétation et validité {#해석과-유효성}

- Le champ est un Edge FIELD du même document. On ne place pas deux fois la même cible pour un champ.
- **Champ d'enregistrement (largeur 0)** : sans CODEC, il accepte tout enregistrement sauf les marqueurs d'emplacement. S'il y en a un ou plus, c'est une liste fermée. L'enregistrement de ce champ doit avoir pour Kind et Codec (pour Reference, Quantifier compris) l'un de la liste, sinon cet enregistrement ne suit pas la spécification. Cela diffère d'un ENUM, qui est une liste ouverte.
- **Champ de valeur brute (largeur n ≥ 1, ou restante `0xFFFF`)** : CODEC ne comporte qu'une seule cible exacte (pas de joker). Sa valeur brute est le Payload de cette Value privée de son TAG. Le Kind et le Codec viennent de CODEC, la Length de la largeur de FIELD. Pour un code pair/impair, c'est le code désigné qui fixe la parité du nombre d'octets. Si la valeur brute ne suit pas les règles de cette Value (longueur comprise), cet enregistrement ne suit pas la spécification.
- Un marqueur d'emplacement ne se confronte qu'aux cibles exactes de la liste. Si `0x0000` apparaît à la place d'un champ facultatif (cible `0000`), c'est une omission. Les autres enregistrements se confrontent à la liste privée des cibles de marqueur.
- On peut placer ensemble CODEC et ENUM sur un champ de valeur brute. CODEC donne le format, ENUM le nom des valeurs de code (par ex. rank en UNSIGNED-INTEGER avec 0·1·2 en ENUM).
- On peut donner un nom à l'Edge Id d'un CODEC par BIND, mais ce n'est pas obligatoire.
- Un champ « Reference ou Value » s'écrit avec 5 CODEC (`000F`, `020F`, `040F`, `060F`, `080F`).

## Longueur {#길이}

```
total = 1 + N_len + N_id + N_field + 1 WORD   (6 WORD si l'Edge Id et le champ sont des ID de 1 WORD LOCAL)
```

## Exemple {#예시}

Dans le document de spécification de LABEL `0x00000000/codecs/0x00000A40/`, le champ Object (FIELD #3) accepte UTF8-LANGUAGE-TEXT (pair·impair) et LOCAL. Edge Id 7~9.

```
0BE5 0051 0007 0051 0003 0780
0BE5 0051 0008 0051 0003 0790
0BE5 0051 0009 0051 0003 0050
```

- TAG `0BE5` (Edge, Codec `0x0BEL`, `LLLL = 0101`, 6 WORD), Edge Id `0051 0007`, champ `0051 0003`, cible `0780`.

## Pages liées {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [DECLARE](0x0BBL-declare.md), [BIND](0x0A3L-bind.md)
- [document de spécification de Codec](../codec-spec.md), [LABEL](0x0A4L-label.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000BE0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BE000000000
BODY
#1 DECLARE 0x0BE0
#2 FIELD #1 record
#3 CODEC #2 0x0050
#4 FIELD #1 0x0001
#5 BIND #1 "CODEC"
#6 BIND #2 "field"
#7 BIND #4 "target"
```
