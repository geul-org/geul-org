---
title: "QUALIFIER (0x0ABL)"
weight: 171
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER est un Edge d'énoncé qui attache une condition qualifiant la proposition contenue dans un autre Edge (le plus souvent un TRIPLE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `QUALIFIER` (BIND du document de spécification `QUALIFIER`) |
| TAG ID | `0x0ABL` |
| Codec ID | `0x00000AB0` |
| Document de spécification | `0x00000000/codecs/0x00000AB0/` (cible de DECLARE `0AB0`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 11 |
| Kind | Edge · famille : énoncé, groupe : proposition |
| TAG WORD | `0000 1010 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Une condition qui qualifie la proposition d'un autre Edge. Property, Target (Edge Id), Value (valeur ou marqueur UNKNOWN-VALUE·NO-VALUE). Fait partie de la proposition |
| Côté Hugo | `edge/qualifier.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `property` | #2 | enregistrement | tout enregistrement (marqueurs d'emplacement exclus) |  |
| 2 | `target` | #3 | enregistrement | `0050` LOCAL |  |
| 3 | `value` | #4 | enregistrement | `000F` section 0 entière (joker, Reference), `020F` section 1 entière (joker, Reference), `040F` section 2 entière (joker, Reference), `060F` section 3 entière (joker, Value), `080F` section 4 entière (joker, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |

QUALIFIER est un Edge d'énoncé qui attache une condition qualifiant la proposition contenue dans un autre Edge (le plus souvent un [TRIPLE](0x0AAL-triple.md)). Codec `0x0ABL`.

Il équivaut à un qualifier (snak) de Wikidata : une propriété et une valeur.

## Disposition {#레이아웃}

```
TAG WORD          0000 1010 1011 LLLL
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Property          enregistrement Reference (WIKIDATA-PID, etc.)
Target            enregistrement Reference LOCAL (Edge Id de l'Edge qualifié)
Value             enregistrement Reference ou Value, ou marqueur d'emplacement 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
```

- L'ordre des composants est le même que pour TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). Le décodeur lit par le même chemin. Les rôles sont fixés par le Codec.

## Interprétation et validité {#해석과-유효성}

- Property et Target sont chacun exactement un enregistrement Reference complet, et Target est une Reference LOCAL. Le document de spécification de geul.org place pour Target le [CODEC](0x0BEL-codec.md) LOCAL (`0050`). Value est exactement un enregistrement Reference ou Value complet, ou 1 WORD du [marqueur d'emplacement](../slot-marker.md) `0x0010` (UNKNOWN-VALUE) ou `0x0020` (NO-VALUE). Le document de spécification place pour Value les CODEC `000F`, `020F`, `040F` (toute Reference), `060F`, `080F` (toute Value), `0010`, `0020`. ABSENT (`0x0000`) n'est pas accepté. Property et Target n'acceptent pas de marqueur d'emplacement. Le curseur, une fois Value lu, doit coïncider avec la fin de l'Edge.
- Target est un Edge Id du même document. QUALIFIER se place dans le même document que l'Edge qu'il qualifie.
- Si Target est le [SOURCE](0x0C0L-source.md#문서-전체의-출처) de HEAD (l'origine de l'ensemble du document), le QUALIFIER se place aussi dans HEAD, après ce SOURCE. Les autres QUALIFIER se placent dans BODY. Un QUALIFIER ayant pour Target le SOURCE de HEAD et situé dans BODY est invalid.
- Target peut être un autre Edge qu'un TRIPLE. Un QUALIFIER attaché à [SOURCE](0x0C0L-source.md) qualifie l'acte de citation (date de consultation, position dans l'origine, etc.). Le sens de SOURCE est lui aussi l'ensemble de tous les QUALIFIER qui le désignent.
- **QUALIFIER fait partie de la proposition.** Ce n'est pas une affirmation distincte à propos de la proposition : il qualifie la condition dans laquelle la proposition est vraie. Le sens du TRIPLE visé est l'ensemble de tous les QUALIFIER qui le désignent.
  - La source d'une proposition s'écrit en [SOURCE](0x0C0L-source.md). Les propriétés du nœud d'origine (titre, auteur, etc.) s'écrivent en TRIPLE ayant l'origine pour Subject.
- Plusieurs QUALIFIER de même Property peuvent viser le même Target. L'ordre des QUALIFIER de même Target est celui du document (exception où l'ordre des Edge a un sens).

## Inconnu et absent {#알-수-없음과-없음}

Si Value d'un QUALIFIER est un marqueur d'emplacement, le sens de la qualification change. Prenons l'instant de fin (P582).

| Attaché au TRIPLE visé | Sens | La proposition est-elle encore valide ? |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | a pris fin en 1974 | non |
| `QUALIFIER P582 #n UNKNOWN` | a pris fin. On ignore quand (`somevalue` de Wikidata) | non |
| `QUALIFIER P582 #n NONE` | asserte qu'elle n'a pas pris fin (`novalue` de Wikidata) | oui |
| pas de QUALIFIER P582 | on ignore si elle a pris fin (monde ouvert) | inconnu |

- Si l'on écarte `somevalue` et `novalue` d'un qualifier Wikidata, la proposition s'élargit. Un TRIPLE de frontière dont on a écarté le somevalue de l'instant de fin se lit comme une « frontière encore valide aujourd'hui ». On les convertit donc en marqueurs.
- Deux UNKNOWN-VALUE ne sont pas considérés comme la même valeur. Le résultat de comparaison est indéterminé.

## Exemple (non normatif) {#예시-비규범}

Q42 P69 (educated at) Q691283 (St John's College), de 1971 à 1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10` : TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Value est l'[EDTF](../value/0x06EL-edtf.md) `"1971"`.

```
0AB9 0051 000A 0191 0244 0051 0009 06E2 3139 3731
```

Frontière (P47) entre Q30 (États-Unis) et Q34266 (Empire russe), instant de fin inconnu. Edge Id `2060`·`3160`.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `0AB7` = `000 0101 01011 0111` (section 5) : Edge, Codec `0x0ABL`, 8 WORD. TAG 1 + Edge Id 2 + Property P582 (`0191 0246`) 2 + Target #2060 (`0051 080C`) 2 + marqueur 1.

On attache une période au TRIPLE NO-VALUE `#3161` de la banque centrale (P1304) de Q30. Elle n'a manqué que de 1811 à 1816.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Pages liées {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [SOURCE](0x0C0L-source.md), [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [EDTF](../value/0x06EL-edtf.md), [marqueur d'emplacement](../slot-marker.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000AB0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AB000000000
BODY
#1 DECLARE 0x0AB0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 BIND #1 "QUALIFIER"
#6 BIND #2 "property"
#7 BIND #3 "target"
#8 BIND #4 "value"
#9 CODEC #3 0x0050
#10 CODEC #4 0x000F
#14 CODEC #4 0x020F
#15 CODEC #4 0x040F
#11 CODEC #4 0x060F
#16 CODEC #4 0x080F
#12 CODEC #4 0x0010
#13 CODEC #4 0x0020
```
