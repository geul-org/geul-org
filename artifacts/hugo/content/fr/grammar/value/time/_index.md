---
title: "Value — Temps"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "Formats de date et d'heure de la famille TIME (Codec `0x20`~`0x3F`, numéros de format `0x4000`~`0x7FFF`) : date grégorienne, horodatages, durées, EDTF, dates GEDCOM."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La famille TIME regroupe les formats de date et d'heure. Elle se place dans les codes directs `0x20`~`0x3F` et les numéros de format d'Issuer `0x4000`~`0x7FFF`.

| Précision | Format |
|---|---|
| Date (calendrier grégorien) | GREGORIAN-DATE |
| Année ou mois, incertitude, intervalle | EDTF |
| Notation d'origine d'un autre calendrier (julien, etc.) | GEDCOM-DATE |
| Heure | Horodatages POSIX, TAI, GPS |
| Durée écoulée | DURATION-SECONDS, DURATION-NANOSECONDS |

- Une date exprimable en GREGORIAN-DATE ne s'écrit pas en EDTF.
- Les horodatages en nanosecondes et les formats TAI et GPS sont des formats sous les Issuer des organismes de normalisation correspondants (IEEE, BIPM, GPS).
