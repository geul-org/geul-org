---
title: "SPEC-VERSION"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "SPEC-VERSION היא Meta של הצהרה שמצהירה במספר שלם אחד על גרסת מפרט GEUL שהמסמך מציית לה. GEUL v1 היא 0x0001."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

מצהירה על גרסת מפרט GEUL שהמסמך מציית לה. הערך הזה קובע איך לקרוא את שאר הרשומות.

## פריסה

```
TAG WORD          0001 1LLL L001 0000      Codec 0x10
[Length extension TAG]
Payload           גרסת המפרט. v1 = 0x0001
```

- Codec: Meta `0x10`, מחלקת הצהרה (`001`)
- Payload: ערך גולמי (מספר שלם unsigned ברוחב הקצר ביותר)
- מספר: לכל היותר אחד

## פירוש ותקינות

- אינה נשענת על קוד Value. כדי שמפענח מכל גרסה יוכל לקרוא אותה, היא מכילה מספר שלם בלבד בלי Value מוטמע.
- אם הגרסה לא מוכרת, המפענח דוחה או מזהיר.
- אם אין, המפענח קורא לפי הגרסה שהוא מכיר. מסמך שפורסם כותב אותה.

## דוגמה

- `0x1890 0x0001`: GEUL v1

## שאלות פתוחות

- ההתאמה לגרסת מסמך ה-codebook ([מסמך מפרט](/he/grammar/codec-spec/)).
