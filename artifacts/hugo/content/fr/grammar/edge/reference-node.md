---
title: "REFERENCE-NODE"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE est un Edge de description orienté (Codec 0x00) qui lie une Reference à un enregistrement Object et définit ce qu'est cette Reference."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-NODE est un Edge de description orienté qui relie une Reference à un enregistrement Object, pour définir ou lier ce qu'est cette Reference. Codec `0x00`.

Le Subject désigne l'Object. Cette liaison n'est pas un [SAME-NODE](/fr/grammar/edge/same-node/) qui affirmerait une identité de sens, et ne signifie pas non plus que les octets des deux enregistrements sont les mêmes.

## Disposition

```
TAG WORD          0001 0LLL L000 0000
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference
Object            1 enregistrement Reference ou Value
```

## Interprétation et validité

- Subject doit être exactement un enregistrement [Reference](/fr/grammar/reference/) complet. On trouve les limites par la Length de Subject lui-même ; si ce n'est pas une Reference ou si c'est incomplet, invalid.
- Object doit être exactement un enregistrement Reference ou Value complet. On trouve les limites par la Length d'Object lui-même ; si c'est un Edge ou un Meta, ou s'il est incomplet, invalid.
- Si Object est une Reference, la chaîne de Reference suivie par les liaisons REFERENCE-NODE ne doit pas être circulaire et le LOCAL doit finir par se résoudre. Une résolution circulaire et un LOCAL dangling sont invalid.
- Dans un même document, si un LOCAL ID est lié à des Object contradictoires, invalid. La portée, l'ID, la largeur minimale et les règles de fusion d'un LOCAL suivent [LOCAL](/fr/grammar/reference/local/).
- Il n'est pas nécessaire que toute Reference soit liée par REFERENCE-NODE.
- L'usage typique est `LOCAL → UTF8-LANGUAGE-TEXT`. Quand l'Object de [LABEL](/fr/grammar/edge/label/) contient un LOCAL, on résout le texte par cette liaison du même document.

On ne doit pas interpréter à l'envers le sens dans lequel le Subject désigne l'Object. Le sens et les règles détaillées de SAME et DIFFERENT sont fixés par chacun de ces formats.

## Longueur

```
Total = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` est le nombre de WORD du TAG d'extension de Length, `N_id` le nombre de WORD de l'enregistrement LOCAL de l'Edge Id, `N_subject` et `N_object` le nombre total de WORD de chaque enregistrement. Le curseur après lecture de Subject et d'Object doit coïncider exactement avec la fin de l'Edge.

## Exemple (non normatif)

Edge Id `0008`, Subject est LOCAL 1, Object est l'[UTF8-LANGUAGE-TEXT](/fr/grammar/value/text/utf8-language-text/) de `Donald Trump` (en).

- L'Edge Id est `0088 0008`, 2 WORD.
- Subject est `0088 0001`, 2 WORD.
- Object fait langue `08C6 656e` (BCP47 `en`) + texte de 12 octets (pair), donc `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), 9 WORD au total. Le TAG est `0C4A`.
- L'Edge fait TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. Le TAG est `1680`.

```
1680 0088 0008 0088 0001 0C4A 08C6 656e 446f 6e61 6c64 2054 7275 6d70
```

## Pages liées

- [Edge](/fr/grammar/edge/), [SAME-NODE](/fr/grammar/edge/same-node/), [DIFFERENT-NODE](/fr/grammar/edge/different-node/), [LABEL](/fr/grammar/edge/label/)
- [Reference](/fr/grammar/reference/), [LOCAL](/fr/grammar/reference/local/), [UTF8-LANGUAGE-TEXT](/fr/grammar/value/text/utf8-language-text/)
