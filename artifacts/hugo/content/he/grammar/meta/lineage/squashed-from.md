---
title: "SQUASHED-FROM"
weight: 56
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "SQUASHED-FROM היא Meta של שושלת שרושמת את hash התוכן של הגרסאות המקוריות שאוחדו לאחת (git squash)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את hash התוכן של הגרסאות המקוריות שאוחדו לאחת (git squash).

## פריסה

```
TAG WORD          0001 1LLL L011 0111      Codec 0x37
[Length extension TAG]
Payload           Value אחד מסוג SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x37`, מחלקת שושלת (`011`)
- Payload: Value מוטמע ([SHA-256-DIGEST](/he/grammar/value/binary/sha-256-digest/))
- מספר: אפשר כמה (אחד לכל גרסה מקורית)

## פירוש ותקינות

- פורמט ה-digest מוטמע כ-Value כדי להשאיר מקום להחלפת אלגוריתם ה-hash. כרגע hash התוכן הוא SHA-256 בלבד.
