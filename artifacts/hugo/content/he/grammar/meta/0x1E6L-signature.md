---
title: "SIGNATURE (0x1E6L)"
weight: 486
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "חתימה על hash התוכן של המסמך (commit או tag חתומים ב-git)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `SIGNATURE` (BIND של מסמך מפרט: `SIGNATURE`) |
| TAG ID | `0x1E6L` |
| Codec ID | `0x00001E60` |
| מסמך מפרט | `0x00000000/codecs/0x00001E60/` (יעד DECLARE: `1E60`) |
| קטע | 15 `1111` (Meta), היסט C בתוך הקטע = 6 |
| Kind | Meta · מחלקה: אימות |
| TAG WORD | `0001 1110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | חתימה על יעד. חתימה על מסמך חותמת את hash התוכן (commit או tag חתומים ב-git) |
| בצד Hugo | `meta/verification/signature.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | ערך גולמי, 1 WORD |  | `0x0001` ed25519 |
| 2 | `signer` | #3 | רשומה | `0400` ISSUER-POINTER |  |
| 3 | `signature` | #4 | ערך גולמי לכל השאר (`0xFFFF`) |  |  |

חתימה על hash התוכן של המסמך (commit או tag חתומים ב-git).

## פריסה {#레이아웃}

```
TAG WORD          0001 1110 0110 LLLL      Codec 0x1E6L
[TAG הרחבה של Length]
מזהה אלגוריתם     WORD אחד (0x0001 = Ed25519)
החותם             רשומת Reference מסוג ISSUER-POINTER (Issuer)
חתימה             כל השאר. הרוחב נקבע לפי האלגוריתם (Ed25519: 32 WORD)
```

- Codec: Meta `0x1E6L`, מחלקת אימות
- Payload: מזהה אלגוריתם (ערך גולמי של WORD אחד) + החותם (Reference מובנה) + חתימה (ערך גולמי, הנותר)
- מספר: אפשר כמה

## פירוש ותוקף {#해석과-유효성}

- היעד לחתימה הוא hash התוכן. לא חותמים על ה-BODY בלבד ([חתימה](../issuer.md#서명)).
- מכיוון שזו מחלקת אימות, היא אינה נכללת ב-hash התוכן. הוספת חתימה אינה משנה את ה-hash.
- האימות הוא “חייבת להיות חתימה של המפתח שנקבע” ולא “אם יש חתימה, בודקים אותה”.
- מסמך רשימת גרסאות נחתם על ידי המפרסם.
- החותם הוא [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) (Issuer) שמצביע על ה-Issuer עצמו. מכיוון שזו רשומת Reference שמסתיימת ב-Length של עצמה, הפריסה נקבעת באופן יחיד גם כשרוחב החתימה שונה בין אלגוריתמים (השדה הנותר של [DECLARE](../edge/0x0BBL-declare.md)).
- אם מספר ה-WORD של החתימה שונה מהרוחב שהאלגוריתם קובע, זה invalid.

## בעיות פתוחות {#열린-문제}

- האם לחתום גם על מועד החתימה.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001E60/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E6000000000
BODY
#1 DECLARE 0x1E60
#2 FIELD #1 0x0001
#3 FIELD #1 record
#11 CODEC #3 0x0400
#4 FIELD #1 rest
#5 ENUM #2 0x0001
#6 BIND #1 "SIGNATURE"
#7 BIND #2 "algorithm"
#8 BIND #3 "signer"
#9 BIND #4 "signature"
#10 BIND #5 "ed25519"
```
