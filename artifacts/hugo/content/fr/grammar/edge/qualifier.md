---
title: "QUALIFIER"
weight: 12
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER est un Edge de description (Codec 0x0B) qui joint une condition restreignant la proposition d'un autre Edge (le plus souvent un TRIPLE). Sa Value peut être, à la place d'une valeur, inconnue (UNKNOWN-VALUE) ou sans valeur (NO-VALUE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUALIFIER est un Edge de description qui joint une condition restreignant la proposition qu'un autre Edge (le plus souvent un [TRIPLE](/fr/grammar/edge/triple/)) contient. Codec `0x0B`.

Il équivaut à un qualifier (snak) de Wikidata : une propriété et une valeur.

## Disposition

```
TAG WORD          0001 0LLL L000 1011
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Property          enregistrement Reference (WIKIDATA-PID, etc.)
Target            enregistrement Reference LOCAL (Edge Id de l'Edge restreint)
Value             enregistrement Reference ou Value, ou marqueur d'emplacement 0x0001 UNKNOWN-VALUE, 0x0002 NO-VALUE
```

- L'ordre des composants est le même que pour TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). Le décodeur lit par le même chemin. Le rôle est fixé par le Codec.

## Interprétation et validité

- Property et Target sont chacun exactement un enregistrement Reference complet, et Target est une Reference LOCAL. Le document de spécification de geul.org place sur Target le [CODEC](/fr/grammar/edge/codec/) LOCAL (`0008`). Value est exactement un enregistrement Reference ou Value complet, ou 1 WORD de [marqueur d'emplacement](/fr/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE) ou `0x0002` (NO-VALUE). Le document de spécification place sur Value les CODEC `0780`, `0F80`, `0001`, `0002`. ABSENT (`0x0000`) n'est pas admis. Property et Target n'acceptent pas de marqueur d'emplacement. Le curseur après lecture de Value doit coïncider avec la fin de l'Edge.
- Target est l'Edge Id d'un Edge du même document. Un QUALIFIER se place dans le même document que l'Edge qu'il restreint.
- Si Target est le [SOURCE](/fr/grammar/edge/source/#origine-du-document-entier) du HEAD (origine du document entier), le QUALIFIER se place aussi dans le HEAD, après ce SOURCE. Les autres QUALIFIER vont dans le BODY. Un QUALIFIER ayant pour Target un SOURCE du HEAD est invalid dans le BODY.
- Target peut être un autre Edge qu'un TRIPLE. Un QUALIFIER joint à un [SOURCE](/fr/grammar/edge/source/) restreint l'acte de citation (date de consultation, emplacement dans l'origine, etc.). Le sens d'un SOURCE est lui aussi l'ensemble de tous les QUALIFIER qui le désignent.
- **Un QUALIFIER fait partie de la proposition.** Ce n'est pas une affirmation séparée sur la proposition, mais une restriction des conditions où elle est vraie. Le sens du TRIPLE cible est l'ensemble de tous les QUALIFIER qui le désignent.
  - La provenance d'une proposition s'écrit par [SOURCE](/fr/grammar/edge/source/). Les propriétés d'un nœud d'origine (titre, auteur, etc.) s'écrivent par un TRIPLE dont l'origine est le Subject.
- Un même Target peut avoir plusieurs QUALIFIER de la même Property. L'ordre des QUALIFIER d'un même Target est leur ordre dans le document (exception où l'ordre des Edge a un sens).

## Inconnu et aucune valeur

Si la Value d'un QUALIFIER est un marqueur d'emplacement, le sens de cette restriction change. Prenons la date de fin (P582).

| Joint au TRIPLE cible | Sens | La proposition est-elle encore valide |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | Terminé en 1974 | Non |
| `QUALIFIER P582 #n UNKNOWN` | Terminé. On ignore quand (`somevalue` de Wikidata) | Non |
| `QUALIFIER P582 #n NONE` | Affirme que ce n'est pas terminé (`novalue` de Wikidata) | Oui |
| Pas de QUALIFIER P582 | On ne sait pas si c'est terminé (monde ouvert) | On ne sait pas |

- Écarter les `somevalue` et `novalue` d'un qualifier de Wikidata élargit la proposition. Un TRIPLE de frontière dont on a écarté le somevalue de la date de fin se lit comme « frontière encore valide ». On les transcrit donc par des marqueurs.
- Deux UNKNOWN-VALUE ne sont pas considérés comme la même valeur. Le résultat de la comparaison est indéterminé.

## Exemple (non normatif)

Q42 P69 (educated at) Q691283 (St John's College), 1971 à 1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10` : TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Value est [EDTF](/fr/grammar/value/time/edtf/) `"1971"`.

```
148B 0088 000A 00A8 0244 0088 0009 0924 3139 3731
```

Frontière (P47) Q30 (États-Unis)–Q34266 (Empire russe), date de fin inconnue. Edge Id `2060` et `3160`.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `138B` = `000 10 0111 0001011` : Edge, 8 WORD, Codec `0x0B`. TAG 1 + Edge Id 2 + Property P582 (`00A8 0246`) 2 + Target #2060 (`0088 080C`) 2 + marqueur 1.

On joint une période au TRIPLE NO-VALUE `#3161` de banque centrale (P1304) de Q30. Il n'y en avait pas seulement de 1811 à 1816.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Pages liées

- [Edge](/fr/grammar/edge/), [TRIPLE](/fr/grammar/edge/triple/), [SOURCE](/fr/grammar/edge/source/), [WIKIDATA-PID](/fr/grammar/reference/wikidata-pid/), [EDTF](/fr/grammar/value/time/edtf/), [Marqueur d'emplacement](/fr/grammar/reference/slot-marker/)
