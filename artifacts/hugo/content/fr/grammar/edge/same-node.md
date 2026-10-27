---
title: "SAME-NODE"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE est un Edge de description d'identité non orientée (Codec 0x01) qui déclare que deux Reference désignent la même cible."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-NODE est un Edge de description d'identité non orientée qui déclare que deux Reference désignent le même referent. Codec `0x01`.

Cela ne signifie pas que l'encodage en octets, le Codec ou l'ID des deux enregistrements Reference sont les mêmes. Alors que [REFERENCE-NODE](/fr/grammar/edge/reference-node/) est une liaison orientée `Reference → enregistrement`, SAME-NODE exprime l'identité référentielle (referential identity) entre deux Reference.

## Disposition

```
TAG WORD          0001 0LLL L000 0001
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference
Object            1 enregistrement Reference
```

## Interprétation et validité

- Subject et Object se sérialisent dans cet ordre et doivent chacun être exactement un enregistrement [Reference](/fr/grammar/reference/) complet. On trouve les limites par la Length de chaque enregistrement.
- Si Subject ou Object est une Value, un Edge ou un enregistrement incomplet, invalid.
- La relation SAME-NODE est réflexive, symétrique et transitive. L'ordre Subject/Object du wire sert au cadrage et ne crée pas de direction de sens. L'implémentation doit pouvoir parcourir cette relation dans les deux sens.
- Deux ID [LOCAL](/fr/grammar/reference/local/) différents sont seulement des Reference différentes, et ne prouvent pas que les referents sont identiques ou différents. Que deux Reference désignent le même referent se déclare par SAME-NODE.
- L'interprétation et l'inférence doivent conserver la provenance, le moment, le world et le policy scope du document qui contient cet Edge et du graphe de jugement. On n'emploie pas SAME-NODE comme fondement d'une fusion globale indépendante du contexte.
- Même avec SAME-NODE, on n'efface ni n'écrase l'enregistrement Reference d'origine ni sa lignée.
- Que SAME-NODE et [DIFFERENT-NODE](/fr/grammar/edge/different-node/) coexistent pour une même paire ne rend pas le wire invalid. On conserve le contexte de chaque affirmation et on l'évalue comme un conflit.
- On résout une variable en reliant une Reference Variable à une Reference Identified par SAME-NODE ([Reference](/fr/grammar/reference/), Variable).

## Longueur

```
Total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Exemple (non normatif)

Edge Id `0009`, Subject est LOCAL 1, Object est LOCAL 2.

- L'Edge fait TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. Le TAG est `0001 0 0110 0000001` = `1301`.

```
1301 0088 0009 0088 0001 0088 0002
```

## Pages liées

- [Edge](/fr/grammar/edge/), [REFERENCE-NODE](/fr/grammar/edge/reference-node/), [DIFFERENT-NODE](/fr/grammar/edge/different-node/)
- [Reference](/fr/grammar/reference/), [LOCAL](/fr/grammar/reference/local/)
