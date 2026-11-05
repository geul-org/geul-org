---
title: "UTF8-LANGUAGE-TEXT (0x078L·0x079L)"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT est un texte muni d'une langue, qui contient dans un seul Value un enregistrement de Value de langue et un texte UTF-8 (Codec 0x078L/0x079L)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT est un texte muni d'une langue, qui contient dans un seul Value un enregistrement de Value de langue et un texte UTF-8 (Codec 0x078L/0x079L).

| Élément | Valeur |
|---|---|
| Nom | `UTF8-LANGUAGE-TEXT` (groupe pair/impair. Le nom de chaque code figure dans le tableau des membres ci-dessous) |
| TAG ID | `0x078L`·`0x079L` |
| Section | 3 `0011` (Value), décalage dans la section C = 24~25 |
| Kind | Value · famille : TEXT |
| Description de l'index | Texte muni d'une langue. Enregistrement de Value de langue (LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE) et octets UTF-8. Pair·impair selon les octets du texte |
| Côté Hugo | `value/text/utf8-language-text.md` |

## Membres {#구성원}

Cette page traite ensemble deux codes formant une paire pair/impair. Le code pair correspond à un nombre d'octets pair, le code impair à un nombre d'octets impair ([Enregistrement et TAG WORD](../record.md#가변-길이-바이트열)). Il y a un document de Codec par code. Les champs des deux documents de Codec sont identiques ; seuls la cible de DECLARE et le nom (BIND) diffèrent.

| TAG ID | Nom | Nombre d'octets | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x078L` | `UTF8-LANGUAGE-TEXT-EVEN` | pair | `0x00000780` | `0x00000000/codecs/0x00000780/` | `0000 0111 1000 LLLL` |
| `0x079L` | `UTF8-LANGUAGE-TEXT-ODD` | impair | `0x00000790` | `0x00000000/codecs/0x00000790/` | `0000 0111 1001 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | enregistrement | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |
| 2 | `bytes` | #3 | reste de valeur brute (`0xFFFF`) |  |  |

UTF8-LANGUAGE-TEXT est un texte muni d'une langue. Il contient dans un seul Value un enregistrement de Value de langue et une suite d'octets UTF-8.

[UTF8-TEXT](0x072L-utf8-text.md) est une chaîne sans langue (identifiant, code, nom de fichier, octets d'origine), tandis que ce format est un texte avec langue (nom, titre, devise, phrase). Les deux sont des valeurs différentes même avec les mêmes octets. « Paris » (chaîne) et « Paris » (français) ne sont pas identiques. C'est comme la distinction que fait RDF entre `xsd:string` et `rdf:langString`.

## Disposition {#레이아웃}

- Code : codes directs de Value `0x078L` (octets pairs du texte) · `0x079L` (octets impairs du texte). Famille TEXT.

```
TAG WORD          0000 0111 100P LLLL      Codec 0x078L/0x079L (P = le texte a un nombre d'octets impair)
[TAG d'extension Length] si le total atteint 15 WORD ou plus
Language          1 enregistrement de Value LANGUAGE-SHORT-CODE ou LANGUAGE-BCP47-CODE (TAG inclus)
Text WORD 1st ... Nth             UTF-8 bytes / si impair, dernier 0x00
```

## Interprétation et validité {#해석과-유효성}

- Le Payload commence par l'enregistrement de langue. On lit le premier WORD du Payload comme un TAG ; les WORD couverts par sa Length forment l'enregistrement de langue, et le reste forme les octets du texte. L'enregistrement de langue est obligatoire. S'il n'y a pas de langue, on utilise UTF8-TEXT et non ce format.
- L'enregistrement de langue est exactement un enregistrement complet de [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) (`0x07AL`) ou de [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`). S'il relève d'un autre Codec ou s'il est incomplet, il est invalid. La validité de l'enregistrement de langue suit les règles de son format.
- Les deux formats de langue sont utilisables. La règle pour comparer si deux langues sont identiques est la même que pour [LABEL](../edge/0x0A4L-label.md). Un SHORT-CODE et le tag BCP 47 que le registry lie à ce numéro désignent la même langue.
- `zxx` (aucun contenu linguistique) n'est pas utilisé. Une telle chaîne est un UTF8-TEXT. `und` (langue indéterminée) et `mul` (plusieurs langues) sont des textes avec langue et peuvent donc être utilisés.
- Les octets du texte suivent les mêmes règles que UTF8-TEXT. Ils doivent être de l'UTF-8 well-formed, un U+FEFF initial est admis comme caractère, la normalisation n'est pas imposée et le texte d'origine est conservé tel quel. C'est le côté qui compare ou indexe qui s'aligne en NFC pour comparer.
- Le nombre d'octets du texte est `2 × (nombre de WORD du Payload − nombre de WORD de l'enregistrement de langue) − P`. P (bit de poids faible du Codec) n'indique que la parité des octets du texte. S'il est impair, l'octet de poids faible du dernier WORD doit être `00`.
- Pour un texte vide (0 octet), on ne met que l'enregistrement de langue avec le code pair.

## Où l'utiliser {#쓰는-곳}

- Valeur monolingualtext de Wikidata : `{"text":"Bundesrepublik Deutschland","language":"de"}` devient une seule valeur de ce format. Il entre tel quel dans l'Object de [TRIPLE](../edge/0x0AAL-triple.md) et dans le Value de [QUALIFIER](../edge/0x0ABL-qualifier.md). La propriété, le rank et le qualifier relèvent de TRIPLE.
- L'Object de [LABEL](../edge/0x0A4L-label.md) et de [ALIAS](../edge/0x0A5L-alias.md). Ce seul Value contient le nom et la langue.
- Textes dont la langue est fixée, comme les titres de lois ou d'articles.

## Correspondance des codes de langue (Wikidata) {#언어-코드-대응-위키데이터}

- Les codes de langue de Wikidata et de Wikimedia ne sont pas tous du BCP 47 (par exemple `simple`, `map-bms`). On les transpose en tags BCP 47 au moyen d'une table de correspondance. Les codes qui ne peuvent pas être transposés sont traités différemment selon l'usage.
  - Valeur (monolingualtext) : le texte d'origine du datavalue est conservé en UTF8-TEXT. La valeur fait partie de la proposition, et la supprimer changerait la proposition.
  - Label, description, alias : on les saute et on les consigne dans le rapport. Ces Edge ne tiennent que s'ils ont une langue (un texte sans langue est invalid), et le texte d'origine reste dans les données sources.
- Si le tag transposé a un numéro dans le GEUL Language Registry, on l'écrit en LANGUAGE-SHORT-CODE ; sinon, en LANGUAGE-BCP47-CODE.

## Longueur {#길이}

- Le total est la somme des WORD : TAG 1 WORD, TAG d'extension Length (s'il existe), enregistrement de langue et WORD du texte. Jusqu'à 14 WORD, la longueur est directe ; à partir de 15 WORD, on utilise la longueur étendue ([Length](../record.md)).
- L'enregistrement de langue fait 2 WORD pour un SHORT-CODE, et `ceil(octets du tag/2) + 1` WORD pour BCP 47 (`de` 2 WORD, `zh-Hant` 5 WORD).

## Exemple {#예시}

Les langues sont toutes données au format LANGUAGE-BCP47-CODE. `fr`·`ko`·`de` ont un numéro dans le registry et pourraient donc aussi s'écrire en SHORT-CODE (2 WORD).

| Valeur | Octets du texte | Total de WORD |
|---|---|---|
| « Paris » (fr) | 5 (impair) | `0795 0761 6672 5061 7269 7300` |
| « » (ko) | 0 | `0782 0761 6B6F` |
| « Bundesrepublik Deutschland » (de) | 26 (pair) | `078E 0011 0761 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- « Paris » : TAG `0795` (Codec `0x079L`, `LLLL=0101`, total 6 WORD), langue `0761 6672` (BCP 47 `fr`), texte `5061 7269 7300` (5 octets, dernier `00`).
- Le troisième fait 17 WORD au total et utilise donc l'extension Length (`LLLL=1110` dans `078E`, TAG d'extension `0011`).

## Fondement normatif {#표준-근거}

- Language tag : [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`·`und`·`mul` sont des codes spéciaux de l'IANA Language Subtag Registry.
- Texte : [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Distinction entre chaîne et texte muni d'une langue : [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## Problèmes ouverts {#열린-문제}

- Vérification de la grammaire des tags BCP 47 par le schema. Pour l'instant, on vérifie seulement que c'est de l'ASCII et non vide.

## Pages liées {#관련-페이지}

- [Value](_index.md), [UTF8-TEXT](0x072L-utf8-text.md), [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [LABEL](../edge/0x0A4L-label.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00000780/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000078000000000
BODY
#1 DECLARE 0x0780
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "UTF8-LANGUAGE-TEXT-EVEN"
#5 BIND #2 "language"
#6 BIND #3 "bytes"
#7 CODEC #2 0x07A0
#8 CODEC #2 0x0760
#9 CODEC #2 0x0770
```

Ce qui précède est le document de Codec de `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`). Le document de Codec de l'autre membre (`UTF8-LANGUAGE-TEXT-ODD`) ne diffère que par le Codec ID dans le DOC-ID, la cible de DECLARE et le nom lié en `#1` (BIND).
