---
title: "EDTF (0x06EL·0x06FL)"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF est une Value qui porte, sous forme de chaîne de date étendue ISO 8601-2, des dates à précision d'année ou de mois, avant notre ère, incertaines ou en intervalle (Codec 0x06EL/0x06FL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF est une Value qui porte, sous forme de chaîne de date étendue ISO 8601-2, des dates à précision d'année ou de mois, avant notre ère, incertaines ou en intervalle (Codec 0x06EL/0x06FL).

| Élément | Valeur |
|---|---|
| Nom | `EDTF` (groupe pair/impair. Les noms par code figurent dans le tableau des membres ci-dessous) |
| TAG ID | `0x06EL`·`0x06FL` |
| Section | 3 `0011` (Value), offset C dans la section = 14~15 |
| Kind | Value · famille : TIME |
| Description d'index | chaîne de date EDTF (ISO 8601-2). Nombre d'octets pair ou impair. On ne l'utilise pas pour une date qui peut s'écrire en GREGORIAN-DATE |
| Côté Hugo | `value/time/edtf.md` |

## Membres {#구성원}

Cette page traite ensemble deux codes d'une paire pair/impair. Le code pair est la valeur dont le nombre d'octets est pair, le code impair celle dont il est impair ([Enregistrement et TAG WORD](../record.md#가변-길이-바이트열)). Il y a un document de Codec par code. Les champs des deux documents de Codec sont identiques ; seuls cible DECLARE et nom (BIND) diffèrent.

| TAG ID | Nom | Nombre d'octets | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x06EL` | `EDTF-EVEN` | pair | `0x000006E0` | `0x00000000/codecs/0x000006E0/` | `0000 0110 1110 LLLL` |
| `0x06FL` | `EDTF-ODD` | impair | `0x000006F0` | `0x00000000/codecs/0x000006F0/` | `0000 0110 1111 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | valeur brute restante (`0xFFFF`) |  |  |

EDTF est une Value qui porte une date sous forme de chaîne [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (Bibliothèque du Congrès, ISO 8601-2:2019). Elle exprime une précision plus grossière que le jour, une date avant notre ère, l'incertain, l'approximatif ou le partiellement inconnu, et les intervalles.

## Disposition {#레이아웃}

- Code : code direct Value `0x06EL` (nombre d'octets pair) · `0x06FL` (nombre d'octets impair). Famille TIME. Le Payload est une chaîne, mais on le place dans la famille TIME.
- Le nombre d'octets est déterminé par le bit de poids faible du Codec et par le nombre de WORD du Payload. C'est `2 × nombre de WORD du Payload − bit de poids faible`, et il n'y a pas de Byte Count ([Value](_index.md)).

```
TAG WORD          0000 0110 111P LLLL      Codec 0x06EL/0x06FL (P = nombre d'octets impair)
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1st ... Nth          octets ASCII de la chaîne EDTF / si impair, dernier 0x00
```

## Interprétation et validité {#해석과-유효성}

- La suite d'octets est une chaîne ASCII conforme à la grammaire EDTF Level 0·1·2. Une chaîne vide est invalid.
- Exemples : jour `1952-03-11`, mois `1952-03`, année `1952`, décennie `195X`, 44 av. J.-C. `-0043`, incertain `1974?`, approximatif `~1974`, intervalle `1952/2001`, grande année `Y-13799999999`.
- Les années suivent la notation astronomique de l'ISO 8601. `0000` est 1 av. J.-C., `-0043` est 44 av. J.-C. Lorsqu'on transpose depuis une notation historique, on décale d'une année.
- C'est le calendrier grégorien. EDTF ne traite pas d'autres calendriers. La notation d'origine d'un autre calendrier, tel le calendrier julien, est conservée dans [GEDCOM-DATE](0x070L-gedcom-date.md). La valeur qui transpose le même jour ou la même période de cette date en calendrier grégorien peut s'écrire en EDTF ou en GREGORIAN-DATE.
- **Forme canonique :** une date qui peut s'écrire exactement en [GREGORIAN-DATE](0x06AL-gregorian-date.md), c'est-à-dire `[-]YYYY-MM-DD` sans qualificateur (`?`, `~`, `%`), sans chiffre inconnu (`X`), sans intervalle ni préfixe `Y`, s'écrit en GREGORIAN-DATE. Écrire une telle date en EDTF est invalid. Ce n'est que si un même jour n'est écrit que dans un seul format qu'on peut l'indexer et le comparer comme un temps.
- Le schema ne vérifie pas encore la grammaire EDTF. Le producteur la vérifie avec un analyseur EDTF. Par exemple `parser.ParseString` de `github.com/sfomuseum/go-edtf` (BSD-3-Clause). `parser.IsValid` ne regarde que la grammaire et laisse passer `2023-02-29` et `1974-13` ; on ne l'utilise donc pas. Cet analyseur ne prend pas encore en charge les années à préfixe `Y`.

## Longueur {#길이}

- Le total est le nombre de WORD du TAG (1 WORD), du TAG d'extension de Length (s'il existe) et du Payload ([Length](../record.md)).

## Exemple {#예시}

| Date | Octets | WORD au total |
|---|---|---|
| `1974` | 4 (pair) | `06E2 3139 3734` |
| `197X` | 4 (pair) | `06E2 3139 3758` |
| `1952-03` | 7 (impair) | `06F4 3139 3532 2D30 3300` |

## Fondement normatif {#표준-근거}

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). Le Level 0 est un sous-ensemble de l'ISO 8601-1, les Level 1·2 sont des fonctionnalités de l'ISO 8601-2.
- En RDF, la même chaîne est indiquée par le datatype `http://id.loc.gov/datatypes/edtf`.

## Problèmes ouverts {#열린-문제}

- Vérification de la grammaire EDTF par le vérificateur (si le vérificateur s'appuie ou non sur une bibliothèque externe).
- Règle de transposition des précisions siècle et millénaire de Wikidata en chiffres inconnus EDTF.

## Pages liées {#관련-페이지}

- [Value](_index.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md), [GEDCOM-DATE](0x070L-gedcom-date.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x000006E0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006E000000000
BODY
#1 DECLARE 0x06E0
#2 FIELD #1 rest
#3 BIND #1 "EDTF-EVEN"
#4 BIND #2 "bytes"
```

Ce qui précède est le document de Codec de `EDTF-EVEN` (`0x06EL`). Pour l'autre membre (`EDTF-ODD`), le document de Codec ne diffère que par le Codec ID du DOC-ID, la cible DECLARE et le nom lié (BIND) en `#1`.
