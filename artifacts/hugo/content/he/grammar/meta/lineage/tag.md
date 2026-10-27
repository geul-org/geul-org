---
title: "TAG"
weight: 58
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TAG היא Meta של שושלת שרושמת שם בלתי משתנה שניתן לגרסה (git annotated tag)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

רושמת שם בלתי משתנה שניתן לגרסה (git annotated tag).

## פריסה

```
TAG WORD          0001 1LLL L011 1001      Codec 0x39
[Length extension TAG]
שם                Value מסוג UTF8-TEXT-*
יעד               Value מסוג SHA-256-DIGEST, או סמן השמטה 0x0000 (שדה רשות). אם משמיטים, זו הגרסה הזו
```

- Codec: Meta `0x39`, מחלקת שושלת (`011`)
- Payload: Value מוטמע (טקסט + hash תוכן רשותי)
- מספר: אפשר כמה

## פירוש ותקינות

- השם הוא [UTF8-TEXT](/he/grammar/value/text/utf8-text/) והיעד הוא [SHA-256-DIGEST](/he/grammar/value/binary/sha-256-digest/).
- אם משמיטים את היעד (ABSENT `0x0000`, [CODEC](/he/grammar/edge/codec/), שדה רשות), זהו שם שניתן למסמך עצמו. hash התוכן של המסמך אי אפשר לכתוב בתוכו. מסמך המפרט של geul.org `0x1839` הוא שני שדות רשומה: name (`0840`·`0841`) ו-target (`0861`·`0000`).
- אותו שם לא משתמשים בו שוב לגרסה אחרת.

## דוגמה

- שם `v1`, הגרסה הזו: `19B9 08C0 7631 0000`

## שאלות פתוחות

- האם TAG נחוץ בכלל כשיש מזהה גרסה (מספר סידורי), וחלוקת התפקידים בינו ובין שם המסמך (`BIND`).
