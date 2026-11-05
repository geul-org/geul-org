---
title: "Marqueur d'emplacement"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "Un marqueur d'emplacement (slot marker) est un enregistrement de 1 WORD qui occupe l'emplacement d'un champ enregistrement."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Un marqueur d'emplacement (slot marker) est un enregistrement de 1 WORD qui occupe l'emplacement d'un champ enregistrement. Il ne désigne rien. Ce sont les codes attribués aux trois premières cases `0x000L~0x002L` de la section 0 de Reference. Chaque marqueur a sa page : [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md).

À l'emplacement d'une valeur, trois énoncés sont possibles : la valeur n'a pas été renseignée, la valeur existe mais on ignore laquelle, il n'y a pas de valeur. Ces trois énoncés sont différents. Les marqueurs d'emplacement les répartissent sur trois WORD voisins.

## Disposition {#레이아웃}

```
TAG WORD          0000 0000 00CC 0000
                  Prefix 000, section 0 (Reference), Codec 0~2, LLLL 0000 (1 WORD)
```

| WORD | Nom | Sens | Notation |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | non renseigné | `ABSENT` |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | inconnu : une valeur existe. On ignore laquelle | `UNKNOWN` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | aucune valeur : il n'y a pas de valeur | `NONE` |
| Codec 0~2, LLLL ≥ `0001` | Reserved | cette forme de TAG (marqueur avec Payload) n'est pas attribuée | |

- Les marqueurs **n'ont pas de Quantifier.** La quantification ne se lit que dans le système 5Q (`5 <= C < 30` de la section 0, `C < 30` de la section 1). On n'interprète pas `0x0010` UNKNOWN-VALUE comme Generic en lisant `C % 5` (Quantifier de [Reference](reference/_index.md)).
- Il n'y a pas de Payload. Il n'y a pas non plus d'ID de cible.
- Même un décodeur sans livre de codes sait, au seul TAG WORD, qu'il s'agit d'un Kind Reference de 1 WORD et le saute. « Si la valeur du WORD est `0x0000`, `0x0010` ou `0x0020`, c'est un marqueur d'emplacement » se détermine par `w & 0xF == 0 && w <= 0x0020`.
- Les notations `ABSENT`, `UNKNOWN` et `NONE` sont les notations textuelles de `geul show` et `geul add`.

## Trois distinctions {#세-가지-구분}

| | Non renseigné (ABSENT) | Inconnu (UNKNOWN-VALUE) | Aucune valeur (NO-VALUE) |
|---|---|---|---|
| De quoi parle-t-il | Du **document** : cet emplacement n'a pas été rempli | Du **monde** : une valeur existe. On ignore laquelle | Du **monde** : il n'y a pas de valeur |
| Logique | N'affirme rien | `∃x. P(s, x)`, x n'est pas identifié | `¬∃x. P(s, x)` |
| Hypothèse sur le monde | Monde ouvert (aucune information) | Existence fermée, identité ouverte | Monde fermé pour (s, P, condition de restriction) |
| Wikidata | Le snak correspondant est absent | `somevalue` | `novalue` |
| Où l'utiliser | Champ facultatif ayant la cible CODEC `0000` (Origin de SOURCE, etc.) | Champ ayant la cible CODEC `0010` (Object de TRIPLE, Value de QUALIFIER, Origin de SOURCE) | Champ ayant la cible CODEC `0020` (Object de TRIPLE, Value de QUALIFIER) |
| « Combien d'enfants (P40) ? » | On ne sait pas | 1 ou plus | 0 |
| « Y a-t-il une date de fin (P582) ? » | On ne sait pas → on ne sait pas si c'est encore valide | C'est terminé. On ignore quand | Ce n'est pas terminé (assertion) |

La même distinction se pose au niveau de la proposition. **L'absence d'un TRIPLE dans le document** est un « non renseigné ». Un document GEUL étant un monde ouvert, l'absence d'énoncé ne signifie pas l'absence du fait. On ne peut dire « il n'y en a pas » qu'en l'**écrivant** par NO-VALUE.

## Règle d'acceptation {#수용-규칙}

- Un marqueur d'emplacement n'est valide **que si la liste des [CODEC](edge/0x0BEL-codec.md) du champ contient le même WORD comme cible exacte.** La cible `0000` signifie « champ facultatif », `0010` « accepte inconnu », `0020` « accepte aucune valeur ».
- Les jokers (`000F`, `060F`, etc., `L=1111`) n'acceptent pas de marqueur. N'importe quel Reference (`000F`·`020F`·`040F`) ne recouvre pas non plus les marqueurs.
- Un champ enregistrement sans CODEC (« n'importe quel enregistrement ») n'accepte pas non plus de marqueur.
- Un marqueur aux emplacements d'enregistrement du HEAD et du BODY ou à l'emplacement de l'Edge Id est invalid.
- Un champ en valeur brute ne peut pas recevoir de marqueur. Une valeur brute n'a pas de TAG, donc pas de place pour un marqueur de 1 WORD.
- Une liste de CODEC ne contenant que des cibles de marqueurs (toujours un marqueur) est invalid.
- Le sens du marqueur (ce qui existe et ce qui n'existe pas) est fixé par la spécification de l'Edge qui l'accepte. C'est le même principe que celui selon lequel la quantification et la négation sont fixées par l'Edge et non par Reference.
- Le sens des marqueurs et la règle d'acceptation relèvent de la [couche 0](publishing.md#층) (intégrée au décodeur). Les trois n'ayant pas de Payload, l'intégration ne coûte rien. On place néanmoins un document de Codec par code. Le document de Codec ne contient que DECLARE et pas de FIELD.

## Obligation du lecteur {#읽는-쪽의-의무}

Chaque marqueur la décrit sur sa page. L'essentiel est le suivant.

- [UNKNOWN-VALUE](reference/0x001L-unknown-value.md#읽는-쪽의-의무) n'est pas une valeur mais une assertion d'existence. Il n'est égal à aucune valeur ni différent d'aucune valeur, et l'on ne fusionne pas de doublons pour ce TRIPLE.
- [NO-VALUE](reference/0x002L-no-value.md#읽는-쪽의-의무) est fermé dans la condition de restriction de cette proposition.
- Pour les deux marqueurs, rank s'applique de la même façon, et s'ils servent de valeur de QUALIFIER, ils changent le sens de cette restriction.
- [ABSENT](reference/0x000L-absent.md#읽는-쪽의-의무) ne dit rien sur le monde. On n'emploie pas UNKNOWN-VALUE pour une valeur qu'on n'a pas pu transcrire.

## Différence avec les autres « aucune valeur » {#다른-없음과의-차이}

- La règle de Codec qui utilise [LOCAL](reference/0x005L-local.md) `0` comme « aucun » ([TOULMIN](toulmin/_index.md) REF, etc.) est une convention interne à ce Codec. Elle diffère du marqueur d'emplacement.
- On n'utilise pas un LOCAL Identified comme null ou sentinelle. Pour noter l'inconnu ou l'absence, on écrit un marqueur dans un champ qui accepte les marqueurs.

## Exemple {#예시}

Frontière entre Q30 (États-Unis) et Q34266 (Empire russe), date de fin inconnue. Les Edge Id sont donnés à titre explicatif.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Banque centrale de Q30, inexistante de 1811 à 1816.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- L'emplacement du marqueur est de 1 WORD. TRIPLE fait 9 WORD (`0AA8`) et QUALIFIER 8 WORD (`0AB7`).
- Sous la forme la plus simple, « aucun enfant (P40) » est `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## Pages liées {#관련-페이지}

- [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md)
- [Reference](reference/_index.md), [CODEC](edge/0x0BEL-codec.md), [Document de spécification de Codec](codec-spec.md)
- [TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md), [TOULMIN](toulmin/_index.md)
