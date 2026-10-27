---
title: "REPLACES"
weight: 55
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REPLACES היא Meta של שושלת שרושמת את hash התוכן של הגרסה שנכתבה מחדש (git amend·rebase). הגרסה המקורית אינה נמחקת."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את hash התוכן של הגרסה שנכתבה מחדש (git amend·rebase).

## פריסה

```
TAG WORD          0001 1LLL L011 0110      Codec 0x36
[Length extension TAG]
Payload           Value אחד מסוג SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x36`, מחלקת שושלת (`011`)
- Payload: Value מוטמע ([SHA-256-DIGEST](/he/grammar/value/binary/sha-256-digest/))
- מספר: אפשר כמה

## פירוש ותקינות

- הגרסה המקורית אינה נמחקת (שימור החוק הישן).
- פורמט ה-digest מוטמע כ-Value כדי להשאיר מקום להחלפת אלגוריתם ה-hash. כרגע hash התוכן הוא SHA-256 בלבד.
