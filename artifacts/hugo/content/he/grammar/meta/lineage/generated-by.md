---
title: "GENERATED-BY"
weight: 51
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "GENERATED-BY היא Meta של שושלת שרושמת את הגורם שיצר את המסמך (אדם, מודל, מנוע כללים) ואת הגרסה שלו."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את הגורם שיצר את המסמך. יכול להיות אדם, מודל או מנוע כללים.

## פריסה

```
TAG WORD          0001 1LLL L011 0010      Codec 0x32
[Length extension TAG]
גורם יוצר         Reference (אדם, מודל, מנוע כללים)
גרסה              Value מסוג UTF8-TEXT, או סמן השמטה 0x0000 (שדה רשות)
```

- Codec: Meta `0x32`, מחלקת שושלת (`011`)
- Payload: Reference מוטמע + טקסט גרסה (רשות)
- מספר: אפשר כמה

## פירוש ותקינות

- אם זה מודל, רושמים גם את גרסת המודל.
- אם הגרסה לא ידועה או שלא מציבים אותה, משמיטים את מקומה וכותבים ABSENT (`0x0000`) ([CODEC](/he/grammar/edge/codec/), שדה רשות). מסמך המפרט של geul.org `0x1832` הוא שני שדות רשומה: agent (בלי CODEC) ו-version (`0840`·`0841`·`0000`).
- הפורמט של [TRANSFORMED-BY](/he/grammar/meta/lineage/transformed-by/) (digest, חובה) מדויק יותר לגרסת המקור של תוכנית. הגרסה ב-GENERATED-BY היא טקסט שרושם דבר שאינו מזהה commit, כמו שם וגרסה של מודל.
- במסמך שפורסם ב-geul.org לא מציבים Reference שמצביע על אדם טבעי ([Issuer ופרסום](/he/grammar/issuer/#פרסום-ב-geulorg)). מצביעים על ארגון או Issuer. חריג: מותר להצביע על אדם טבעי באמצעות [WIKIDATA-QID](/he/grammar/reference/wikidata-qid/).
