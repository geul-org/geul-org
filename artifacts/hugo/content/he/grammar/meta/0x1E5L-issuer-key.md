---
title: "ISSUER-KEY (0x1E5L)"
weight: 485
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "מצהיר על המפתח הציבורי של Issuer שהונפק עצמית (16 WORD)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `ISSUER-KEY` (BIND של מסמך מפרט: `ISSUER-KEY`) |
| TAG ID | `0x1E5L` |
| Codec ID | `0x00001E50` |
| מסמך מפרט | `0x00000000/codecs/0x00001E50/` (יעד DECLARE: `1E50`) |
| קטע | 15 `1111` (Meta), היסט C בתוך הקטע = 5 |
| Kind | Meta · מחלקה: אימות |
| TAG WORD | `0001 1110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | הצהרה על מזהה אלגוריתם החתימה ועל המפתח הציבורי של Issuer שהונפק עצמית |
| בצד Hugo | `meta/verification/issuer-key.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | ערך גולמי, 1 WORD |  | `0x0001` ed25519 |
| 2 | `key` | #3 | ערך גולמי לכל השאר (`0xFFFF`) |  |  |

מצהיר על המפתח הציבורי של Issuer שהונפק עצמית (16 WORD). Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ מזהה אלגוריתם ‖ מפתח ציבורי) ([Issuer של 16 WORD](../issuer.md#16-word-issuer)).

## פריסה {#레이아웃}

```
TAG WORD          0001 1110 0101 LLLL      Codec 0x1E5L
[TAG הרחבה של Length]
מזהה אלגוריתם     WORD אחד (0x0001 = Ed25519)
מפתח ציבורי       הרוחב נקבע לפי האלגוריתם (Ed25519: 16 WORD)
```

- Codec: Meta `0x1E5L`, מחלקת אימות
- Payload: ערך גולמי (מזהה אלגוריתם + מפתח ציבורי)
- מספר: אפשר כמה (החלפת מפתח)

## פירוש ותוקף {#해석과-유효성}

- מכיוון שזו מחלקת אימות, היא אינה נכללת ב-hash התוכן.
- Issuer של 2 ו-4 WORD משתמשים במפתח שנרשם ב-geul.org, ולכן אין בהם צורך.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001E50/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E5000000000
BODY
#1 DECLARE 0x1E50
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 ENUM #2 0x0001
#5 BIND #1 "ISSUER-KEY"
#6 BIND #2 "algorithm"
#7 BIND #3 "key"
#8 BIND #4 "ed25519"
```
