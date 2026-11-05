---
title: "PRIVACY (0x1E0L)"
weight: 480
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "רושם את דרגת המידע האישי של המסמך."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `PRIVACY` (BIND של מסמך מפרט: `PRIVACY`) |
| TAG ID | `0x1E0L` |
| Codec ID | `0x00001E00` |
| מסמך מפרט | `0x00000000/codecs/0x00001E00/` (יעד DECLARE: `1E00`) |
| קטע | 15 `1111` (Meta), היסט C בתוך הקטע = 0 |
| Kind | Meta · מחלקה: מדיניות |
| TAG WORD | `0001 1110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | דרגת מידע אישי |
| בצד Hugo | `meta/policy/privacy.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | ערך גולמי, 1 WORD |  |  |

רושם את דרגת המידע האישי של המסמך.

## פריסה {#레이아웃}

```
TAG WORD          0001 1110 0000 LLLL      Codec 0x1E0L
[TAG הרחבה של Length]
דרגה              WORD אחד
```

- Codec: Meta `0x1E0L`, מחלקת מדיניות
- Payload: ערך גולמי (דרגה, WORD אחד)
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- אינו משנה את הפירוש. קובע רק את הטיפול.

## בעיות פתוחות {#열린-문제}

- טבלת קודי הדרגות (התאמה לסיווג של חוק הגנת המידע האישי).

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001E00/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E0000000000
BODY
#1 DECLARE 0x1E00
#2 FIELD #1 0x0001
#3 BIND #1 "PRIVACY"
#4 BIND #2 "level"
```
