---
title: "DESCRIPTION"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION est un Edge de description (Codec 0x06) qui rattache une courte description par langue à la cible du Subject. Sa disposition est identique à celle de LABEL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIPTION est un Edge de description qui rattache comme Object une description, dans une langue donnée, de la cible du Subject. Codec `0x06`.

Une description est une courte expression qui distingue la cible (description de Wikidata, par ex. « capitale et plus grande ville d'Allemagne »). Ce n'est ni une définition ni une affirmation sur la cible. Les propositions sur la cible s'écrivent par [TRIPLE](/fr/grammar/edge/triple/). La disposition est celle de [LABEL](/fr/grammar/edge/label/). La description et sa langue tiennent dans un seul Object, [UTF8-LANGUAGE-TEXT](/fr/grammar/value/text/utf8-language-text/). Il n'y a pas de champ en valeur brute.

## Disposition

```
TAG WORD          0001 0LLL L000 0110
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference
Object            Value UTF8-LANGUAGE-TEXT ou 1 enregistrement Reference LOCAL
```

## Interprétation et validité

- Les règles de Subject et d'Object sont celles de [LABEL](/fr/grammar/edge/label/). Subject est exactement un enregistrement Reference complet. Object est exactement un enregistrement UTF8-LANGUAGE-TEXT (`0x4A`, `0x4B`) complet, ou une Reference LOCAL qui se résout en UTF8-LANGUAGE-TEXT par une liaison [REFERENCE-NODE](/fr/grammar/edge/reference-node/) du même document.
- Un texte sans langue (UTF8-TEXT) ne peut pas être une DESCRIPTION. Une description est unique par langue, et cette règle n'a de sens que si la langue existe. Une description commune à plusieurs langues s'écrit avec la langue `mul`.
- Il y a au plus une DESCRIPTION par Subject et par langue.
- La description sert à distinguer d'une autre cible de même nom. Il vaut mieux que le couple LABEL et DESCRIPTION ne se répète pas pour deux cibles dans la même langue, mais la spécification ne le vérifie pas (Wikidata ne fait que le recommander, sans l'imposer).
- Le document de spécification de geul.org limite Object par [CODEC](/fr/grammar/edge/codec/) (`084A`, `084B`, `0008`, comme LABEL).

## Longueur

```
Total = 1 + N_len + N_id + N_subject + N_object WORD
```

- L'enregistrement de langue et le nombre d'octets du texte de l'Object relèvent de l'enregistrement Object. Le curseur après lecture du dernier enregistrement doit coïncider exactement avec la fin de l'Edge.
- Une description étant plus longue qu'un label, Object comme Edge dépassent facilement 15 WORD. On emploie alors l'extension de Length ([Enregistrement et TAG WORD](/fr/grammar/record/)).

## Exemple (non normatif)

Edge Id `0009`, Subject Q64 (`00A0 0040`), Object `capital and largest city of Germany` (en). La langue est LANGUAGE-BCP47-CODE, faute de registre pour l'instant.

- Object fait langue `08C6 656E` (BCP47 `en`, 2 WORD) + texte de 35 octets (impair, 18 WORD), donc `0x4B`, TAG 1 + TAG d'extension 1 + 20 = 22 WORD, `0F4B 0016 …`.
- L'Edge fait TAG 1 + TAG d'extension 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD, donc `LLLL=1110`, TAG `1706`, TAG d'extension `001C`.

```
1706 001C 0088 0009 00A0 0040
0F4B 0016 08C6 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Correspondance Wikidata

- Les `descriptions` d'un élément (une par langue) → une DESCRIPTION par langue. Les codes de langue se transcrivent par la même table de correspondance des codes de langue que pour LABEL.

## Problèmes ouverts

- Existe-t-il des cas justifiant d'admettre une description UTF8-TEXT sans langue (pour l'instant, non admise).

## Pages liées

- [Edge](/fr/grammar/edge/), [LABEL](/fr/grammar/edge/label/), [ALIAS](/fr/grammar/edge/alias/), [CODEC](/fr/grammar/edge/codec/)
- [UTF8-LANGUAGE-TEXT](/fr/grammar/value/text/utf8-language-text/), [LOCAL](/fr/grammar/reference/local/), [REFERENCE-NODE](/fr/grammar/edge/reference-node/)
