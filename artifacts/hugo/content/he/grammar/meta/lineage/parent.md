---
title: "PARENT"
weight: 49
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "PARENT היא Meta של שושלת שרושמת את hash התוכן של הגרסה הקודמת הישירה (git parent). אם יש כמה, זהו מיזוג."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את hash התוכן של הגרסה הקודמת הישירה (git parent).

## פריסה

```
TAG WORD          0001 1LLL L011 0000      Codec 0x30
[Length extension TAG]
Payload           Value אחד מסוג SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x30`, מחלקת שושלת (`011`)
- Payload: Value מוטמע ([SHA-256-DIGEST](/he/grammar/value/binary/sha-256-digest/))
- מספר: אפשר כמה (מיזוג)

## פירוש ותקינות

- אם אין, זו הגרסה הראשונה, ואם יש כמה, זהו מיזוג (git merge commit).
- מכיוון שהיא נכללת ב-[hash התוכן](/he/grammar/document/#hash-תוכן), ההיסטוריה כולה הופכת לשרשרת hash.
- מסמך רשימת גרסאות מצביע על מסמך הרשימה הקודם הישיר ([PUBLICATION](/he/grammar/edge/publication/)).
- פורמט ה-digest מוטמע כ-Value כדי להשאיר מקום להחלפת אלגוריתם ה-hash. כרגע hash התוכן הוא SHA-256 בלבד.

## דוגמה

- `0x1F30 0x0014 0x0F61 0x0012 <16 WORD>` (Meta של 20 WORD = TAG + הרחבת Length + Value מוטמע של 18 WORD)
