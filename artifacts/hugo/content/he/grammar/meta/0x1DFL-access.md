---
title: "ACCESS (0x1DFL)"
weight: 479
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "רושם את היקף החשיפה של המסמך."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `ACCESS` (BIND של מסמך מפרט: `ACCESS`) |
| TAG ID | `0x1DFL` |
| Codec ID | `0x00001DF0` |
| מסמך מפרט | `0x00000000/codecs/0x00001DF0/` (יעד DECLARE: `1DF0`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 31 |
| Kind | Meta · מחלקה: מדיניות |
| TAG WORD | `0001 1101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | היקף חשיפה |
| בצד Hugo | `meta/policy/access.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | ערך גולמי, 1 WORD |  | `0x0000` public, `0x0001` internal, `0x0002` confidential |

רושם את היקף החשיפה של המסמך.

## פריסה {#레이아웃}

```
TAG WORD          0001 1101 1111 LLLL      Codec 0x1DFL
[TAG הרחבה של Length]
דרגה              WORD אחד (0 ציבורי, 1 פנימי, 2 חסוי, השאר Reserved)
```

- Codec: Meta `0x1DFL`, מחלקת מדיניות
- Payload: ערך גולמי (דרגה, WORD אחד)
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- מסמך חסוי אינו מפורסם ([Issuer](../issuer.md)).
- אינו משנה את הפירוש. קובע רק את הטיפול.

## בעיות פתוחות {#열린-문제}

- טבלת קודי הדרגות.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001DF0/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DF000000000
BODY
#1 DECLARE 0x1DF0
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "ACCESS"
#7 BIND #2 "level"
#8 BIND #3 "public"
#9 BIND #4 "internal"
#10 BIND #5 "confidential"
```
