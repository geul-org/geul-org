---
title: "BIND"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND est un Edge de description (Codec 0x03) qui lie au Subject un nom auquel la machine se conforme (UTF8-TEXT sans langue)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIND est un Edge de description qui lie au Subject un nom auquel la machine se conforme. Codec `0x03`.

C'est une dénomination. Les noms lisibles par l'humain (titres par langue) relèvent de [LABEL](/fr/grammar/edge/label/). Le même enregistrement sert pour le nom d'un symbole de programme et pour le nom servant d'adresse d'un document.

## Disposition

```
TAG WORD          0001 0LLL L000 0011
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference, ou 1 WORD de TAG WORD de codec
Nom               1 Value UTF8-TEXT-*
```

## Interprétation et validité

- Subject est exactement un enregistrement [Reference](/fr/grammar/reference/) complet. Si c'est un LOCAL, c'est une cible de ce document (symbole, etc.) ; si c'est une Reference de pointeur, une cible d'un autre document. Le document lui-même est [DOC-POINTER](/fr/grammar/reference/doc-pointer/), l'Issuer lui-même [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/).
- Ou bien Subject est un TAG WORD de codec (seulement Kind et Codec, `LLLL = 0`, sans Payload). Ce n'est pas un enregistrement à Payload vide mais ce code direct lui-même, c'est-à-dire son document de spécification (document `0x000000000000<TAG>` de l'Issuer GEUL) ([Documents de spécification de Codec](/fr/grammar/codec-spec/), [DECLARE](/fr/grammar/edge/declare/)). Exemple : `1018` est PUBLICATION. Dans l'index des noms, on emploie un Subject DOC-POINTER. Les codecs de format d'Issuer ne s'emploient pas.
- Les autres enregistrements (Value, etc.) ne peuvent pas être Subject. Le FIELD du document de spécification de BIND ne déclare Subject qu'en largeur `0` (enregistrement), donc cette contrainte est une règle du corps de BIND.
- Le nom est exactement une Value [UTF8-TEXT](/fr/grammar/value/text/utf8-text/). Sans langue ni normalisation. Deux noms ne sont les mêmes que si leurs octets sont identiques.
- La portée d'un nom est le document qui contient le BIND. Dans un document, on ne lie pas le même nom à des Subject différents.
- On peut lier plusieurs noms à un Subject (alias, anciens noms). Sauf décision contraire du document, le dernier BIND donne le nom représentatif.
- Les autres enregistrements désignent une cible par LOCAL ID, non par nom. Le nom sert à s'accorder avec l'extérieur (fonctions hôtes, saisie d'adresses, humains).
- Les caractères admis dans un nom dépendent de l'usage. Le nom servant d'adresse de document suit la règle des noms de document (slug ASCII en minuscules) ([Adresse de publication et liste des versions](/fr/grammar/publishing/#nom-du-document)).

## Longueur

```
Total = 1 + N_len + N_id + N_subject + N_name WORD
```

## Exemple (non normatif)

Symbole de programme : Edge Id `0003`, Subject LOCAL 7, nom `main`.

- Le nom `main` fait 4 octets (pair), soit `0940 6d61 696e`, 3 WORD.
- L'Edge fait TAG 1 + Edge Id 2 + Subject 2 + nom 3 = 8 WORD, TAG `1383`.

```
1383 0088 0003 0088 0007 0940 6d61 696e
```

Nom de document (dans son document de liste des versions `0x0000/0xffff000000000002/versions.geul`) : Edge Id `0005`, Subject `DOC-POINTER` (Issuer `0x0000`, document `0xffff000000000002`, version `0` = le document lui-même), nom `this-is-sample-doc`.

- Subject fait TAG `03B8` + Issuer 1 + ID de document 4 + ID de version 2 = 8 WORD.
- Le nom fait 18 octets (pair), soit TAG `0CC0` + 9 WORD = 10 WORD.
- L'Edge fait TAG 1 + extension de Length 1 + Edge Id 2 + Subject 8 + nom 10 = 22 WORD, donc `LLLL=1110`, TAG `1703`, extension `0016`.

```
1703 0016 0088 0005 03B8 0000 ffff 0000 0000 0002 0000 0000 0CC0 7468 6973 2d69 732d 7361 6d70 6c65 2d64 6f63
```

## Pages liées

- [Edge](/fr/grammar/edge/), [LABEL](/fr/grammar/edge/label/), [PUBLICATION](/fr/grammar/edge/publication/) (nom de document du document de liste des versions)
- [LOCAL](/fr/grammar/reference/local/), [DOC-POINTER](/fr/grammar/reference/doc-pointer/), [ISSUER-POINTER](/fr/grammar/reference/issuer-pointer/)
