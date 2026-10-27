---
title: "RECORDED-BY"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-BY היא Meta של מוצא שרושמת כ-Reference את מי שתיעד את המסמך (git committer)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את מי שתיעד את המסמך (git committer).

## פריסה

```
TAG WORD          0001 1LLL L010 0100      Codec 0x24
[Length extension TAG]
Payload           רשומת Reference אחת (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL וכד')
```

- Codec: Meta `0x24`, מחלקת מוצא (`010`)
- Payload: Reference מוטמע
- מספר: לכל היותר אחד

## פירוש ותקינות

- ה-Reference אינו תלוי ב-Codec. הוא יכול להיות אדם, ארגון, מודל או מנוע כללים ([EXTERNAL-ISSUER](/he/grammar/reference/external-issuer/), [GEUL](/he/grammar/reference/geul/), [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/), [LOCAL](/he/grammar/reference/local/) וכד').
- במסמך שפורסם ב-geul.org לא מציבים Reference שמצביע על אדם טבעי ([Issuer ופרסום](/he/grammar/issuer/#פרסום-ב-geulorg)). מצביעים על ארגון או Issuer. חריג: מותר להצביע על אדם טבעי באמצעות [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/).
- אם זה LOCAL, היעד מתואר ב-BODY.
