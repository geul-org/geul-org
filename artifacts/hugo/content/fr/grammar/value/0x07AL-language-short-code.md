---
title: "LANGUAGE-SHORT-CODE (0x07AL)"
weight: 122
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE est un code de langue compressé de GEUL qui contient en 1 WORD un tag BCP 47 auquel un numéro est attribué dans le GEUL Language Registry."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `LANGUAGE-SHORT-CODE` (BIND `LANGUAGE-SHORT-CODE` du document de spécification) |
| TAG ID | `0x07AL` |
| Codec ID | `0x000007A0` |
| Document de spécification | `0x00000000/codecs/0x000007A0/` (cible de DECLARE `07A0`) |
| Section | 3 `0011` (Value), décalage dans la section C = 26 |
| Kind | Value · famille : TEXT |
| TAG WORD | `0000 0111 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description de l'index | Tag BCP 47 écrit avec un numéro du GEUL Language Registry (Payload de 1 WORD) |
| Côté Hugo | `value/text/language-short-code.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | valeur brute de 1 WORD |  | 8678 ENUM. Ex. : `0x0001` aa, `0x0002` aaa, `0x0003` aab, `0x0004` aac, `0x0005` aad … |

LANGUAGE-SHORT-CODE est un code de langue compressé de GEUL qui contient en 1 WORD un tag BCP 47 auquel un numéro est attribué dans le GEUL Language Registry. Le Payload fait exactement 1 WORD.

## Disposition {#레이아웃}

- Code : code direct de Value `0x07AL`. Famille TEXT.
- Le Payload est un code unsigned de 16 bits d'exactement 1 WORD.

```
TAG WORD          0x07A1 (0000 0111 1010 0001)  total 2 WORD
Payload WORD 1st (16 bits)           numéro du GEUL Language Registry (uint16)
```

## Interprétation et validité {#해석과-유효성}

- On lit le Payload de 1 WORD comme un entier unsigned de 16 bits.
- Cette valeur est un tag attribué par le GEUL Language Registry. La représentation officielle du registry est le document de spécification `0x00000000/codecs/0x000007A0` de ce Codec. Chaque valeur de code a un [ENUM](../edge/0x0BDL-enum.md) dans le FIELD `code`, et le nom lié par [BIND](../edge/0x0A3L-bind.md) à l'Edge Id de cet ENUM est le tag BCP 47 en casse canonique.
- Le registry est une liste fermée. Une valeur sans ENUM dans le document de spécification est invalid. Cette règle du Codec prime sur la règle générale d'ENUM (« une valeur de code non déclarée n'est pas une erreur »).
- Les cibles d'attribution sont les trois suivantes.
  - Parmi les enregistrements `Type: language` de l'IANA Language Subtag Registry, tous sauf ceux de `Scope: private-use` (`qaa..qtz`). Les collection, macrolanguage et special (`mul`·`und`·`zxx`·`mis`) ne sont pas exclus.
  - Les tags enregistrés tels quels par l'IANA : grandfathered et redundant (`zh-Hans`, `sr-Latn`, `zh-min-nan`, etc.).
  - Les tags de combinaison valides observés dans des sources publiques CC0 (`pt-BR`, `en-GB`, `be-tarask`, etc.). Ce sont des tags composés uniquement de subtags language, extlang, script, region et variant. Les tags contenant extension (`-u-`·`-t-`) et private-use (`-x-`) ne sont pas acceptés.
- Un tag sans numéro ne peut pas s'écrire dans ce format. On l'écrit en [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`). Il n'y a pas de voie d'escape à l'intérieur du SHORT-CODE.
- `0x0000` et `0xFFFF` ne sont jamais attribués. Dans ce Value, les deux sont invalid. Aucun des deux ne s'emploie au sens de `null`·`unknown`·`und`.
- Les plages de valeurs sont une convention d'attribution. Le décodeur ne déduit pas le type d'un tag à partir de la plage de la valeur. Le sens d'une valeur ne vient que du document de spécification.

| Plage | Usage |
|---|---|
| `0x0000` | non attribué (invalid) |
| `0x0001`–`0x3FFF` | tags composés d'un seul subtag language |
| `0x4000`–`0x7FFF` | tags de deux subtags ou plus (tags IANA entiers, tags de combinaison observés) |
| `0x8000`–`0xFFFE` | débordement. Quand les blocs ci-dessus sont pleins, l'attribution continue ici |
| `0xFFFF` | non attribué (invalid) |

- La version initiale donne les numéros à l'intérieur d'un bloc dans l'ordre ASCII des tags en minuscules. Dans le bloc `0x4000`, les tags IANA entiers (grandfathered et redundant mêlés, en ordre ASCII) sont suivis des tags de combinaison observés (en ordre ASCII). L'ordre physique du fichier IANA et la fréquence d'usage ne sont pas des règles de numérotation.
- L'attribution se fait uniquement par ajout (append-only). Un nouveau tag est ajouté à la fin du bloc ; quand le bloc est plein, il est ajouté dans la plage de débordement. Le tag d'un numéro déjà donné (sans tenir compte de la casse) n'est pas changé, ni supprimé, ni réutilisé.
- Un nouveau tag est introduit en ajoutant ENUM et BIND dans une nouvelle version du document de spécification. Les ENUM et BIND existants ne sont pas modifiés. Ainsi, toute version est un sur-ensemble de la précédente.
- Quand les 65 534 numéros sont tous pris, on n'attribue plus. Les nouveaux tags suivants s'écrivent en LANGUAGE-BCP47-CODE. L'expressivité ne diminue pas ; seul le gain de compression disparaît.
- Même langue : le SHORT-CODE `n` et le LANGUAGE-BCP47-CODE du tag que le registry lie à `n` (sans tenir compte de la casse) désignent la même langue.
- L'édition du registry est la version du document de spécification. Chaque édition consigne le fichier de registry IANA qui lui sert de fondement (File-Date, SHA-256) comme [SOURCE](../edge/0x0C0L-source.md) du HEAD du document de spécification. Quand il faut indiquer l'édition avec laquelle une valeur a été interprétée, on laisse aussi cette version ([CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000`, `0x000007A0`, ID de version `n`)).
- Une spécification de Codec peut contenir ce même code de 1 WORD dans un champ de valeur brute sans TAG ([CODEC](../codec-spec.md#codec) du champ de valeur brute). C'est une règle de cette spécification de Codec ; la wire form d'un Value indépendant est toujours TAG 1 WORD + Payload 1 WORD.

## Fondement normatif {#표준-근거}

- Le sens des tags et la validité des subtags suivent l'[IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) et la [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). L'IANA et l'IETF placent leurs droits sur les registries de protocoles sous CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- Les numéros du registry (attribution append-only en ordre ASCII, composition des blocs, `0x0000`·`0xFFFF` non attribués, liste fermée), le fait que les ENUM du document de spécification soient la représentation officielle, et la distinction avec l'embedding dans un champ de valeur brute sans TAG sont des règles de GEUL.

## Longueur {#길이}

- Le total est exactement 2 WORD, TAG 1 WORD plus Payload 1 WORD, avec la longueur directe `LLLL=0001`. Il n'y a ni TAG d'extension Length, ni descriptor, ni padding.
- On rejette si le Payload n'est pas exactement 1 WORD.

## Exemple {#예시}

Numéros du registry v2 (document de spécification `0x00000000/codecs/0x000007A0` version 2, IANA File-Date 2026-09-17). 8 678 ont été attribués (language 8 275, grandfathered 26, redundant 67, combinaisons observées 310).

| tag | Code | Total de WORD |
|---|---|---|
| `en` | `0x0784` | `07A1 0784` |
| `ko` | `0x0D06` | `07A1 0D06` |
| `zh-Hans` | `0x404C` | `07A1 404C` |
| `pt-BR` | `0x4130` | `07A1 4130` |

- Dans le document de spécification, `en` est `ENUM #2 0x0784` et le `BIND "en"` lié à l'Edge Id de cet ENUM.
- `de-x-formal` (private-use) et `nl-u-sd-bebru` (extension) n'ont pas de numéro et s'écrivent donc en LANGUAGE-BCP47-CODE.

## Problèmes ouverts {#열린-문제}

- Interprétation entre éditions : quand un lecteur rencontre un numéro plus récent que l'édition qu'il possède, faut-il le rejeter comme invalid, ou le traiter comme « code inconnu » en conservant la valeur d'origine ? Comme l'attribution est append-only, la dernière édition suffit toujours, mais il faut une règle pour les décodeurs hors ligne.
- Forme canonique : faut-il (SHOULD/MUST) écrire en SHORT-CODE un tag qui a un numéro ? Avec MUST, la notation est unique, mais quand une nouvelle édition paraît, les documents écrits auparavant cessent d'être en forme canonique.
- Manière de représenter dans le document de spécification les deprecated tag et Preferred-Value (absente de l'édition actuelle).
- Procédure d'ajout des tags de combinaison observés (sources, seuil minimal d'observation).

## Pages liées {#관련-페이지}

- [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md), [LABEL](../edge/0x0A4L-label.md)
- [Document de spécification de Codec](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x000007A0/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007A000000000
#17368 SOURCE #0 #17362
#17369 QUALIFIER P577 #17368 GREGORIAN-DATE(2026-09-17)
#17370 QUALIFIER P813 #17368 GREGORIAN-DATE(2026-10-29)
#17371 QUALIFIER P4092 #17368 SHA-256-DIGEST(0x755FAD43283BE7B41EBE3C89AD054B6EAF928F404F9C0EDB74799E0EAB74BEB1)
#17372 SOURCE #0 Q2013
#17373 QUALIFIER P813 #17372 GREGORIAN-DATE(2026-10-29)
BODY
#1 DECLARE 0x07A0
#2 FIELD #1 0x0001
#3 BIND #1 "LANGUAGE-SHORT-CODE"
#4 BIND #2 "code"
#5 ENUM #2 0x0001
#6 BIND #5 "aa"
#7 ENUM #2 0x0002
#8 BIND #7 "aaa"
#9 ENUM #2 0x0003
#10 BIND #9 "aab"
#11 ENUM #2 0x0004
#12 BIND #11 "aac"
#13 ENUM #2 0x0005
#14 BIND #13 "aad"
… (17346 lignes ENUM·BIND omises)
#17361 REFERENCE-NODE #17362 <https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry>
#17363 TRIPLE P275 #17362 Q6938433 normal
#17364 REFERENCE-NODE #17365 <https://www.iana.org/help/licensing-terms>
#17366 SOURCE #17363 #17365
#17367 QUALIFIER P813 #17366 GREGORIAN-DATE(2026-10-29)
```
