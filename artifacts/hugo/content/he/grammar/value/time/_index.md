---
title: "Value — זמן"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "פורמטי תאריך ושעה של משפחת TIME (Codec `0x20`~`0x3F`, מספרי פורמט `0x4000`~`0x7FFF`): תאריך בלוח גרגוריאני, חותמת זמן, זמן שחלף, EDTF ותאריך GEDCOM."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

משפחת TIME היא פורמטים של תאריך ושעה. היא מוצבת בקודים ישירים `0x20`~`0x3F` ובמספרי פורמט Issuer `0x4000`~`0x7FFF`.

| דיוק | פורמט |
|---|---|
| תאריך (לוח גרגוריאני) | GREGORIAN-DATE |
| שנה·חודש, אי-ודאות, קטע | EDTF |
| כתיב מקורי של לוח שנה אחר (יוליאני וכד') | GEDCOM-DATE |
| שעה | חותמות זמן POSIX·TAI·GPS |
| זמן שחלף | DURATION-SECONDS, DURATION-NANOSECONDS |

- תאריך שאפשר לכתוב ב-GREGORIAN-DATE לא נכתב ב-EDTF.
- חותמת זמן בננו-שניות ופורמטי TAI·GPS הם פורמטים תחת ה-Issuer של גופי התקינה (IEEE, BIPM, GPS).
