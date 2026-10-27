---
title: "CO-AUTHOR"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CO-AUTHOR היא Meta של מוצא שרושמת כ-Reference את מי שכתב את המסמך יחד עם אחרים (git Co-authored-by)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את מי שכתב את המסמך יחד עם אחרים (git `Co-authored-by`).

## פריסה

```
TAG WORD          0001 1LLL L010 0001      Codec 0x21
[Length extension TAG]
Payload           רשומת Reference אחת (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL וכד')
```

- Codec: Meta `0x21`, מחלקת מוצא (`010`)
- Payload: Reference מוטמע
- מספר: אפשר כמה

## פירוש ותקינות

- ה-Reference אינו תלוי ב-Codec. הוא יכול להיות אדם, ארגון, מודל או מנוע כללים ([EXTERNAL-ISSUER](/he/grammar/reference/external-issuer/), [GEUL](/he/grammar/reference/geul/), [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/), [LOCAL](/he/grammar/reference/local/) וכד').
- במסמך שפורסם ב-geul.org לא מציבים Reference שמצביע על אדם טבעי ([Issuer ופרסום](/he/grammar/issuer/#פרסום-ב-geulorg)). מצביעים על ארגון או Issuer. חריג: מותר להצביע על אדם טבעי באמצעות [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/).
- אם זה LOCAL, היעד מתואר ב-BODY.
