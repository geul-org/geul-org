---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE est une Value de code de langue de GEUL qui ne contient, compressée en 1 WORD, que la sous-balise de langue primaire (Codec 0x48)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE est un code de langue compressé de GEUL qui ne contient pas la balise BCP 47 complète mais seulement la sous-balise de langue primaire. Le Payload fait exactement 1 WORD.

## Disposition

- Code : code direct de Value `0x48`. Famille TEXT.
- Le Payload est un code unsigned de 16 bits sur exactement 1 WORD.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  2 WORD au total
Payload WORD 1er (16 bits)           GEUL language code (uint16)
```

## Interprétation et validité

- Le WORD du Payload se lit comme un entier non signé de 16 bits.
- Cette valeur est le code compressé de la sous-balise de langue primaire. Elle ne contient ni script, ni région, ni variante, ni extension, ni private-use. Si l'on a besoin de ces informations, on emploie [LANGUAGE-BCP47-CODE](/fr/grammar/value/text/language-bcp47-code/) (`0x46` et `0x47`).
- `0x0000..0xfffe` est la plage d'attribution du GEUL Language Registry. Même dans cette plage, une valeur qui n'est pas réellement attribuée dans la version de ce registre est invalid.
- Les cibles de l'attribution initiale sont les enregistrements publics `Type: language` d'un snapshot précis de l'IANA Language Subtag Registry, privés des `Scope: private-use`. On n'écarte ni collections, ni macrolanguage, ni special.
- L'attribution initiale trie ces enregistrements publics par sous-balise ASCII et leur donne leur ID. L'ordre physique du fichier IANA n'est pas une règle d'ID.
- Les nouvelles sous-balises `Type: language` ultérieures s'ajoutent à la fin sans changer les numéros existants (append-only).
- L'ID d'une sous-balise de langue deprecated n'est ni effacé ni réutilisé. La relation de Preferred-Value et l'état deprecated sont conservés comme métadonnées du registre.
- `0xffff` est réservé comme échappement d'extension. Tant qu'un format d'extension n'est pas défini à part, il est invalid dans une Value LANGUAGE-SHORT-CODE indépendante. On ne l'emploie pas avec un sens comme `null`, `unknown` ou `und`.
- Une autre spécification de Codec pourra définir la règle d'interprétation qui suit `0xffff`. Mais cela ne signifie pas que cette règle allonge le Payload de ce format ou admet un Payload qui suit.
- Une spécification de Codec peut placer le même code de 1 WORD dans un champ en valeur brute sans TAG (un [CODEC](/fr/grammar/codec-spec/#codec) sur le champ en valeur brute). C'est une règle de cette spécification de Codec, et le wire form d'une Value indépendante est toujours TAG de 1 WORD + Payload de 1 WORD.
- Pour juger le sens d'une valeur, il faut conserver la version du GEUL Language Registry employée et la date du snapshot IANA fixée par cette version.

## Fondement normatif

- Le registre d'origine de la sous-balise de langue primaire et les métadonnées deprecated/Preferred-Value suivent l'[IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- Le sens de base du système des sous-balises de langue BCP 47 suit la [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- L'attribution d'ID append-only triée en ASCII, la réservation de `0xffff` et la distinction avec l'intégration sans TAG dans un champ en valeur brute sont des règles de GEUL.

## Longueur

- Le total est exactement de 2 WORD, soit le TAG de 1 WORD plus le Payload de 1 WORD, avec la longueur directe `LLLL=0001`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 1 WORD, on rejette.

## Exemple

- Comme le snapshot du registre et la table réelle des codes ne sont pas encore fixés, on ne donne pas d'exemple d'ID numérique pour une langue précise.

## Problèmes ouverts

- Date du snapshot IANA initial, nom de la version du GEUL Language Registry, table de correspondance complète. Tant qu'ils ne sont pas fixés, on ne confirme ni exemple numérique concret ni table de codes.
