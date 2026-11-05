---
title: "GEDCOM-DATE (0x070L·0x071L)"
weight: 112
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE est un Value qui conserve tel quel, sous forme de chaîne de valeur de date GEDCOM 7, une date d'un autre calendrier, comme le calendrier julien (Codec 0x070L/0x071L)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE est un Value qui conserve tel quel, sous forme de chaîne de valeur de date GEDCOM 7, une date d'un autre calendrier, comme le calendrier julien (Codec 0x070L/0x071L).

| Élément | Valeur |
|---|---|
| Nom | `GEDCOM-DATE` (groupe pair/impair. Le nom de chaque code figure dans le tableau des membres ci-dessous) |
| TAG ID | `0x070L`·`0x071L` |
| Section | 3 `0011` (Value), décalage dans la section C = 16~17 |
| Kind | Value · famille : TIME |
| Description de l'index | Chaîne de valeur de date GEDCOM 7. Conserve la notation d'origine des autres calendriers (julien, etc.). Octets pairs·impairs |
| Côté Hugo | `value/time/gedcom-date.md` |

## Membres {#구성원}

Cette page traite ensemble deux codes formant une paire pair/impair. Le code pair correspond à un nombre d'octets pair, le code impair à un nombre d'octets impair ([Enregistrement et TAG WORD](../record.md#가변-길이-바이트열)). Il y a un document de Codec par code. Les champs des deux documents de Codec sont identiques ; seuls la cible de DECLARE et le nom (BIND) diffèrent.

| TAG ID | Nom | Nombre d'octets | Codec ID | Document de spécification | TAG WORD |
|---|---|---|---|---|---|
| `0x070L` | `GEDCOM-DATE-EVEN` | pair | `0x00000700` | `0x00000000/codecs/0x00000700/` | `0000 0111 0000 LLLL` |
| `0x071L` | `GEDCOM-DATE-ODD` | impair | `0x00000710` | `0x00000000/codecs/0x00000710/` | `0000 0111 0001 LLLL` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | reste de valeur brute (`0xFFFF`) |  |  |

GEDCOM-DATE est un Value qui contient la chaîne de valeur de date (`DateValue`) de [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch). Il conserve **tel qu'écrit** une date que la source a notée dans un calendrier autre que grégorien (julien, etc.).

## Disposition {#레이아웃}

- Code : codes directs de Value `0x070L` (octets pairs) · `0x071L` (octets impairs). Famille TIME.
- Le nombre d'octets est déterminé par le bit de poids faible du Codec et par le nombre de WORD du Payload. Il vaut `2 × nombre de WORD du Payload − bit de poids faible`, et il n'y a pas de Byte Count ([Value](_index.md)).

```
TAG WORD          0000 0111 000P LLLL      Codec 0x070L/0x071L (P = octets impairs)
[TAG d'extension Length] si le total atteint 15 WORD ou plus
Payload WORD 1st ... Nth          octets ASCII de la chaîne de date GEDCOM / si impair, dernier 0x00
```

## Interprétation et validité {#해석과-유효성}

- La suite d'octets est une chaîne ASCII conforme à la grammaire `DateValue` de GEDCOM 7. La chaîne vide est invalid. GEDCOM autorise un `DateValue` vide, mais s'il n'y a pas de valeur, on n'écrit pas l'enregistrement.
- Grammaire en bref : `[calendrier] [[jour] mois] année [BCE]`. On fait précéder de `ABT`·`CAL`·`EST` (approximatif), `BEF`·`AFT`·`BET … AND …` (intervalle), `FROM … TO …` (période). Le séparateur est une seule espace.
- Calendriers : `GREGORIAN` (par défaut si omis), `JULIAN`, `FRENCH_R`, `HEBREW`, TAG d'extension. Les noms de mois sont fixés par calendrier (le calendrier julien utilise les mêmes `JAN`…`DEC` que le grégorien).
- L'année est de **style historique**. Il n'y a pas d'année 0, et les années avant notre ère portent `BCE` (`44 BCE` = 44 avant notre ère). Elle diffère d'un an du style astronomique d'EDTF et de GREGORIAN-DATE.
- Le schema ne vérifie que le format des octets : ASCII `0x20`~`0x7E`, non vide, sans espace en début ni en fin. La grammaire et l'existence réelle du jour sont vérifiées par le producteur. Exemple : `gedcom.ParseDate` de `github.com/cacack/gedcom-go/v3` (MIT). Le `Validate` de cette bibliothèque ne vérifie le jour que dans le calendrier grégorien et laisse donc passer `JULIAN 30 FEB 1100`, et `ToGregorian` ne convertit pas réellement les précisions année·mois. La vérification de l'existence de la date et la normalisation se font séparément.
- **Où l'utiliser :** une date grégorienne s'écrit en [GREGORIAN-DATE](0x06AL-gregorian-date.md) ou en [EDTF](0x06EL-edtf.md). GEDCOM-DATE s'utilise pour les dates d'autres calendriers dont il faut conserver la notation d'origine.

## Utilisation avec une valeur normalisée {#정규화된-값과-함께-쓰기}

- Pour comparer et indexer la même date sur l'axe du temps, une valeur grégorienne est nécessaire. En précision au jour, la correspondance exacte est le GREGORIAN-DATE du même jour ; en précision année·mois, c'est l'EDTF d'intervalle grégorien de cette période (`JULIAN 1300` → `1300-01-09/1301-01-08`).
- La manière de porter ensemble la notation d'origine (GEDCOM-DATE) et la valeur normalisée dans deux Value n'est pas encore fixée (problème ouvert).

## Longueur {#길이}

- Le total est le nombre de WORD : TAG 1 WORD, plus le TAG d'extension Length (s'il existe) et le Payload ([Length](../record.md)).

## Exemple {#예시}

| Date | Octets | Total de WORD |
|---|---|---|
| `JULIAN 1300` | 11 (impair) | `0716 4A55 4C49 414E 2031 3330 3000` |

## Fondement normatif {#표준-근거}

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). Le dépôt de la spécification est sous licence Apache 2.0. GEUL ne fait que référencer le format et ne reproduit pas le texte de la spécification.
- ISO 8601, EDTF, XSD et les identifiants de calendrier CLDR (`u-ca`) ne comportent pas le calendrier julien. GEDCOM 7 est un format d'échange public qui traite en une seule grammaire le préfixe de calendrier, les années avant notre ère, la précision et les qualificateurs.

## Problèmes ouverts {#열린-문제}

- Manière de porter ensemble la notation d'origine et la valeur normalisée (manière de relier les deux dans un seul TRIPLE).
- Vérification de la grammaire GEDCOM par le schema.
- Précision au siècle·à la décennie. GEDCOM n'a pas de format correspondant. Les dates qui ne peuvent pas être transposées depuis Wikidata gardent leur texte d'origine en UTF8-TEXT.

## Pages liées {#관련-페이지}

- [Value](_index.md), [EDTF](0x06EL-edtf.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x00000700/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000070000000000
BODY
#1 DECLARE 0x0700
#2 FIELD #1 rest
#3 BIND #1 "GEDCOM-DATE-EVEN"
#4 BIND #2 "bytes"
```

Ce qui précède est le document de Codec de `GEDCOM-DATE-EVEN` (`0x070L`). Le document de Codec de l'autre membre (`GEDCOM-DATE-ODD`) ne diffère que par le Codec ID dans le DOC-ID, la cible de DECLARE et le nom lié en `#1` (BIND).
