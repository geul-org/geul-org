---
title: "EDTF"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF est une Value qui contient une date sous forme de chaîne étendue ISO 8601-2 : précision à l'année ou au mois, avant notre ère, incertitude, intervalle (Codec 0x24/0x25)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF est une Value qui contient une date sous forme de chaîne [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (Bibliothèque du Congrès, ISO 8601-2:2019). Il exprime une précision plus grossière que le jour, les dates avant notre ère, l'incertitude, l'approximation, l'inconnu partiel et les intervalles.

## Disposition

- Code : code direct de Value `0x24` (nombre d'octets pair) et `0x25` (impair). Famille TIME. Le Payload est une chaîne, mais on la place dans la famille TIME pour que les décodeurs et les index la traitent comme une valeur de temps sans connaître le format.
- Le nombre d'octets est fixé par le bit de poids faible du Codec et le nombre de WORD du Payload. C'est `2 × nombre de WORD du Payload − bit de poids faible`, sans Byte Count ([Value](/fr/grammar/value/)).

```
TAG WORD          0000 1LLL L010 010P      Codec 0x24/0x25 (P = nombre d'octets impair)
[TAG d'extension de Length] à partir de 15 WORD au total
Payload WORD 1er ... Nème          octets ASCII de la chaîne EDTF / si impair, dernier 0x00
```

## Interprétation et validité

- La suite d'octets est une chaîne ASCII suivant la grammaire EDTF Level 0, 1 et 2. Une chaîne vide est invalid.
- Exemples : jour `1952-03-11`, mois `1952-03`, année `1952`, décennie `195X`, 44 av. J.-C. `-0043`, incertain `1974?`, approximatif `~1974`, intervalle `1952/2001`, grande année `Y-13799999999`.
- L'année est selon la convention astronomique d'ISO 8601. `0000` est l'an 1 av. J.-C., `-0043` l'an 44 av. J.-C. En transcrivant depuis une notation historique, on décale d'une année.
- C'est le calendrier grégorien. EDTF ne traite pas d'autres calendriers. La notation d'origine d'un autre calendrier comme le julien se conserve avec [GEDCOM-DATE](/fr/grammar/value/time/gedcom-date/). La valeur de ce même jour ou de cette même période convertie en grégorien peut s'écrire en EDTF ou GREGORIAN-DATE.
- **Forme canonique :** une date qu'on peut écrire exactement en [GREGORIAN-DATE](/fr/grammar/value/time/gregorian-date/), c'est-à-dire `[-]YYYY-MM-DD` sans qualificatif (`?`, `~`, `%`), sans chiffres inconnus (`X`), sans intervalle et sans préfixe `Y`, s'écrit en GREGORIAN-DATE. Écrire une telle date en EDTF est invalid. Ce n'est que si un même jour n'est écrit que dans un seul format qu'on peut l'indexer et le comparer comme temps.
- Le schema ne vérifie pas encore la grammaire EDTF. Le producteur la vérifie avec un analyseur EDTF. Exemple : `parser.ParseString` de `github.com/sfomuseum/go-edtf` (BSD-3-Clause). `parser.IsValid` ne regarde que la grammaire et laisse donc passer `2023-02-29` et `1974-13`, on ne l'emploie pas. Cet analyseur ne prend pas encore en charge les années à préfixe `Y`.

## Longueur

- Le total est le nombre de WORD du TAG de 1 WORD, du TAG d'extension de Length (s'il existe) et du Payload ([Length](/fr/grammar/record/)).

## Exemple

| Date | Octets | WORD au total |
|---|---|---|
| `1974` | 4 (pair) | `0924 3139 3734` |
| `197X` | 4 (pair) | `0924 3139 3758` |
| `1952-03` | 7 (impair) | `0A25 3139 3532 2d30 3300` |

## Fondement normatif

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). Le Level 0 est un sous-ensemble d'ISO 8601-1, les Level 1 et 2 sont des fonctions d'ISO 8601-2.
- En RDF, la même chaîne s'indique par le type de données `http://id.loc.gov/datatypes/edtf`.

## Problèmes ouverts

- Vérification de la grammaire EDTF par le vérificateur (s'il s'appuie ou non sur une bibliothèque externe).
- Règle pour transcrire la précision au siècle et au millénaire de Wikidata en chiffres inconnus d'EDTF.

## Pages liées

- [Value](/fr/grammar/value/), [GREGORIAN-DATE](/fr/grammar/value/time/gregorian-date/), [GEDCOM-DATE](/fr/grammar/value/time/gedcom-date/)
