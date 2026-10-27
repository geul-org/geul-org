---
title: "UTF8-LANGUAGE-TEXT"
weight: 75
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT est un texte accompagné d'une langue, qui contient dans une seule Value un enregistrement Value de langue et un texte UTF-8 (Codec 0x4A/0x4B)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT est un texte accompagné d'une langue. Il contient dans une seule Value un enregistrement Value de langue et une suite d'octets UTF-8.

[UTF8-TEXT](/fr/grammar/value/text/utf8-text/) est une chaîne sans langue (identifiant, code, nom de fichier, octets du texte d'origine), tandis que ce format est un texte avec langue (nom, titre, devise, phrase). Même avec les mêmes octets, ce sont des valeurs différentes. « Paris » (chaîne) et « Paris » (en français) ne sont pas égaux. C'est la même distinction que celle de RDF entre `xsd:string` et `rdf:langString`.

## Disposition

- Code : code direct de Value `0x4A` (texte d'un nombre d'octets pair) et `0x4B` (impair). Famille TEXT.

```
TAG WORD          0000 1LLL L100 101P      Codec 0x4A/0x4B (P = le texte a un nombre d'octets impair)
[TAG d'extension de Length] à partir de 15 WORD au total
Language          1 enregistrement Value LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE (TAG compris)
Text WORD 1er ... Nème             UTF-8 bytes / si impair, dernier 0x00
```

## Interprétation et validité

- Le Payload commence par l'enregistrement de langue. On lit le premier WORD du Payload comme un TAG, la Length de ce TAG donne l'enregistrement de langue, et le reste est les octets du texte. L'enregistrement de langue est obligatoire. Sans langue, on emploie non ce format mais UTF8-TEXT.
- L'enregistrement de langue est exactement un enregistrement complet [LANGUAGE-SHORT-CODE](/fr/grammar/value/text/language-short-code/) (`0x48`) ou [LANGUAGE-BCP47-CODE](/fr/grammar/value/text/language-bcp47-code/) (`0x46`, `0x47`). Si c'est un autre Codec ou s'il est incomplet, invalid. La validité de l'enregistrement de langue suit les règles de ce format.
- Les deux formats de langue sont admis. La règle de comparaison pour savoir si c'est la même langue est celle de [LABEL](/fr/grammar/edge/label/). Un SHORT-CODE et la balise BCP 47 correspondante qui n'a qu'une seule sous-balise primaire sont la même langue.
- On n'emploie pas `zxx` (aucun contenu linguistique). Une telle chaîne est UTF8-TEXT. `und` (langue indéterminée) et `mul` (plusieurs langues) sont des textes avec langue et peuvent s'employer.
- Les octets du texte suivent les mêmes règles qu'UTF8-TEXT. UTF-8 well-formed, BOM de tête interdit, pas de normalisation imposée et conservation du texte d'origine tel quel. Celui qui compare ou indexe aligne sur NFC pour comparer.
- Le nombre d'octets du texte est `2 × (nombre de WORD du Payload − nombre de WORD de l'enregistrement de langue) − P`. P (bit de poids faible du Codec) n'indique que la parité des octets du texte. S'il est impair, l'octet de poids faible du dernier WORD doit être `00`.
- Un texte vide (0 octet) place seulement l'enregistrement de langue sous le code pair.

## Où l'employer

- Valeur monolingualtext de Wikidata : `{"text":"Bundesrepublik Deutschland","language":"de"}` devient une seule de ces Value. Elle entre telle quelle dans l'Object de [TRIPLE](/fr/grammar/edge/triple/) et la Value de [QUALIFIER](/fr/grammar/edge/qualifier/). La propriété, le rank et les qualifier relèvent du TRIPLE.
- L'Object de [LABEL](/fr/grammar/edge/label/) et [ALIAS](/fr/grammar/edge/alias/). Cette seule valeur contient le nom et la langue.
- Les textes dont la langue est fixée, comme les titres de lois et d'articles.

## Correspondance des codes de langue (Wikidata)

- Les codes de langue de Wikidata et Wikimedia ne sont pas tous du BCP 47 (par ex. `simple`, `map-bms`). On les transcrit en balises BCP 47 par une table de correspondance. Les codes qu'on ne peut pas transcrire se traitent différemment selon l'usage.
  - Valeurs (monolingualtext) : on conserve le texte d'origine du datavalue en UTF8-TEXT. Une valeur faisant partie de la proposition, la jeter changerait la proposition.
  - Labels, descriptions, alias : on les saute et on les consigne dans le rapport. Ces Edge n'existent que s'il y a une langue (un texte sans langue est invalid), et le texte d'origine reste dans les données sources.
- Tant que le GEUL Language Registry n'existe pas, on emploie LANGUAGE-BCP47-CODE.

## Longueur

- Le total est la somme du TAG de 1 WORD, du TAG d'extension de Length (s'il existe), de l'enregistrement de langue et des WORD du texte. Jusqu'à 14 WORD, longueur directe ; à partir de 15 WORD, longueur étendue ([Length](/fr/grammar/record/)).
- L'enregistrement de langue fait 2 WORD pour un SHORT-CODE, et `ceil(octets de la balise/2) + 1` WORD pour BCP 47 (`de` 2 WORD, `zh-Hant` 5 WORD).

## Exemple

Les langues sont toutes en LANGUAGE-BCP47-CODE, faute de registre pour l'instant.

| Valeur | Octets du texte | WORD au total |
|---|---|---|
| "Paris" (fr) | 5 (impair) | `0ACB 08C6 6672 5061 7269 7300` |
| "" (ko) | 0 | `094A 08C6 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (pair) | `0F4A 0011 08C6 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris" : TAG `0ACB` (Codec `0x4B`, `LLLL=0101`, 6 WORD au total), langue `08C6 6672` (BCP 47 `fr`), texte `5061 7269 7300` (5 octets, dernier `00`).
- Le troisième fait 17 WORD au total, donc emploie la longueur étendue (`LLLL=1110` dans `0F4A`, TAG d'extension `0011`).

## Fondement normatif

- Balise de langue : [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`, `und` et `mul` sont des codes special de l'IANA Language Subtag Registry.
- Texte : [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Distinction entre chaîne et texte accompagné d'une langue : [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## Problèmes ouverts

- Vérification par le schema de la grammaire des balises BCP 47. Pour l'instant, on ne regarde que l'ASCII et le caractère non vide.

## Pages liées

- [Value](/fr/grammar/value/), [UTF8-TEXT](/fr/grammar/value/text/utf8-text/), [LANGUAGE-SHORT-CODE](/fr/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/fr/grammar/value/text/language-bcp47-code/), [LABEL](/fr/grammar/edge/label/)
