---
title: "DEFAULT-LANGUAGE (0x1CAL)"
weight: 458
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "מצהיר על שפת ברירת המחדל של טקסט המסמך."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `DEFAULT-LANGUAGE` (BIND של מסמך מפרט: `DEFAULT-LANGUAGE`) |
| TAG ID | `0x1CAL` |
| Codec ID | `0x00001CA0` |
| מסמך מפרט | `0x00000000/codecs/0x00001CA0/` (יעד DECLARE: `1CA0`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 10 |
| Kind | Meta · מחלקה: הצהרה |
| TAG WORD | `0001 1100 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | שפת ברירת מחדל |
| בצד Hugo | `meta/declaration/default-language.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | רשומה | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |

מצהיר על שפת ברירת המחדל של טקסט המסמך. טקסט שלא צוינה לו שפה הוא בשפה הזו.

## פריסה {#레이아웃}

```
TAG WORD          0001 1100 1010 LLLL      Codec 0x1CAL
[TAG הרחבה של Length]
Payload           Value אחד של שפה
```

- Codec: Meta `0x1CAL`, מחלקת הצהרה
- Payload: Value מובנה ([LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md) או [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md))
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- מסמך TANGEUL רושם את הלוקאל שבו נכתב (למשל `en`, `ko`).

## דוגמה {#예시}

- `en`: `0x1CA2 0x0761 0x656E`

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001CA0/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CA000000000
BODY
#1 DECLARE 0x1CA0
#2 FIELD #1 record
#3 BIND #1 "DEFAULT-LANGUAGE"
#4 BIND #2 "language"
#5 CODEC #2 0x07A0
#6 CODEC #2 0x0760
#7 CODEC #2 0x0770
```
