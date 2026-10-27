---
title: "DEFAULT-LANGUAGE"
weight: 23
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DEFAULT-LANGUAGE היא Meta של הצהרה שמצהירה על שפת ברירת המחדל של טקסט המסמך כ-Value של שפה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

מצהירה על שפת ברירת המחדל של טקסט המסמך. טקסט שלא צוינה לו שפה הוא בשפה הזו.

## פריסה

```
TAG WORD          0001 1LLL L001 0110      Codec 0x16
[Length extension TAG]
Payload           Value אחד של שפה
```

- Codec: Meta `0x16`, מחלקת הצהרה (`001`)
- Payload: Value מוטמע ([LANGUAGE-BCP47-CODE](/he/grammar/value/text/language-bcp47-code/) או [LANGUAGE-SHORT-CODE](/he/grammar/value/text/language-short-code/))
- מספר: לכל היותר אחד

## פירוש ותקינות

- מסמך TANGEUL רושם את לוקאל הכתיבה (למשל `en`, `ko`).

## דוגמה

- `en`: `0x1916 0x08C6 0x656E`
