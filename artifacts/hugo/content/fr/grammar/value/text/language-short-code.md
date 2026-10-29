---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE est une Value de code de langue GEUL qui contient en 1 WORD une balise BCP 47 numérotée par le GEUL Language Registry (Codec 0x48). Le registre est l'ensemble des ENUM du document de spécification de ce Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE est un code de langue compressé GEUL qui contient en 1 WORD une balise BCP 47 ayant un numéro dans le GEUL Language Registry. Le Payload fait exactement 1 WORD.

## Disposition

- Code : code direct de Value `0x48`. Famille TEXT.
- Le Payload fait exactement 1 WORD, un code unsigned de 16 bits.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  2 WORD au total
Payload WORD 1st (16 bits)           numéro du GEUL Language Registry (uint16)
```

## Interprétation et validité

- Le WORD du Payload se lit comme un entier unsigned de 16 bits.
- Cette valeur est une balise attribuée par le GEUL Language Registry. La forme normative du registre est le document de spécification de ce Codec, `0x0000/0x0000000000000848`. Chaque valeur de code a un [ENUM](/fr/grammar/edge/enum/) sur le FIELD `code`, et le nom lié par [BIND](/fr/grammar/edge/bind/) à l'Edge Id de cet ENUM est la balise BCP 47 dans sa casse canonique.
- Le registre est une liste fermée. Une valeur sans ENUM dans le document de spécification est invalid. Cette règle du Codec l'emporte sur la règle générale d'ENUM (« une valeur de code non déclarée n'est pas une erreur »).
- Trois sortes de balises sont numérotées.
  - Les enregistrements `Type: language` de l'IANA Language Subtag Registry, sauf `Scope: private-use` (`qaa..qtz`). Les collection, macrolanguage et special (`mul`, `und`, `zxx`, `mis`) ne sont pas exclus.
  - Les balises que l'IANA enregistre entières : grandfathered et redundant (`zh-Hans`, `sr-Latn`, `zh-min-nan`, etc.).
  - Les balises combinées valides observées dans des sources publiques CC0 (`pt-BR`, `en-GB`, `be-tarask`, etc.). Elles ne se composent que de sous-balises language, extlang, script, region et variant. Les balises contenant une extension (`-u-`, `-t-`) ou du private-use (`-x-`) ne sont pas admises.
- Une balise sans numéro ne peut pas s'écrire dans ce format. On l'écrit en [LANGUAGE-BCP47-CODE](/fr/grammar/value/text/language-bcp47-code/) (`0x46`, `0x47`). SHORT-CODE n'a pas de chemin d'échappement.
- `0x0000` et `0xffff` ne sont jamais attribués. Les deux sont invalid dans cette Value. Aucun ne sert à signifier `null`, `unknown` ou `und`.
- Les plages de valeurs sont une convention d'attribution. Le décodeur ne déduit pas la sorte de balise de la plage de la valeur. Le sens d'une valeur ne vient que du document de spécification.

| Plage | Usage |
|---|---|
| `0x0000` | Jamais attribué (invalid) |
| `0x0001`–`0x3fff` | Balises d'une seule sous-balise language |
| `0x4000`–`0x7fff` | Balises de deux sous-balises ou plus (balises entières de l'IANA, balises combinées observées) |
| `0x8000`–`0xfffe` | Débordement. Quand un bloc ci-dessus est plein, l'attribution continue ici |
| `0xffff` | Jamais attribué (invalid) |

- L'édition initiale numérote les balises dans chaque bloc selon l'ordre ASCII en minuscules. Dans le bloc `0x4000` viennent d'abord les balises entières de l'IANA (grandfathered et redundant mêlées, ordre ASCII), puis les balises combinées observées (ordre ASCII). Ni l'ordre physique du fichier de l'IANA ni la fréquence d'usage ne sont des règles de numérotation.
- L'attribution ne fait qu'ajouter (append-only). Une nouvelle balise s'ajoute à la fin de son bloc et, si le bloc est plein, dans la plage de débordement. La balise (sans tenir compte de la casse) d'un numéro déjà donné n'est ni changée, ni supprimée, ni réutilisée.
- Une nouvelle balise entre par l'ajout d'un ENUM et d'un BIND dans une nouvelle version du document de spécification. Les ENUM et BIND existants ne sont pas modifiés. Toute version est donc un sur-ensemble de la précédente.
- Quand les 65 534 numéros sont épuisés, on n'en attribue plus. Les balises nouvelles qui suivent s'écrivent en LANGUAGE-BCP47-CODE. L'expressivité ne diminue pas ; seul le gain de compression disparaît.
- Même langue : le SHORT-CODE `n` et le LANGUAGE-BCP47-CODE de la balise que le registre lie à `n` (sans tenir compte de la casse) sont la même langue.
- Une édition du registre est une version du document de spécification. Chaque édition consigne le fichier du registre de l'IANA sur lequel elle repose (File-Date, SHA-256) comme [SOURCE](/fr/grammar/edge/source/) dans le HEAD du document de spécification. Quand il faut indiquer l'édition utilisée pour interpréter une valeur, on conserve cette version (`0x0000/0x0000000000000848@n`) avec elle.
- Une spécification de Codec peut contenir le même code de 1 WORD dans un champ de valeur brute sans TAG ([CODEC](/fr/grammar/codec-spec/#codec) d'un champ de valeur brute). C'est une règle de cette spécification de Codec ; la wire form d'une Value autonome est toujours TAG 1 WORD + Payload 1 WORD.

## Fondement normatif

- Le sens des balises et la validité des sous-balises suivent l'[IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) et la [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). L'IANA et l'IETF placent leurs droits sur les registres de protocole sous CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- Les numéros du registre (attribution append-only dans l'ordre ASCII, composition des blocs, `0x0000` et `0xffff` jamais attribués, liste fermée), le fait que les ENUM du document de spécification soient la forme normative et la distinction avec l'embedding sans TAG dans un champ de valeur brute sont des règles GEUL.

## Longueur

- Le total fait exactement 2 WORD, TAG 1 WORD plus Payload 1 WORD, avec la longueur directe `LLLL=0001`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 1 WORD, on rejette.

## Exemple

Numéros du registre v2 (document de spécification `0x0000/0x0000000000000848` version 2, IANA File-Date 2026-09-17). Il attribue 8 678 balises (language 8 275, grandfathered 26, redundant 67, combinées observées 310).

| balise | Code | WORD complets |
|---|---|---|
| `en` | `0x0784` | `08C8 0784` |
| `ko` | `0x0d06` | `08C8 0D06` |
| `zh-Hans` | `0x404c` | `08C8 404C` |
| `pt-BR` | `0x4130` | `08C8 4130` |

- Dans le document de spécification, `en` est `ENUM #2 0x0784` et le `BIND "en"` sur son Edge Id.
- `de-x-formal` (private-use) et `nl-u-sd-bebru` (extension) n'ont pas de numéro ; ils s'écrivent donc en LANGUAGE-BCP47-CODE.

## Problèmes ouverts

- Lecture d'une édition à l'autre : un numéro plus récent que l'édition du lecteur est-il rejeté comme invalid ou conservé avec sa valeur brute comme « code inconnu » ? Comme l'attribution est append-only, la dernière édition suffit toujours, mais les décodeurs hors ligne ont besoin d'une règle.
- Forme canonique : une balise qui a un numéro doit-elle (SHOULD/MUST) s'écrire en SHORT-CODE ? Avec MUST la graphie est unique, mais une nouvelle édition rendrait non canoniques les documents écrits avant.
- Comment exprimer les balises deprecated et Preferred-Value dans le document de spécification (l'édition actuelle n'en a pas).
- La procédure d'ajout des balises combinées observées (sources, seuil d'observation).

## Pages liées

- [LANGUAGE-BCP47-CODE](/fr/grammar/value/text/language-bcp47-code/), [UTF8-LANGUAGE-TEXT](/fr/grammar/value/text/utf8-language-text/), [LABEL](/fr/grammar/edge/label/)
- [Documents de spécification de Codec](/fr/grammar/codec-spec/), [ENUM](/fr/grammar/edge/enum/), [BIND](/fr/grammar/edge/bind/), [SOURCE](/fr/grammar/edge/source/)
