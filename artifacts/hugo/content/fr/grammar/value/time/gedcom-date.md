---
title: "GEDCOM-DATE"
weight: 39
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE est une Value qui contient une chaîne de valeur de date GEDCOM 7 et conserve telle qu'écrite une date d'un autre calendrier comme le julien (Codec 0x26/0x27)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE est une Value qui contient une chaîne de valeur de date (`DateValue`) de [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch). Elle conserve **telle qu'écrite** une date que l'origine a notée dans un calendrier autre que le grégorien (julien, etc.).

## Disposition

- Code : code direct de Value `0x26` (nombre d'octets pair) et `0x27` (impair). Famille TIME.
- Le nombre d'octets est fixé par le bit de poids faible du Codec et le nombre de WORD du Payload. C'est `2 × nombre de WORD du Payload − bit de poids faible`, sans Byte Count ([Value](/fr/grammar/value/)).

```
TAG WORD          0000 1LLL L010 011P      Codec 0x26/0x27 (P = nombre d'octets impair)
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1er ... Nème          octets ASCII de la chaîne de date GEDCOM / si impair, dernier 0x00
```

## Interprétation et validité

- La suite d'octets est une chaîne ASCII suivant la grammaire `DateValue` de GEDCOM 7. Une chaîne vide est invalid. GEDCOM admet un `DateValue` vide, mais s'il n'y a pas de valeur, on n'écrit pas l'enregistrement.
- Résumé de la grammaire : `[calendrier] [[jour] mois] année [BCE]`. On peut préfixer `ABT`, `CAL`, `EST` (approximatif), `BEF`, `AFT`, `BET … AND …` (intervalle), `FROM … TO …` (période). Le séparateur est une seule espace.
- Calendriers : `GREGORIAN` (par défaut si omis), `JULIAN`, `FRENCH_R`, `HEBREW`, balises d'extension. Les noms de mois sont fixés par calendrier (le julien a les mêmes `JAN`…`DEC` que le grégorien).
- L'année suit la convention **historique**. Il n'y a pas d'année 0 et l'on ajoute `BCE` avant notre ère (`44 BCE` = 44 av. J.-C.). Elle diffère d'une année de la convention astronomique d'EDTF et de GREGORIAN-DATE.
- Le schema ne vérifie que la forme en octets : ASCII `0x20`~`0x7E`, non vide, sans espace en tête ni en queue. La grammaire et l'existence réelle du jour sont vérifiées par le producteur. Exemple : `gedcom.ParseDate` de `github.com/cacack/gedcom-go/v3` (MIT). Le `Validate` de cette bibliothèque ne vérifie le jour que pour le grégorien et laisse donc passer `JULIAN 30 FEB 1100`, et `ToGregorian` ne convertit pas réellement la précision à l'année ou au mois. La vérification de l'existence de la date et sa normalisation se font à part.
- **Où l'employer :** les dates grégoriennes s'écrivent avec [GREGORIAN-DATE](/fr/grammar/value/time/gregorian-date/) ou [EDTF](/fr/grammar/value/time/edtf/). GEDCOM-DATE s'emploie pour les dates d'autres calendriers dont il faut conserver la notation d'origine.

## L'employer avec une valeur normalisée

- Pour comparer et indexer la même date sur l'axe du temps, il faut une valeur grégorienne. À la précision du jour, c'est la GREGORIAN-DATE du même jour ; à la précision de l'année ou du mois, c'est l'EDTF d'intervalle grégorien de cette période (`JULIAN 1300` → `1300-01-09/1301-01-08`) qui correspond exactement.
- On n'a pas encore fixé comment contenir ensemble en deux Value la notation d'origine (GEDCOM-DATE) et la valeur normalisée (problème ouvert).

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe) et du Payload ([Length](/fr/grammar/record/)).

## Exemple

| Date | Octets | WORD au total |
|---|---|---|
| `JULIAN 1300` | 11 (impair) | `0B27 4a55 4c49 414e 2031 3330 3000` |

## Fondement normatif

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). La licence du dépôt de la spécification est Apache 2.0. GEUL ne fait que référencer le format et ne reproduit pas le texte de la spécification.
- ISO 8601, EDTF, XSD et les identifiants de calendrier CLDR (`u-ca`) n'ont pas le calendrier julien. GEDCOM 7 est un format d'échange public qui traite en une seule grammaire le préfixe de calendrier, l'avant notre ère, la précision et les qualificatifs.

## Problèmes ouverts

- Comment écrire ensemble la notation d'origine et la valeur normalisée (comment relier les deux dans un seul TRIPLE).
- Vérification de la grammaire GEDCOM par le schema.
- Précision au siècle et à la décennie. GEDCOM n'a pas ce format. Les dates de Wikidata qu'on ne peut pas transcrire gardent leur texte d'origine en UTF8-TEXT.

## Pages liées

- [Value](/fr/grammar/value/), [EDTF](/fr/grammar/value/time/edtf/), [GREGORIAN-DATE](/fr/grammar/value/time/gregorian-date/)
