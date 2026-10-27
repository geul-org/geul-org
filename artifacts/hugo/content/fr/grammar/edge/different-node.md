---
title: "DIFFERENT-NODE"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE est un Edge de description de non-identité (Codec 0x02) : deux Reference désignent des cibles différentes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DIFFERENT-NODE est un Edge de description de non-identité : deux Reference désignent des referents différents. Codec `0x02`.

Cela ne signifie pas que l'encodage en octets, le Codec ou l'ID des deux enregistrements Reference diffèrent. Il se distingue de la liaison orientée de [REFERENCE-NODE](/fr/grammar/edge/reference-node/) et de l'identité de [SAME-NODE](/fr/grammar/edge/same-node/).

## Disposition

```
TAG WORD          0001 0LLL L000 0010
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference
Object            1 enregistrement Reference
```

## Interprétation et validité

- Subject et Object doivent chacun être exactement un enregistrement [Reference](/fr/grammar/reference/) complet. On trouve les limites par la Length de chaque enregistrement ; si c'est une Value ou un Edge, ou s'il est incomplet, invalid.
- Subject et Object désignent des referents différents. On ne déduit pas que les referents diffèrent de la seule différence de suite d'octets, de Codec ou d'ID des enregistrements Reference.
- En particulier, deux ID [LOCAL](/fr/grammar/reference/local/) différents sont seulement des Reference différentes, et cela ne signifie pas que les referents réels diffèrent. On ne tire pas DIFFERENT de la seule différence d'ID LOCAL.
- La non-identité est symétrique, irréflexive et non transitive. `DIFFERENT(A, B)` est la même relation que `DIFFERENT(B, A)`. En revanche, on ne déduit pas `DIFFERENT(A, C)` de `DIFFERENT(A, B)` et `DIFFERENT(B, C)`.
- L'ordre Subject/Object du wire n'est qu'un ordre de sérialisation pour le cadrage et ne crée pas de direction de sens. L'implémentation doit pouvoir parcourir dans les deux sens.
- Le curseur après lecture des deux composants doit coïncider exactement avec la fin de l'Edge.

La relation est irréflexive, mais on ne doit pas effacer comme erreur de grammaire du wire une affirmation `DIFFERENT(A, A)` structurellement valide ni une affirmation où SAME et DIFFERENT s'opposent. De telles affirmations conservent leur contexte et leur lignée et sont traitées comme contradictions par la couche de jugement. Pour interpréter ou déduire DIFFERENT, on conserve la provenance, le moment, le world et le policy scope du document qui contient cet Edge, et l'on ne l'élargit pas à une conclusion globale qui les ignorerait.

## Longueur

```
Total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Exemple (non normatif)

Edge Id `000a`, Subject est LOCAL 1, Object est LOCAL 2.

- L'Edge fait TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. Le TAG est `0001 0 0110 0000010` = `1302`.

```
1302 0088 000a 0088 0001 0088 0002
```

La différence des LOCAL ID dans cet exemple ne sert qu'à montrer l'encodage. On ne fait de cette séquence un DIFFERENT-NODE que s'il existe par ailleurs une affirmation que les ID 1 et 2 désignent des referents différents.

## Pages liées

- [Edge](/fr/grammar/edge/), [REFERENCE-NODE](/fr/grammar/edge/reference-node/), [SAME-NODE](/fr/grammar/edge/same-node/)
- [Reference](/fr/grammar/reference/), [LOCAL](/fr/grammar/reference/local/)
