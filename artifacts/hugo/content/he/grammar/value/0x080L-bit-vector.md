---
title: "BIT-VECTOR (0x080L)"
weight: 128
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR הוא raw bit sequence שאורכו מוצהר."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR הוא raw bit sequence שאורכו מוצהר. קוד ישיר של Value ‏`0x080L`, משפחה BINARY. שני ה-Payload WORD הראשונים הם bit count ‏`N` מסוג unsigned של 32 סיביות, ולאחריהם `ceil(N/16)` WORD.

| פריט | ערך |
|---|---|
| שם | `BIT-VECTOR` (מסמך מפרט BIND `BIT-VECTOR`) |
| TAG ID | `0x080L` |
| Codec ID | `0x00000800` |
| מסמך מפרט | `0x00000000/codecs/0x00000800/` (יעד DECLARE ‏`0800`) |
| קטע | 4 `0100` (Value), היסט בתוך הקטע C = 0 |
| Kind | Value · משפחה: BINARY |
| TAG WORD | `0000 1000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | N סיביות השמורות MSB-first אחרי bit-count |
| בצד Hugo | `value/binary/bit-vector.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bit-count` | #2 | ערך גולמי, 2 WORD |  |  |
| 2 | `bits` | #3 | שארית ערך גולמי (`0xFFFF`) |  |  |

## פריסה {#레이아웃}

```
TAG WORD          0000 1000 0000 LLLL      Codec 0x080L
[Length TAG הרחבה] כשהסך הכול 15 WORD ומעלה
Payload WORD 1st–2nd       Bit Count N (16 סיביות עליונות │ 16 סיביות תחתונות)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## פירוש ותוקף {#해석과-유효성}

- ‏`N` הוא הערך שנקרא משני ה-Payload WORD הראשונים כמספר שלם big-endian unsigned של 32 סיביות.
- סיביות ה-payload ממולאות לפי הסדר החל מהסיבית העליונה ביותר של כל WORD.
- מספר ה-payload WORD הוא בדיוק `ceil(N/16)`, וכל הסיביות התחתונות שאינן בשימוש ב-WORD האחרון חייבות להיות 0.
- אם `N=0`, אין payload WORD. שני ה-count WORD כבר מהווים את ה-Payload, ולכן אין התנגשות בכלל ה-Payload המינימלי של WORD אחד.

## מעמד הפורמט {#형식-지위}

- ה-bit count מסוג unsigned של 32 סיביות, פריסת MSB-first ו-zero padding ב-WORD האחרון אינם ציטוט של תקן תעשייתי חיצוני אלא framing ייחודי ל-GEUL.
- דף זה מגדיר את הייצוג, כולל כללי TAG, ‏Length ו-WORD של 16 סיביות ב-GEUL.

## אורך {#길이}

- הסך הכול הוא מספר ה-WORD של TAG אחד, ה-Length TAG של ההרחבה (אם יש) וה-Payload. עד 14 WORD משתמשים באורך ישיר, ומ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וה-TAG של ההרחבה נכלל גם הוא בסך הכול ([רשומה ו-TAG WORD](../record.md)).

## דוגמה {#예시}

- bit vector ריק: count ‏`0000 0000`, בלי payload, סך הכול 3 WORD, ‏`LLLL=0010`. השלם הוא `0802 0000 0000`.
- ה-bit sequence ‏`101`: count ‏`0000 0003`, ‏payload ‏`A000`, סך הכול 4 WORD, ‏`LLLL=0011`. השלם הוא `0803 0000 0003 A000`.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x00000800/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000080000000000
BODY
#1 DECLARE 0x0800
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "BIT-VECTOR"
#5 BIND #2 "bit-count"
#6 BIND #3 "bits"
```
