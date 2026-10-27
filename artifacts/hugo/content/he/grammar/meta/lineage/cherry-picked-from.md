---
title: "CHERRY-PICKED-FROM"
weight: 53
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "CHERRY-PICKED-FROM היא Meta של שושלת שרושמת את hash התוכן של הגרסה המקורית שממנה נלקח שינוי משושלת אחרת (git cherry-pick -x)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את hash התוכן של הגרסה המקורית שממנה נלקח שינוי משושלת אחרת (git cherry-pick `-x`).

## פריסה

```
TAG WORD          0001 1LLL L011 0100      Codec 0x34
[Length extension TAG]
Payload           Value אחד מסוג SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x34`, מחלקת שושלת (`011`)
- Payload: Value מוטמע ([SHA-256-DIGEST](/he/grammar/value/binary/sha-256-digest/))
- מספר: אפשר כמה

## פירוש ותקינות

- פורמט ה-digest מוטמע כ-Value כדי להשאיר מקום להחלפת אלגוריתם ה-hash. כרגע hash התוכן הוא SHA-256 בלבד.
