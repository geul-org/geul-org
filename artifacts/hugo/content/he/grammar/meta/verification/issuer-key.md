---
title: "ISSUER-KEY"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ISSUER-KEY היא Meta של אימות שמצהירה על ID של אלגוריתם החתימה ועל המפתח הציבורי של Issuer בהנפקה עצמית (16 WORD)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

מצהירה על המפתח הציבורי של Issuer בהנפקה עצמית (16 WORD). Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID של אלגוריתם ‖ מפתח ציבורי) ([Issuer בן 16 WORD](/he/grammar/issuer/#issuer-בן-16-word)).

## פריסה

```
TAG WORD          0001 1LLL L100 0000      Codec 0x40
[Length extension TAG]
ID של אלגוריתם    WORD אחד (0x0001 = Ed25519)
מפתח ציבורי       הרוחב שהאלגוריתם קובע (Ed25519 16 WORD)
```

- Codec: Meta `0x40`, מחלקת אימות (`100`)
- Payload: ערך גולמי (ID של אלגוריתם + מפתח ציבורי)
- מספר: אפשר כמה (החלפת מפתח)

## פירוש ותקינות

- היא מחלקת אימות ולכן מוצאת מ-hash התוכן.
- Issuer בן 1·2·4 WORD משתמש במפתח שנרשם ב-geul.org, ולכן אין בה צורך.
