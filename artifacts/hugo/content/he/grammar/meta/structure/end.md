---
title: "END"
weight: 16
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "END היא Meta של מבנה בת WORD אחד, שסוגרת את המסמך. היא חובה בכל מסמך."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

הרשומה שסוגרת את המסמך.

## פריסה

```
TAG WORD          0001 1LLL L000 1111      Codec 0x0F
[Length extension TAG]
```

- Codec: Meta `0x0F`, מחלקת מבנה (`000`)
- Payload: אין (WORD אחד)
- מספר: אחד לכל מסמך, בסוף

## פירוש ותקינות

- היא חובה. המיקום שלה מאומת לפי האורך של [DOC](/he/grammar/meta/structure/doc/) (`DOC-*`).
- אם הקלט נגמר בלי END, המסמך קטוע. אם לראות בתוכן של מסמך קטוע תקף, זו מדיניות של המפענח.
- אחריה לא בא דבר.

## דוגמה

- `0x180F`
