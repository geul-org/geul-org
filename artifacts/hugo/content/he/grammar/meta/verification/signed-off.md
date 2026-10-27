---
title: "SIGNED-OFF"
weight: 67
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNED-OFF היא Meta של אימות שרושמת כ-Reference אישור זכות התרומה (git Signed-off-by, DCO)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

אישור זכות התרומה (git `Signed-off-by`, DCO).

## פריסה

```
TAG WORD          0001 1LLL L100 0010      Codec 0x42
[Length extension TAG]
Payload           Reference אחד
```

- Codec: Meta `0x42`, מחלקת אימות (`100`)
- Payload: Reference מוטמע
- מספר: אפשר כמה

## פירוש ותקינות

- במסמך שפורסם ב-geul.org לא מציבים Reference שמצביע על אדם טבעי ([Issuer ופרסום](/he/grammar/issuer/#פרסום-ב-geulorg)). מצביעים על ארגון או Issuer. חריג: מותר להצביע על אדם טבעי באמצעות [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/).
