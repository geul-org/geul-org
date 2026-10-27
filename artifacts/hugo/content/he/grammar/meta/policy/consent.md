---
title: "CONSENT"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "CONSENT היא Meta של מדיניות שרושמת את היקף ההסכמה ובסיסה כ-Reference או כטקסט."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת את היקף ההסכמה ובסיסה.

## פריסה

```
TAG WORD          0001 1LLL L101 0100      Codec 0x54
[Length extension TAG]
Payload           Reference או טקסט שמצביע על בסיס ההסכמה
```

- Codec: Meta `0x54`, מחלקת מדיניות (`101`)
- Payload: Reference או Value מוטמע
- מספר: אפשר כמה

## שאלות פתוחות

- מבנה הביטוי של ההיקף (מטרה, תקופה, מסירה לצד שלישי).
