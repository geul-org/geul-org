---
title: "LABEL"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL est un Edge de description (Codec 0x04) qui rattache le nom d'une cible du Subject dans une langue, sous forme d'Object UTF8-LANGUAGE-TEXT."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL est un Edge de description qui rattache comme Object le nom (label) d'une cible du Subject dans une langue donnée. Codec `0x04`. Ce n'est pas un Edge qui représente le lemme de la lexicographie générale.

Le nom et sa langue tiennent dans un seul Object, [UTF8-LANGUAGE-TEXT](/fr/grammar/value/text/utf8-language-text/). Il n'y a pas de champ en valeur brute.

## Disposition

```
TAG WORD          0001 0LLL L000 0100
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference
Object            Value UTF8-LANGUAGE-TEXT ou 1 enregistrement Reference LOCAL
```

## Interprétation et validité

- Subject est exactement un enregistrement Reference complet. On trouve les limites par la Length de Subject lui-même ; si ce n'est pas une Reference ou si c'est incomplet, invalid.
- Object est exactement un enregistrement [UTF8-LANGUAGE-TEXT](/fr/grammar/value/text/utf8-language-text/) (`0x4A`, `0x4B`) complet. Les règles de langue et de texte (les deux formats de langue sont admis, comparaison d'une même langue) suivent ce format.
- Object peut aussi être une Reference LOCAL. Elle doit alors se résoudre en UTF8-LANGUAGE-TEXT par une liaison [REFERENCE-NODE](/fr/grammar/edge/reference-node/) du même document. Si elle ne se résout pas, ou se résout en une cible d'un autre genre, invalid.
- Le document de spécification de geul.org écrit cette restriction par [CODEC](/fr/grammar/edge/codec/) (Object = `084A`, `084B`, `0008`). La cible de résolution d'un LOCAL ne s'exprime pas par CODEC.
- Si Object n'est aucune de ces deux formes, ou si l'enregistrement est incomplet, invalid. Un texte sans langue (UTF8-TEXT) ne peut pas être un LABEL. Un nom pour la machine, sans langue, s'écrit par [BIND](/fr/grammar/edge/bind/). Un nom commun à plusieurs langues s'écrit avec la langue `mul`.
- Il y a au plus un LABEL par Subject et par langue. Les autres noms s'écrivent par [ALIAS](/fr/grammar/edge/alias/).

## Longueur

```
Total = 1 + N_len + N_id + N_subject + N_object WORD
```

- L'enregistrement de langue et le nombre d'octets du texte de l'Object relèvent de l'enregistrement Object, non de l'Edge. Le curseur après lecture du dernier enregistrement doit coïncider exactement avec la fin de l'Edge.

## Exemple (non normatif)

Le code de langue `0784` de `en` est le numéro dans la GEUL Language Registry v2 (document de spécification `0x0000/0x0000000000000848` version 2).

### LANGUAGE-SHORT-CODE

Edge Id `0007`, Subject Q22686 (`00A0 589e`), Object `Donald Trump` (en).

- Object fait langue `08C8 0784` (SHORT-CODE, 2 WORD) + texte de 12 octets (pair, 6 WORD), donc `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), 9 WORD au total `0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70`.
- L'Edge fait TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. Le TAG est `1684`.

```
1684 0088 0007 00A0 589e 0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70
```

### LANGUAGE-BCP47-CODE

Edge Id `0008`, Subject Q155 (`00A0 009b`), Object `Brasil` (pt-BR).

- Object fait langue `09C7 7074 2d42 5200` (BCP47 `pt-BR`, 4 WORD) + texte de 6 octets (pair, 3 WORD), soit 8 WORD au total `0BCA 09C7 7074 2d42 5200 4272 6173 696c`.
- L'Edge fait TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, `LLLL=1100`. Le TAG est `1604`.

```
1604 0088 0008 00A0 009b 0BCA 09C7 7074 2d42 5200 4272 6173 696c
```

## Pages liées

- [Edge](/fr/grammar/edge/), [ALIAS](/fr/grammar/edge/alias/), [DESCRIPTION](/fr/grammar/edge/description/), [BIND](/fr/grammar/edge/bind/)
- [UTF8-LANGUAGE-TEXT](/fr/grammar/value/text/utf8-language-text/), [LANGUAGE-SHORT-CODE](/fr/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/fr/grammar/value/text/language-bcp47-code/)
- [LOCAL](/fr/grammar/reference/local/), [REFERENCE-NODE](/fr/grammar/edge/reference-node/)
