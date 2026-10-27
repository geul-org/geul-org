---
title: "Value — Zeit"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "Die Datums- und Zeitformate der TIME-Familie (Codec `0x20`~`0x3F`, Formatnummern `0x4000`~`0x7FFF`): gregorianisches Datum, Zeitstempel, Dauer, EDTF, GEDCOM-Datum."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die TIME-Familie umfasst Datums- und Zeitformate. Sie liegen bei den direkten Codes `0x20`~`0x3F` und den Issuer-Formatnummern `0x4000`~`0x7FFF`.

| Genauigkeit | Format |
|---|---|
| Datum (gregorianischer Kalender) | GREGORIAN-DATE |
| Jahr/Monat, unsicher, Intervall | EDTF |
| Originalschreibweise eines anderen Kalenders (Julianisch usw.) | GEDCOM-DATE |
| Uhrzeit | POSIX-, TAI- und GPS-Zeitstempel |
| Verstrichene Zeit | DURATION-SECONDS, DURATION-NANOSECONDS |

- Ein Datum, das sich als GREGORIAN-DATE schreiben lässt, wird nicht als EDTF geschrieben.
- Nanosekunden-Zeitstempel sowie TAI- und GPS-Formate sind Formate unter dem Issuer der jeweiligen Normungsorganisation (IEEE, BIPM, GPS).
