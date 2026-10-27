---
title: "DERIVED-FROM"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DERIVED-FROM היא Meta של שושלת שרושמת את המסמך או החומר משושלת אחרת שממנו נגזר המסמך הזה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת שהמסמך הזה נגזר ממסמך או מחומר של שושלת אחרת.

## פריסה

```
TAG WORD          0001 1LLL L011 0001      Codec 0x31
[Length extension TAG]
Payload           Reference, או SHA-256-DIGEST (hash תוכן), או Value מסוג URI
```

- Codec: Meta `0x31`, מחלקת שושלת (`011`)
- Payload: Reference או Value מוטמע
- מספר: אפשר כמה

## פירוש ותקינות

- אם נגזר ממסמך GEUL, מציבים את hash התוכן שלו ([SHA-256-DIGEST](/he/grammar/value/binary/sha-256-digest/)), ואם מחומר חיצוני, מציבים [URI](/he/grammar/value/text/uri/). כדי לנעול את המהדורה של חומר חיצוני באמצעות hash, מצרפים ל-[SOURCE](/he/grammar/edge/source/#מקור-המסמך-כולו) שב-HEAD QUALIFIER של hash הטקסט המקורי (P4092).
- המקור ברמת רשומה הוא תפקידו של Edge הראיה [SOURCE](/he/grammar/edge/source/), והרשומה הישנה לפני העברה, פיצול או איחוד היא תפקידו של QUALIFIER P1365 ב-Edge היעד (הערך הוא ה-Edge Id הישן).
